<template>
  <div class="px-page order-detail-page">
    <router-link to="/orders" class="back-link">
      <svg viewBox="0 0 16 16" width="13" height="13" aria-hidden="true">
        <path d="M13 8H3M7 4L3 8l4 4" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
      </svg>
      返回我的订单
    </router-link>

    <div v-if="loading" class="detail-skeleton">
      <PremiumCard variant="quiet" padding="lg"><el-skeleton :rows="4" animated /></PremiumCard>
      <PremiumCard variant="quiet" padding="lg"><el-skeleton :rows="5" animated /></PremiumCard>
    </div>

    <PremiumCard v-else-if="!order" variant="glass" padding="lg">
      <el-empty description="订单不存在">
        <PremiumButton variant="ghost" @click="router.push('/orders')">返回订单列表</PremiumButton>
      </el-empty>
    </PremiumCard>

    <template v-else>
      <section class="status-hero">
        <div class="status-hero__inner">
          <div class="status-hero__main">
            <p class="status-hero__eyebrow">Order status</p>
            <div class="status-hero__status">
              <span class="status-hero__dot" />
              {{ statusOf(ORDER_STATUS, order.orderStatus).label }}
            </div>
            <p class="status-hero__no">订单号 {{ order.orderNo }}</p>
          </div>

          <div class="status-hero__amount">
            <span>应付金额</span>
            <strong><em>¥</em>{{ order.payAmount }}</strong>
          </div>
        </div>

        <div class="status-hero__foot">
          <span class="status-hero__time">下单于 {{ order.createdAt }}</span>
          <div class="status-hero__actions">
            <PremiumButton
              v-if="order.orderStatus === 0"
              tone="success"
              @click="payVisible = true"
            >
              去支付
            </PremiumButton>
            <PremiumButton
              v-if="order.orderStatus === 0"
              variant="ghost"
              tone="danger"
              @click="handleCancel"
            >
              取消订单
            </PremiumButton>
          </div>
        </div>
      </section>

      <div class="detail-grid">
        <PremiumCard variant="glass" padding="lg" class="info-card">
          <header class="card-head">
            <p class="px-eyebrow">Information</p>
            <h2>订单信息</h2>
          </header>

          <dl class="info-grid">
            <div class="info-cell">
              <dt>订单号</dt>
              <dd class="mono">{{ order.orderNo }}</dd>
            </div>
            <div class="info-cell">
              <dt>下单时间</dt>
              <dd>{{ order.createdAt }}</dd>
            </div>
            <div class="info-cell">
              <dt>游玩日期</dt>
              <dd>{{ order.visitDate }}</dd>
            </div>
            <div class="info-cell">
              <dt>支付截止</dt>
              <dd>{{ order.expireTime || '—' }}</dd>
            </div>
            <div class="info-cell">
              <dt>支付状态</dt>
              <dd>
                <PremiumTag :tone="toneOf(statusOf(PAY_STATUS, order.payStatus).type)">
                  {{ statusOf(PAY_STATUS, order.payStatus).label }}
                </PremiumTag>
              </dd>
            </div>
            <div class="info-cell">
              <dt>支付时间</dt>
              <dd>{{ order.payTime || '—' }}</dd>
            </div>
            <div class="info-cell">
              <dt>核销状态</dt>
              <dd>
                <PremiumTag :tone="toneOf(statusOf(CHECKIN_STATUS, order.checkinStatus).type)">
                  {{ statusOf(CHECKIN_STATUS, order.checkinStatus).label }}
                </PremiumTag>
                <span v-if="order.checkedQuantity > 0" class="info-muted">
                  已核销 {{ order.checkedQuantity }} 张
                </span>
              </dd>
            </div>
            <div class="info-cell">
              <dt>联系人</dt>
              <dd>{{ order.contactName }}（{{ order.contactPhone }}）</dd>
            </div>
            <div class="info-cell">
              <dt>订单总额</dt>
              <dd>¥ {{ order.totalAmount }}</dd>
            </div>
            <div class="info-cell">
              <dt>应付金额</dt>
              <dd class="amount">¥ {{ order.payAmount }}</dd>
            </div>
          </dl>
        </PremiumCard>

        <PremiumCard variant="glass" padding="lg" class="items-card">
          <header class="card-head">
            <p class="px-eyebrow">Tickets</p>
            <h2>票种明细</h2>
          </header>

          <div class="items-table">
            <div class="items-table__head">
              <span class="col-name">票种</span>
              <span class="col-date">游玩日期</span>
              <span class="col-price">单价</span>
              <span class="col-qty">数量</span>
              <span class="col-amount">小计</span>
            </div>
            <div v-for="item in order.items" :key="item.id || item.ticketName" class="items-table__row">
              <span class="col-name">{{ item.ticketName }}</span>
              <span class="col-date">{{ item.visitDate }}</span>
              <span class="col-price">¥ {{ item.unitPrice }}</span>
              <span class="col-qty">{{ item.quantity }}</span>
              <span class="col-amount">¥ {{ item.amount }}</span>
            </div>
            <div v-if="!order.items?.length" class="items-table__empty">暂无明细</div>
          </div>
        </PremiumCard>
      </div>
    </template>

    <PaymentDialog
      v-model="payVisible"
      :order-no="order?.orderNo || ''"
      :amount="order?.payAmount || 0"
      @success="loadDetail"
    />
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import PremiumButton from '@/components/premium/PremiumButton.vue'
import PremiumCard from '@/components/premium/PremiumCard.vue'
import PremiumTag from '@/components/premium/PremiumTag.vue'
import PaymentDialog from '@/components/PaymentDialog.vue'
import { cancelOrder, getOrderDetail } from '@/api/order'
import { CHECKIN_STATUS, ORDER_STATUS, PAY_STATUS, statusOf } from '@/utils/orderStatus'

