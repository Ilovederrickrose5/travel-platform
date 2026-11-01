<template>
  <PremiumCard variant="glass" padding="lg" class="admin-card">
    <header class="admin-toolbar">
      <div class="admin-toolbar__title">
        <p class="px-eyebrow">Orders</p>
        <h2>订单列表 <span class="admin-toolbar__count">{{ list.length }}</span></h2>
      </div>
      <PremiumButton variant="ghost" :loading="loading" @click="loadList">刷新</PremiumButton>
    </header>

    <div class="filter-bar">
      <div class="filter-bar__field">
        <span class="filter-bar__label">订单状态</span>
        <el-select v-model="orderStatus" placeholder="全部" clearable style="width: 160px" @change="loadList">
          <el-option
            v-for="(item, code) in ORDER_STATUS"
            :key="code"
            :label="item.label"
            :value="Number(code)"
          />
        </el-select>
      </div>
    </div>

    <el-table v-loading="loading" :data="list" empty-text="暂无订单" class="admin-table">
      <el-table-column prop="orderNo" label="订单号" width="210" />
      <el-table-column prop="visitDate" label="游玩日期" width="120" />
      <el-table-column label="金额" width="110">
        <template #default="{ row }"><span class="table-money">¥{{ row.totalAmount }}</span></template>
      </el-table-column>
      <el-table-column label="订单状态" width="110">
        <template #default="{ row }">
          <PremiumTag :tone="toneOf(statusOf(ORDER_STATUS, row.orderStatus).type)">
            {{ statusOf(ORDER_STATUS, row.orderStatus).label }}
          </PremiumTag>
        </template>
      </el-table-column>
      <el-table-column label="支付状态" width="110">
        <template #default="{ row }">
          <PremiumTag variant="hollow" :tone="toneOf(statusOf(PAY_STATUS, row.payStatus).type)">
            {{ statusOf(PAY_STATUS, row.payStatus).label }}
          </PremiumTag>
        </template>
      </el-table-column>
      <el-table-column label="核销" width="140">
        <template #default="{ row }">
          <PremiumTag variant="hollow" :tone="toneOf(statusOf(CHECKIN_STATUS, row.checkinStatus).type)">
            {{ statusOf(CHECKIN_STATUS, row.checkinStatus).label }}
          </PremiumTag>
          <span v-if="row.checkedQuantity > 0" class="table-extra">{{ row.checkedQuantity }} 张</span>
        </template>
      </el-table-column>
      <el-table-column prop="createdAt" label="下单时间" width="170" />
      <el-table-column label="操作" width="160" fixed="right">
        <template #default="{ row }">
          <div class="table-actions">
            <PremiumButton variant="text" size="sm" @click="openDetail(row)">详情</PremiumButton>
            <PremiumButton
              v-if="row.orderStatus === 10 && row.checkinStatus !== 1"
              variant="text"
              tone="success"
              size="sm"
              @click="openCheckin(row)"
            >
              核销
            </PremiumButton>
            <PremiumButton
              v-if="row.orderStatus === 0"
              variant="text"
              tone="danger"
              size="sm"
              @click="handleClose(row)"
            >
              关闭
            </PremiumButton>
          </div>
        </template>
      </el-table-column>
    </el-table>
  </PremiumCard>

  <PremiumModal
    v-model="detailVisible"
    eyebrow="Order"
    title="订单详情"
    :subtitle="detail ? `订单号 ${detail.orderNo}` : ''"
    width="760px"
  >
    <el-skeleton v-if="detailLoading" :rows="5" animated />
    <template v-else-if="detail">
      <div class="admin-info-grid">
        <div class="admin-info-cell">
          <span>订单状态</span>
          <b>{{ statusOf(ORDER_STATUS, detail.orderStatus).label }}</b>
        </div>
        <div class="admin-info-cell">
          <span>游玩日期</span>
          <b>{{ detail.visitDate }}</b>
        </div>
        <div class="admin-info-cell">
          <span>联系人</span>
          <b>{{ detail.contactName }}（{{ detail.contactPhone }}）</b>
        </div>
        <div class="admin-info-cell">
          <span>下单时间</span>
          <b>{{ detail.createdAt }}</b>
        </div>
        <div class="admin-info-cell">
          <span>订单总额</span>
          <b>¥ {{ detail.totalAmount }}</b>
        </div>
        <div class="admin-info-cell">
          <span>应付金额</span>
          <b class="is-accent">¥ {{ detail.payAmount }}</b>
        </div>
        <div class="admin-info-cell">
          <span>支付时间</span>
          <b>{{ detail.payTime || '—' }}</b>
        </div>
        <div class="admin-info-cell">
          <span>核销状态</span>
          <b>
            {{ statusOf(CHECKIN_STATUS, detail.checkinStatus).label }}
            <i v-if="detail.checkedQuantity > 0">· {{ detail.checkedQuantity }} 张</i>
          </b>
        </div>
        <div class="admin-info-cell span-2">
          <span>备注</span>
          <b>{{ detail.remark || '—' }}</b>
        </div>
      </div>

      <div class="admin-items">
        <div class="admin-items__head">
          <span>票种</span>
          <span>游玩日期</span>
          <span class="is-right">单价</span>
          <span class="is-right">数量</span>
          <span class="is-right">小计</span>
        </div>
        <div v-for="item in detail.items" :key="item.id || item.ticketName" class="admin-items__row">
          <span class="is-strong">{{ item.ticketName }}</span>
          <span class="is-muted">{{ item.visitDate }}</span>
          <span class="is-right">¥ {{ item.unitPrice }}</span>
          <span class="is-right">{{ item.quantity }}</span>
          <span class="is-right is-accent">¥ {{ item.amount }}</span>
        </div>
        <div v-if="!detail.items?.length" class="admin-items__empty">暂无明细</div>
      </div>
    </template>
    <template #footer>
      <PremiumButton variant="ghost" @click="detailVisible = false">关闭</PremiumButton>
    </template>
  </PremiumModal>

  <PremiumModal
    v-model="checkinVisible"
    eyebrow="Check-in"
    title="订单核销"
    :subtitle="checkinForm.orderNo"
    width="440px"
    :close-on-click-modal="false"
  >
    <div class="checkin-panel">
      <div class="checkin-row">
        <span>可核销数量</span>
        <b>{{ checkinForm.remaining }} 张</b>
      </div>
      <div class="checkin-field">
        <span class="checkin-field__label">本次核销</span>
        <el-input-number
          v-model="checkinForm.quantity"
          :min="1"
          :max="Math.max(checkinForm.remaining, 1)"
          :disabled="checkinForm.remaining <= 0"
          controls-position="right"
          style="width: 100%"
        />
      </div>
    </div>
    <template #footer>
      <PremiumButton variant="ghost" @click="checkinVisible = false">取消</PremiumButton>
      <PremiumButton
        :loading="checkinSubmitting"
        :disabled="checkinForm.remaining <= 0"
        @click="submitCheckin"
      >
        确认核销
      </PremiumButton>
    </template>
  </PremiumModal>
