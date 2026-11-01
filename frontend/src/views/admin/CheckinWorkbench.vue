<template>
  <div class="checkin-page">
    <PremiumCard variant="glass" padding="lg">
      <header class="admin-toolbar">
        <div class="admin-toolbar__title">
          <p class="px-eyebrow">Check-in</p>
          <h2>订单核销</h2>
        </div>
      </header>

      <div class="lookup">
        <PremiumInput
          v-model="orderNo"
          placeholder="输入或扫描订单号，如 TK202610310001"
          size="lg"
          clearable
          class="lookup__input"
          @enter="lookup"
        />
        <PremiumButton size="lg" :loading="loading" @click="lookup">查询订单</PremiumButton>
      </div>
      <p class="lookup__hint">支持按订单号精确查询，核销后不可撤销。</p>
    </PremiumCard>

    <PremiumCard v-if="order" variant="glass" padding="lg">
      <header class="order-head">
        <div>
          <p class="order-head__no">{{ order.orderNo }}</p>
          <p class="order-head__meta">
            {{ order.visitDate }} · {{ order.contactName }} {{ order.contactPhone }}
          </p>
        </div>
        <div class="order-head__tags">
          <PremiumTag :tone="toneOf(statusOf(ORDER_STATUS, order.orderStatus).type)">
            {{ statusOf(ORDER_STATUS, order.orderStatus).label }}
          </PremiumTag>
          <PremiumTag variant="hollow" :tone="toneOf(statusOf(CHECKIN_STATUS, order.checkinStatus).type)">
            {{ statusOf(CHECKIN_STATUS, order.checkinStatus).label }}
          </PremiumTag>
        </div>
      </header>

      <div class="order-stats">
        <div class="order-stat">
          <span>票数</span>
          <b>{{ totalQuantity }} 张</b>
        </div>
        <div class="order-stat">
          <span>已核销</span>
          <b>{{ order.checkedQuantity || 0 }} 张</b>
        </div>
        <div class="order-stat">
          <span>可核销</span>
          <b class="is-accent">{{ remaining }} 张</b>
        </div>
      </div>

      <div class="order-items">
        <div v-for="item in order.items" :key="item.ticketName + item.visitDate" class="order-item">
          <span class="order-item__name">{{ item.ticketName }}</span>
          <span class="order-item__qty">× {{ item.quantity }}</span>
          <span class="order-item__amount">¥{{ item.amount }}</span>
        </div>
        <div v-if="!order.items?.length" class="order-items__empty">暂无票种明细</div>
      </div>

      <div class="checkin-bar">
        <div class="checkin-bar__field">
          <span class="checkin-bar__label">本次核销数量</span>
          <el-input-number
            v-model="quantity"
            :min="1"
            :max="Math.max(remaining, 1)"
            :disabled="!canCheckin"
            controls-position="right"
          />
        </div>
        <PremiumButton
          size="lg"
          tone="success"
          :loading="submitting"
          :disabled="!canCheckin"
          @click="submit"
        >
          确认核销
        </PremiumButton>
      </div>
      <p v-if="!canCheckin" class="checkin-warn">{{ warnText }}</p>
    </PremiumCard>
  </div>
</template>

