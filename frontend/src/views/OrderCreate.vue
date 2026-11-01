<template>
  <div class="px-page order-page">
    <router-link :to="backTarget" class="back-link">
      <svg viewBox="0 0 16 16" width="13" height="13" aria-hidden="true">
        <path d="M13 8H3M7 4L3 8l4 4" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
      </svg>
      返回景点详情
    </router-link>

    <header class="checkout-head">
      <div>
        <p class="px-eyebrow">Checkout</p>
        <h1 class="checkout-head__title">填写订单</h1>
        <p class="px-subtitle">确认出行日期与联系人信息，提交后请在 30 分钟内完成支付。</p>
      </div>
      <ol class="steps">
        <li class="steps__item is-done"><span>1</span>选择票种</li>
        <li class="steps__line" />
        <li class="steps__item is-active"><span>2</span>填写订单</li>
        <li class="steps__line" />
        <li class="steps__item"><span>3</span>完成支付</li>
      </ol>
    </header>

    <div v-if="loading" class="checkout-grid">
      <PremiumCard variant="quiet" padding="lg"><el-skeleton :rows="6" animated /></PremiumCard>
      <PremiumCard variant="quiet" padding="lg"><el-skeleton :rows="5" animated /></PremiumCard>
    </div>

    <PremiumCard v-else-if="!ticket" variant="glass" padding="lg">
      <el-empty description="票种不存在或已下架">
        <PremiumButton variant="ghost" @click="router.push('/attractions')">返回景点列表</PremiumButton>
      </el-empty>
    </PremiumCard>

    <div v-else class="checkout-grid">
      <el-form
        ref="formRef"
        :model="form"
        :rules="rules"
        label-position="top"
        class="checkout-main order-forms"
      >
        <PremiumCard variant="glass" padding="lg">
          <header class="form-head">
            <span class="form-head__index">01</span>
            <div>
              <h2 class="form-head__title">出行信息</h2>
              <p class="form-head__desc">选择游玩日期与购买数量</p>
            </div>
          </header>

          <div class="field-grid">
            <el-form-item label="游玩日期" prop="visitDate">
              <el-date-picker
                v-model="form.visitDate"
                type="date"
                placeholder="请选择游玩日期"
                value-format="YYYY-MM-DD"
                :disabled-date="isPastDate"
                style="width: 100%"
                @change="loadInventory"
              />
              <p class="field-hint" :class="{ 'is-warning': !stockAvailable && form.visitDate }">
                <span class="field-hint__dot" />
                {{ stockText }}
              </p>
            </el-form-item>

            <el-form-item label="购买数量" prop="quantity">
              <el-input-number
                v-model="form.quantity"
                :min="1"
                :max="maxQuantity"
                :disabled="!stockAvailable"
                controls-position="right"
                style="width: 100%"
              />
              <p class="field-hint"><span class="field-hint__dot" />每单限购 {{ ticket.purchaseLimit }} 张</p>
            </el-form-item>
          </div>
        </PremiumCard>

        <PremiumCard variant="glass" padding="lg">
          <header class="form-head">
            <span class="form-head__index">02</span>
            <div>
              <h2 class="form-head__title">联系人信息</h2>
              <p class="form-head__desc">用于接收订单与入园通知</p>
            </div>
          </header>

          <div class="field-grid">
            <el-form-item label="联系人" prop="contactName">
              <PremiumInput v-model="form.contactName" placeholder="请输入联系人姓名" clearable autocomplete="name" />
            </el-form-item>

            <el-form-item label="联系电话" prop="contactPhone">
              <PremiumInput v-model="form.contactPhone" placeholder="请输入手机号" clearable autocomplete="tel" />
            </el-form-item>
          </div>

          <el-form-item label="备注">
            <PremiumInput
              v-model="form.remark"
              type="textarea"
              :rows="3"
              :maxlength="255"
              show-word-limit
              placeholder="选填，可填写特殊需求"
            />
          </el-form-item>
        </PremiumCard>
      </el-form>

      <aside class="checkout-aside">
        <PremiumCard variant="solid" floating padding="lg" class="summary-card">
          <p class="px-eyebrow">Order summary</p>
          <h2 class="summary-card__title">订单摘要</h2>

          <div class="summary-ticket">
            <div class="summary-ticket__media">
              <el-image v-if="attraction?.coverUrl" :src="attraction.coverUrl" fit="cover" />
              <span v-else>{{ attraction?.name?.slice(0, 1) || 'T' }}</span>
            </div>
            <div class="summary-ticket__text">
              <strong>{{ attraction?.name || '景点门票' }}</strong>
              <span>{{ ticket.name }}</span>
            </div>
          </div>

          <div class="summary-rows">
            <div class="summary-row">
              <span>游玩日期</span>
              <b>{{ form.visitDate || '待选择' }}</b>
            </div>
            <div class="summary-row">
              <span>购买数量</span>
              <b>{{ form.quantity }} 张</b>
            </div>
            <div class="summary-row">
              <span>单价</span>
              <b>¥ {{ ticket.price }}</b>
            </div>
            <div class="summary-row">
              <span>库存状态</span>
              <b :class="{ 'is-warning': !stockAvailable }">{{ stockText }}</b>
            </div>
          </div>

          <div class="summary-total">
            <span>应付金额</span>
            <div class="summary-total__value">
              <em>¥</em>
              <strong>{{ totalAmount }}</strong>
            </div>
          </div>

          <PremiumButton
            block
            size="lg"
            :loading="submitting"
            :disabled="!stockAvailable"
            @click="submit"
          >
            提交订单
          </PremiumButton>

          <p class="summary-note">提交即表示同意平台预订须知，订单超时未支付将自动关闭。</p>
        </PremiumCard>
      </aside>
    </div>

    <PremiumModal
      v-model="successVisible"
      eyebrow="Confirmed"
      title="下单成功"
      subtitle="订单已创建，请尽快完成支付"
      width="480px"
      :close-on-click-modal="false"
    >
      <div v-if="createdOrder" class="success-panel">
        <div class="success-row">
          <span>订单号</span>
          <b>{{ createdOrder.orderNo }}</b>
        </div>
        <div class="success-row">
          <span>应付金额</span>
          <b class="success-row__amount"><em>¥</em>{{ createdOrder.payAmount }}</b>
        </div>
        <div class="success-row">
          <span>游玩日期</span>
          <b>{{ createdOrder.visitDate }}</b>
        </div>
        <div class="success-row">
          <span>支付截止</span>
          <b>{{ createdOrder.expireTime }}</b>
        </div>
      </div>
      <p class="success-tip">请尽快完成支付，超时订单将无法支付。</p>
      <template #footer>
        <PremiumButton variant="ghost" @click="backToAttractions">返回景点列表</PremiumButton>
        <PremiumButton @click="goOrderDetail">查看订单</PremiumButton>
      </template>
    </PremiumModal>
  </div>