const route = useRoute()
const router = useRouter()

const loading = ref(false)
const order = ref(null)
const payVisible = ref(false)

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

async function loadDetail() {
  loading.value = true
  try {
    order.value = await getOrderDetail(route.params.orderNo)
  } catch {
    order.value = null
  } finally {
    loading.value = false
  }
}

async function handleCancel() {
  try {
    await ElMessageBox.confirm(
      '确定取消该订单吗？取消后库存将释放，且无法恢复。',
      '取消订单',
      { type: 'warning', confirmButtonText: '确定取消', cancelButtonText: '再想想' }
    )
  } catch {
    return
  }
  await cancelOrder(order.value.orderNo)
  ElMessage.success('订单已取消')
  loadDetail()
}

onMounted(loadDetail)
</script>

<style scoped lang="scss">
.order-detail-page {
  padding-top: var(--px-space-5);
}

.back-link {
  display: inline-flex;
  align-items: center;
  gap: 7px;
  margin-bottom: var(--px-space-4);
  padding: 8px 14px 8px 11px;
  border-radius: var(--px-radius-pill);
  background: rgba(255, 255, 255, 0.42);
  box-shadow: var(--px-shadow-1), inset 0 1px 0 rgba(255, 255, 255, 0.65);
  color: var(--px-ink-3);
  font-size: var(--px-text-sm);
  transition:
    background-color var(--px-duration-base) var(--px-ease-out),
    color var(--px-duration-base) var(--px-ease-out),
    transform var(--px-duration-fast) var(--px-ease-out);
}

.back-link:hover {
  background: rgba(255, 255, 255, 0.72);
  color: var(--px-ink-1);
  transform: translateX(-2px);
}

.detail-skeleton {
  display: flex;
  flex-direction: column;
  gap: var(--px-space-4);
}

/* ---------- status hero ---------- */
.status-hero {
  position: relative;
  z-index: var(--px-z-card);
  border-radius: var(--px-radius-xl);
  padding: 28px 32px 22px;
  background:
    radial-gradient(120% 120% at 88% 0%, rgba(138, 166, 184, 0.28), transparent 55%),
    linear-gradient(145deg, #263241 0%, #31404f 52%, #3a4b5b 100%);
  box-shadow: var(--px-shadow-3), inset 0 1px 0 rgba(255, 255, 255, 0.12);
  overflow: hidden;
}

.status-hero::after {
  content: '';
  position: absolute;
  right: -80px;
  top: -120px;
  width: 340px;
  height: 340px;
  border-radius: 50%;
  background: radial-gradient(circle, rgba(216, 196, 162, 0.18), transparent 66%);
  pointer-events: none;
}

.status-hero__inner {
  position: relative;
  z-index: 1;
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 32px;
}

.status-hero__eyebrow {
  font-size: 10px;
  font-weight: var(--px-weight-semibold);
  letter-spacing: 0.24em;
  text-transform: uppercase;
  color: rgba(255, 255, 255, 0.46);
}

.status-hero__status {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-top: 12px;
  font-size: var(--px-text-xl);
  font-weight: var(--px-weight-semibold);
  color: #fff;
  letter-spacing: 0.01em;
}

.status-hero__dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: #d8c4a2;
  box-shadow: 0 0 0 4px rgba(216, 196, 162, 0.14);
  animation: status-breathe var(--px-duration-breathe) var(--px-ease-soft) infinite alternate;
}

@keyframes status-breathe {
  from {
    box-shadow: 0 0 0 3px rgba(216, 196, 162, 0.12);
  }
  to {
    box-shadow: 0 0 0 8px rgba(216, 196, 162, 0.03);
  }
}

.status-hero__no {
  margin-top: 8px;
  font-size: var(--px-text-sm);
  color: rgba(255, 255, 255, 0.56);
  font-variant-numeric: tabular-nums;
  letter-spacing: 0.04em;
}

.status-hero__amount {
  text-align: right;
}

