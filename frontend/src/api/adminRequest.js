import axios from 'axios'
import { ElMessage } from 'element-plus'
import { clearAdminAuth, getAdminToken } from '@/utils/adminAuth'

const request = axios.create({
  baseURL: '/api',
  timeout: 10000
})

function redirectToAdminLogin() {
  clearAdminAuth()
  if (window.location.pathname !== '/login') {
    const redirect = encodeURIComponent(window.location.pathname + window.location.search)
    window.location.href = `/login?redirect=${redirect}`
  }
}

request.interceptors.request.use((config) => {
  const token = getAdminToken()
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

request.interceptors.response.use(
  (response) => {
    const result = response.data
    if (result.code === 200) {
      return result.data
    }
    if (result.code === 401 || result.code === 403) {
      ElMessage.error(result.message || '管理员登录已失效')
      redirectToAdminLogin()
    } else {
      ElMessage.error(result.message || '请求失败')
    }
    return Promise.reject(new Error(result.message || '请求失败'))
  },
  (error) => {
    const status = error.response?.status
    if (status === 401 || status === 403) {
      ElMessage.error(status === 403 ? '没有管理员操作权限' : '管理员登录已失效')
      redirectToAdminLogin()
    } else if (status >= 500) {
      ElMessage.error('服务器异常，请稍后重试')
    } else {
      ElMessage.error(error.response?.data?.message || error.message || '网络异常')
    }
    return Promise.reject(error)
  }
)

export default request
