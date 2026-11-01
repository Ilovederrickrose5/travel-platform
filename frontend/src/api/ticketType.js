import request from './request'

export function getTicketTypes(attractionId) {
  return request.get('/ticket-types', { params: { attractionId } })
}

export function getTicketTypeDetail(id) {
  return request.get(`/ticket-types/${id}`)
}
