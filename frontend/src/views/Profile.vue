<template>
  <div class="px-page profile-page">
    <PremiumCard variant="glass" padding="lg">
      <div class="profile-hero">
        <div class="profile-hero__identity">
          <span class="profile-avatar">
            <img v-if="avatar" :src="avatar" alt="" />
            <template v-else>{{ initial }}</template>
          </span>
          <div>
            <p class="px-eyebrow">Traveler</p>
            <h1 class="profile-hero__name">{{ nickname }}</h1>
            <p class="profile-hero__meta">
              <span>@{{ username || '—' }}</span>
              <span class="profile-dot" />
              <span>游客账号</span>
            </p>
            <p v-if="signature" class="profile-hero__signature">{{ signature }}</p>
          </div>
        </div>
        <div class="profile-hero__side">
          <PremiumButton variant="ghost" size="sm" @click="router.push('/profile/settings')">编辑资料</PremiumButton>
          <div class="profile-hero__quote">
            <p>“慢一点走，才能看见风土。”</p>
            <span>记录你在路上的每一次停留</span>
          </div>
        </div>
      </div>
    </PremiumCard>

    <section class="profile-stats">
      <article v-for="item in statCards" :key="item.label" class="profile-stat">
        <p class="profile-stat__label">{{ item.label }}</p>
        <p class="profile-stat__value">{{ item.value }}</p>
      </article>
    </section>

    <div class="profile-grid">
      <PremiumCard variant="glass" padding="lg">
        <header class="profile-head">
          <div>
            <p class="px-eyebrow">Recent orders</p>
            <h2>最近订单</h2>
          </div>
          <PremiumButton variant="text" size="sm" @click="router.push('/orders')">全部订单 →</PremiumButton>
        </header>

        <div v-if="loading" class="profile-loading">
          <el-skeleton :rows="3" animated />
        </div>
        <div v-else-if="!recentOrders.length" class="profile-empty">
          <p>还没有出行记录，去挑一处风景吧。</p>
          <PremiumButton variant="ghost" size="sm" @click="router.push('/attractions')">浏览目的地</PremiumButton>
        </div>
        <ul v-else class="recent-list">
          <li v-for="row in recentOrders" :key="row.orderNo" class="recent-item" @click="router.push(`/orders/${row.orderNo}`)">
            <div>
              <p class="recent-item__no">{{ row.orderNo }}</p>
              <p class="recent-item__meta">{{ row.visitDate }} · ¥{{ row.totalAmount }}</p>
            </div>
            <PremiumTag :tone="toneOf(statusOf(ORDER_STATUS, row.orderStatus).type)">
              {{ statusOf(ORDER_STATUS, row.orderStatus).label }}
            </PremiumTag>
          </li>
        </ul>
      </PremiumCard>

      <PremiumCard variant="glass" padding="lg">
        <header class="profile-head">
          <div>
            <p class="px-eyebrow">Shortcuts</p>
            <h2>常用入口</h2>
          </div>
        </header>
        <div class="profile-shortcuts">
          <button v-for="item in shortcuts" :key="item.to" type="button" class="profile-shortcut" @click="router.push(item.to)">
            <span class="profile-shortcut__title">{{ item.title }}</span>
            <span class="profile-shortcut__desc">{{ item.desc }}</span>
            <span class="profile-shortcut__arrow">→</span>
          </button>
        </div>
      </PremiumCard>
    </div>

    <PremiumCard variant="glass" padding="lg">
      <header class="profile-head">
        <div>
          <p class="px-eyebrow">Saved places</p>
          <h2>我的收藏</h2>
        </div>
        <PremiumButton variant="text" size="sm" @click="router.push('/profile/favorites')">全部收藏 →</PremiumButton>
      </header>

      <div v-if="!favorites.length" class="profile-empty">
        <p>还没有收藏的目的地，看到喜欢的就点亮心形吧。</p>
        <PremiumButton variant="ghost" size="sm" @click="router.push('/attractions')">去逛逛</PremiumButton>
      </div>
      <div v-else class="favorite-grid">
        <div
          v-for="item in favorites.slice(0, 4)"
          :key="item.attractionId"
          class="favorite-card"
          @click="router.push(`/attractions/${item.attractionId}`)"
        >
          <AttractionCard
            :name="item.name"
            :city="item.city"
            :cover-url="item.coverUrl"
            :level="item.level"
            :price="item.minPrice"
          />
        </div>
      </div>
    </PremiumCard>
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import AttractionCard from '@/components/AttractionCard.vue'
import PremiumButton from '@/components/premium/PremiumButton.vue'
import PremiumCard from '@/components/premium/PremiumCard.vue'
import PremiumTag from '@/components/premium/PremiumTag.vue'
import { getFavorites } from '@/api/favorites'
import { getOrders } from '@/api/order'
import { getProfile } from '@/api/profile'
import { getUser, updateStoredUser } from '@/utils/auth'
import { ORDER_STATUS, statusOf } from '@/utils/orderStatus'

