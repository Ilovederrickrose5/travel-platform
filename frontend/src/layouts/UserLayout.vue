<template>
  <div class="user-layout">
    <div class="ambient" aria-hidden="true">
      <span class="ambient__grid" />
    </div>

    <header class="site-header" :class="{ 'is-scrolled': scrolled }">
      <div class="site-header__inner">
        <router-link to="/" class="brand">
          <span class="brand__mark"><span /></span>
          <span class="brand__text">Travel<em>旅游</em></span>
        </router-link>

        <nav class="nav">
          <router-link
            v-for="item in navItems"
            :key="item.to"
            :to="item.to"
            class="nav__link"
            :class="{ 'is-active': isActive(item) }"
          >
            {{ item.label }}
          </router-link>
        </nav>

        <form class="nav-search" role="search" @submit.prevent="handleSearch">
          <svg class="nav-search__icon" viewBox="0 0 20 20" width="15" height="15" aria-hidden="true">
            <circle cx="9" cy="9" r="5.5" fill="none" stroke="currentColor" stroke-width="1.5" />
            <path d="M13.2 13.2L17 17" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" />
          </svg>
          <input
            v-model="searchKeyword"
            type="search"
            class="nav-search__input"
            placeholder="搜索景点、城市或省份"
            aria-label="搜索景点、城市或省份"
          />
          <button type="submit" class="nav-search__submit" aria-label="搜索">→</button>
        </form>

        <el-dropdown v-if="!preview" trigger="click" placement="bottom-end" @command="handleCommand">
          <button type="button" class="user-chip">
            <span class="user-chip__avatar">
              <img v-if="avatar" :src="avatar" alt="" />
              <template v-else>{{ initial }}</template>
            </span>
            <span class="user-chip__name">{{ nickname }}</span>
            <svg class="user-chip__chevron" viewBox="0 0 16 16" width="12" height="12" aria-hidden="true">
              <path d="M4 6l4 4 4-4" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" />
            </svg>
          </button>
          <template #dropdown>
            <el-dropdown-menu>
              <el-dropdown-item command="profile">个人中心</el-dropdown-item>
              <el-dropdown-item command="favorites">我的收藏</el-dropdown-item>
              <el-dropdown-item command="orders">我的订单</el-dropdown-item>
              <el-dropdown-item command="logout" divided>退出登录</el-dropdown-item>
            </el-dropdown-menu>
          </template>
        </el-dropdown>
      </div>
    </header>

    <div v-if="preview" class="preview-bar">
      <span class="preview-bar__tag">管理员预览</span>
      <span class="preview-bar__text">{{ adminName }} · 只读浏览，不能下单或支付</span>
      <button type="button" class="preview-bar__exit" @click="exitPreview">返回管理后台</button>
    </div>

    <main class="main">
      <router-view />
    </main>
  </div>
</template>

