<template>
  <div class="dash">
    <section class="dash-stats">
      <article v-for="item in statCards" :key="item.label" class="stat-tile">
        <p class="stat-tile__label">{{ item.label }}</p>
        <p class="stat-tile__value">{{ item.value }}</p>
        <p class="stat-tile__hint">{{ item.hint }}</p>
      </article>
    </section>

    <div class="dash-grid">
      <PremiumCard variant="glass" padding="lg">
        <header class="dash-head">
          <div>
            <p class="px-eyebrow">Last 7 days</p>
            <h2>近 7 日订单走势</h2>
          </div>
          <span class="dash-head__note">按下单日期统计</span>
        </header>

        <div v-if="loading" class="dash-loading">
          <el-skeleton :rows="4" animated />
        </div>
        <div v-else class="trend">
          <div v-for="day in stats.daily" :key="day.date" class="trend__row">
            <span class="trend__date">{{ day.date.slice(5) }}</span>
            <div class="trend__track">
              <span class="trend__bar" :style="{ width: barWidth(day.orderCount) }" />
            </div>
            <span class="trend__count">{{ day.orderCount }} 单</span>
            <span class="trend__revenue">¥{{ day.revenue }}</span>
          </div>
        </div>
      </PremiumCard>

      <PremiumCard variant="glass" padding="lg">
        <header class="dash-head">
          <div>
            <p class="px-eyebrow">Shortcuts</p>
            <h2>常用操作</h2>
          </div>
        </header>
        <div class="shortcuts">
          <button v-for="item in shortcuts" :key="item.to" type="button" class="shortcut" @click="router.push(item.to)">
            <span class="shortcut__title">{{ item.title }}</span>
            <span class="shortcut__desc">{{ item.desc }}</span>
            <span class="shortcut__arrow">→</span>
          </button>
        </div>
      </PremiumCard>
    </div>

    <PremiumCard variant="glass" padding="lg" class="recent-card">
      <header class="dash-head">
        <div>
          <p class="px-eyebrow">Recent orders</p>
          <h2>最近订单</h2>
        </div>
        <PremiumButton variant="text" size="sm" @click="router.push('/admin/orders')">查看全部 →</PremiumButton>
      </header>

      <el-table :data="recentOrders" empty-text="暂无订单" class="admin-table">
        <el-table-column prop="orderNo" label="订单号" min-width="200" />
        <el-table-column prop="visitDate" label="游玩日期" width="120" />
        <el-table-column label="金额" width="110">
          <template #default="{ row }"><span class="table-money">¥{{ row.totalAmount }}</span></template>
        </el-table-column>
        <el-table-column label="状态" width="110">
          <template #default="{ row }">
            <PremiumTag :tone="toneOf(statusOf(ORDER_STATUS, row.orderStatus).type)">
              {{ statusOf(ORDER_STATUS, row.orderStatus).label }}
            </PremiumTag>
          </template>
        </el-table-column>
        <el-table-column prop="createdAt" label="下单时间" width="180" />
      </el-table>
    </PremiumCard>
  </div>
</template>

