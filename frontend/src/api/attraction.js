import request from './request'

export function getAttractions(params) {
  return request.get('/attractions', { params })
}

export function getAttractionDetail(id) {
  return request.get(`/attractions/${id}`)
}

export function getAttractionMap() {
  return request.get('/attractions/map')
}
