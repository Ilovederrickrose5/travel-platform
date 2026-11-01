<template>
  <div class="admin-layout">
    <aside class="admin-sidebar">
      <router-link to="/admin/dashboard" class="admin-brand">
        <span class="admin-brand__mark">T</span>
        <span class="admin-brand__text">
          Travel<em>管理后台</em>
        </span>
      </router-link>

      <nav class="admin-nav">
        <router-link
          v-for="item in navItems"
          :key="item.to"
          :to="item.to"
          class="admin-nav__item"
          :class="{ 'is-active': route.path === item.to }"
        >
          {{ item.label }}
        </router-link>
      </nav>

      <div class="admin-sidebar__foot">
        <p class="admin-sidebar__hint">管理员控制台</p>
        <button type="button" class="admin-sidebar__link" @click="enterPreview">
          预览游客主站
          <span>→</span>
        </button>
      </div>
    </aside>

    <div class="admin-main">
      <header class="admin-header">
        <div>
          <p class="admin-header__eyebrow">Admin console</p>
          <h1>{{ pageTitle }}</h1>
        </div>
        <div class="admin-header__actions">
          <span class="admin-header__user">{{ adminName }}</span>
          <PremiumButton variant="ghost" size="sm" @click="handleLogout">退出登录</PremiumButton>
        </div>
      </header>

      <main class="admin-content">
        <router-view />
      </main>
    </div>
  </div>
</template>

<script setup>
import { computed, onBeforeUnmount, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import PremiumButton from '@/components/premium/PremiumButton.vue'
import { clearAdminAuth, getAdminUser, startAdminPreview } from '@/utils/adminAuth'

const route = useRoute()
const router = useRouter()

const navItems = [
  { label: '经营看板', to: '/admin/dashboard' },
  { label: '景点目的地', to: '/admin/attractions' },
  { label: '攻略内容', to: '/admin/guides' },
  { label: '票种库存', to: '/admin/inventory' },
  { label: '订单管理', to: '/admin/orders' },
  { label: '游客账号', to: '/admin/users' },
  { label: '核销工作台', to: '/admin/checkin' }
]

const pageTitle = computed(() => route.meta.title || '管理后台')
const adminName = computed(() => getAdminUser()?.nickname || getAdminUser()?.username || '')

function enterPreview() {
  startAdminPreview()
  router.push('/')
}

async function handleLogout() {
  try {
    await ElMessageBox.confirm('退出后需要重新登录才能进入管理后台。', '确认退出管理后台？', {
      confirmButtonText: '退出登录',
      cancelButtonText: '取消',
      type: 'warning'
    })
  } catch {
    return
  }
  clearAdminAuth()
  ElMessage.success('已退出管理后台')
  router.push('/login')
}

onMounted(() => document.body.classList.add('admin-mode'))
onBeforeUnmount(() => document.body.classList.remove('admin-mode'))
</script>

<style scoped lang="scss">
.admin-layout {
  display: flex;
  min-height: 100vh;
  background: #f2f5f8;
}

.admin-sidebar {
  position: fixed;
  inset: 0 auto 0 0;
  z-index: var(--px-z-card);
  width: 232px;
  display: flex;
  flex-direction: column;
  padding: 22px 14px 18px;
  background: #fbfcfd;
  box-shadow: 1px 0 0 rgba(32, 42, 54, 0.06);
}

.admin-brand {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 2px 8px 22px;
}

.admin-brand__mark {
  width: 32px;
  height: 32px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border-radius: 8px;
  background: var(--px-accent);
  color: #fff;
  font-size: 15px;
  font-weight: var(--px-weight-semibold);
}

.admin-brand__text {
  display: flex;
  flex-direction: column;
  font-size: 15px;
  font-weight: var(--px-weight-semibold);
  color: var(--px-ink-1);
  line-height: 1.15;
}

.admin-brand__text em {
  margin-top: 3px;
  font-style: normal;
  font-size: 10px;
  font-weight: var(--px-weight-medium);
  letter-spacing: 0.14em;
  color: var(--px-ink-3);
}

.admin-nav {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.admin-nav__item {
  position: relative;
  display: flex;
  align-items: center;
  height: 42px;
  padding: 0 12px;
  border-radius: 8px;
  font-size: var(--px-text-sm);
  font-weight: var(--px-weight-medium);
  color: var(--px-ink-2);
  transition:
    background-color var(--px-duration-fast) var(--px-ease-out),
    color var(--px-duration-fast) var(--px-ease-out);
}

.admin-nav__item:hover {
  background: rgba(32, 42, 54, 0.04);
  color: var(--px-ink-1);
}

.admin-nav__item.is-active {
  background: var(--px-accent-soft);
  color: var(--px-accent-deep);
}

.admin-nav__item.is-active::before {
  content: '';
  position: absolute;
  left: 0;
  top: 12px;
  bottom: 12px;
  width: 3px;
  border-radius: 2px;
  background: var(--px-accent);
}

.admin-sidebar__foot {
  margin-top: auto;
  padding: 16px 8px 2px;
}

.admin-sidebar__hint {
  font-size: 11px;
  color: var(--px-ink-4);
}

.admin-sidebar__link {
  display: flex;
  align-items: center;
  justify-content: space-between;
  width: 100%;
  margin-top: 10px;
  padding: 9px 11px;
  border: 0;
  border-radius: 8px;
  background: rgba(32, 42, 54, 0.04);
  color: var(--px-ink-2);
  font-family: inherit;
  font-size: var(--px-text-sm);
  cursor: pointer;
  transition:
    background-color var(--px-duration-fast) var(--px-ease-out),
    color var(--px-duration-fast) var(--px-ease-out);
}

.admin-sidebar__link:hover {
  background: rgba(32, 42, 54, 0.08);
  color: var(--px-ink-1);
}

.admin-main {
  flex: 1;
  min-width: 0;
  margin-left: 232px;
  display: flex;
  flex-direction: column;
}

.admin-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 20px;
  height: 74px;
  padding: 0 28px;
  background: #fbfcfd;
  box-shadow: 0 1px 0 rgba(32, 42, 54, 0.06);
}

.admin-header__eyebrow {
  font-size: 10px;
  font-weight: var(--px-weight-semibold);
  letter-spacing: 0.16em;
  text-transform: uppercase;
  color: var(--px-ink-4);
}

.admin-header h1 {
  margin-top: 3px;
  font-size: var(--px-text-lg);
  color: var(--px-ink-1);
}

.admin-header__actions {
  display: flex;
  align-items: center;
  gap: 12px;
}

.admin-header__user {
  font-size: var(--px-text-sm);
  color: var(--px-ink-3);
}

.admin-content {
  flex: 1;
  padding: 22px 28px 32px;
}
</style>
