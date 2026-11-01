<template>
  <PremiumCard variant="glass" padding="lg" class="admin-card">
    <header class="admin-toolbar">
      <div class="admin-toolbar__title">
        <p class="px-eyebrow">Inventory</p>
        <h2>库存日历 <span class="admin-toolbar__count">{{ list.length }}</span></h2>
      </div>
      <PremiumButton :disabled="!ticketTypeId" @click="openConfig()">配置库存</PremiumButton>
    </header>

    <div class="filter-bar">
      <div class="filter-bar__field">
        <span class="filter-bar__label">景点</span>
        <el-select
          v-model="attractionId"
          placeholder="请选择景点"
          style="width: 200px"
          @change="handleAttractionChange"
        >
          <el-option v-for="item in attractions" :key="item.id" :label="item.name" :value="item.id" />
        </el-select>
      </div>

      <div class="filter-bar__field">
        <span class="filter-bar__label">票种</span>
        <el-select
          v-model="ticketTypeId"
          placeholder="请选择票种"
          style="width: 180px"
          :disabled="!attractionId"
          @change="loadList"
        >
          <el-option
            v-for="item in ticketTypes"
            :key="item.id"
            :label="item.name"
            :value="item.id"
          />
        </el-select>
      </div>

      <div class="filter-bar__field">
        <span class="filter-bar__label">日期区间</span>
        <el-date-picker
          v-model="dateRange"
          type="daterange"
          value-format="YYYY-MM-DD"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
          @change="loadList"
        />
      </div>

      <PremiumButton variant="ghost" size="sm" :loading="loading" class="filter-bar__refresh" @click="loadList">
        刷新
      </PremiumButton>
    </div>

    <el-table v-loading="loading" :data="list" empty-text="暂无库存数据" class="admin-table">
      <el-table-column prop="visitDate" label="日期" width="130" />
      <el-table-column prop="totalStock" label="总库存" width="100" />
      <el-table-column prop="soldStock" label="已售" width="100" />
      <el-table-column label="可售" width="100">
        <template #default="{ row }">
          <span class="table-number" :class="{ 'is-low': row.availableStock === 0 }">
            {{ row.availableStock }}
          </span>
        </template>
      </el-table-column>
      <el-table-column label="状态" width="100">
        <template #default="{ row }">
          <PremiumTag :tone="row.status === 1 ? 'success' : 'neutral'">
            {{ row.status === 1 ? '开放' : '关闭' }}
          </PremiumTag>
        </template>
      </el-table-column>
      <el-table-column prop="updatedAt" label="更新时间" min-width="170" />
      <el-table-column label="操作" width="100" fixed="right">
        <template #default="{ row }">
          <PremiumButton variant="text" size="sm" @click="openConfig(row)">配置</PremiumButton>
        </template>
      </el-table-column>
    </el-table>
  </PremiumCard>

  <PremiumModal
    v-model="configVisible"
    eyebrow="Inventory"
    title="配置库存"
    subtitle="设置指定日期的总库存与开放状态"
    width="480px"
    :close-on-click-modal="false"
  >
    <el-form ref="configFormRef" :model="configForm" :rules="configRules" label-position="top">
      <div class="modal-grid">
        <el-form-item label="游玩日期" prop="visitDate" class="span-2">
          <el-date-picker
            v-model="configForm.visitDate"
            type="date"
            value-format="YYYY-MM-DD"
            style="width: 100%"
            :disabled="Boolean(configForm.soldStock)"
          />
        </el-form-item>

        <el-form-item v-if="configForm.soldStock" label="已售数量" class="span-2">
          <span class="sold-hint">{{ configForm.soldStock }} 张 · 总库存不可低于此值</span>
        </el-form-item>

        <el-form-item label="总库存" prop="totalStock">
          <el-input-number
            v-model="configForm.totalStock"
            :min="0"
            :step="10"
            controls-position="right"
            style="width: 100%"
          />
        </el-form-item>

        <el-form-item label="状态">
          <el-radio-group v-model="configForm.status">
            <el-radio :value="1">开放</el-radio>
            <el-radio :value="0">关闭</el-radio>
          </el-radio-group>
        </el-form-item>
      </div>
    </el-form>

    <template #footer>
      <PremiumButton variant="ghost" @click="configVisible = false">取消</PremiumButton>
      <PremiumButton :loading="configSubmitting" @click="submitConfig">保存</PremiumButton>
    </template>
  </PremiumModal>
