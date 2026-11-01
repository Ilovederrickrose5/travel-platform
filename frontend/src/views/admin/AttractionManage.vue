<template>
  <PremiumCard variant="glass" padding="lg" class="admin-card">
    <header class="admin-toolbar">
      <div class="admin-toolbar__title">
        <p class="px-eyebrow">Attractions</p>
        <h2>景点列表 <span class="admin-toolbar__count">{{ list.length }}</span></h2>
      </div>
      <div class="admin-toolbar__actions">
        <PremiumButton @click="openCreate">新增景点</PremiumButton>
        <PremiumButton variant="ghost" :loading="loading" @click="loadList">刷新</PremiumButton>
      </div>
    </header>

    <el-table v-loading="loading" :data="list" empty-text="暂无景点" class="admin-table">
      <el-table-column prop="name" label="景点名称" min-width="180" />
      <el-table-column prop="city" label="城市" width="100" />
      <el-table-column prop="level" label="等级" width="80" />
      <el-table-column label="状态" width="100">
        <template #default="{ row }">
          <PremiumTag :tone="row.status === 1 ? 'success' : 'neutral'">
            {{ row.status === 1 ? '上线' : '下线' }}
          </PremiumTag>
        </template>
      </el-table-column>
      <el-table-column label="票种" width="80">
        <template #default="{ row }">
          <span class="table-number">{{ row.ticketTypes?.length || 0 }}</span>
        </template>
      </el-table-column>
      <el-table-column prop="sort" label="排序" width="80" />
      <el-table-column label="操作" width="250" fixed="right">
        <template #default="{ row }">
          <div class="table-actions">
            <PremiumButton variant="text" size="sm" @click="openEdit(row)">编辑</PremiumButton>
            <PremiumButton variant="text" tone="success" size="sm" @click="openTicketManage(row)">
              票种管理
            </PremiumButton>
            <PremiumButton variant="text" tone="danger" size="sm" @click="handleDelete(row)">
              删除
            </PremiumButton>
          </div>
        </template>
      </el-table-column>
    </el-table>
  </PremiumCard>

  <PremiumModal
    v-model="formVisible"
    eyebrow="Attraction"
    :title="form.id ? '编辑景点' : '新增景点'"
    subtitle="维护景点基础信息与展示状态"
    width="720px"
    :close-on-click-modal="false"
  >
    <el-form ref="formRef" :model="form" :rules="formRules" label-position="top">
      <div class="modal-grid">
        <el-form-item label="景点名称" prop="name" class="span-2">
          <PremiumInput v-model="form.name" :maxlength="100" placeholder="请输入景点名称" />
        </el-form-item>
        <el-form-item label="城市">
          <PremiumInput v-model="form.city" :maxlength="50" placeholder="如：杭州" />
        </el-form-item>
        <el-form-item label="景区等级">
          <PremiumInput v-model="form.level" :maxlength="20" placeholder="如：5A" />
        </el-form-item>
        <el-form-item label="地址" class="span-2">
          <PremiumInput v-model="form.address" :maxlength="255" placeholder="详细地址" />
        </el-form-item>
        <el-form-item label="封面图" class="span-2">
          <PremiumInput v-model="form.coverUrl" :maxlength="255" placeholder="/attraction/xxx.jpg" />
        </el-form-item>
        <el-form-item label="开放时间">
          <PremiumInput v-model="form.openTime" :maxlength="100" placeholder="如：08:00-17:30" />
        </el-form-item>
        <el-form-item label="排序">
          <el-input-number v-model="form.sort" :min="0" :max="9999" controls-position="right" style="width: 100%" />
        </el-form-item>
        <el-form-item label="经度" prop="longitude">
          <PremiumInput v-model="form.longitude" placeholder="如：120.145" />
        </el-form-item>
        <el-form-item label="纬度" prop="latitude">
          <PremiumInput v-model="form.latitude" placeholder="如：30.244" />
        </el-form-item>
        <el-form-item label="景点介绍" class="span-2">
          <PremiumInput v-model="form.description" type="textarea" :rows="3" :maxlength="2000" />
        </el-form-item>
        <el-form-item label="风土人文" class="span-2">
          <PremiumInput
            v-model="form.cultureIntro"
            type="textarea"
            :rows="3"
            :maxlength="2000"
            placeholder="当地人文、民俗与生活方式，展示在游客端攻略区"
          />
        </el-form-item>
        <el-form-item label="游玩攻略" class="span-2">
          <PremiumInput
            v-model="form.travelGuide"
            type="textarea"
            :rows="4"
            :maxlength="3000"
            placeholder="推荐路线、最佳时段、必看体验"
          />
        </el-form-item>
        <el-form-item label="在地贴士" class="span-2">
          <PremiumInput
            v-model="form.localTips"
            type="textarea"
            :rows="3"
            :maxlength="1500"
            placeholder="交通、天气、礼仪等实用提示，每行一条"
          />
        </el-form-item>
        <el-form-item label="状态" class="span-2">
          <el-radio-group v-model="form.status">
            <el-radio :value="1">上线</el-radio>
            <el-radio :value="0">下线</el-radio>
          </el-radio-group>
        </el-form-item>
      </div>
    </el-form>
    <template #footer>
      <PremiumButton variant="ghost" @click="formVisible = false">取消</PremiumButton>
      <PremiumButton :loading="submitting" @click="submitForm">保存</PremiumButton>
    </template>
  </PremiumModal>

  <PremiumModal
    v-model="ticketManageVisible"
    eyebrow="Tickets"
    :title="`票种管理 · ${ticketAttractionName}`"
    subtitle="维护该景点下所有在售票种"
    width="820px"
  >
    <div class="admin-toolbar admin-toolbar--inner">
      <span class="admin-toolbar__hint">共 {{ ticketList.length }} 个票种</span>
      <div class="admin-toolbar__actions">
        <PremiumButton size="sm" @click="openTicketForm()">新增票种</PremiumButton>
        <PremiumButton variant="ghost" size="sm" :loading="ticketListLoading" @click="loadTicketTypes">
          刷新
        </PremiumButton>
      </div>
    </div>

    <el-table v-loading="ticketListLoading" :data="ticketList" empty-text="暂无票种" class="admin-table">
      <el-table-column prop="name" label="票种名称" min-width="140" />
      <el-table-column label="售价" width="100">
        <template #default="{ row }"><span class="table-money">¥{{ row.price }}</span></template>
      </el-table-column>
      <el-table-column label="原价" width="100">
        <template #default="{ row }">
          <span class="table-muted">¥{{ row.originalPrice ?? '-' }}</span>
        </template>
      </el-table-column>
      <el-table-column prop="purchaseLimit" label="限购" width="80" />
      <el-table-column label="状态" width="100">
        <template #default="{ row }">
          <PremiumTag :tone="toneOfType(ticketStatusOf(row.status).type)">
            {{ ticketStatusOf(row.status).label }}
          </PremiumTag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="140" fixed="right">
        <template #default="{ row }">
          <div class="table-actions">
            <PremiumButton variant="text" size="sm" @click="openTicketForm(row)">编辑</PremiumButton>
            <PremiumButton variant="text" tone="danger" size="sm" @click="handleDeleteTicket(row)">
              删除
            </PremiumButton>
          </div>
        </template>
      </el-table-column>
    </el-table>
  </PremiumModal>

  <PremiumModal
    v-model="ticketFormVisible"
    eyebrow="Ticket"
    :title="ticketForm.id ? '编辑票种' : '新增票种'"
    width="560px"
    :close-on-click-modal="false"
  >
    <el-form ref="ticketFormRef" :model="ticketForm" :rules="ticketRules" label-position="top">
      <div class="modal-grid">
        <el-form-item label="票种名称" prop="name" class="span-2">
          <PremiumInput v-model="ticketForm.name" :maxlength="100" placeholder="如：成人票" />
        </el-form-item>
        <el-form-item label="售价" prop="price">
          <el-input-number v-model="ticketForm.price" :min="0" :precision="2" :step="10" controls-position="right" style="width: 100%" />
        </el-form-item>
        <el-form-item label="原价">
          <el-input-number v-model="ticketForm.originalPrice" :min="0" :precision="2" :step="10" controls-position="right" style="width: 100%" />
        </el-form-item>
        <el-form-item label="每单限购">
          <el-input-number v-model="ticketForm.purchaseLimit" :min="1" :max="99" controls-position="right" style="width: 100%" />
        </el-form-item>
        <el-form-item label="排序">
          <el-input-number v-model="ticketForm.sort" :min="0" :max="9999" controls-position="right" style="width: 100%" />
        </el-form-item>
        <el-form-item label="票种说明" class="span-2">
          <PremiumInput v-model="ticketForm.description" type="textarea" :rows="2" :maxlength="255" />
        </el-form-item>
        <el-form-item label="状态" class="span-2">
          <el-radio-group v-model="ticketForm.status">
            <el-radio :value="1">在售</el-radio>
            <el-radio :value="0">下架</el-radio>
            <el-radio :value="2">售罄</el-radio>
          </el-radio-group>
        </el-form-item>
      </div>
    </el-form>
    <template #footer>
      <PremiumButton variant="ghost" @click="ticketFormVisible = false">取消</PremiumButton>
      <PremiumButton :loading="ticketSubmitting" @click="submitTicket">保存</PremiumButton>
    </template>
  </PremiumModal>
