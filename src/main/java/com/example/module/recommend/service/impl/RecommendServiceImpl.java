package com.example.module.recommend.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.example.common.constant.OrderStatus;
import com.example.common.constant.TicketStatus;
import com.example.module.content.entity.Attraction;
import com.example.module.content.entity.TicketType;
import com.example.module.content.mapper.AttractionMapper;
import com.example.module.content.mapper.TicketTypeMapper;
import com.example.module.order.entity.Order;
import com.example.module.order.entity.OrderItem;
import com.example.module.order.mapper.OrderItemMapper;
import com.example.module.order.mapper.OrderMapper;
import com.example.module.recommend.service.RecommendService;
import com.example.module.recommend.vo.RecommendItemVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.function.BinaryOperator;
import java.util.stream.Collectors;

/**
 * 规则推荐：城市偏好 + 景区等级 + 运营排序。
 */
@Service
@RequiredArgsConstructor
public class RecommendServiceImpl implements RecommendService {

    private static final int DEFAULT_LIMIT = 6;
    private static final int MAX_LIMIT = 20;

    private final AttractionMapper attractionMapper;
    private final TicketTypeMapper ticketTypeMapper;
    private final OrderMapper orderMapper;
    private final OrderItemMapper orderItemMapper;

    @Override
    public List<RecommendItemVO> recommend(Long userId, Integer limit) {
        int size = limit == null ? DEFAULT_LIMIT : Math.min(Math.max(limit, 1), MAX_LIMIT);

        List<Attraction> attractions = attractionMapper.selectList(new LambdaQueryWrapper<Attraction>()
                .eq(Attraction::getStatus, 1)
                .orderByAsc(Attraction::getSort));
        if (attractions.isEmpty()) {
            return Collections.emptyList();
        }

        Map<Long, BigDecimal> minPriceMap = loadMinPrice(
                attractions.stream().map(Attraction::getId).toList());
        String preferredCity = findPreferredCity(userId);

        List<RecommendItemVO> items = new ArrayList<>(attractions.size());
        for (Attraction attraction : attractions) {
            RecommendItemVO item = new RecommendItemVO();
            item.setAttractionId(attraction.getId());
            item.setName(attraction.getName());
            item.setCity(attraction.getCity());
            item.setCoverUrl(attraction.getCoverUrl());
            item.setPrice(minPriceMap.get(attraction.getId()));

            BigDecimal score = BigDecimal.valueOf(60);
            String reason = "热门景区";
            if (preferredCity != null && preferredCity.equals(attraction.getCity())) {
                score = score.add(BigDecimal.valueOf(25));
                reason = "你最近在" + preferredCity + "出行，为你推荐";
            } else if ("5A".equals(attraction.getLevel())) {
                score = score.add(BigDecimal.valueOf(8));
                reason = "5A 级景区";
            } else if ("4A".equals(attraction.getLevel())) {
                score = score.add(BigDecimal.valueOf(4));
                reason = "4A 级景区";
            }
            item.setScore(score);
            item.setReason(reason);
            items.add(item);
        }

        items.sort(Comparator.comparing(RecommendItemVO::getScore).reversed());
        return items.subList(0, Math.min(size, items.size()));
    }

    private Map<Long, BigDecimal> loadMinPrice(List<Long> attractionIds) {
        return ticketTypeMapper.selectList(new LambdaQueryWrapper<TicketType>()
                        .in(TicketType::getAttractionId, attractionIds)
                        .eq(TicketType::getStatus, TicketStatus.ON_SALE.getCode()))
                .stream()
                .filter(ticketType -> ticketType.getPrice() != null)
                .collect(Collectors.toMap(
                        TicketType::getAttractionId,
                        TicketType::getPrice,
                        BinaryOperator.minBy(Comparator.naturalOrder())));
    }

    private String findPreferredCity(Long userId) {
        if (userId == null) {
            return null;
        }
        List<Order> orders = orderMapper.selectList(new LambdaQueryWrapper<Order>()
                .eq(Order::getUserId, userId)
                .in(Order::getOrderStatus, OrderStatus.PAID.getCode(), OrderStatus.COMPLETED.getCode())
                .orderByDesc(Order::getCreatedAt)
                .last("LIMIT 5"));
        if (orders.isEmpty()) {
            return null;
        }
        OrderItem item = orderItemMapper.selectOne(new LambdaQueryWrapper<OrderItem>()
                .in(OrderItem::getOrderId, orders.stream().map(Order::getId).toList())
                .orderByDesc(OrderItem::getId)
                .last("LIMIT 1"));
        if (item == null) {
            return null;
        }
        TicketType ticketType = ticketTypeMapper.selectById(item.getTicketTypeId());
        if (ticketType == null) {
            return null;
        }
        Attraction attraction = attractionMapper.selectById(ticketType.getAttractionId());
        return attraction == null ? null : attraction.getCity();
    }
}
