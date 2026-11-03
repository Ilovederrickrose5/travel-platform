<template>
  <PremiumCard variant="glass" padding="lg" class="admin-card">
    <header class="admin-toolbar">
      <div class="admin-toolbar__title">
        <p class="px-eyebrow">Visitors</p>
        <h2>游客账号 <span class="admin-toolbar__count">{{ list.length }}</span></h2>
      </div>
      <PremiumButton variant="ghost" :loading="loading" @click="loadList">刷新</PremiumButton>
    </header>

    <div class="filter-bar">
      <div class="filter-bar__field">
        <span class="filter-bar__label">关键词</span>
        <el-input
          v-model="keyword"
          placeholder="用户名 / 昵称 / 手机号"
          clearable
          style="width: 220px"
          @keyup.enter="loadList"
          @clear="loadList"
        />
      </div>
      <div class="filter-bar__field">
        <span class="filter-bar__label">账号状态</span>
        <el-select v-model="status" placeholder="全部" clearable style="width: 140px" @change="loadList">
          <el-option label="正常" :value="1" />
          <el-option label="已禁用" :value="0" />
        </el-select>
      </div>
      <PremiumButton @click="loadList">查询</PremiumButton>
    </div>

    <el-table v-loading="loading" :data="list" empty-text="暂无游客账号" class="admin-table">
      <el-table-column prop="username" label="用户名" width="150" />
      <el-table-column prop="nickname" label="昵称" width="150" />
      <el-table-column prop="phone" label="手机号" width="140" />
      <el-table-column prop="email" label="邮箱" min-width="190" />
      <el-table-column label="状态" width="100">
        <template #default="{ row }">
          <PremiumTag :tone="row.status === 1 ? 'success' : 'danger'">
            {{ row.status === 1 ? '正常' : '已禁用' }}
          </PremiumTag>
        </template>
      </el-table-column>
      <el-table-column label="注册时间" width="160">
        <template #default="{ row }">{{ formatTime(row.createdAt) }}</template>
      </el-table-column>
      <el-table-column label="操作" width="190" fixed="right">
        <template #default="{ row }">
          <div class="table-actions">
            <PremiumButton
              v-if="row.status === 1"
              variant="text"
              tone="danger"
              size="sm"
              @click="toggleStatus(row, 0)"
            >
              禁用
            </PremiumButton>
            <PremiumButton
              v-else
              variant="text"
              tone="success"
              size="sm"
              @click="toggleStatus(row, 1)"
            >
              启用
            </PremiumButton>
            <PremiumButton variant="text" size="sm" @click="handleResetPassword(row)">
              重置密码
            </PremiumButton>
          </div>
        </template>
      </el-table-column>
    </el-table>
  </PremiumCard>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import PremiumButton from '@/components/premium/PremiumButton.vue'
import PremiumCard from '@/components/premium/PremiumCard.vue'
import PremiumTag from '@/components/premium/PremiumTag.vue'
import { getAdminUsers, resetUserPassword, updateUserStatus } from '@/api/admin'

const loading = ref(false)
const list = ref([])
const keyword = ref('')
const status = ref(null)

function formatTime(value) {
  return value ? String(value).replace('T', ' ').slice(0, 16) : '—'
}

async function loadList() {
  loading.value = true
  try {
    list.value = await getAdminUsers({
      keyword: keyword.value || undefined,
      status: status.value === null || status.value === '' ? undefined : status.value
    })
  } catch {
    list.value = []
  } finally {
    loading.value = false
  }
}

async function toggleStatus(row, nextStatus) {
  const action = nextStatus === 1 ? '启用' : '禁用'
  try {
    await ElMessageBox.confirm(
      `确定要${action}游客「${row.nickname || row.username}」吗？`,
      `${action}账号`,
      { type: 'warning', confirmButtonText: action, cancelButtonText: '取消' }
    )
  } catch {
    return
  }
  try {
    await updateUserStatus(row.id, nextStatus)
    ElMessage.success(`已${action}`)
    await loadList()
  } catch {
    /* 错误提示由请求拦截器统一处理 */
  }
}

async function handleResetPassword(row) {
  try {
    await ElMessageBox.confirm(
      `确定要把游客「${row.nickname || row.username}」的密码重置为随机密码吗？`,
      '重置密码',
      { type: 'warning', confirmButtonText: '重置', cancelButtonText: '取消' }
    )
  } catch {
    return
  }
  try {
    const password = await resetUserPassword(row.id)
    ElMessageBox.alert(`新密码为：${password}`, '密码已重置', { confirmButtonText: '知道了' })
  } catch {
    /* 错误提示由请求拦截器统一处理 */
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

.table-actions {
  display: flex;
  align-items: center;
  gap: 2px;
}
</style>
