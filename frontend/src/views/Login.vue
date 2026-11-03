<template>
  <div class="login-page">
    <div class="login-ambient" aria-hidden="true">
      <span class="login-ambient__orb login-ambient__orb--a" />
      <span class="login-ambient__orb login-ambient__orb--b" />
      <span class="login-ambient__grid" />
    </div>

    <div class="login-shell">
      <aside class="login-visual">
        <img class="login-visual__image" src="/attraction/attraction_8_1.jpg" alt="九寨沟风光" />
        <div class="login-visual__veil" aria-hidden="true" />

        <div class="login-visual__content">
          <div class="login-brand">
            <span class="login-brand__mark"><span /></span>
            <span class="login-brand__text">Travel<em>旅游</em></span>
          </div>

          <div class="login-quote">
            <p class="login-quote__eyebrow">Curated journeys</p>
            <h1>一次轻装出发，<br />去看更大的世界。</h1>
            <p class="login-quote__desc">
              从山海到古城，循着在地人文、村落街巷与风土人情，找到值得慢慢走的目的地。
            </p>
          </div>

          <div class="login-visual__foot">
            <span class="login-visual__dot" />
            文旅推荐 · 风土人文 · 在地攻略
          </div>
        </div>
      </aside>

      <main class="login-panel">
        <div class="login-panel__inner">
          <header class="login-panel__head">
            <p class="px-eyebrow">Welcome back</p>
            <h2 class="login-panel__title">{{ activeTab === 'login' ? '登录 Travel' : '创建账号' }}</h2>
            <p class="login-panel__subtitle">
              {{ activeTab === 'login' ? '请输入账号和密码登录，也可以直接使用游客演示账号。' : '填写基本信息，即可开始预订旅程。' }}
            </p>
          </header>

          <div v-if="activeTab === 'login'" class="login-demo">
            <span class="login-demo__label">游客演示</span>
            <span class="login-demo__account">traveler / travel123</span>
          </div>

          <div class="auth-switch" role="tablist">
            <span
              class="auth-switch__thumb"
              :class="{ 'is-register': activeTab === 'register' }"
            />
            <button
              type="button"
              role="tab"
              class="auth-switch__item"
              :class="{ 'is-active': activeTab === 'login' }"
              :aria-selected="activeTab === 'login'"
              @click="activeTab = 'login'"
            >
              登录
            </button>
            <button
              type="button"
              role="tab"
              class="auth-switch__item"
              :class="{ 'is-active': activeTab === 'register' }"
              :aria-selected="activeTab === 'register'"
              @click="activeTab = 'register'"
            >
              注册
            </button>
          </div>

          <el-form
            v-if="activeTab === 'login'"
            ref="loginFormRef"
            :model="loginForm"
            :rules="loginRules"
            label-position="top"
            class="auth-form"
            @keyup.enter="handleLogin"
          >
            <el-form-item prop="username" label="用户名">
              <PremiumInput
                v-model="loginForm.username"
                placeholder="请输入用户名"
                clearable
                autocomplete="username"
              >
                <template #prefix>
                  <svg viewBox="0 0 20 20" width="15" height="15" aria-hidden="true">
                    <circle cx="10" cy="7" r="3.2" fill="none" stroke="currentColor" stroke-width="1.5" />
                    <path d="M4 17c0-3.2 2.7-5 6-5s6 1.8 6 5" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" />
                  </svg>
                </template>
              </PremiumInput>
            </el-form-item>

            <el-form-item prop="password" label="密码">
              <PremiumInput
                v-model="loginForm.password"
                type="password"
                placeholder="请输入密码"
                clearable
                autocomplete="current-password"
              >
                <template #prefix>
                  <svg viewBox="0 0 20 20" width="15" height="15" aria-hidden="true">
                    <rect x="4.5" y="8.5" width="11" height="8" rx="2" fill="none" stroke="currentColor" stroke-width="1.5" />
                    <path d="M7 8.5V6.8a3 3 0 016 0v1.7" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" />
                  </svg>
                </template>
              </PremiumInput>
            </el-form-item>

            <PremiumButton block size="lg" :loading="submitting" class="auth-submit" @click="handleLogin">
              登录
            </PremiumButton>
          </el-form>

          <el-form
            v-else
            ref="registerFormRef"
            :model="registerForm"
            :rules="registerRules"
            label-position="top"
            class="auth-form auth-form--register"
          >
            <div class="auth-grid">
              <el-form-item prop="username" label="用户名">
                <PremiumInput v-model="registerForm.username" placeholder="3-50 位字符" clearable autocomplete="username" />
              </el-form-item>
              <el-form-item prop="nickname" label="昵称">
                <PremiumInput v-model="registerForm.nickname" placeholder="选填" clearable />
              </el-form-item>
              <el-form-item prop="password" label="密码">
                <PremiumInput v-model="registerForm.password" type="password" placeholder="至少 6 位" autocomplete="new-password" />
              </el-form-item>
              <el-form-item prop="confirmPassword" label="确认密码">
                <PremiumInput v-model="registerForm.confirmPassword" type="password" placeholder="再次输入密码" autocomplete="new-password" />
              </el-form-item>
            </div>

            <el-form-item prop="phone" label="手机号">
              <PremiumInput v-model="registerForm.phone" placeholder="选填，用于接收通知" clearable autocomplete="tel" />
            </el-form-item>

            <PremiumButton block size="lg" :loading="submitting" class="auth-submit" @click="handleRegister">
              注册
            </PremiumButton>
          </el-form>

          <p class="login-panel__note">
            登录即表示同意平台服务条款与隐私政策
          </p>
        </div>
      </main>
    </div>
  </div>