<script setup>
import { computed, onBeforeUnmount, onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { clearAuth, getUser } from '@/utils/auth'
import { getAdminUser, isAdminPreviewMode, stopAdminPreview } from '@/utils/adminAuth'

const route = useRoute()
const router = useRouter()
const scrolled = ref(false)
const preview = isAdminPreviewMode()
const user = ref(getUser())

const navItems = [
  { label: '首页', to: '/', match: (path) => path === '/' },
  { label: '景点', to: '/attractions', match: (path) => path.startsWith('/attractions') },
  { label: '地图', to: '/map', match: (path) => path === '/map' },
  ...(preview
    ? []
    : [{ label: '我的订单', to: '/orders', match: (path) => path.startsWith('/orders') }])
]

const searchKeyword = ref('')

function handleSearch() {
  const keyword = searchKeyword.value.trim()
  router.push(keyword ? { path: '/attractions', query: { keyword } } : { path: '/attractions' })
}

const nickname = computed(() => user.value?.nickname || user.value?.username || '未登录')
const initial = computed(() => nickname.value.slice(0, 1).toUpperCase())
const avatar = computed(() => user.value?.avatar || '')
const adminName = computed(() => getAdminUser()?.nickname || getAdminUser()?.username || '管理员')

function syncUser() {
  user.value = getUser()
}

function exitPreview() {
  stopAdminPreview()
  router.push('/admin/dashboard')
}

function isActive(item) {
  return item.match(route.path)
}

function onScroll() {
  scrolled.value = window.scrollY > 16
}

async function handleCommand(command) {
  if (command === 'logout') {
    try {
      await ElMessageBox.confirm('退出后需要重新登录才能继续预订行程。', '确认退出登录？', {
        confirmButtonText: '退出登录',
        cancelButtonText: '取消',
        type: 'warning'
      })
    } catch {
      return
    }
    clearAuth()
    ElMessage.success('已退出登录')
    router.push('/login')
    return
  }
  if (command === 'profile') {
    router.push('/profile')
    return
  }
  if (command === 'favorites') {
    router.push('/profile/favorites')
    return
  }
  if (command === 'orders') {
    router.push('/orders')
  }
}

onMounted(() => {
  syncUser()
  onScroll()
  window.addEventListener('scroll', onScroll, { passive: true })
  window.addEventListener('travel-auth-user-changed', syncUser)
})

onBeforeUnmount(() => {
  window.removeEventListener('scroll', onScroll)
  window.removeEventListener('travel-auth-user-changed', syncUser)
})
</script>

<style scoped lang="scss">
.user-layout {
  position: relative;
  min-height: 100%;
  display: flex;
  flex-direction: column;
}

.ambient {
  position: fixed;
  inset: 0;
  z-index: 0;
  pointer-events: none;
  overflow: hidden;
}

.ambient__grid {
  position: absolute;
  inset: 0;
  background-image: radial-gradient(rgba(32, 42, 54, 0.09) 1px, transparent 1px);
  background-size: 30px 30px;
  opacity: 0.34;
  mask-image: linear-gradient(180deg, rgba(0, 0, 0, 0.65), transparent 58%);
  -webkit-mask-image: linear-gradient(180deg, rgba(0, 0, 0, 0.65), transparent 58%);
}

.site-header {
  position: sticky;
  top: 0;
  z-index: var(--px-z-float);
  padding: 18px 24px 0;
  transition: padding var(--px-duration-slow) var(--px-ease-out);
}

.site-header.is-scrolled {
  padding-top: 10px;
}

.site-header__inner {
  position: relative;
  width: min(100%, var(--px-container));
  margin: 0 auto;
  height: var(--px-header-h);
  padding: 0 14px 0 22px;
  display: flex;
  align-items: center;
  gap: 28px;
  border-radius: var(--px-radius-xl);
  background: linear-gradient(150deg, rgba(253, 254, 255, 0.78), rgba(240, 245, 249, 0.5));
  box-shadow: var(--px-shadow-2), var(--px-shadow-highlight);
  backdrop-filter: blur(var(--px-blur-lg)) saturate(170%);
  -webkit-backdrop-filter: blur(var(--px-blur-lg)) saturate(170%);
  transition:
    box-shadow var(--px-duration-slow) var(--px-ease-out),
    background-color var(--px-duration-slow) var(--px-ease-out);
}

.site-header.is-scrolled .site-header__inner {
  box-shadow: var(--px-shadow-3), var(--px-shadow-highlight);
  background: linear-gradient(150deg, rgba(253, 254, 255, 0.9), rgba(240, 245, 249, 0.66));
}

.site-header__inner::after {
  content: '';
  position: absolute;
  left: 24%;
  right: 24%;
  bottom: 0;
  height: 1px;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.95), transparent);
  opacity: 0.8;
}

.brand {
  display: inline-flex;
  align-items: center;
  gap: 11px;
  white-space: nowrap;
}

.brand__mark {
  position: relative;
  width: 32px;
  height: 32px;
  border-radius: 11px;
  background: var(--px-gradient-accent);
  box-shadow: 0 6px 16px rgba(93, 127, 150, 0.32), inset 0 1px 0 rgba(255, 255, 255, 0.5);
  display: inline-flex;
  align-items: center;
  justify-content: center;
  transform: rotate(-6deg);
  transition: transform var(--px-duration-slow) var(--px-ease-out);
}

.brand:hover .brand__mark {
  transform: rotate(0deg) translateY(-1px);
}

.brand__mark span {
  width: 9px;
  height: 9px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.92);
  box-shadow: 0 0 0 3px rgba(255, 255, 255, 0.16);
}

.brand__text {
  font-size: 18px;
  font-weight: var(--px-weight-semibold);
  letter-spacing: 0.01em;
  color: var(--px-ink-1);
  display: inline-flex;
  align-items: baseline;
  gap: 6px;
}

.brand__text em {
  font-style: normal;
  font-size: var(--px-text-xs);
  font-weight: var(--px-weight-medium);
  letter-spacing: 0.24em;
  color: var(--px-ink-3);
}

.nav {
  display: flex;
  align-items: center;
  gap: 4px;
  margin-right: auto;
}

.nav__link {
  position: relative;
  padding: 8px 16px;
  border-radius: var(--px-radius-pill);
  font-size: var(--px-text-base);
  font-weight: var(--px-weight-medium);
  color: var(--px-ink-2);
  transition:
    background-color var(--px-duration-base) var(--px-ease-out),
    color var(--px-duration-base) var(--px-ease-out),
    transform var(--px-duration-fast) var(--px-ease-out);
}

.nav__link:hover {
  color: var(--px-ink-1);
  background: rgba(255, 255, 255, 0.58);
  transform: translateY(-1px);
}

