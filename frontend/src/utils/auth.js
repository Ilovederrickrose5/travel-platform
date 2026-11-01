const TOKEN_KEY = 'travel_token'
const USER_KEY = 'travel_user'

export function getToken() {
  return localStorage.getItem(TOKEN_KEY)
}

export function getUser() {
  const raw = localStorage.getItem(USER_KEY)
  if (!raw) return null
  try {
    return JSON.parse(raw)
  } catch {
    return null
  }
}

export function setAuth(loginResult) {
  localStorage.setItem(TOKEN_KEY, loginResult.token)
  localStorage.setItem(
    USER_KEY,
    JSON.stringify({
      userId: loginResult.userId,
      username: loginResult.username,
      nickname: loginResult.nickname,
      avatar: loginResult.avatar,
      signature: loginResult.signature,
      role: loginResult.role
    })
  )
}

export function updateStoredUser(patch) {
  const current = getUser() || {}
  localStorage.setItem(USER_KEY, JSON.stringify({ ...current, ...patch }))
  window.dispatchEvent(new Event('travel-auth-user-changed'))
}

export function clearAuth() {
  localStorage.removeItem(TOKEN_KEY)
  localStorage.removeItem(USER_KEY)
  window.dispatchEvent(new Event('travel-auth-user-changed'))
}
