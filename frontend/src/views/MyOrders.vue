<template>
  <div class="px-page orders-page">
    <header class="orders-head">
      <div>
        <p class="px-eyebrow">My orders</p>
        <h1 class="orders-head__title">我的订单</h1>
        <p class="px-subtitle">查看订单状态、完成支付或核销信息。</p>
      </div>
      <div class="orders-head__side">
        <span class="orders-count">共 <b>{{ orders.length }}</b> 笔</span>
        <PremiumButton variant="ghost" size="sm" :loading="loading" @click="loadOrders">
          刷新
        </PremiumButton>
      </div>
    </header>

    <div v-if="loading && !orders.length" class="order-list">
      <PremiumCard v-for="n in 3" :key="n" variant="quiet" padding="md">
        <el-skeleton :rows="3" animated />
      </PremiumCard>
    </div>

    <PremiumCard v-else-if="!orders.length" variant="glass" padding="lg">
      <el-empty description="暂无订单，去挑一处风景吧">
        <PremiumButton variant="ghost" @click="router.push('/attractions')">浏览景点</PremiumButton>
      </el-empty>
    </PremiumCard>

    <div v-else class="order-list">
      <PremiumCard
        v-for="row in orders"
        :key="row.orderNo"
        variant="glass"
        padding="none"
        hoverable
        class="order-item"
      >
        <div class="order-item__top">
          <div class="order-item__id">
            <span class="order-item__label">订单号</span>
            <router-link :to="`/orders/${row.orderNo}`" class="order-item__no">
              {{ row.orderNo }}
            </router-link>
          </div>
          <div class="order-item__tags">
            <PremiumTag :tone="toneOf(statusOf(ORDER_STATUS, row.orderStatus).type)">
              {{ statusOf(ORDER_STATUS, row.orderStatus).label }}
            </PremiumTag>
            <PremiumTag
              variant="hollow"
              :tone="toneOf(statusOf(PAY_STATUS, row.payStatus).type)"
            >
              {{ statusOf(PAY_STATUS, row.payStatus).label }}
            </PremiumTag>
          </div>
        </div>

        <div class="order-item__body">
          <div class="order-meta">
            <span>游玩日期</span>
            <b>{{ row.visitDate }}</b>
          </div>
          <div class="order-meta">
            <span>订单金额</span>
            <b class="order-meta__amount"><em>¥</em>{{ row.totalAmount }}</b>
          </div>
          <div class="order-meta">
            <span>核销状态</span>
            <b>
              {{ statusOf(CHECKIN_STATUS, row.checkinStatus).label }}
              <i v-if="row.checkedQuantity > 0" class="order-meta__extra">· {{ row.checkedQuantity }} 张</i>
            </b>
          </div>
          <div class="order-meta">
            <span>下单时间</span>
            <b class="order-meta__time">{{ row.createdAt }}</b>
          </div>
        </div>

        <div class="order-item__foot">
          <span class="order-item__hint">
            {{ row.orderStatus === 0 ? '请尽快完成支付，超时订单将自动关闭' : '订单信息以实际支付与核销记录为准' }}
          </span>
          <div class="order-item__actions">
            <PremiumButton variant="text" size="sm" @click="goDetail(row)">查看详情</PremiumButton>
            <PremiumButton
              v-if="row.orderStatus === 0"
              tone="success"
              variant="soft"
              size="sm"
              @click="openPay(row)"
            >
              去支付
            </PremiumButton>
            <PremiumButton
              v-if="row.orderStatus === 0"
              tone="danger"
              variant="text"
              size="sm"
              @click="handleCancel(row)"
            >
              取消订单
            </PremiumButton>
          </div>
        </div>
      </PremiumCard>
    </div>

    <PaymentDialog
      v-model="payVisible"
      :order-no="payTarget.orderNo"
      :amount="payTarget.amount"
      @success="loadOrders"
    />
  </div>
</template>

