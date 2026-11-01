import axios from 'axios'
import { ElMessage } from 'element-plus'
import { clearAuth, getToken } from '@/utils/auth'
import {
  clearAdminAuth,
  getAdminToken,
  isAdminPreviewMode,
  stopAdminPreview
} from '@/utils/adminAuth'

const request = axios.create({
  baseURL: '/api',
  timeout: 10000
})

function redirectToLogin() {
  if (isAdminPreviewMode()) {
    stopAdminPreview()
    clearAdminAuth()
    ElMessage.error('管理员登录已失效，请重新登录')
    if (window.location.pathname !== '/login') {
      window.location.href = '/login'
    }
    return
  }
  clearAuth()
  if (window.location.pathname !== '/login') {
    const redirect = encodeURIComponent(window.location.pathname + window.location.search)
    window.location.href = `/login?redirect=${redirect}`
  }
}

request.interceptors.request.use((config) => {
  if (isAdminPreviewMode()) {
    if ((config.method || 'get').toLowerCase() !== 'get') {
      ElMessage.warning('预览模式下仅支持浏览，不能下单或操作')
      return Promise.reject(new Error('预览模式下仅支持浏览'))
    }
    config.headers.Authorization = `Bearer ${getAdminToken()}`
    return config
  }
  const token = getToken()
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
    if (result.code === 401) {
      ElMessage.error(result.message || '登录已过期，请重新登录')
      redirectToLogin()
    } else {
      ElMessage.error(result.message || '请求失败')
    }
    return Promise.reject(new Error(result.message || '请求失败'))
  },
  (error) => {
    const status = error.response?.status
    if (status === 401) {
      ElMessage.error('登录已过期，请重新登录')
      redirectToLogin()
    } else if (status === 403) {
      ElMessage.error('没有操作权限')
    } else if (status >= 500) {
      ElMessage.error('服务器异常，请稍后重试')
    } else {
      ElMessage.error(error.response?.data?.message || error.message || '网络异常')
    }
    return Promise.reject(error)
  }
)

export default request
