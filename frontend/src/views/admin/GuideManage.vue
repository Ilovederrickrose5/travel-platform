<template>
  <PremiumCard variant="glass" padding="lg" class="admin-card">
    <header class="admin-toolbar">
      <div class="admin-toolbar__title">
        <p class="px-eyebrow">Travel guides</p>
        <h2>攻略完善度 <span class="admin-toolbar__count">{{ list.length }}</span></h2>
      </div>
      <div class="admin-toolbar__actions">
        <PremiumInput
          v-model="keyword"
          placeholder="搜索目的地"
          clearable
          size="sm"
          class="guide-search"
          @enter="loadList"
          @clear="loadList"
        />
        <PremiumButton variant="ghost" :loading="loading" @click="loadList">搜索</PremiumButton>
      </div>
    </header>

    <el-table v-loading="loading" :data="list" empty-text="暂无目的地" class="admin-table">
      <el-table-column prop="name" label="目的地" min-width="180" />
      <el-table-column prop="city" label="城市" width="100" />
      <el-table-column label="风土人文" width="120">
        <template #default="{ row }">
          <PremiumTag :tone="row.cultureIntro ? 'success' : 'neutral'" variant="hollow">
            {{ row.cultureIntro ? '已完善' : '待补充' }}
          </PremiumTag>
        </template>
      </el-table-column>
      <el-table-column label="游玩攻略" width="120">
        <template #default="{ row }">
          <PremiumTag :tone="row.travelGuide ? 'success' : 'neutral'" variant="hollow">
            {{ row.travelGuide ? '已完善' : '待补充' }}
          </PremiumTag>
        </template>
      </el-table-column>
      <el-table-column label="在地贴士" width="120">
        <template #default="{ row }">
          <PremiumTag :tone="row.localTips ? 'success' : 'neutral'" variant="hollow">
            {{ row.localTips ? '已完善' : '待补充' }}
          </PremiumTag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="110" fixed="right">
        <template #default="{ row }">
          <PremiumButton variant="text" size="sm" @click="openEdit(row)">编辑攻略</PremiumButton>
        </template>
      </el-table-column>
    </el-table>
  </PremiumCard>

  <PremiumModal
    v-model="visible"
    eyebrow="Guide"
    :title="`编辑攻略 · ${form.name}`"
    subtitle="内容展示在游客端景点详情页的攻略区域"
    width="720px"
    :close-on-click-modal="false"
  >
    <el-form label-position="top" class="guide-form">
      <el-form-item label="风土人文">
        <PremiumInput
          v-model="form.cultureIntro"
          type="textarea"
          :rows="4"
          :maxlength="2000"
          show-word-limit
          placeholder="介绍当地人文、民俗与生活方式"
        />
      </el-form-item>
      <el-form-item label="游玩攻略">
        <PremiumInput
          v-model="form.travelGuide"
          type="textarea"
          :rows="5"
          :maxlength="3000"
          show-word-limit
          placeholder="推荐路线、最佳时段、必看体验"
        />
      </el-form-item>
      <el-form-item label="在地贴士">
        <PremiumInput
          v-model="form.localTips"
          type="textarea"
          :rows="3"
          :maxlength="1500"
          show-word-limit
          placeholder="交通、天气、礼仪等实用提示"
        />
      </el-form-item>
    </el-form>

    <template #footer>
      <PremiumButton variant="ghost" @click="visible = false">取消</PremiumButton>
      <PremiumButton :loading="submitting" @click="submit">保存</PremiumButton>
    </template>
  </PremiumModal>
</template>

<script setup>
import { onMounted, reactive, ref } from 'vue'
import { ElMessage } from 'element-plus'
import PremiumButton from '@/components/premium/PremiumButton.vue'
import PremiumCard from '@/components/premium/PremiumCard.vue'
import PremiumInput from '@/components/premium/PremiumInput.vue'
import PremiumModal from '@/components/premium/PremiumModal.vue'
import PremiumTag from '@/components/premium/PremiumTag.vue'
import { getAdminAttractions, updateAttraction } from '@/api/admin'

const loading = ref(false)
const list = ref([])
const keyword = ref('')

const visible = ref(false)
const submitting = ref(false)
const form = reactive(emptyForm())

function emptyForm() {
  return { id: null, name: '', cultureIntro: '', travelGuide: '', localTips: '' }
}

async function loadList() {
  loading.value = true
  try {
    list.value = await getAdminAttractions({ keyword: keyword.value || undefined })
  } catch {
    list.value = []
  } finally {
    loading.value = false
  }
}

function openEdit(row) {
  Object.assign(form, {
    id: row.id,
    name: row.name,
    cultureIntro: row.cultureIntro || '',
    travelGuide: row.travelGuide || '',
    localTips: row.localTips || ''
  })
  visible.value = true
}

async function submit() {
  submitting.value = true
  try {
    await updateAttraction(form.id, {
      cultureIntro: form.cultureIntro,
      travelGuide: form.travelGuide,
      localTips: form.localTips
    })
    ElMessage.success('攻略内容已保存')
    visible.value = false
    loadList()
  } finally {
    submitting.value = false
  }
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

.admin-toolbar__actions {
  display: flex;
  align-items: center;
  gap: 8px;
  flex: none;
}

.guide-search {
  width: 200px;
}

.guide-form :deep(.el-form-item) {
  margin-bottom: 14px;
}

.guide-form :deep(.el-form-item__label) {
  padding-bottom: 5px;
  font-size: var(--px-text-xs);
  font-weight: var(--px-weight-medium);
  color: var(--px-ink-2);
}
</style>