</template>

<script setup>
import { reactive, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import PremiumButton from '@/components/premium/PremiumButton.vue'
import PremiumInput from '@/components/premium/PremiumInput.vue'
import { login, register } from '@/api/auth'
import { setAuth } from '@/utils/auth'
import { setAdminAuth, stopAdminPreview } from '@/utils/adminAuth'

const route = useRoute()
const router = useRouter()

const activeTab = ref('login')
const submitting = ref(false)
const loginFormRef = ref()
const registerFormRef = ref()

const loginForm = reactive({
  username: '',
  password: ''
})

const registerForm = reactive({
  username: '',
  password: '',
  confirmPassword: '',
  nickname: '',
  phone: ''
})

const loginRules = {
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }]
}

const registerRules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 3, max: 50, message: '用户名长度 3-50 位', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, max: 32, message: '密码长度 6-32 位', trigger: 'blur' }
  ],
  confirmPassword: [
    { required: true, message: '请再次输入密码', trigger: 'blur' },
    {
      validator: (rule, value, callback) => {
        if (value !== registerForm.password) {
          callback(new Error('两次输入的密码不一致'))
          return
        }
        callback()
      },
      trigger: 'blur'
    }
  ],
  phone: [
    {
      validator: (rule, value, callback) => {
        if (value && !/^1[3-9]\d{9}$/.test(value)) {
          callback(new Error('手机号格式不正确'))
          return
        }
        callback()
      },
      trigger: 'blur'
    }
  ]
}

async function handleLogin() {
  const valid = await loginFormRef.value.validate().catch(() => false)
  if (!valid) return
  submitting.value = true
  try {
    const result = await login({ ...loginForm })
    const redirect = route.query.redirect
    if (result.role === 1) {
      setAdminAuth(result)
      stopAdminPreview()
      ElMessage.success('登录成功')
      router.push(redirect && String(redirect).startsWith('/admin') ? redirect : '/admin/dashboard')
    } else {
      setAuth(result)
      ElMessage.success('登录成功')
      router.push(redirect && !String(redirect).startsWith('/admin') ? redirect : '/')
    }
  } finally {
    submitting.value = false
  }
}

async function handleRegister() {
  const valid = await registerFormRef.value.validate().catch(() => false)
  if (!valid) return
  submitting.value = true
  try {
    await register({
      username: registerForm.username,
      password: registerForm.password,
      nickname: registerForm.nickname || undefined,
      phone: registerForm.phone || undefined
    })
    ElMessage.success('注册成功，请登录')
    loginForm.username = registerForm.username
    loginForm.password = ''
    activeTab.value = 'login'
  } finally {
    submitting.value = false
  }
}
</script>

<style scoped lang="scss">
.login-page {
  position: relative;
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 32px;
  overflow: hidden;
}

.login-ambient {
  position: absolute;
  inset: 0;
  z-index: 0;
  pointer-events: none;
}

.login-ambient__orb {
  position: absolute;
  border-radius: 50%;
  filter: blur(100px);
  opacity: 0.7;
  animation: orb-drift var(--px-duration-breathe) var(--px-ease-soft) infinite alternate;
}

