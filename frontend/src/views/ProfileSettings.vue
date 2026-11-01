<template>
  <div class="px-page settings-page">
    <header class="settings-head">
      <div>
        <p class="px-eyebrow">Account settings</p>
        <h1>账号设置</h1>
        <p class="settings-head__desc">维护你的公开资料与登录安全，修改后立即生效。</p>
      </div>
      <PremiumButton variant="ghost" size="sm" @click="router.push('/profile')">返回个人中心</PremiumButton>
    </header>

    <PremiumCard variant="glass" padding="lg">
      <header class="settings-card__head">
        <div>
          <p class="px-eyebrow">Profile</p>
          <h2>基本资料</h2>
        </div>
      </header>

      <div class="settings-avatar">
        <span class="settings-avatar__preview">
          <img v-if="profile.avatar" :src="profile.avatar" alt="" />
          <template v-else>{{ initial }}</template>
        </span>
        <div class="settings-avatar__side">
          <p class="settings-avatar__title">头像</p>
          <p class="settings-avatar__hint">支持 JPG、PNG、WebP，文件不超过 2MB。</p>
          <div class="settings-avatar__actions">
            <PremiumButton variant="soft" size="sm" :loading="uploading" @click="pickFile">更换头像</PremiumButton>
          </div>
          <input ref="fileInput" type="file" accept="image/jpeg,image/png,image/webp" hidden @change="onFileChange" />
        </div>
      </div>

      <div class="settings-form">
        <PremiumInput v-model="form.nickname" label="昵称" placeholder="2-20 个字符" :maxlength="20" :error="errors.nickname" />
        <PremiumInput
          v-model="form.signature"
          type="textarea"
          label="个性签名"
          optional
          placeholder="用一句话介绍你的旅行偏好"
          :maxlength="120"
          show-word-limit
          :rows="3"
          :error="errors.signature"
        />
        <div class="settings-form__row">
          <PremiumInput v-model="form.phone" label="手机号" optional placeholder="用于接收出行通知" :maxlength="11" :error="errors.phone" />
          <PremiumInput v-model="form.email" label="邮箱" optional placeholder="name@example.com" :maxlength="100" :error="errors.email" />
        </div>
      </div>

      <footer class="settings-actions">
        <PremiumButton :loading="savingProfile" @click="saveProfile">保存基本资料</PremiumButton>
      </footer>
    </PremiumCard>

    <PremiumCard variant="glass" padding="lg">
      <header class="settings-card__head">
        <div>
          <p class="px-eyebrow">Login name</p>
          <h2>登录账号</h2>
        </div>
      </header>
      <p class="settings-note">
        当前账号：<strong>@{{ profile.username || '—' }}</strong>
        <span v-if="!canChangeUsername" class="settings-cooldown">· 下次可修改：{{ nextUsernameDate }}</span>
      </p>
      <div class="settings-form">
        <PremiumInput
          v-model="usernameForm.username"
          label="新登录账号"
          placeholder="4-20 位，字母开头，可含数字与下划线"
          :maxlength="20"
          :error="errors.username"
          :hint="canChangeUsername ? '登录账号每 7 天只能修改一次。' : ''"
        />
        <PremiumInput
          v-model="usernameForm.password"
          type="password"
          label="当前密码"
          placeholder="验证身份后修改"
          autocomplete="current-password"
          :error="errors.usernamePassword"
        />
      </div>
      <footer class="settings-actions">
        <PremiumButton :loading="savingUsername" :disabled="!canChangeUsername" @click="saveUsername">修改登录账号</PremiumButton>
      </footer>
    </PremiumCard>

    <PremiumCard variant="glass" padding="lg">
      <header class="settings-card__head">
        <div>
          <p class="px-eyebrow">Security</p>
          <h2>修改密码</h2>
        </div>
      </header>
      <div class="settings-form">
        <PremiumInput
          v-model="passwordForm.oldPassword"
          type="password"
          label="当前密码"
          autocomplete="current-password"
          :error="errors.oldPassword"
        />
        <div class="settings-form__row">
          <PremiumInput
            v-model="passwordForm.newPassword"
            type="password"
            label="新密码"
            placeholder="8-32 位字符"
            autocomplete="new-password"
            :maxlength="32"
            :error="errors.newPassword"
          />
          <PremiumInput
            v-model="passwordForm.confirmPassword"
            type="password"
            label="确认新密码"
            autocomplete="new-password"
            :maxlength="32"
            :error="errors.confirmPassword"
          />
        </div>
      </div>
      <footer class="settings-actions">
        <PremiumButton :loading="savingPassword" @click="savePassword">更新密码</PremiumButton>
      </footer>
    </PremiumCard>
  </div>