.status-hero__amount span {
  font-size: 10px;
  font-weight: var(--px-weight-semibold);
  letter-spacing: 0.2em;
  text-transform: uppercase;
  color: rgba(255, 255, 255, 0.46);
}

.status-hero__amount strong {
  display: flex;
  align-items: baseline;
  justify-content: flex-end;
  margin-top: 10px;
  font-size: var(--px-text-2xl);
  font-weight: var(--px-weight-semibold);
  color: #fff;
  font-variant-numeric: tabular-nums;
  line-height: 1;
}

.status-hero__amount em {
  font-style: normal;
  font-size: var(--px-text-sm);
  font-weight: var(--px-weight-medium);
  color: rgba(255, 255, 255, 0.5);
  margin-right: 4px;
}

.status-hero__foot {
  position: relative;
  z-index: 1;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 20px;
  margin-top: 26px;
  padding-top: 18px;
  background: linear-gradient(90deg, rgba(255, 255, 255, 0.16), rgba(255, 255, 255, 0.03)) top / 100% 1px no-repeat;
}

.status-hero__time {
  font-size: var(--px-text-xs);
  color: rgba(255, 255, 255, 0.42);
  letter-spacing: 0.04em;
}

.status-hero__actions {
  display: flex;
  align-items: center;
  gap: 10px;
}

.status-hero__actions :deep(.px-btn--ghost) {
  background: rgba(255, 255, 255, 0.1);
  color: rgba(255, 255, 255, 0.86);
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.16);
}

.status-hero__actions :deep(.px-btn--ghost:hover) {
  background: rgba(255, 255, 255, 0.18);
  color: #fff;
}

/* ---------- detail cards ---------- */
.detail-grid {
  display: grid;
  grid-template-columns: minmax(0, 1.35fr) minmax(0, 1fr);
  gap: var(--px-space-4);
  margin-top: var(--px-space-4);
  align-items: start;
}

.card-head {
  margin-bottom: var(--px-space-4);
}

.card-head h2 {
  margin-top: 7px;
  font-size: var(--px-text-md);
  color: var(--px-ink-1);
}

.info-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 0;
  margin: 0;
}

.info-cell {
  padding: 14px 0;
  min-width: 0;
  background: linear-gradient(90deg, transparent, var(--px-line), transparent) bottom / 100% 1px no-repeat;
}

.info-cell:nth-child(odd) {
  padding-right: 20px;
}

.info-cell:nth-child(even) {
  padding-left: 20px;
  background:
    linear-gradient(180deg, transparent, var(--px-line), transparent) left / 1px 100% no-repeat,
    linear-gradient(90deg, transparent, var(--px-line), transparent) bottom / 100% 1px no-repeat;
}

.info-cell dt {
  font-size: 10px;
  font-weight: var(--px-weight-semibold);
  letter-spacing: 0.16em;
  text-transform: uppercase;
  color: var(--px-ink-4);
}

.info-cell dd {
  margin: 6px 0 0;
  display: flex;
  align-items: center;
  gap: 8px;
  flex-wrap: wrap;
  font-size: var(--px-text-sm);
  font-weight: var(--px-weight-medium);
  color: var(--px-ink-1);
  font-variant-numeric: tabular-nums;
}

.info-cell dd.mono {
  font-size: var(--px-text-xs);
  letter-spacing: 0.02em;
}

.info-cell dd.amount {
  color: var(--px-accent-deep);
}

.info-muted {
  font-size: var(--px-text-xs);
  font-weight: var(--px-weight-regular);
  color: var(--px-ink-3);
}

/* ---------- items ---------- */
.items-table {
  display: flex;
  flex-direction: column;
}

.items-table__head,
.items-table__row {
  display: grid;
  grid-template-columns: 1.5fr 1fr 0.8fr 0.6fr 0.8fr;
  gap: 12px;
  align-items: center;
  padding: 12px 4px;
}

.items-table__head {
  font-size: 10px;
  font-weight: var(--px-weight-semibold);
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: var(--px-ink-4);
  background: linear-gradient(90deg, transparent, var(--px-line), transparent) bottom / 100% 1px no-repeat;
}

.items-table__row {
  font-size: var(--px-text-sm);
  color: var(--px-ink-2);
  background: linear-gradient(90deg, transparent, var(--px-line), transparent) bottom / 100% 1px no-repeat;
}

.items-table__row:last-of-type {
  background: none;
}

.col-name {
  font-weight: var(--px-weight-medium);
  color: var(--px-ink-1);
}

.col-price,
.col-qty,
.col-amount {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

.col-date {
  color: var(--px-ink-3);
}

.col-amount {
  color: var(--px-accent-deep);
  font-weight: var(--px-weight-semibold);
}

.items-table__empty {
  padding: 26px 0;
  text-align: center;
  font-size: var(--px-text-sm);
  color: var(--px-ink-3);
}
</style>