.login-ambient__orb--a {
  width: 540px;
  height: 540px;
  top: -160px;
  left: -120px;
  background: radial-gradient(circle, rgba(133, 168, 190, 0.4), transparent 68%);
}

.login-ambient__orb--b {
  width: 480px;
  height: 480px;
  right: -140px;
  bottom: -160px;
  background: radial-gradient(circle, rgba(193, 177, 150, 0.34), transparent 68%);
  animation-delay: -2.4s;
}

@keyframes orb-drift {
  from {
    transform: translate3d(0, 0, 0) scale(1);
  }
  to {
    transform: translate3d(24px, 20px, 0) scale(1.05);
  }
}

.login-ambient__grid {
  position: absolute;
  inset: 0;
  background-image: radial-gradient(rgba(32, 42, 54, 0.08) 1px, transparent 1px);
  background-size: 30px 30px;
  opacity: 0.35;
  mask-image: linear-gradient(180deg, rgba(0, 0, 0, 0.6), transparent 62%);
  -webkit-mask-image: linear-gradient(180deg, rgba(0, 0, 0, 0.6), transparent 62%);
}

.login-shell {
  position: relative;
  z-index: var(--px-z-card);
  width: min(100%, 1060px);
  height: 646px;
  display: grid;
  grid-template-columns: 1.02fr 1fr;
  border-radius: var(--px-radius-xl);
  overflow: hidden;
  background: var(--px-surface-strong);
  box-shadow: var(--px-shadow-3), var(--px-shadow-highlight);
  backdrop-filter: blur(var(--px-blur-lg)) saturate(160%);
  -webkit-backdrop-filter: blur(var(--px-blur-lg)) saturate(160%);
  isolation: isolate;
}

/* ---------- visual ---------- */
.login-visual {
  position: relative;
  overflow: hidden;
  background: #263241;
}

.login-visual__image {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
  filter: saturate(82%);
  transform: scale(1.02);
  animation: visual-breathe 14s var(--px-ease-soft) infinite alternate;
}

@keyframes visual-breathe {
  from {
    transform: scale(1.02) translate3d(0, 0, 0);
  }
  to {
    transform: scale(1.07) translate3d(-6px, -4px, 0);
  }
}

.login-visual__veil {
  position: absolute;
  inset: 0;
  background:
    linear-gradient(180deg, rgba(16, 24, 33, 0.32) 0%, rgba(16, 24, 33, 0.12) 32%, rgba(16, 24, 33, 0.78) 100%),
    linear-gradient(90deg, rgba(16, 24, 33, 0.3), transparent 60%);
}

.login-visual__content {
  position: relative;
  z-index: 1;
  height: 100%;
  display: flex;
  flex-direction: column;
  padding: 38px 40px 34px;
  color: #fff;
}

.login-brand {
  display: inline-flex;
  align-items: center;
  gap: 11px;
}

.login-brand__mark {
  width: 32px;
  height: 32px;
  border-radius: 11px;
  background: rgba(255, 255, 255, 0.16);
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.34);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  display: inline-flex;
  align-items: center;
  justify-content: center;
  transform: rotate(-6deg);
}

.login-brand__mark span {
  width: 9px;
  height: 9px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.94);
  box-shadow: 0 0 0 3px rgba(255, 255, 255, 0.14);
}

.login-brand__text {
  display: inline-flex;
  align-items: baseline;
  gap: 7px;
  font-size: 17px;
  font-weight: var(--px-weight-semibold);
  color: #fff;
}

.login-brand__text em {
  font-style: normal;
  font-size: 10px;
  font-weight: var(--px-weight-medium);
  letter-spacing: 0.26em;
  color: rgba(255, 255, 255, 0.62);
}

.login-quote {
  margin-top: auto;
}

.login-quote__eyebrow {
  font-size: 10px;
  font-weight: var(--px-weight-semibold);
  letter-spacing: 0.26em;
  text-transform: uppercase;
  color: rgba(255, 255, 255, 0.52);
}

.login-quote h1 {
  margin-top: 14px;
  font-size: 34px;
  font-weight: var(--px-weight-semibold);
  line-height: 1.26;
  letter-spacing: 0.01em;
  color: #fff;
  text-shadow: 0 8px 36px rgba(10, 16, 22, 0.3);
}

