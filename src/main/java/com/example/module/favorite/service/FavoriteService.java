package com.example.module.favorite.service;

import com.example.module.favorite.vo.FavoriteVO;

import java.util.List;

public interface FavoriteService {

    List<FavoriteVO> listFavorites(Long userId);

    List<Long> listFavoriteIds(Long userId);

    void addFavorite(Long userId, Long attractionId);

    void removeFavorite(Long userId, Long attractionId);
}