</template>

<script setup>
import { computed, onMounted, reactive, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import PremiumButton from '@/components/premium/PremiumButton.vue'
import PremiumCard from '@/components/premium/PremiumCard.vue'
import PremiumInput from '@/components/premium/PremiumInput.vue'
import PremiumModal from '@/components/premium/PremiumModal.vue'
import { getTicketTypeDetail } from '@/api/ticketType'
import { getAttractionDetail } from '@/api/attraction'
import { getInventory } from '@/api/inventory'
import { createOrder } from '@/api/order'

const route = useRoute()
const router = useRouter()

const ticketTypeId = Number(route.query.ticketTypeId)

const loading = ref(false)
const submitting = ref(false)
const ticket = ref(null)
const attraction = ref(null)
const inventory = ref(null)
const inventoryLoading = ref(false)
const successVisible = ref(false)
const createdOrder = ref(null)
const formRef = ref()

const form = reactive({
  visitDate: '',
  quantity: 1,
  contactName: '',
  contactPhone: '',
  remark: ''
})

const rules = {
  visitDate: [{ required: true, message: '请选择游玩日期', trigger: 'change' }],
  quantity: [{ required: true, message: '请选择购买数量', trigger: 'change' }],
  contactName: [{ required: true, message: '请输入联系人姓名', trigger: 'blur' }],
  contactPhone: [
    { required: true, message: '请输入联系电话', trigger: 'blur' },
    { pattern: /^1[3-9]\d{9}$/, message: '手机号格式不正确', trigger: 'blur' }
  ]
}

const backTarget = computed(() =>
  attraction.value ? `/attractions/${attraction.value.id}` : '/attractions'
)

const stockAvailable = computed(
  () => Boolean(inventory.value) && inventory.value.status === 1 && inventory.value.availableStock > 0
)

const maxQuantity = computed(() => {
  if (!ticket.value) return 1
  const limit = ticket.value.purchaseLimit || 1
  if (!stockAvailable.value) return limit
  return Math.max(1, Math.min(limit, inventory.value.availableStock))
})

const totalAmount = computed(() => {
  if (!ticket.value) return '0.00'
  return (Number(ticket.value.price) * form.quantity).toFixed(2)
})

const stockText = computed(() => {
  if (!form.visitDate) return '请选择游玩日期后查看余票'
  if (inventoryLoading.value) return '正在查询余票...'
  if (!inventory.value) return '该日期暂无库存配置'
  if (inventory.value.status !== 1) return '该日期库存未开放'
  if (inventory.value.availableStock <= 0) return '该日期已售罄'
  return `剩余 ${inventory.value.availableStock} 张`
})

watch(inventory, () => {
  if (form.quantity > maxQuantity.value) {
    form.quantity = maxQuantity.value
  }
})

function isPastDate(date) {
  const today = new Date()
  today.setHours(0, 0, 0, 0)
  return date.getTime() < today.getTime()
}

async function loadTicket() {
  loading.value = true
  try {
    ticket.value = await getTicketTypeDetail(ticketTypeId)
    attraction.value = await getAttractionDetail(ticket.value.attractionId)
  } catch {
    ticket.value = null
  } finally {
    loading.value = false
  }
}

async function loadInventory() {
  inventory.value = null
  if (!form.visitDate) return
  inventoryLoading.value = true
  try {
    inventory.value = await getInventory(ticketTypeId, form.visitDate)
  } catch {
    inventory.value = null
  } finally {
    inventoryLoading.value = false
  }
}

async function submit() {
  const valid = await formRef.value.validate().catch(() => false)
  if (!valid) return
  if (!stockAvailable.value) {
    ElMessage.warning(stockText.value)
    return
  }
  submitting.value = true
  try {
    createdOrder.value = await createOrder({
      ticketTypeId,
      visitDate: form.visitDate,
      quantity: form.quantity,
      contactName: form.contactName,
      contactPhone: form.contactPhone,
      remark: form.remark || undefined
    })
    successVisible.value = true
  } finally {
    submitting.value = false
  }
}

function backToAttractions() {
  successVisible.value = false
  router.push('/attractions')
}

function goOrderDetail() {
  successVisible.value = false
  router.push(`/orders/${createdOrder.value.orderNo}`)
}

onMounted(() => {
  if (!ticketTypeId) {
    ElMessage.warning('缺少票种参数')
    router.replace('/attractions')
    return
  }
  loadTicket()
})
</script>

<style scoped lang="scss">
.order-page {
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

.checkout-head {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 32px;
  margin-bottom: var(--px-space-5);
}

.checkout-head__title {
  margin: 8px 0 8px;
  font-size: var(--px-text-2xl);
  color: var(--px-ink-1);
}

.steps {
  display: flex;
  align-items: center;
  gap: 10px;
  margin: 0;
  padding: 12px 16px;
  list-style: none;
  border-radius: var(--px-radius-pill);
  background: rgba(255, 255, 255, 0.42);
  box-shadow: var(--px-shadow-1), inset 0 1px 0 rgba(255, 255, 255, 0.65);
}

.steps__item {
  display: inline-flex;
  align-items: center;
  gap: 7px;
  font-size: var(--px-text-xs);
  color: var(--px-ink-3);
  white-space: nowrap;
}

.steps__item span {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 20px;
  height: 20px;
  border-radius: 50%;
  background: rgba(32, 42, 54, 0.06);
  font-size: 10px;
  font-weight: var(--px-weight-semibold);
}

.steps__item.is-done {
  color: var(--px-ink-2);
}

.steps__item.is-done span {
  background: var(--px-success-soft);
  color: var(--px-success);
}

.steps__item.is-active {
  color: var(--px-accent-deep);
  font-weight: var(--px-weight-semibold);
}

.steps__item.is-active span {
  background: var(--px-accent);
  color: #fff;
}

.steps__line {
  width: 22px;
  height: 1px;
  background: var(--px-line-strong);
}

.checkout-grid {
  display: grid;
  grid-template-columns: minmax(0, 1fr) 360px;
  gap: var(--px-space-5);
  align-items: start;
}

.checkout-main {
  display: flex;
  flex-direction: column;
  gap: var(--px-space-4);
}

.form-head {
  display: flex;
  align-items: flex-start;
  gap: 14px;
  margin-bottom: var(--px-space-5);
}

.form-head__index {
  font-size: var(--px-text-xs);
  font-weight: var(--px-weight-semibold);
  letter-spacing: 0.12em;
  color: var(--px-gold);
  padding-top: 4px;
}

.form-head__title {
  font-size: var(--px-text-md);
  color: var(--px-ink-1);
}

.form-head__desc {
  margin-top: 4px;
  font-size: var(--px-text-xs);
  color: var(--px-ink-3);
}

.field-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: var(--px-space-4);
}

.field-hint {
  display: flex;
  align-items: center;
  gap: 6px;
  margin-top: 8px;
  font-size: var(--px-text-xs);
  color: var(--px-ink-3);
  line-height: var(--px-leading-snug);
}

.field-hint__dot {
  width: 4px;
  height: 4px;
  flex: none;
  border-radius: 50%;
  background: var(--px-success);
  opacity: 0.7;
}

.field-hint.is-warning {
  color: var(--px-danger);
}

.field-hint.is-warning .field-hint__dot {
  background: var(--px-danger);
}

/* ---------- summary ---------- */
.checkout-aside {
  position: sticky;
  top: calc(var(--px-header-h) + 34px);
}

.summary-card__title {
  margin: 8px 0 20px;
  font-size: var(--px-text-lg);
  color: var(--px-ink-1);
}

.summary-ticket {
  display: flex;
  align-items: center;
  gap: 12px;
  padding-bottom: 16px;
  background: linear-gradient(90deg, transparent, var(--px-line-strong), transparent) bottom / 100% 1px no-repeat;
}

.summary-ticket__media {
  width: 56px;
  height: 56px;
  flex: none;
  border-radius: var(--px-radius-sm);
  overflow: hidden;
  background: var(--px-accent-soft);
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--px-accent-deep);
  font-weight: var(--px-weight-semibold);
}

