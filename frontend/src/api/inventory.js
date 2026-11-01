import request from './request'

export function getInventory(ticketTypeId, visitDate) {
  return request.get('/inventory', { params: { ticketTypeId, visitDate } })
}
