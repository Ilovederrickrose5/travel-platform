import request from './request'

export function payOrder(orderNo) {
  return request.post(`/payments/${orderNo}/pay`)
}

export function paymentCallback(data) {
  return request.post('/payments/callback', data)
}
