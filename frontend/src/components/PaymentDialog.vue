<template>
  <PremiumModal
    :model-value="modelValue"
    eyebrow="Payment"
    title="模拟支付"
    :subtitle="orderNo ? `订单 ${orderNo}` : ''"
    width="460px"
    :close-on-click-modal="false"
    @update:model-value="(v) => emit('update:modelValue', v)"
    @closed="close"
  >
    <div class="pay-panel">
      <div class="pay-panel__row">
        <span>订单号</span>
        <b class="pay-panel__mono">{{ orderNo }}</b>
      </div>
      <div class="pay-panel__row">
        <span>应付金额</span>
        <b class="pay-panel__amount"><em>¥</em>{{ amount }}</b>
      </div>
      <div class="pay-panel__row">
        <span>支付单号</span>
        <b v-if="payLoading" class="pay-panel__pending">
          <i /><i /><i />
        </b>
        <b v-else class="pay-panel__mono">{{ paymentNo || '—' }}</b>
      </div>
    </div>

    <p class="pay-tip">
      <span class="pay-tip__dot" />
      当前为演示支付，点击「模拟支付成功」会直接触发支付回调。
    </p>

    <template #footer>
      <PremiumButton variant="ghost" @click="close">取消</PremiumButton>
      <PremiumButton
        :loading="callbackLoading"
        :disabled="!paymentNo || payLoading"
        @click="confirmPay"
      >
        模拟支付成功
      </PremiumButton>
    </template>
  </PremiumModal>
</template>

<script setup>
import { ref, watch } from 'vue'
import { ElMessage } from 'element-plus'
import PremiumButton from '@/components/premium/PremiumButton.vue'
import PremiumModal from '@/components/premium/PremiumModal.vue'
import { payOrder, paymentCallback } from '@/api/payment'

const props = defineProps({
  modelValue: { type: Boolean, default: false },
  orderNo: { type: String, default: '' },
  amount: { type: [Number, String], default: 0 }
})

const emit = defineEmits(['update:modelValue', 'success'])

const paymentNo = ref('')
const payLoading = ref(false)
const callbackLoading = ref(false)

watch(
  () => props.modelValue,
  (visible) => {
    if (visible) {
      createPayment()
    }
  }
)

async function createPayment() {
  paymentNo.value = ''
  payLoading.value = true
  try {
    paymentNo.value = await payOrder(props.orderNo)
  } catch {
    paymentNo.value = ''
  } finally {
    payLoading.value = false
  }
}

function formatNow() {
  const now = new Date()
  const pad = (value) => String(value).padStart(2, '0')
  return `${now.getFullYear()}-${pad(now.getMonth() + 1)}-${pad(now.getDate())} ` +
    `${pad(now.getHours())}:${pad(now.getMinutes())}:${pad(now.getSeconds())}`
}

async function confirmPay() {
  callbackLoading.value = true
  try {
    await paymentCallback({
      paymentNo: paymentNo.value,
      orderNo: props.orderNo,
      tradeNo: `MOCK${Date.now()}`,
      amount: Number(props.amount),
      status: 1,
      callbackTime: formatNow()
    })
    ElMessage.success('支付成功')
    emit('success')
    close()
  } finally {
    callbackLoading.value = false
  }
}

function close() {
  emit('update:modelValue', false)
}
</script>

<style scoped lang="scss">
.pay-panel {
  display: flex;
  flex-direction: column;
  gap: 0;
  padding: 6px 18px;
  border-radius: var(--px-radius-md);
  background: rgba(32, 42, 54, 0.035);
}

.pay-panel__row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 20px;
  padding: 13px 0;
  font-size: var(--px-text-sm);
  color: var(--px-ink-3);
}

.pay-panel__row + .pay-panel__row {
  background: linear-gradient(90deg, transparent, rgba(32, 42, 54, 0.08), transparent) top / 100% 1px no-repeat;
}

.pay-panel__row b {
  font-weight: var(--px-weight-medium);
  color: var(--px-ink-1);
  text-align: right;
  word-break: break-all;
}

.pay-panel__mono {
  font-size: var(--px-text-xs);
  letter-spacing: 0.02em;
  font-variant-numeric: tabular-nums;
}

.pay-panel__amount {
  font-size: var(--px-text-lg);
  font-weight: var(--px-weight-semibold);
  color: var(--px-accent-deep) !important;
  font-variant-numeric: tabular-nums;
}

.pay-panel__amount em {
  font-style: normal;
  font-size: var(--px-text-xs);
  font-weight: var(--px-weight-medium);
  color: var(--px-ink-3);
  margin-right: 3px;
}

.pay-panel__pending {
  display: inline-flex;
  gap: 4px;
}

.pay-panel__pending i {
  width: 4px;
  height: 4px;
  border-radius: 50%;
  background: var(--px-accent);
  animation: pay-dot 1.4s var(--px-ease-soft) infinite;
}

.pay-panel__pending i:nth-child(2) {
  animation-delay: 0.18s;
}

.pay-panel__pending i:nth-child(3) {
  animation-delay: 0.36s;
}

@keyframes pay-dot {
  0%,
  100% {
    opacity: 0.25;
    transform: translateY(0);
  }
  45% {
    opacity: 1;
    transform: translateY(-2px);
  }
}

.pay-tip {
  display: flex;
  align-items: flex-start;
  gap: 8px;
  margin-top: 16px;
  font-size: var(--px-text-xs);
  line-height: var(--px-leading-snug);
  color: var(--px-ink-3);
}

.pay-tip__dot {
  width: 5px;
  height: 5px;
  flex: none;
  margin-top: 6px;
  border-radius: 50%;
  background: var(--px-gold);
  opacity: 0.8;
}
</style>