</template>

<script setup>
import { onMounted, reactive, ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import PremiumButton from '@/components/premium/PremiumButton.vue'
import PremiumCard from '@/components/premium/PremiumCard.vue'
import PremiumModal from '@/components/premium/PremiumModal.vue'
import PremiumTag from '@/components/premium/PremiumTag.vue'
import { checkIn, closeOrder, getAdminOrderDetail, getAdminOrders } from '@/api/admin'
import { getAdminUser } from '@/utils/adminAuth'
import { CHECKIN_STATUS, ORDER_STATUS, PAY_STATUS, statusOf } from '@/utils/orderStatus'

const loading = ref(false)
const list = ref([])
const orderStatus = ref(null)

const detailVisible = ref(false)
const detailLoading = ref(false)
const detail = ref(null)

const checkinVisible = ref(false)
const checkinSubmitting = ref(false)
const checkinForm = reactive({ orderNo: '', quantity: 1, remaining: 0 })

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

async function loadList() {
  loading.value = true
  try {
    const params = {}
    if (orderStatus.value !== null && orderStatus.value !== '') {
      params.orderStatus = orderStatus.value
    }
    list.value = await getAdminOrders(params)
  } catch {
    list.value = []
  } finally {
    loading.value = false
  }
}

async function openDetail(row) {
  detailVisible.value = true
  detail.value = null
  detailLoading.value = true
  try {
    detail.value = await getAdminOrderDetail(row.orderNo)
  } catch {
    detail.value = null
  } finally {
    detailLoading.value = false
  }
}

async function openCheckin(row) {
  checkinForm.orderNo = row.orderNo
  checkinForm.quantity = 1
  checkinForm.remaining = 1
  checkinVisible.value = true
  try {
    const orderDetail = await getAdminOrderDetail(row.orderNo)
    const total = (orderDetail.items || []).reduce(
      (sum, item) => sum + (item.quantity || 0),
      0
    )
    checkinForm.remaining = Math.max(0, total - (orderDetail.checkedQuantity || 0))
    checkinForm.quantity = Math.max(1, checkinForm.remaining)
  } catch {
    // 查询详情失败时保留默认值，由后端做核销数量校验
  }
}

async function submitCheckin() {
  if (checkinForm.remaining <= 0) {
    ElMessage.warning('该订单暂无可核销数量')
    return
  }
  checkinSubmitting.value = true
  try {
    await checkIn({
      orderNo: checkinForm.orderNo,
      quantity: checkinForm.quantity,
      operatorId: getAdminUser()?.userId
    })
    ElMessage.success('核销成功')
    checkinVisible.value = false
    loadList()
  } finally {
    checkinSubmitting.value = false
  }
}

async function handleClose(row) {
  try {
    await ElMessageBox.confirm(
      `确定关闭订单 ${row.orderNo} 吗？关闭后库存将立即释放。`,
      '关闭订单',
      { type: 'warning', confirmButtonText: '确定关闭', cancelButtonText: '取消' }
    )
  } catch {
    return
  }
  await closeOrder(row.orderNo)
  ElMessage.success('订单已关闭')
  loadList()
}

onMounted(loadList)
</script>

<style scoped lang="scss">
.admin-card {
  min-height: 420px;
}

.admin-toolbar {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 20px;
  margin-bottom: var(--px-space-4);
}

.admin-toolbar__title h2 {
  margin-top: 7px;
  font-size: var(--px-text-lg);
  color: var(--px-ink-1);
}

.admin-toolbar__count {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 24px;
  height: 20px;
  margin-left: 6px;
  padding: 0 7px;
  border-radius: var(--px-radius-pill);
  background: var(--px-accent-soft);
  color: var(--px-accent-deep);
  font-size: 11px;
  font-weight: var(--px-weight-semibold);
  vertical-align: 2px;
}

.filter-bar {
  display: flex;
  align-items: flex-end;
  gap: 14px;
  margin-bottom: var(--px-space-4);
  padding: 14px 16px;
  border-radius: var(--px-radius-md);
  background: rgba(255, 255, 255, 0.34);
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.6);
}

