<template>
  <div class="px-page">
    <header class="list-head">
      <div class="list-head__text">
        <p class="px-eyebrow">All destinations</p>
        <h1 class="list-head__title">发现景点</h1>
        <p class="px-subtitle">从山海到古城，挑一处心之所向，查看实时余票与开放时间。</p>
      </div>
      <div class="list-head__count">
        <strong>{{ list.length }}</strong>
        <span>处目的地</span>
      </div>
    </header>

    <PremiumCard variant="glass" padding="sm" class="filter-card">
      <div class="filter">
        <PremiumInput
          v-model="filters.keyword"
          placeholder="搜索景点、城市或省份"
          clearable
          class="filter__field"
          @enter="loadList"
          @clear="loadList"
        >
          <template #prefix>
            <svg viewBox="0 0 20 20" width="15" height="15" aria-hidden="true">
              <circle cx="9" cy="9" r="5.5" fill="none" stroke="currentColor" stroke-width="1.5" />
              <path d="M13.2 13.2L17 17" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" />
            </svg>
          </template>
        </PremiumInput>

        <PremiumInput
          v-model="filters.city"
          placeholder="城市或省份，如 杭州 / 新疆"
          clearable
          class="filter__field filter__field--city"
          @enter="loadList"
          @clear="loadList"
        >
          <template #prefix>
            <svg viewBox="0 0 20 20" width="15" height="15" aria-hidden="true">
              <path d="M10 18s6-5.2 6-9.5A6 6 0 004 8.5C4 12.8 10 18 10 18z" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linejoin="round" />
              <circle cx="10" cy="8.5" r="1.8" fill="none" stroke="currentColor" stroke-width="1.4" />
            </svg>
          </template>
        </PremiumInput>

        <div class="filter__actions">
          <PremiumButton @click="loadList">搜索</PremiumButton>
          <PremiumButton variant="ghost" @click="resetFilters">重置</PremiumButton>
        </div>
      </div>
    </PremiumCard>

    <div v-if="loading" class="card-grid">
      <PremiumCard v-for="n in 8" :key="n" variant="quiet" padding="sm" class="skeleton-card">
        <el-skeleton animated>
          <template #template>
            <el-skeleton-item variant="image" style="width: 100%; height: 186px; border-radius: 14px" />
            <div class="skeleton-card__body">
              <el-skeleton-item variant="h3" style="width: 60%" />
              <el-skeleton-item variant="text" style="width: 42%" />
              <el-skeleton-item variant="text" style="width: 78%" />
            </div>
          </template>
        </el-skeleton>
      </PremiumCard>
    </div>

    <PremiumCard v-else-if="!list.length" variant="glass" padding="lg" class="empty-card">
      <el-empty description="没有找到符合条件的景点">
        <PremiumButton variant="ghost" @click="resetFilters">清除筛选条件</PremiumButton>
      </el-empty>
    </PremiumCard>

    <div v-else class="card-grid">
      <router-link
        v-for="(item, index) in list"
        :key="item.id"
        :to="`/attractions/${item.id}`"
        class="card-link"
        :style="{ '--i': index }"
      >
        <AttractionCard
          :name="item.name"
          :city="item.city"
          :cover-url="item.coverUrl"
          :level="item.level"
          :address="item.address"
          :price="minPrice(item.ticketTypes)"
        >
          <template #extra>
            <PremiumTag v-if="item.ticketTypes?.length" tone="success" size="sm">
              {{ item.ticketTypes.length }} 种票
            </PremiumTag>
          </template>
        </AttractionCard>
      </router-link>
    </div>
  </div>
</template>

<script setup>
import { onMounted, reactive, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import AttractionCard from '@/components/AttractionCard.vue'
import PremiumButton from '@/components/premium/PremiumButton.vue'
import PremiumCard from '@/components/premium/PremiumCard.vue'
import PremiumInput from '@/components/premium/PremiumInput.vue'
import PremiumTag from '@/components/premium/PremiumTag.vue'
import { getAttractions } from '@/api/attraction'

const route = useRoute()
const router = useRouter()

const filters = reactive({
  keyword: typeof route.query.keyword === 'string' ? route.query.keyword : '',
  city: ''
})

const loading = ref(false)
const list = ref([])

function minPrice(ticketTypes) {
  if (!ticketTypes || !ticketTypes.length) return null
  return Math.min(...ticketTypes.map((item) => Number(item.price)))
}

async function loadList() {
  loading.value = true
  try {
    const params = {}
    if (filters.keyword.trim()) params.keyword = filters.keyword.trim()
    if (filters.city.trim()) params.city = filters.city.trim()
    list.value = await getAttractions(params)
  } catch {
    list.value = []
  } finally {
    loading.value = false
  }
}

function resetFilters() {
  filters.keyword = ''
  filters.city = ''
  if (route.query.keyword) {
    router.replace({ path: '/attractions' })
  }
  loadList()
}

watch(
  () => route.query.keyword,
  (value) => {
    const keyword = typeof value === 'string' ? value : ''
    if (keyword === filters.keyword) return
    filters.keyword = keyword
    loadList()
  }
)

onMounted(loadList)
</script>

<style scoped lang="scss">
.list-head {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 32px;
  margin-bottom: var(--px-space-5);
}

.list-head__text {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.list-head__title {
  font-size: var(--px-text-2xl);
  color: var(--px-ink-1);
}

.list-head__count {
  display: inline-flex;
  align-items: baseline;
  gap: 6px;
  padding: 10px 18px;
  border-radius: var(--px-radius-pill);
  background: rgba(255, 255, 255, 0.44);
  box-shadow: var(--px-shadow-1), inset 0 1px 0 rgba(255, 255, 255, 0.7);
  color: var(--px-ink-3);
  font-size: var(--px-text-xs);
  white-space: nowrap;
}

.list-head__count strong {
  font-size: var(--px-text-lg);
  font-weight: var(--px-weight-semibold);
  color: var(--px-ink-1);
  font-variant-numeric: tabular-nums;
}

.filter-card {
  margin-bottom: var(--px-space-5);
}

.filter {
  display: flex;
  align-items: center;
  gap: 12px;
}

.filter__field {
  max-width: 300px;
}

.filter__field--city {
  max-width: 220px;
}

.filter__field :deep(.el-input__prefix) {
  color: var(--px-ink-4);
}

.filter__actions {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-left: auto;
}

.card-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: var(--px-space-4);
}

.card-link {
  display: block;
  min-width: 0;
  animation: card-enter 560ms var(--px-ease-out) both;
  animation-delay: calc(var(--i, 0) * 45ms);
}

@keyframes card-enter {
  from {
    opacity: 0;
    transform: translateY(12px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.skeleton-card {
  pointer-events: none;
}

.skeleton-card__body {
  display: flex;
  flex-direction: column;
  gap: 10px;
  padding: 18px 6px 8px;
}

.empty-card :deep(.el-empty) {
  padding: var(--px-space-6) 0;
}
</style>