</template>

<script setup>
import { onMounted, reactive, ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import PremiumButton from '@/components/premium/PremiumButton.vue'
import PremiumCard from '@/components/premium/PremiumCard.vue'
import PremiumInput from '@/components/premium/PremiumInput.vue'
import PremiumModal from '@/components/premium/PremiumModal.vue'
import PremiumTag from '@/components/premium/PremiumTag.vue'
import {
  createAttraction,
  createTicketType,
  deleteAttraction,
  deleteTicketType,
  getAdminAttractions,
  getAdminTicketTypes,
  updateAttraction,
  updateTicketType
} from '@/api/admin'

const TICKET_STATUS = {
  0: { label: '下架', type: 'info' },
  1: { label: '在售', type: 'success' },
  2: { label: '售罄', type: 'warning' }
}

const loading = ref(false)
const list = ref([])

const formVisible = ref(false)
const submitting = ref(false)
const formRef = ref()
const form = reactive(emptyForm())

const ticketManageVisible = ref(false)
const ticketListLoading = ref(false)
const ticketList = ref([])
const ticketAttractionId = ref(null)
const ticketAttractionName = ref('')

const ticketFormVisible = ref(false)
const ticketSubmitting = ref(false)
const ticketFormRef = ref()
const ticketForm = reactive(emptyTicketForm())

const coordinateRule = {
  pattern: /^-?\d{1,3}(\.\d{1,6})?$/,
  message: '请输入有效坐标，如 120.145',
  trigger: 'blur'
}

const formRules = {
  name: [{ required: true, message: '请输入景点名称', trigger: 'blur' }],
  longitude: [coordinateRule],
  latitude: [coordinateRule]
}

const ticketRules = {
  name: [{ required: true, message: '请输入票种名称', trigger: 'blur' }],
  price: [{ required: true, message: '请输入售价', trigger: 'blur' }]
}

const toneMap = {
  warning: 'warning',
  success: 'success',
  danger: 'danger',
  info: 'info',
  primary: 'primary'
}

function toneOfType(type) {
  return toneMap[type] || 'neutral'
}

function emptyForm() {
  return {
    id: null,
    name: '',
    city: '',
    address: '',
    level: '',
    coverUrl: '',
    description: '',
    cultureIntro: '',
    travelGuide: '',
    localTips: '',
    openTime: '',
    longitude: '',
    latitude: '',
    status: 1,
    sort: 0
  }
}

function emptyTicketForm() {
  return {
    id: null,
    name: '',
    description: '',
    price: 0,
    originalPrice: null,
    purchaseLimit: 5,
    status: 1,
    sort: 0
  }
}

function ticketStatusOf(status) {
  return TICKET_STATUS[status] || { label: '未知', type: 'info' }
}

async function loadList() {
  loading.value = true
  try {
    list.value = await getAdminAttractions()
  } catch {
    list.value = []
  } finally {
    loading.value = false
  }
}

function openCreate() {
  Object.assign(form, emptyForm())
  formVisible.value = true
}

function openEdit(row) {
  Object.assign(form, emptyForm(), {
    id: row.id,
    name: row.name,
    city: row.city,
    address: row.address,
    level: row.level,
    coverUrl: row.coverUrl,
    description: row.description,
    cultureIntro: row.cultureIntro || '',
    travelGuide: row.travelGuide || '',
    localTips: row.localTips || '',
    openTime: row.openTime,
    longitude: row.longitude == null ? '' : String(row.longitude),
    latitude: row.latitude == null ? '' : String(row.latitude),
    status: row.status,
    sort: row.sort
  })
  formVisible.value = true
}

async function submitForm() {
  const valid = await formRef.value.validate().catch(() => false)
  if (!valid) return
  submitting.value = true
  try {
    const payload = {
      ...form,
      longitude: form.longitude === '' ? null : form.longitude,
      latitude: form.latitude === '' ? null : form.latitude
    }
    if (form.id) {
      await updateAttraction(form.id, payload)
    } else {
      delete payload.id
      await createAttraction(payload)
    }
    ElMessage.success('保存成功')
    formVisible.value = false
    loadList()
  } finally {
    submitting.value = false
  }
}

async function handleDelete(row) {
  try {
    await ElMessageBox.confirm(
      `确定删除景点「${row.name}」吗？该操作不可恢复。`,
      '删除景点',
      { type: 'warning', confirmButtonText: '确定删除', cancelButtonText: '取消' }
    )
  } catch {
    return
  }
  await deleteAttraction(row.id)
  ElMessage.success('删除成功')
  loadList()
}

function openTicketManage(row) {
  ticketAttractionId.value = row.id
  ticketAttractionName.value = row.name
  ticketManageVisible.value = true
  loadTicketTypes()
}

async function loadTicketTypes() {
  ticketListLoading.value = true
  try {
    ticketList.value = await getAdminTicketTypes(ticketAttractionId.value)
  } catch {
    ticketList.value = []
  } finally {
    ticketListLoading.value = false
  }
}

function openTicketForm(row) {
  Object.assign(ticketForm, emptyTicketForm())
  if (row) {
    Object.assign(ticketForm, {
      id: row.id,
      name: row.name,
      description: row.description,
      price: Number(row.price),
      originalPrice: row.originalPrice === null ? null : Number(row.originalPrice),
      purchaseLimit: row.purchaseLimit,
      status: row.status,
      sort: row.sort
    })
  }
  ticketFormVisible.value = true
}

async function submitTicket() {
  const valid = await ticketFormRef.value.validate().catch(() => false)
  if (!valid) return
  ticketSubmitting.value = true
  try {
    const payload = { ...ticketForm }
    if (ticketForm.id) {
      await updateTicketType(ticketForm.id, payload)
    } else {
      delete payload.id
      await createTicketType(ticketAttractionId.value, payload)
    }
    ElMessage.success('保存成功')
    ticketFormVisible.value = false
    loadTicketTypes()
    loadList()
  } finally {
    ticketSubmitting.value = false
  }
}

async function handleDeleteTicket(row) {
  try {
    await ElMessageBox.confirm(
      `确定删除票种「${row.name}」吗？删除后库存数据将不再被引用。`,
      '删除票种',
      { type: 'warning', confirmButtonText: '确定删除', cancelButtonText: '取消' }
    )
  } catch {
    return
  }
  await deleteTicketType(row.id)
  ElMessage.success('删除成功')
  loadTicketTypes()
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

.admin-toolbar--inner {
  align-items: center;
  margin-bottom: 10px;
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

.admin-toolbar__actions {
  display: flex;
  align-items: center;
  gap: 8px;
  flex: none;
}

.admin-toolbar__hint {
  font-size: var(--px-text-xs);
  color: var(--px-ink-3);
}

.admin-table {
  margin-top: 4px;
}

.table-number {
  font-variant-numeric: tabular-nums;
  color: var(--px-ink-1);
  font-weight: var(--px-weight-medium);
}

.table-money {
  color: var(--px-accent-deep);
  font-weight: var(--px-weight-semibold);
  font-variant-numeric: tabular-nums;
}

.table-muted {
  color: var(--px-ink-3);
  font-variant-numeric: tabular-nums;
}

.table-actions {
  display: flex;
  align-items: center;
  gap: 2px;
}

.modal-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 0 16px;
}

.span-2 {
  grid-column: span 2;
}
</style>