const router = useRouter()

const user = computed(() => getUser())
const profile = ref(null)
const profileUser = computed(() => profile.value || user.value || {})
const nickname = computed(() => profileUser.value.nickname || profileUser.value.username || '旅行者')
const initial = computed(() => nickname.value.slice(0, 1).toUpperCase())
const avatar = computed(() => profileUser.value.avatar || '')
const username = computed(() => profileUser.value.username || '')
const signature = computed(() => profileUser.value.signature || '')

const loading = ref(false)
const orders = ref([])
const favorites = ref([])

const paidOrders = computed(() => orders.value.filter((row) => row.payStatus === 1))
const totalSpend = computed(() =>
  paidOrders.value.reduce((sum, row) => sum + Number(row.payAmount ?? row.totalAmount ?? 0), 0)
)

const statCards = computed(() => [
  { label: '订单总数', value: orders.value.length },
  { label: '待支付', value: orders.value.filter((row) => row.orderStatus === 0).length },
  { label: '已核销', value: orders.value.filter((row) => row.checkinStatus === 1).length },
  { label: '我的收藏', value: favorites.value.length },
  { label: '累计出行消费', value: `¥${totalSpend.value.toFixed(2)}` }
])

const recentOrders = computed(() => orders.value.slice(0, 4))

const shortcuts = [
  { title: '我的订单', desc: '支付、核销与订单状态', to: '/orders' },
  { title: '账号设置', desc: '头像、昵称与登录安全', to: '/profile/settings' },
  { title: '我的收藏', desc: '查看点亮过心形的地方', to: '/profile/favorites' },
  { title: '目的地列表', desc: '按城市浏览文旅目的地', to: '/attractions' },
  { title: '返回首页', desc: '继续发现风土与攻略', to: '/' }
]

const toneMap = {
  warning: 'warning',
  success: 'success',
  danger: 'danger',
  info: 'info',
  primary: 'primary'
}

function toneOf(type) {
  return toneMap[type] || 'neutral'
}

async function load() {
  loading.value = true
  try {
    const [orderRows, favoriteRows, profileData] = await Promise.all([
      getOrders().catch(() => []),
      getFavorites().catch(() => []),
      getProfile().catch(() => null)
    ])
    orders.value = orderRows || []
    favorites.value = favoriteRows || []
    if (profileData) {
      profile.value = profileData
      updateStoredUser({
        nickname: profileData.nickname || '',
        avatar: profileData.avatar || '',
        signature: profileData.signature || '',
        username: profileData.username || ''
      })
    }
  } finally {
    loading.value = false
  }
}

onMounted(load)
</script>

<style scoped lang="scss">
.profile-page {
  display: flex;
  flex-direction: column;
  gap: var(--px-space-5);
  padding-bottom: var(--px-space-8);
}

.profile-hero {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 28px;
}

.profile-hero__identity {
  display: flex;
  align-items: center;
  gap: 20px;
}

.profile-avatar {
  width: 64px;
  height: 64px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  overflow: hidden;
  background: linear-gradient(140deg, var(--px-accent-soft), rgba(255, 255, 255, 0.7));
  color: var(--px-accent-deep);
  font-size: 24px;
  font-weight: var(--px-weight-semibold);
  box-shadow: inset 0 0 0 1px rgba(255, 255, 255, 0.7);
}

.profile-avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.profile-hero__name {
  margin-top: 6px;
  font-size: var(--px-text-xl);
  color: var(--px-ink-1);
}

