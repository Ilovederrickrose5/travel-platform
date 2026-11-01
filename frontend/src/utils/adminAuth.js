const TOKEN_KEY = 'travel_admin_token'
const USER_KEY = 'travel_admin_user'
const PREVIEW_KEY = 'travel_admin_preview'

export function getAdminToken() {
  return localStorage.getItem(TOKEN_KEY)
}

export function getAdminUser() {
  const raw = localStorage.getItem(USER_KEY)
  if (!raw) return null
  try {
    return JSON.parse(raw)
  } catch {
    return null
  }
}

export function setAdminAuth(loginResult) {
  localStorage.setItem(TOKEN_KEY, loginResult.token)
  localStorage.setItem(
    USER_KEY,
    JSON.stringify({
      userId: loginResult.userId,
      username: loginResult.username,
      nickname: loginResult.nickname,
      role: loginResult.role
    })
  )
}

export function clearAdminAuth() {
  localStorage.removeItem(TOKEN_KEY)
  localStorage.removeItem(USER_KEY)
  stopAdminPreview()
}

export function isAdminPreview() {
  return sessionStorage.getItem(PREVIEW_KEY) === '1'
}

export function isAdminPreviewMode() {
  return isAdminPreview() && Boolean(getAdminToken())
}

export function startAdminPreview() {
  sessionStorage.setItem(PREVIEW_KEY, '1')
}

export function stopAdminPreview() {
  sessionStorage.removeItem(PREVIEW_KEY)
}