</template>

<script setup>
import { onMounted, reactive, ref } from 'vue'
import { ElMessage } from 'element-plus'
import PremiumButton from '@/components/premium/PremiumButton.vue'
import PremiumCard from '@/components/premium/PremiumCard.vue'
import PremiumModal from '@/components/premium/PremiumModal.vue'
import PremiumTag from '@/components/premium/PremiumTag.vue'
import {
  configInventory,
  getAdminAttractions,
  getAdminInventory,
  getAdminTicketTypes
} from '@/api/admin'

const attractions = ref([])
const attractionId = ref(null)
const ticketTypes = ref([])
const ticketTypeId = ref(null)
const dateRange = ref(defaultDateRange())

const loading = ref(false)
const list = ref([])

const configVisible = ref(false)
const configSubmitting = ref(false)
const configFormRef = ref()
const configForm = reactive(emptyConfig())

const configRules = {
  visitDate: [{ required: true, message: '请选择游玩日期', trigger: 'change' }],
  totalStock: [{ required: true, message: '请输入总库存', trigger: 'blur' }]
}

function formatDate(date) {
  const pad = (value) => String(value).padStart(2, '0')
  return `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())}`
}

function defaultDateRange() {
  const start = new Date()
  const end = new Date()
  end.setDate(end.getDate() + 7)
  return [formatDate(start), formatDate(end)]
}

function emptyConfig() {
  return { visitDate: '', totalStock: 0, status: 1, soldStock: 0 }
}

async function loadAttractions() {
  try {
    attractions.value = await getAdminAttractions()
  } catch {
    attractions.value = []
  }
}

function handleAttractionChange() {
  ticketTypeId.value = null
  ticketTypes.value = []
  list.value = []
  if (attractionId.value) {
    loadTicketTypes()
  }
}

async function loadTicketTypes() {
  try {
    ticketTypes.value = await getAdminTicketTypes(attractionId.value)
  } catch {
    ticketTypes.value = []
  }
}

async function loadList() {
  if (!ticketTypeId.value || !dateRange.value?.length) {
    list.value = []
    return
  }
  loading.value = true
  try {
    list.value = await getAdminInventory({
      ticketTypeId: ticketTypeId.value,
      startDate: dateRange.value[0],
      endDate: dateRange.value[1]
    })
  } catch {
    list.value = []
  } finally {
    loading.value = false
  }
}

function openConfig(row) {
  Object.assign(configForm, emptyConfig())
  if (row) {
    configForm.visitDate = row.visitDate
    configForm.totalStock = row.totalStock
    configForm.status = row.status
    configForm.soldStock = row.soldStock || 0
  } else {
    configForm.visitDate = dateRange.value?.[0] || ''
  }
  configVisible.value = true
}

async function submitConfig() {
  const valid = await configFormRef.value.validate().catch(() => false)
  if (!valid) return
  configSubmitting.value = true
  try {
    await configInventory({
      ticketTypeId: ticketTypeId.value,
      visitDate: configForm.visitDate,
      totalStock: configForm.totalStock,
      status: configForm.status
    })
    ElMessage.success('库存已保存')
    configVisible.value = false
    loadList()
  } finally {
    configSubmitting.value = false
  }
}

onMounted(loadAttractions)
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

.filter-bar__refresh {
  margin-left: auto;
  margin-bottom: 1px;
}

.admin-table {
  margin-top: 4px;
}

.table-number {
  color: var(--px-ink-1);
  font-weight: var(--px-weight-medium);
  font-variant-numeric: tabular-nums;
}

.table-number.is-low {
  color: var(--px-danger);
}

.modal-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 0 16px;
}

.span-2 {
  grid-column: span 2;
}

.sold-hint {
  font-size: var(--px-text-xs);
  color: var(--px-warning);
}
</style>