.nav__link.is-active {
  color: var(--px-accent-deep);
  background: var(--px-accent-soft);
}

.nav-search {
  display: flex;
  align-items: center;
  gap: 8px;
  width: clamp(180px, 20vw, 240px);
  height: 38px;
  padding: 0 8px 0 14px;
  border-radius: var(--px-radius-pill);
  background: rgba(255, 255, 255, 0.44);
  box-shadow: var(--px-shadow-1), inset 0 1px 0 rgba(255, 255, 255, 0.7);
  color: var(--px-ink-3);
  transition:
    background-color var(--px-duration-base) var(--px-ease-out),
    box-shadow var(--px-duration-base) var(--px-ease-out);
}

.nav-search:focus-within {
  background: rgba(255, 255, 255, 0.82);
  box-shadow: var(--px-shadow-2), 0 0 0 3px var(--px-accent-soft);
}

.nav-search__icon {
  flex: none;
}

.nav-search__input {
  flex: 1;
  min-width: 0;
  border: 0;
  outline: 0;
  background: transparent;
  color: var(--px-ink-1);
  font-family: inherit;
  font-size: var(--px-text-sm);
}

.nav-search__input::placeholder {
  color: var(--px-ink-4);
}

.nav-search__input::-webkit-search-cancel-button {
  cursor: pointer;
}

.nav-search__submit {
  flex: none;
  width: 24px;
  height: 24px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border: 0;
  border-radius: 50%;
  background: transparent;
  color: var(--px-ink-3);
  font-family: inherit;
  font-size: 13px;
  cursor: pointer;
  transition:
    background-color var(--px-duration-fast) var(--px-ease-out),
    color var(--px-duration-fast) var(--px-ease-out);
}

.nav-search__submit:hover {
  background: var(--px-accent-soft);
  color: var(--px-accent-deep);
}

.user-chip {
  display: inline-flex;
  align-items: center;
  gap: 9px;
  height: 40px;
  padding: 0 12px 0 6px;
  border: 0;
  border-radius: var(--px-radius-pill);
  background: rgba(255, 255, 255, 0.44);
  box-shadow: var(--px-shadow-1), inset 0 1px 0 rgba(255, 255, 255, 0.7);
  color: var(--px-ink-2);
  font-family: inherit;
  font-size: var(--px-text-sm);
  font-weight: var(--px-weight-medium);
  cursor: pointer;
  transition:
    background-color var(--px-duration-base) var(--px-ease-out),
    box-shadow var(--px-duration-base) var(--px-ease-out),
    transform var(--px-duration-fast) var(--px-ease-out);
}

.user-chip:hover {
  background: rgba(255, 255, 255, 0.74);
  box-shadow: var(--px-shadow-2);
  transform: translateY(-1px);
}

.user-chip__avatar {
  width: 28px;
  height: 28px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  overflow: hidden;
  background: var(--px-gradient-gold);
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.5);
  color: #fff;
  font-size: var(--px-text-xs);
  font-weight: var(--px-weight-semibold);
}

.user-chip__avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.user-chip__name {
  max-width: 96px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.user-chip__chevron {
  color: var(--px-ink-3);
  transition: transform var(--px-duration-base) var(--px-ease-out);
}

.user-chip:hover .user-chip__chevron {
  transform: translateY(1px);
}

.preview-bar {
  position: relative;
  z-index: 2;
  width: min(100% - 48px, var(--px-container));
  margin: 12px auto 0;
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 10px 14px;
  border-radius: var(--px-radius-md);
  background: rgba(255, 246, 230, 0.92);
  box-shadow: var(--px-shadow-1), inset 0 1px 0 rgba(255, 255, 255, 0.7);
  color: var(--px-ink-2);
  font-size: var(--px-text-sm);
}

.preview-bar__tag {
  padding: 3px 9px;
  border-radius: var(--px-radius-pill);
  background: var(--px-warning);
  color: #fff;
  font-size: 11px;
  font-weight: var(--px-weight-semibold);
  white-space: nowrap;
}

.preview-bar__text {
  flex: 1;
  min-width: 0;
}

.preview-bar__exit {
  padding: 6px 12px;
  border: 0;
  border-radius: var(--px-radius-pill);
  background: rgba(32, 42, 54, 0.08);
  color: var(--px-ink-1);
  font-family: inherit;
  font-size: var(--px-text-xs);
  font-weight: var(--px-weight-medium);
  cursor: pointer;
  white-space: nowrap;
  transition: background-color var(--px-duration-fast) var(--px-ease-out);
}

.preview-bar__exit:hover {
  background: rgba(32, 42, 54, 0.14);
}

.main {
  position: relative;
  z-index: 1;
  flex: 1;
}
</style>