.summary-ticket__media :deep(.el-image) {
  width: 100%;
  height: 100%;
}

.summary-ticket__media :deep(img) {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.summary-ticket__text {
  display: flex;
  flex-direction: column;
  gap: 4px;
  min-width: 0;
}

.summary-ticket__text strong {
  font-size: var(--px-text-sm);
  font-weight: var(--px-weight-semibold);
  color: var(--px-ink-1);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.summary-ticket__text span {
  font-size: var(--px-text-xs);
  color: var(--px-ink-3);
}

.summary-rows {
  display: flex;
  flex-direction: column;
  gap: 11px;
  padding: 16px 0;
}

.summary-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  font-size: var(--px-text-sm);
  color: var(--px-ink-3);
}

.summary-row b {
  font-weight: var(--px-weight-medium);
  color: var(--px-ink-1);
  text-align: right;
}

.summary-row b.is-warning {
  color: var(--px-danger);
}

.summary-total {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  padding: 16px 0 20px;
  background: linear-gradient(90deg, transparent, var(--px-line-strong), transparent) top / 100% 1px no-repeat;
}

.summary-total > span {
  font-size: var(--px-text-sm);
  color: var(--px-ink-2);
}

.summary-total__value {
  display: inline-flex;
  align-items: baseline;
  color: var(--px-accent-deep);
}

.summary-total__value em {
  font-style: normal;
  font-size: var(--px-text-sm);
  font-weight: var(--px-weight-medium);
  margin-right: 3px;
  color: var(--px-ink-3);
}

.summary-total__value strong {
  font-size: var(--px-text-2xl);
  font-weight: var(--px-weight-semibold);
  letter-spacing: -0.02em;
  font-variant-numeric: tabular-nums;
  line-height: 1;
}

.summary-note {
  margin-top: 14px;
  font-size: var(--px-text-xs);
  line-height: var(--px-leading-snug);
  color: var(--px-ink-4);
  text-align: center;
}

/* ---------- success ---------- */
.success-panel {
  display: flex;
  flex-direction: column;
  padding: 6px 18px;
  border-radius: var(--px-radius-md);
  background: rgba(32, 42, 54, 0.035);
}

.success-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 20px;
  padding: 13px 0;
  font-size: var(--px-text-sm);
  color: var(--px-ink-3);
}

.success-row + .success-row {
  background: linear-gradient(90deg, transparent, rgba(32, 42, 54, 0.08), transparent) top / 100% 1px no-repeat;
}

.success-row b {
  font-weight: var(--px-weight-medium);
  color: var(--px-ink-1);
  text-align: right;
  font-variant-numeric: tabular-nums;
}

.success-row__amount {
  color: var(--px-accent-deep) !important;
  font-size: var(--px-text-lg);
  font-weight: var(--px-weight-semibold) !important;
}

.success-row__amount em {
  font-style: normal;
  font-size: var(--px-text-xs);
  font-weight: var(--px-weight-medium);
  color: var(--px-ink-3);
  margin-right: 3px;
}

.success-tip {
  margin-top: 14px;
  font-size: var(--px-text-xs);
  color: var(--px-ink-3);
}
</style>