<script setup>
import { computed, ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import PremiumButton from '@/components/premium/PremiumButton.vue'
import PremiumCard from '@/components/premium/PremiumCard.vue'
import PremiumInput from '@/components/premium/PremiumInput.vue'
import PremiumTag from '@/components/premium/PremiumTag.vue'
import { checkIn, getAdminOrderDetail } from '@/api/admin'
import { getAdminUser } from '@/utils/adminAuth'
import { CHECKIN_STATUS, ORDER_STATUS, statusOf } from '@/utils/orderStatus'

const orderNo = ref('')
const order = ref(null)
const quantity = ref(1)
const loading = ref(false)
const submitting = ref(false)

const totalQuantity = computed(() =>
  (order.value?.items || []).reduce((sum, item) => sum + (item.quantity || 0), 0)
)

const remaining = computed(() =>
  Math.max(totalQuantity.value - (order.value?.checkedQuantity || 0), 0)
)

const canCheckin = computed(
  () => Boolean(order.value) && order.value.orderStatus === 10 && remaining.value > 0
)

const warnText = computed(() => {
  if (!order.value) return ''
  if (remaining.value <= 0) return '该订单已全部核销'
  const label = statusOf(ORDER_STATUS, order.value.orderStatus).label
  return `当前订单状态为「${label}」，仅已支付订单可核销`
})

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

async function lookup() {
  const no = orderNo.value.trim()
  if (!no) {
    ElMessage.warning('请输入订单号')
    return
  }
  loading.value = true
  try {
    order.value = await getAdminOrderDetail(no)
    quantity.value = Math.min(1, remaining.value) || 1
  } catch {
    order.value = null
  } finally {
    loading.value = false
  }
}

async function submit() {
  if (!canCheckin.value) return
  const count = quantity.value
  try {
    await ElMessageBox.confirm(
      `确认核销订单 ${order.value.orderNo} 的 ${count} 张票？核销后不可撤销。`,
      '核销确认',
      { confirmButtonText: '确认核销', cancelButtonText: '取消', type: 'warning' }
    )
  } catch {
    return
  }
  submitting.value = true
  try {
    await checkIn({
      orderNo: order.value.orderNo,
      quantity: count,
      operatorId: getAdminUser()?.id
    })
    ElMessage.success(`已核销 ${count} 张`)
    order.value = await getAdminOrderDetail(order.value.orderNo)
    quantity.value = Math.min(1, remaining.value) || 1
  } finally {
    submitting.value = false
  }
}
</script>

<style scoped lang="scss">
.checkin-page {
  display: flex;
  flex-direction: column;
  gap: 16px;
  max-width: 880px;
}

.lookup {
  display: flex;
  gap: 10px;
}

.lookup__input {
  flex: 1;
}

.lookup__hint {
  margin-top: 10px;
  font-size: var(--px-text-xs);
  color: var(--px-ink-4);
}

.order-head {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  padding-bottom: 16px;
  border-bottom: 1px solid rgba(32, 42, 54, 0.07);
}

.order-head__no {
  font-size: var(--px-text-md);
  font-weight: var(--px-weight-semibold);
  color: var(--px-ink-1);
  font-variant-numeric: tabular-nums;
}

.order-head__meta {
  margin-top: 6px;
  font-size: var(--px-text-xs);
  color: var(--px-ink-3);
}

.order-head__tags {
  display: flex;
  gap: 8px;
  flex: none;
}

.order-stats {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 12px;
  margin: 18px 0;
}

.order-stat {
  padding: 14px 16px;
  border-radius: 10px;
  background: rgba(32, 42, 54, 0.03);
}

.order-stat span {
  display: block;
  font-size: var(--px-text-xs);
  color: var(--px-ink-3);
}

.order-stat b {
  display: block;
  margin-top: 6px;
  font-size: var(--px-text-lg);
  color: var(--px-ink-1);
  font-variant-numeric: tabular-nums;
}

.is-accent {
  color: var(--px-accent-deep);
}

.order-items {
  border: 1px solid rgba(32, 42, 54, 0.07);
  border-radius: 10px;
  overflow: hidden;
}

.order-item {
  display: grid;
  grid-template-columns: 1fr 70px 100px;
  gap: 12px;
  padding: 12px 16px;
  font-size: var(--px-text-sm);
  color: var(--px-ink-2);
}

.order-item + .order-item {
  border-top: 1px solid rgba(32, 42, 54, 0.06);
}

.order-item__name {
  font-weight: var(--px-weight-medium);
  color: var(--px-ink-1);
}

.order-item__qty {
  text-align: right;
  color: var(--px-ink-3);
}

.order-item__amount {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

.order-items__empty {
  padding: 16px;
  font-size: var(--px-text-xs);
  color: var(--px-ink-4);
}

.checkin-bar {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 20px;
  margin-top: 20px;
}

.checkin-bar__label {
  display: block;
  margin-bottom: 6px;
  font-size: var(--px-text-xs);
  color: var(--px-ink-2);
}

.checkin-warn {
  margin-top: 10px;
  font-size: var(--px-text-xs);
  color: var(--px-ink-4);
}
</style>