<script setup>
import { onMounted, reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import PremiumButton from '@/components/premium/PremiumButton.vue'
import PremiumCard from '@/components/premium/PremiumCard.vue'
import PremiumTag from '@/components/premium/PremiumTag.vue'
import PaymentDialog from '@/components/PaymentDialog.vue'
import { cancelOrder, getOrders } from '@/api/order'
import { CHECKIN_STATUS, ORDER_STATUS, PAY_STATUS, statusOf } from '@/utils/orderStatus'

const router = useRouter()

const loading = ref(false)
const orders = ref([])
const payVisible = ref(false)
const payTarget = reactive({ orderNo: '', amount: 0 })

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

async function loadOrders() {
  loading.value = true
  try {
    orders.value = await getOrders()
  } catch {
    orders.value = []
  } finally {
    loading.value = false
  }
}

function goDetail(row) {
  router.push(`/orders/${row.orderNo}`)
}

function openPay(row) {
  payTarget.orderNo = row.orderNo
  payTarget.amount = row.totalAmount
  payVisible.value = true
}

async function handleCancel(row) {
  try {
    await ElMessageBox.confirm(
      `确定取消订单 ${row.orderNo} 吗？取消后库存将释放。`,
      '取消订单',
      { type: 'warning', confirmButtonText: '确定取消', cancelButtonText: '再想想' }
    )
  } catch {
    return
  }
  await cancelOrder(row.orderNo)
  ElMessage.success('订单已取消')
  loadOrders()
}

onMounted(loadOrders)
</script>

<style scoped lang="scss">
.orders-page {
  padding-top: var(--px-space-6);
}

.orders-head {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 32px;
  margin-bottom: var(--px-space-5);
}

.orders-head__title {
  margin: 8px 0;
  font-size: var(--px-text-2xl);
  color: var(--px-ink-1);
}

.orders-head__side {
  display: flex;
  align-items: center;
  gap: 10px;
}

.orders-count {
  font-size: var(--px-text-xs);
  color: var(--px-ink-3);
  padding: 8px 14px;
  border-radius: var(--px-radius-pill);
  background: rgba(255, 255, 255, 0.42);
  box-shadow: var(--px-shadow-1), inset 0 1px 0 rgba(255, 255, 255, 0.65);
}

.orders-count b {
  color: var(--px-ink-1);
  font-weight: var(--px-weight-semibold);
  font-variant-numeric: tabular-nums;
}

.order-list {
  display: flex;
  flex-direction: column;
  gap: 14px;
}

.order-item {
  padding: 20px 24px;
}

.order-item__top {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 20px;
  padding-bottom: 16px;
  background: linear-gradient(90deg, transparent, var(--px-line-strong), transparent) bottom / 100% 1px no-repeat;
}

.order-item__id {
  display: flex;
  align-items: baseline;
  gap: 10px;
  min-width: 0;
}

.order-item__label {
  font-size: 10px;
  font-weight: var(--px-weight-semibold);
  letter-spacing: 0.16em;
  text-transform: uppercase;
  color: var(--px-ink-4);
}

.order-item__no {
  font-size: var(--px-text-sm);
  font-weight: var(--px-weight-medium);
  color: var(--px-ink-1);
  font-variant-numeric: tabular-nums;
  letter-spacing: 0.02em;
}

.order-item__no:hover {
  color: var(--px-accent-deep);
}

.order-item__tags {
  display: flex;
  align-items: center;
  gap: 8px;
  flex: none;
}

.order-item__body {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr 1.2fr;
  gap: 24px;
  padding: 16px 0;
}

.order-meta {
  display: flex;
  flex-direction: column;
  gap: 5px;
  min-width: 0;
}

.order-meta span {
  font-size: 10px;
  font-weight: var(--px-weight-semibold);
  letter-spacing: 0.14em;
  text-transform: uppercase;
  color: var(--px-ink-4);
}

.order-meta b {
  font-size: var(--px-text-sm);
  font-weight: var(--px-weight-medium);
  color: var(--px-ink-1);
  font-variant-numeric: tabular-nums;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.order-meta__amount {
  color: var(--px-accent-deep) !important;
  font-size: var(--px-text-md) !important;
  font-weight: var(--px-weight-semibold) !important;
}

.order-meta__amount em {
  font-style: normal;
  font-size: var(--px-text-xs);
  color: var(--px-ink-3);
  margin-right: 2px;
}

.order-meta__extra {
  font-style: normal;
  font-weight: var(--px-weight-regular);
  color: var(--px-ink-3);
}

.order-meta__time {
  color: var(--px-ink-2) !important;
  font-weight: var(--px-weight-regular) !important;
}

.order-item__foot {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 20px;
  padding-top: 14px;
  background: linear-gradient(90deg, transparent, var(--px-line-strong), transparent) top / 100% 1px no-repeat;
}

.order-item__hint {
  font-size: var(--px-text-xs);
  color: var(--px-ink-4);
}

.order-item__actions {
  display: flex;
  align-items: center;
  gap: 6px;
  flex: none;
}
</style>
