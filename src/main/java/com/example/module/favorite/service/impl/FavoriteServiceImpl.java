package com.example.module.favorite.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.example.common.exception.BizException;
import com.example.common.result.ResultCode;
import com.example.module.auth.entity.User;
import com.example.module.auth.mapper.UserMapper;
import com.example.module.content.entity.Attraction;
import com.example.module.content.entity.TicketType;
import com.example.module.content.mapper.AttractionMapper;
import com.example.module.content.mapper.TicketTypeMapper;
import com.example.module.favorite.entity.UserFavorite;
import com.example.module.favorite.mapper.UserFavoriteMapper;
import com.example.module.favorite.service.FavoriteService;
import com.example.module.favorite.vo.FavoriteVO;
import lombok.RequiredArgsConstructor;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.function.BinaryOperator;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class FavoriteServiceImpl implements FavoriteService {

    private static final int VISITOR_ROLE = 0;

    private final UserFavoriteMapper favoriteMapper;
    private final UserMapper userMapper;
    private final AttractionMapper attractionMapper;
    private final TicketTypeMapper ticketTypeMapper;

    @Override
    public List<FavoriteVO> listFavorites(Long userId) {
        requireVisitor(userId);
        List<UserFavorite> favorites = favoriteMapper.selectList(new LambdaQueryWrapper<UserFavorite>()
                .eq(UserFavorite::getUserId, userId)
                .orderByDesc(UserFavorite::getCreatedAt)
                .orderByDesc(UserFavorite::getId));
        if (favorites.isEmpty()) {
            return Collections.emptyList();
        }

        List<Long> attractionIds = favorites.stream().map(UserFavorite::getAttractionId).distinct().toList();
        Map<Long, Attraction> attractionMap = attractionMapper.selectBatchIds(attractionIds).stream()
                .filter(attraction -> Integer.valueOf(1).equals(attraction.getStatus()))
                .collect(Collectors.toMap(Attraction::getId, attraction -> attraction));
        Map<Long, BigDecimal> minPriceMap = loadMinPrices(attractionIds);

        return favorites.stream()
                .map(favorite -> {
                    Attraction attraction = attractionMap.get(favorite.getAttractionId());
                    if (attraction == null) {
                        return null;
                    }
                    FavoriteVO vo = new FavoriteVO();
                    vo.setAttractionId(attraction.getId());
                    vo.setName(attraction.getName());
                    vo.setCity(attraction.getCity());
                    vo.setLevel(attraction.getLevel());
                    vo.setCoverUrl(attraction.getCoverUrl());
                    vo.setMinPrice(minPriceMap.get(attraction.getId()));
                    vo.setFavoritedAt(favorite.getCreatedAt());
                    return vo;
                })
                .filter(Objects::nonNull)
                .toList();
    }

    @Override
    public List<Long> listFavoriteIds(Long userId) {
        requireVisitor(userId);
        return favoriteMapper.selectList(new LambdaQueryWrapper<UserFavorite>()
                        .eq(UserFavorite::getUserId, userId)
                        .orderByDesc(UserFavorite::getCreatedAt))
                .stream()
                .map(UserFavorite::getAttractionId)
                .toList();
    }

    @Override
    public void addFavorite(Long userId, Long attractionId) {
        requireVisitor(userId);
        Attraction attraction = attractionMapper.selectById(attractionId);
        if (attraction == null || !Integer.valueOf(1).equals(attraction.getStatus())) {
            throw new BizException("景点不存在或已下线");
        }
        Long existing = favoriteMapper.selectCount(new LambdaQueryWrapper<UserFavorite>()
                .eq(UserFavorite::getUserId, userId)
                .eq(UserFavorite::getAttractionId, attractionId));
        if (existing != null && existing > 0) {
            return;
        }
        UserFavorite favorite = new UserFavorite();
        favorite.setUserId(userId);
        favorite.setAttractionId(attractionId);
        try {
            favoriteMapper.insert(favorite);
        } catch (DuplicateKeyException ignored) {
            // 并发重复收藏时保持幂等
        }
    }

    @Override
    public void removeFavorite(Long userId, Long attractionId) {
        requireVisitor(userId);
        favoriteMapper.delete(new LambdaQueryWrapper<UserFavorite>()
                .eq(UserFavorite::getUserId, userId)
                .eq(UserFavorite::getAttractionId, attractionId));
    }

    private Map<Long, BigDecimal> loadMinPrices(List<Long> attractionIds) {
        List<TicketType> tickets = ticketTypeMapper.selectList(new LambdaQueryWrapper<TicketType>()
                .in(TicketType::getAttractionId, attractionIds)
                .eq(TicketType::getStatus, 1));
        return tickets.stream()
                .filter(ticket -> ticket.getPrice() != null)
                .collect(Collectors.toMap(
                        TicketType::getAttractionId,
                        TicketType::getPrice,
                        BinaryOperator.minBy(BigDecimal::compareTo)));
    }

    private void requireVisitor(Long userId) {
        User user = userMapper.selectById(userId);
        if (user == null || !Integer.valueOf(VISITOR_ROLE).equals(user.getRole())) {
            throw new BizException(ResultCode.FORBIDDEN.getCode(), "游客账号不存在");
        }
    }
}
