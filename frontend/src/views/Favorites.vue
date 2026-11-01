<template>
  <div class="px-page favorites-page">
    <header class="favorites-head">
      <div>
        <p class="px-eyebrow">Saved places</p>
        <h1>我的收藏</h1>
        <p class="favorites-head__desc">收好的地方会一直在这里，等你有空再出发。</p>
      </div>
      <PremiumButton variant="ghost" size="sm" @click="router.push('/profile')">返回个人中心</PremiumButton>
    </header>

    <div v-if="loading" class="favorites-grid">
      <PremiumCard v-for="n in 4" :key="n" variant="glass" padding="lg">
        <el-skeleton :rows="3" animated />
      </PremiumCard>
    </div>

    <PremiumCard v-else-if="!favorites.length" variant="glass" padding="lg">
      <div class="favorites-empty">
        <p class="favorites-empty__title">还没有收藏的目的地</p>
        <p class="favorites-empty__desc">在景点详情页点亮心形，喜欢的风景就会出现在这里。</p>
        <PremiumButton @click="router.push('/attractions')">去逛逛景点</PremiumButton>
      </div>
    </PremiumCard>

    <div v-else class="favorites-grid">
      <div
        v-for="item in favorites"
        :key="item.attractionId"
        class="favorites-item"
        @click="router.push(`/attractions/${item.attractionId}`)"
      >
        <AttractionCard
          :name="item.name"
          :city="item.city"
          :cover-url="item.coverUrl"
          :level="item.level"
          :price="item.minPrice"
        />
        <button
          type="button"
          class="favorites-remove"
          :disabled="removingId === item.attractionId"
          title="取消收藏"
          @click.stop="remove(item)"
        >
          <svg viewBox="0 0 24 24" width="16" height="16" aria-hidden="true">
            <path
              d="M12 20s-7-4.35-7-9a4 4 0 0 1 7-2.65A4 4 0 0 1 19 11c0 4.65-7 9-7 9z"
              fill="currentColor"
              stroke="currentColor"
              stroke-width="1.2"
              stroke-linejoin="round"
            />
          </svg>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import AttractionCard from '@/components/AttractionCard.vue'
import PremiumButton from '@/components/premium/PremiumButton.vue'
import PremiumCard from '@/components/premium/PremiumCard.vue'
import { getFavorites, removeFavorite } from '@/api/favorites'

const router = useRouter()
const loading = ref(false)
const favorites = ref([])
const removingId = ref(null)

async function load() {
  loading.value = true
  try {
    favorites.value = (await getFavorites()) || []
  } catch {
    favorites.value = []
  } finally {
    loading.value = false
  }
}

async function remove(item) {
  removingId.value = item.attractionId
  try {
    await removeFavorite(item.attractionId)
    favorites.value = favorites.value.filter((row) => row.attractionId !== item.attractionId)
    ElMessage.success('已取消收藏')
  } catch {
    // 请求层已提示错误
  } finally {
    removingId.value = null
  }
}

onMounted(load)
</script>

<style scoped lang="scss">
.favorites-page {
  display: flex;
  flex-direction: column;
  gap: var(--px-space-5);
  padding-bottom: var(--px-space-8);
}

.favorites-head {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 20px;
}

.favorites-head h1 {
  margin-top: 6px;
  font-size: var(--px-text-xl);
  color: var(--px-ink-1);
}

.favorites-head__desc {
  margin-top: 8px;
  font-size: var(--px-text-sm);
  color: var(--px-ink-3);
}

.favorites-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
  gap: 18px;
}

.favorites-item {
  position: relative;
  cursor: pointer;
}

.favorites-remove {
  position: absolute;
  top: 12px;
  right: 12px;
  z-index: 30;
  width: 34px;
  height: 34px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border: 0;
  border-radius: 50%;
  background: rgba(253, 254, 255, 0.9);
  box-shadow: var(--px-shadow-1), inset 0 1px 0 rgba(255, 255, 255, 0.7);
  color: var(--px-danger, #c2544a);
  cursor: pointer;
  opacity: 0;
  transform: translateY(-3px);
  transition:
    opacity var(--px-duration-fast) var(--px-ease-out),
    transform var(--px-duration-fast) var(--px-ease-out);
}

.favorites-item:hover .favorites-remove,
.favorites-remove:focus-visible {
  opacity: 1;
  transform: translateY(0);
}

.favorites-remove:disabled {
  opacity: 0.5;
  cursor: wait;
}

.favorites-empty {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
  padding: 40px 0;
  text-align: center;
}

.favorites-empty__title {
  font-size: var(--px-text-md);
  font-weight: var(--px-weight-medium);
  color: var(--px-ink-1);
}

.favorites-empty__desc {
  margin-bottom: 8px;
  font-size: var(--px-text-sm);
  color: var(--px-ink-3);
}

@media (max-width: 720px) {
  .favorites-head {
    flex-direction: column;
    align-items: flex-start;
  }

  .favorites-remove {
    opacity: 1;
    transform: none;
  }
}
</style>
