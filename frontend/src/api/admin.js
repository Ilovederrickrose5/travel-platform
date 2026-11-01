import request from './adminRequest'

export function getAdminAttractions(params) {
  return request.get('/admin/attractions', { params })
}

export function createAttraction(data) {
  return request.post('/admin/attractions', data)
}

export function updateAttraction(id, data) {
  return request.put(`/admin/attractions/${id}`, data)
}

export function deleteAttraction(id) {
  return request.delete(`/admin/attractions/${id}`)
}

export function createTicketType(attractionId, data) {
  return request.post(`/admin/attractions/${attractionId}/ticket-types`, data)
}

export function getAdminTicketTypes(attractionId) {
  return request.get('/admin/ticket-types', { params: { attractionId } })
}

export function updateTicketType(id, data) {
  return request.put(`/admin/ticket-types/${id}`, data)
}

export function deleteTicketType(id) {
  return request.delete(`/admin/ticket-types/${id}`)
}

export function getAdminInventory(params) {
  return request.get('/admin/inventory', { params })
}

export function configInventory(data) {
  return request.put('/admin/inventory', data)
}

export function getAdminOrders(params) {
  return request.get('/admin/orders', { params })
}

export function getAdminOrderDetail(orderNo) {
  return request.get(`/admin/orders/${orderNo}`)
}

export function closeOrder(orderNo) {
  return request.post(`/admin/orders/${orderNo}/close`)
}

export function getDashboardStats() {
  return request.get('/admin/dashboard/stats')
}

export function checkIn(data) {
  return request.post('/admin/checkin', data)
}

export function getCheckinStatus(orderNo) {
  return request.get(`/admin/checkin/${orderNo}/status`)
}

export function getAdminUsers(params) {
  return request.get('/admin/users', { params })
}

export function updateUserStatus(id, status) {
  return request.put(`/admin/users/${id}/status`, null, { params: { status } })
}

export function resetUserPassword(id) {
  return request.post(`/admin/users/${id}/reset-password`)
}
