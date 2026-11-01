export const ORDER_STATUS = {
  0: { label: '待支付', type: 'warning' },
  10: { label: '已支付', type: 'success' },
  20: { label: '已取消', type: 'info' },
  30: { label: '已完成', type: 'success' },
  40: { label: '退款中', type: 'warning' },
  50: { label: '已退款', type: 'info' }
}

export const PAY_STATUS = {
  0: { label: '未支付', type: 'warning' },
  1: { label: '已支付', type: 'success' },
  2: { label: '已退款', type: 'info' },
  3: { label: '支付失败', type: 'danger' }
}

export const CHECKIN_STATUS = {
  0: { label: '未核销', type: 'info' },
  1: { label: '已核销', type: 'success' }
}

export function statusOf(map, code) {
  return map[code] || { label: '未知', type: 'info' }
}
