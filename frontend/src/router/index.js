import { createRouter, createWebHistory } from 'vue-router'
import { getToken } from '@/utils/auth'
import { getAdminToken, isAdminPreviewMode } from '@/utils/adminAuth'

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/Login.vue'),
    meta: { public: true, title: '登录' }
  },
  {
    path: '/',
    component: () => import('@/layouts/UserLayout.vue'),
    children: [
      {
        path: '',
        name: 'Home',
        component: () => import('@/views/Home.vue'),
        meta: { title: '首页' }
      },
      {
        path: 'attractions',
        name: 'AttractionList',
        component: () => import('@/views/AttractionList.vue'),
        meta: { title: '景点列表' }
      },
      {
        path: 'attractions/:id',
        name: 'AttractionDetail',
        component: () => import('@/views/AttractionDetail.vue'),
        meta: { title: '景点详情' }
      },
      {
        path: 'map',
        name: 'AttractionMap',
        component: () => import('@/views/AttractionMap.vue'),
        meta: { title: '景点地图' }
      },
      {
        path: 'order/create',
        name: 'OrderCreate',
        component: () => import('@/views/OrderCreate.vue'),
        meta: { title: '填写订单' }
      },
      {
        path: 'orders',
        name: 'MyOrders',
        component: () => import('@/views/MyOrders.vue'),
        meta: { title: '我的订单' }
      },
      {
        path: 'orders/:orderNo',
        name: 'OrderDetail',
        component: () => import('@/views/OrderDetail.vue'),
        meta: { title: '订单详情' }
      },
      {
        path: 'profile',
        name: 'Profile',
        component: () => import('@/views/Profile.vue'),
        meta: { title: '个人中心' }
      },
      {
        path: 'profile/settings',
        name: 'ProfileSettings',
        component: () => import('@/views/ProfileSettings.vue'),
        meta: { title: '账号设置' }
      },
      {
        path: 'profile/favorites',
        name: 'ProfileFavorites',
        component: () => import('@/views/Favorites.vue'),
        meta: { title: '我的收藏' }
      }
    ]
  },
  {
    path: '/admin',
    component: () => import('@/layouts/AdminLayout.vue'),
    redirect: '/admin/dashboard',
    meta: { adminAuth: true },
    children: [
      {
        path: 'dashboard',
        name: 'AdminDashboard',
        component: () => import('@/views/admin/Dashboard.vue'),
        meta: { title: '经营看板' }
      },
      {
        path: 'attractions',
        name: 'AdminAttraction',
        component: () => import('@/views/admin/AttractionManage.vue'),
        meta: { title: '景点目的地' }
      },
      {
        path: 'guides',
        name: 'AdminGuide',
        component: () => import('@/views/admin/GuideManage.vue'),
        meta: { title: '攻略内容' }
      },
      {
        path: 'inventory',
        name: 'AdminInventory',
        component: () => import('@/views/admin/InventoryManage.vue'),
        meta: { title: '票种库存' }
      },
      {
        path: 'orders',
        name: 'AdminOrder',
        component: () => import('@/views/admin/OrderManage.vue'),
        meta: { title: '订单管理' }
      },
      {
        path: 'users',
        name: 'AdminUser',
        component: () => import('@/views/admin/UserManage.vue'),
        meta: { title: '游客账号' }
      },
      {
        path: 'checkin',
        name: 'AdminCheckin',
        component: () => import('@/views/admin/CheckinWorkbench.vue'),
        meta: { title: '核销工作台' }
      }
    ]
  },
  {
    path: '/:pathMatch(.*)*',
    redirect: '/'
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to) => {
  const loggedIn = Boolean(getToken())
  const adminLoggedIn = Boolean(getAdminToken())
  const adminPreview = isAdminPreviewMode()

  if (to.meta.adminAuth && !adminLoggedIn) {
    return { path: '/login', query: { redirect: to.fullPath } }
  }

  const isPublic = to.meta.public || to.meta.adminAuth
  if (!isPublic && !loggedIn && !adminPreview) {
    return { path: '/login', query: { redirect: to.fullPath } }
  }

  const previewBlocked = [
    'OrderCreate',
    'MyOrders',
    'OrderDetail',
    'Profile',
    'ProfileSettings',
    'ProfileFavorites'
  ]
  if (adminPreview && previewBlocked.includes(to.name)) {
    return { path: '/' }
  }
  if (to.path === '/login' && (loggedIn || adminLoggedIn || adminPreview)) {
    return { path: adminLoggedIn ? '/admin/dashboard' : '/' }
  }
  return true
})

router.afterEach((to) => {
  document.title = to.meta.title ? `${to.meta.title} - Travel 文旅` : 'Travel 文旅'
})

export default router