</template>

<script setup>
import { computed, onMounted, reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import PremiumButton from '@/components/premium/PremiumButton.vue'
import PremiumCard from '@/components/premium/PremiumCard.vue'
import PremiumInput from '@/components/premium/PremiumInput.vue'
import { changePassword, changeUsername, getProfile, updateProfile, uploadAvatar } from '@/api/profile'
import { updateStoredUser } from '@/utils/auth'

const router = useRouter()

const profile = reactive({
  username: '',
  nickname: '',
  avatar: '',
  signature: '',
  phone: '',
  email: '',
  usernameUpdatedAt: null
})

const form = reactive({ nickname: '', signature: '', phone: '', email: '' })
const usernameForm = reactive({ username: '', password: '' })
const passwordForm = reactive({ oldPassword: '', newPassword: '', confirmPassword: '' })
const errors = reactive({})

const savingProfile = ref(false)
const uploading = ref(false)
const savingUsername = ref(false)
const savingPassword = ref(false)
const fileInput = ref(null)

const initial = computed(() => (profile.nickname || profile.username || '旅').slice(0, 1).toUpperCase())

const usernameCooldownEnd = computed(() => {
  if (!profile.usernameUpdatedAt) return null
  const start = new Date(profile.usernameUpdatedAt)
  if (Number.isNaN(start.getTime())) return null
  return new Date(start.getTime() + 7 * 24 * 60 * 60 * 1000)
})

const canChangeUsername = computed(() => !usernameCooldownEnd.value || Date.now() >= usernameCooldownEnd.value.getTime())

const nextUsernameDate = computed(() => {
  if (!usernameCooldownEnd.value) return ''
  const date = usernameCooldownEnd.value
  const pad = (n) => String(n).padStart(2, '0')
  return `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())} ${pad(date.getHours())}:${pad(date.getMinutes())}`
})

function clearErrors() {
  Object.keys(errors).forEach((key) => delete errors[key])
}

function applyProfile(data) {
  if (!data) return
  Object.assign(profile, {
    username: '',
    nickname: '',
    avatar: '',
    signature: '',
    phone: '',
    email: '',
    usernameUpdatedAt: null
  }, data)
  form.nickname = data.nickname || ''
  form.signature = data.signature || ''
  form.phone = data.phone || ''
  form.email = data.email || ''
  updateStoredUser({
    username: data.username || '',
    nickname: data.nickname || '',
    avatar: data.avatar || '',
    signature: data.signature || ''
  })
}

async function loadProfile() {
  try {
    applyProfile(await getProfile())
  } catch {
    // 请求层已提示错误
  }
}

function pickFile() {
  fileInput.value?.click()
}

async function onFileChange(event) {
  const file = event.target.files?.[0]
  event.target.value = ''
  if (!file) return
  if (!['image/jpeg', 'image/png', 'image/webp'].includes(file.type)) {
    ElMessage.warning('仅支持 JPG、PNG 或 WebP 格式的图片')
    return
  }
  if (file.size > 2 * 1024 * 1024) {
    ElMessage.warning('头像图片不能超过 2MB')
    return
  }
  uploading.value = true
  try {
    applyProfile(await uploadAvatar(file))
    ElMessage.success('头像已更新')
  } catch {
    // 请求层已提示错误
  } finally {
    uploading.value = false
  }
}

function validateProfile() {
  clearErrors()
  const nickname = form.nickname.trim()
  if (nickname.length < 2 || nickname.length > 20) {
    errors.nickname = '昵称长度需在 2-20 个字符之间'
  }
  if (form.phone && !/^1[3-9]\d{9}$/.test(form.phone.trim())) {
    errors.phone = '请输入有效的 11 位手机号'
  }
  if (form.email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(form.email.trim())) {
    errors.email = '请输入有效的邮箱地址'
  }
  return Object.keys(errors).length === 0
}

async function saveProfile() {
  if (!validateProfile()) return
  savingProfile.value = true
  try {
    applyProfile(
      await updateProfile({
        nickname: form.nickname.trim(),
        signature: form.signature.trim(),
        phone: form.phone.trim(),
        email: form.email.trim()
      })
    )
    ElMessage.success('基本资料已保存')
  } catch {
    // 请求层已提示错误
  } finally {
    savingProfile.value = false
  }
}

function validateUsername() {
  clearErrors()
  if (!/^[A-Za-z][A-Za-z0-9_]{3,19}$/.test(usernameForm.username.trim())) {
    errors.username = '登录账号需 4-20 位，以字母开头，仅含字母、数字或下划线'
  }
  if (!usernameForm.password) {
    errors.usernamePassword = '请输入当前密码'
  }
  return Object.keys(errors).length === 0
}

async function saveUsername() {
  if (!validateUsername()) return
  savingUsername.value = true
  try {
    applyProfile(
      await changeUsername({
        username: usernameForm.username.trim(),
        password: usernameForm.password
      })
    )
    usernameForm.username = ''
    usernameForm.password = ''
    ElMessage.success('登录账号已更新，下次请使用新账号登录')
  } catch {
    // 请求层已提示错误
  } finally {
    savingUsername.value = false
  }
}

function validatePassword() {
  clearErrors()
  if (!passwordForm.oldPassword) {
    errors.oldPassword = '请输入当前密码'
  }
  if (passwordForm.newPassword.length < 8 || passwordForm.newPassword.length > 32) {
    errors.newPassword = '新密码长度需在 8-32 位之间'
  } else if (passwordForm.newPassword === passwordForm.oldPassword) {
    errors.newPassword = '新密码不能与当前密码相同'
  }
  if (passwordForm.confirmPassword !== passwordForm.newPassword) {
    errors.confirmPassword = '两次输入的新密码不一致'
  }
  return Object.keys(errors).length === 0
}

async function savePassword() {
  if (!validatePassword()) return
  savingPassword.value = true
  try {
    await changePassword({
      oldPassword: passwordForm.oldPassword,
      newPassword: passwordForm.newPassword
    })
    passwordForm.oldPassword = ''
    passwordForm.newPassword = ''
    passwordForm.confirmPassword = ''
    ElMessage.success('密码已更新')
  } catch {
    // 请求层已提示错误
  } finally {
    savingPassword.value = false
  }
}

onMounted(loadProfile)
</script>

<style scoped lang="scss">
.settings-page {
  display: flex;
  flex-direction: column;
  gap: var(--px-space-5);
  padding-bottom: var(--px-space-8);
  max-width: 880px;
}

.settings-head {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 20px;
}

.settings-head h1 {
  margin-top: 6px;
  font-size: var(--px-text-xl);
  color: var(--px-ink-1);
}

.settings-head__desc {
  margin-top: 8px;
  font-size: var(--px-text-sm);
  color: var(--px-ink-3);
}

.settings-card__head {
  margin-bottom: 20px;
}

.settings-card__head h2 {
  margin-top: 4px;
  font-size: var(--px-text-md);
  color: var(--px-ink-1);
}

.settings-avatar {
  display: flex;
  align-items: center;
  gap: 20px;
  padding-bottom: 22px;
  margin-bottom: 22px;
  border-bottom: 1px solid rgba(32, 42, 54, 0.06);
}

.settings-avatar__preview {
  width: 76px;
  height: 76px;
  flex: none;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  overflow: hidden;
  background: linear-gradient(140deg, var(--px-accent-soft), rgba(255, 255, 255, 0.7));
  color: var(--px-accent-deep);
  font-size: 28px;
  font-weight: var(--px-weight-semibold);
  box-shadow: inset 0 0 0 1px rgba(255, 255, 255, 0.7);
}

.settings-avatar__preview img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.settings-avatar__title {
  font-size: var(--px-text-sm);
  font-weight: var(--px-weight-medium);
  color: var(--px-ink-2);
}

.settings-avatar__hint {
  margin-top: 6px;
  font-size: var(--px-text-xs);
  color: var(--px-ink-3);
}

.settings-avatar__actions {
  margin-top: 12px;
}

.settings-form {
  display: flex;
  flex-direction: column;
  gap: 18px;
}

.settings-form__row {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 18px;
}

.settings-actions {
  display: flex;
  justify-content: flex-end;
  margin-top: 22px;
}

.settings-note {
  margin-bottom: 16px;
  font-size: var(--px-text-sm);
  color: var(--px-ink-3);
}

.settings-note strong {
  color: var(--px-ink-1);
  font-weight: var(--px-weight-medium);
}

.settings-cooldown {
  color: var(--px-ink-4);
}

@media (max-width: 720px) {
  .settings-head {
    flex-direction: column;
    align-items: flex-start;
  }

  .settings-form__row {
    grid-template-columns: minmax(0, 1fr);
  }
}
</style>