.filter-bar__field {
  display: flex;
  flex-direction: column;
  gap: 7px;
}

.filter-bar__label {
  font-size: 10px;
  font-weight: var(--px-weight-semibold);
  letter-spacing: 0.14em;
  text-transform: uppercase;
  color: var(--px-ink-4);
}

.admin-table {
  margin-top: 4px;
}

.table-money {
  color: var(--px-accent-deep);
  font-weight: var(--px-weight-semibold);
  font-variant-numeric: tabular-nums;
}

.table-extra {
  margin-left: 6px;
  font-size: var(--px-text-xs);
  color: var(--px-ink-3);
}

.table-actions {
  display: flex;
  align-items: center;
  gap: 2px;
}

.admin-info-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 0 20px;
  padding: 4px 18px;
  border-radius: var(--px-radius-md);
  background: rgba(32, 42, 54, 0.03);
}

.admin-info-cell {
  display: flex;
  flex-direction: column;
  gap: 5px;
  padding: 13px 0;
  background: linear-gradient(90deg, transparent, var(--px-line), transparent) bottom / 100% 1px no-repeat;
}

.admin-info-cell.span-2 {
  grid-column: span 2;
}

.admin-info-cell span {
  font-size: 10px;
  font-weight: var(--px-weight-semibold);
  letter-spacing: 0.14em;
  text-transform: uppercase;
  color: var(--px-ink-4);
}

.admin-info-cell b {
  font-size: var(--px-text-sm);
  font-weight: var(--px-weight-medium);
  color: var(--px-ink-1);
  font-variant-numeric: tabular-nums;
}

.admin-info-cell b.is-accent {
  color: var(--px-accent-deep);
}

.admin-info-cell b i {
  font-style: normal;
  font-weight: var(--px-weight-regular);
  color: var(--px-ink-3);
}

.admin-items {
  margin-top: 16px;
  padding: 0 4px;
}

.admin-items__head,
.admin-items__row {
  display: grid;
  grid-template-columns: 1.4fr 1fr 0.7fr 0.5fr 0.8fr;
  gap: 12px;
  align-items: center;
  padding: 10px 0;
}

.admin-items__head {
  font-size: 10px;
  font-weight: var(--px-weight-semibold);
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: var(--px-ink-4);
  background: linear-gradient(90deg, transparent, var(--px-line), transparent) bottom / 100% 1px no-repeat;
}

.admin-items__row {
  font-size: var(--px-text-sm);
  color: var(--px-ink-2);
  font-variant-numeric: tabular-nums;
  background: linear-gradient(90deg, transparent, var(--px-line), transparent) bottom / 100% 1px no-repeat;
}

.is-right {
  text-align: right;
}

.is-strong {
  font-weight: var(--px-weight-medium);
  color: var(--px-ink-1);
}

.is-muted {
  color: var(--px-ink-3);
}

.is-accent {
  color: var(--px-accent-deep);
  font-weight: var(--px-weight-semibold);
}

.admin-items__empty {
  padding: 22px 0;
  text-align: center;
  font-size: var(--px-text-sm);
  color: var(--px-ink-3);
}

.checkin-panel {
  display: flex;
  flex-direction: column;
  gap: 14px;
}

.checkin-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 13px 16px;
  border-radius: var(--px-radius-sm);
  background: rgba(32, 42, 54, 0.035);
  font-size: var(--px-text-sm);
  color: var(--px-ink-3);
}

.checkin-row b {
  color: var(--px-ink-1);
  font-weight: var(--px-weight-semibold);
  font-variant-numeric: tabular-nums;
}

.checkin-field {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.checkin-field__label {
  font-size: var(--px-text-xs);
  font-weight: var(--px-weight-medium);
  color: var(--px-ink-2);
}
</style>