.profile-hero__meta {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-top: 8px;
  font-size: var(--px-text-xs);
  color: var(--px-ink-3);
}

.profile-dot {
  width: 3px;
  height: 3px;
  border-radius: 50%;
  background: var(--px-ink-4);
}

.profile-hero__signature {
  margin-top: 10px;
  font-size: var(--px-text-sm);
  color: var(--px-ink-2);
}

.profile-hero__side {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 16px;
  flex: none;
}

.profile-hero__quote {
  text-align: right;
  flex: none;
}

.profile-hero__quote p {
  font-family: var(--px-font-serif, inherit);
  font-size: var(--px-text-md);
  color: var(--px-ink-2);
}

.profile-hero__quote span {
  display: block;
  margin-top: 6px;
  font-size: var(--px-text-xs);
  color: var(--px-ink-4);
}

.profile-stats {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
  gap: 14px;
}

.profile-stat {
  padding: 18px 20px;
  border-radius: var(--px-radius-md);
  background: rgba(255, 255, 255, 0.62);
  box-shadow: var(--px-shadow-1), var(--px-shadow-highlight);
}

.profile-stat__label {
  font-size: var(--px-text-xs);
  color: var(--px-ink-3);
}

.profile-stat__value {
  margin-top: 9px;
  font-size: 24px;
  font-weight: var(--px-weight-semibold);
  color: var(--px-ink-1);
  font-variant-numeric: tabular-nums;
}

.profile-grid {
  display: grid;
  grid-template-columns: minmax(0, 1.4fr) minmax(0, 1fr);
  gap: 16px;
  align-items: start;
}

.profile-head {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 16px;
  margin-bottom: 16px;
}

.profile-head h2 {
  margin-top: 4px;
  font-size: var(--px-text-md);
  color: var(--px-ink-1);
}

.profile-loading {
  padding: 4px 0;
}

.profile-empty {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  padding: 18px 0;
  font-size: var(--px-text-sm);
  color: var(--px-ink-3);
}

.recent-list {
  margin: 0;
  padding: 0;
  list-style: none;
}

.recent-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  padding: 13px 2px;
  border-top: 1px solid rgba(32, 42, 54, 0.06);
  cursor: pointer;
  transition: opacity var(--px-duration-fast) var(--px-ease-out);
}

.recent-item:first-child {
  border-top: 0;
}

.recent-item:hover {
  opacity: 0.72;
}

.recent-item__no {
  font-size: var(--px-text-sm);
  font-weight: var(--px-weight-medium);
  color: var(--px-ink-1);
  font-variant-numeric: tabular-nums;
}

.recent-item__meta {
  margin-top: 4px;
  font-size: var(--px-text-xs);
  color: var(--px-ink-4);
}

.profile-shortcuts {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.profile-shortcut {
  position: relative;
  display: flex;
  flex-direction: column;
  gap: 4px;
  padding: 14px 16px;
  border: 0;
  border-radius: 10px;
  background: rgba(32, 42, 54, 0.03);
  text-align: left;
  font-family: inherit;
  cursor: pointer;
  transition: background-color var(--px-duration-fast) var(--px-ease-out);
}

.profile-shortcut:hover {
  background: rgba(32, 42, 54, 0.06);
}

.profile-shortcut__title {
  font-size: var(--px-text-sm);
  font-weight: var(--px-weight-semibold);
  color: var(--px-ink-1);
}

.profile-shortcut__desc {
  font-size: var(--px-text-xs);
  color: var(--px-ink-3);
}

.profile-shortcut__arrow {
  position: absolute;
  right: 16px;
  top: 50%;
  transform: translateY(-50%);
  color: var(--px-ink-4);
}

.favorite-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 16px;
}

.favorite-card {
  cursor: pointer;
  transition: transform var(--px-duration-base) var(--px-ease-out);
}

.favorite-card:hover {
  transform: translateY(-3px);
}

@media (max-width: 900px) {
  .profile-stats {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .profile-grid {
    grid-template-columns: minmax(0, 1fr);
  }

  .profile-hero {
    flex-direction: column;
    align-items: flex-start;
  }

  .profile-hero__side {
    align-items: flex-start;
  }

  .profile-hero__quote {
    text-align: left;
  }

  .favorite-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}
</style>