.login-quote__desc {
  margin-top: 14px;
  max-width: 340px;
  font-size: var(--px-text-sm);
  line-height: var(--px-leading-base);
  color: rgba(255, 255, 255, 0.64);
}

.login-visual__foot {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-top: 34px;
  padding-top: 18px;
  font-size: var(--px-text-xs);
  letter-spacing: 0.06em;
  color: rgba(255, 255, 255, 0.5);
  background: linear-gradient(90deg, rgba(255, 255, 255, 0.24), transparent) top / 100% 1px no-repeat;
}

.login-visual__dot {
  width: 5px;
  height: 5px;
  border-radius: 50%;
  background: #d8c4a2;
  box-shadow: 0 0 0 4px rgba(216, 196, 162, 0.14);
}

/* ---------- panel ---------- */
.login-panel {
  position: relative;
  z-index: 2;
  background:
    radial-gradient(90% 60% at 100% 0%, rgba(255, 255, 255, 0.72), transparent 60%),
    linear-gradient(160deg, rgba(252, 253, 255, 0.94), rgba(241, 245, 249, 0.9));
  overflow-y: auto;
}

.login-panel__inner {
  min-height: 100%;
  display: flex;
  flex-direction: column;
  padding: 46px clamp(36px, 4vw, 54px) 32px;
}

.login-panel__head {
  display: flex;
  flex-direction: column;
  gap: 9px;
}

.login-panel__title {
  font-size: var(--px-text-xl);
  color: var(--px-ink-1);
}

.login-panel__subtitle {
  font-size: var(--px-text-sm);
  line-height: var(--px-leading-snug);
  color: var(--px-ink-3);
}

.login-demo {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  margin-top: 16px;
  padding: 8px 12px;
  border-radius: var(--px-radius-sm, 8px);
  background: rgba(84, 108, 150, 0.06);
  border: 1px solid rgba(84, 108, 150, 0.14);
}

.login-demo__label {
  padding: 2px 7px;
  border-radius: 4px;
  font-size: 10px;
  font-weight: 600;
  letter-spacing: 0.04em;
  color: #4a628a;
  background: rgba(84, 108, 150, 0.12);
}

.login-demo__account {
  font-family: var(--px-font-mono, ui-monospace, monospace);
  font-size: 12px;
  color: var(--px-ink-2);
}

.auth-switch {
  position: relative;
  display: grid;
  grid-template-columns: 1fr 1fr;
  margin: 26px 0 24px;
  padding: 4px;
  border-radius: var(--px-radius-pill);
  background: rgba(32, 42, 54, 0.045);
  box-shadow: var(--px-shadow-inset);
}

.auth-switch__thumb {
  position: absolute;
  top: 4px;
  left: 4px;
  width: calc(50% - 4px);
  height: calc(100% - 8px);
  border-radius: var(--px-radius-pill);
  background: rgba(255, 255, 255, 0.92);
  box-shadow: var(--px-shadow-1), inset 0 1px 0 rgba(255, 255, 255, 0.9);
  transition: transform var(--px-duration-slow) var(--px-ease-out);
}

.auth-switch__thumb.is-register {
  transform: translateX(100%);
}

.auth-switch__item {
  position: relative;
  z-index: 1;
  height: 36px;
  border: 0;
  background: transparent;
  font-family: inherit;
  font-size: var(--px-text-sm);
  font-weight: var(--px-weight-medium);
  color: var(--px-ink-3);
  cursor: pointer;
  transition: color var(--px-duration-base) var(--px-ease-out);
}

.auth-switch__item.is-active {
  color: var(--px-ink-1);
}

.auth-form {
  display: flex;
  flex-direction: column;
}

.auth-form :deep(.el-form-item) {
  margin-bottom: 16px;
}

.auth-form :deep(.el-form-item__label) {
  padding-bottom: 5px;
  font-size: var(--px-text-xs);
  font-weight: var(--px-weight-medium);
  color: var(--px-ink-2);
}

.auth-form :deep(.el-input__prefix) {
  color: var(--px-ink-4);
}

.auth-form--register :deep(.el-form-item) {
  margin-bottom: 12px;
}

.auth-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 0 12px;
}

.auth-submit {
  margin-top: 8px;
}

.login-panel__note {
  margin-top: auto;
  padding-top: 22px;
  text-align: center;
  font-size: var(--px-text-xs);
  color: var(--px-ink-4);
  letter-spacing: 0.02em;
}
</style>
