import request from './request'

export function getFavorites() {
  return request.get('/favorites')
}

export function getFavoriteIds() {
  return request.get('/favorites/ids')
}

export function addFavorite(attractionId) {
  return request.post(`/favorites/${attractionId}`)
}

export function removeFavorite(attractionId) {
  return request.delete(`/favorites/${attractionId}`)
}
