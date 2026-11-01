import request from './request'

export function getRecommend(params) {
  return request.get('/recommend', { params })
}
