import request from './request'

export function createOrder(data) {
  return request.post('/orders', data)
}

export function getOrders() {
  return request.get('/orders')
}

export function getOrderDetail(orderNo) {
  return request.get(`/orders/${orderNo}`)
}

export function cancelOrder(orderNo) {
  return request.post(`/orders/${orderNo}/cancel`)
}