<script setup>
import { computed, onMounted, reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import PremiumButton from '@/components/premium/PremiumButton.vue'
import PremiumCard from '@/components/premium/PremiumCard.vue'
import PremiumTag from '@/components/premium/PremiumTag.vue'
import { getAdminOrders, getDashboardStats } from '@/api/admin'
import { ORDER_STATUS, statusOf } from '@/utils/orderStatus'

const router = useRouter()

const loading = ref(false)
const stats = reactive({
  attractionCount: 0,
  onlineAttractionCount: 0,
  ticketTypeCount: 0,
  orderCount: 0,
  todayOrderCount: 0,
  checkedOrderCount: 0,
  checkedQuantity: 0,
  revenue: 0,
  daily: []
})
const recentOrders = ref([])

const statCards = computed(() => [
  {
    label: '累计订单',
    value: stats.orderCount,
    hint: `今日新增 ${stats.todayOrderCount} 单`
  },
  {
    label: '支付金额',
    value: `¥${stats.revenue}`,
    hint: '已支付订单累计'
  },
  {
    label: '已核销',
    value: stats.checkedOrderCount,
    hint: `共 ${stats.checkedQuantity} 张票`
  },
  {
    label: '在售票种',
    value: stats.ticketTypeCount,
    hint: `${stats.onlineAttractionCount}/${stats.attractionCount} 个目的地上线`
  }
])

const shortcuts = [
  { title: '维护攻略内容', desc: '补充风土人文与在地贴士', to: '/admin/guides' },
  { title: '配置票种库存', desc: '按日期调整可售数量', to: '/admin/inventory' },
  { title: '核销工作台', desc: '按订单号快速核销', to: '/admin/checkin' }
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

function barWidth(count) {
  const max = Math.max(...(stats.daily || []).map((day) => day.orderCount), 1)
  return `${Math.max((count / max) * 100, count > 0 ? 10 : 3)}%`
}

async function load() {
  loading.value = true
  try {
    const [data, orders] = await Promise.all([getDashboardStats(), getAdminOrders()])
    Object.assign(stats, data)
    recentOrders.value = (orders || []).slice(0, 6)
  } catch {
    // 拦截器已提示错误
  } finally {
    loading.value = false
  }
}

onMounted(load)
</script>

<style scoped lang="scss">
.dash {
  display: flex;
  flex-direction: column;
  gap: 18px;
}

.dash-stats {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 16px;
}

.stat-tile {
  padding: 20px 22px;
  border-radius: var(--px-radius-md);
  background: #fff;
  box-shadow: 0 1px 2px rgba(31, 41, 55, 0.05), 0 8px 20px rgba(31, 41, 55, 0.04);
}

.stat-tile__label {
  font-size: var(--px-text-xs);
  color: var(--px-ink-3);
}

.stat-tile__value {
  margin-top: 10px;
  font-size: 28px;
  font-weight: var(--px-weight-semibold);
  color: var(--px-ink-1);
  line-height: 1;
  font-variant-numeric: tabular-nums;
}

.stat-tile__hint {
  margin-top: 10px;
  font-size: var(--px-text-xs);
  color: var(--px-ink-4);
}

.dash-grid {
  display: grid;
  grid-template-columns: minmax(0, 1.5fr) minmax(0, 1fr);
  gap: 16px;
  align-items: start;
}

.dash-head {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 16px;
  margin-bottom: 18px;
}

.dash-head h2 {
  margin-top: 4px;
  font-size: var(--px-text-md);
  color: var(--px-ink-1);
}

.dash-head__note {
  font-size: var(--px-text-xs);
  color: var(--px-ink-4);
}

.dash-loading {
  padding: 8px 0;
}

.trend {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.trend__row {
  display: grid;
  grid-template-columns: 48px 1fr 48px 78px;
  gap: 12px;
  align-items: center;
}

.trend__date {
  font-size: var(--px-text-xs);
  color: var(--px-ink-3);
  font-variant-numeric: tabular-nums;
}

.trend__track {
  height: 8px;
  border-radius: 999px;
  background: rgba(32, 42, 54, 0.05);
  overflow: hidden;
}

.trend__bar {
  display: block;
  height: 100%;
  border-radius: 999px;
  background: var(--px-accent);
  transition: width var(--px-duration-slow) var(--px-ease-out);
}

.trend__count {
  text-align: right;
  font-size: var(--px-text-xs);
  color: var(--px-ink-2);
  font-variant-numeric: tabular-nums;
}

.trend__revenue {
  text-align: right;
  font-size: var(--px-text-xs);
  color: var(--px-ink-4);
  font-variant-numeric: tabular-nums;
}

.shortcuts {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.shortcut {
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

.shortcut:hover {
  background: rgba(32, 42, 54, 0.06);
}

.shortcut__title {
  font-size: var(--px-text-sm);
  font-weight: var(--px-weight-semibold);
  color: var(--px-ink-1);
}

.shortcut__desc {
  font-size: var(--px-text-xs);
  color: var(--px-ink-3);
}

.shortcut__arrow {
  position: absolute;
  right: 16px;
  top: 50%;
  transform: translateY(-50%);
  color: var(--px-ink-4);
  font-size: var(--px-text-sm);
}

.recent-card {
  margin-top: 2px;
}

.table-money {
  color: var(--px-accent-deep);
  font-weight: var(--px-weight-semibold);
  font-variant-numeric: tabular-nums;
}
</style>
