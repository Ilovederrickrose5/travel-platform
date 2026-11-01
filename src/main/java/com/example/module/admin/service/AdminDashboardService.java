package com.example.module.admin.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.example.common.constant.CheckinStatus;
import com.example.common.constant.PayStatus;
import com.example.module.admin.vo.DailyStatVO;
import com.example.module.admin.vo.DashboardStatsVO;
import com.example.module.content.entity.Attraction;
import com.example.module.content.entity.TicketType;
import com.example.module.content.mapper.AttractionMapper;
import com.example.module.content.mapper.TicketTypeMapper;
import com.example.module.order.entity.Order;
import com.example.module.order.mapper.OrderMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class AdminDashboardService {

    private static final int TREND_DAYS = 7;

    private final AttractionMapper attractionMapper;
    private final TicketTypeMapper ticketTypeMapper;
    private final OrderMapper orderMapper;

    public DashboardStatsVO stats() {
        LocalDate today = LocalDate.now();
        LocalDateTime todayStart = today.atStartOfDay();

        DashboardStatsVO vo = new DashboardStatsVO();
        vo.setAttractionCount(attractionMapper.selectCount(null));
        vo.setOnlineAttractionCount(attractionMapper.selectCount(new LambdaQueryWrapper<Attraction>()
                .eq(Attraction::getStatus, 1)));
        vo.setTicketTypeCount(ticketTypeMapper.selectCount(new LambdaQueryWrapper<TicketType>()
                .eq(TicketType::getStatus, 1)));
        vo.setOrderCount(orderMapper.selectCount(null));
        vo.setTodayOrderCount(orderMapper.selectCount(new LambdaQueryWrapper<Order>()
                .ge(Order::getCreatedAt, todayStart)));

        List<Order> checkedOrders = orderMapper.selectList(new LambdaQueryWrapper<Order>()
                .eq(Order::getCheckinStatus, CheckinStatus.CHECKED_IN.getCode()));
        vo.setCheckedOrderCount((long) checkedOrders.size());
        vo.setCheckedQuantity(checkedOrders.stream()
                .mapToLong(order -> order.getCheckedQuantity() == null ? 0 : order.getCheckedQuantity())
                .sum());

        List<Order> paidOrders = orderMapper.selectList(new LambdaQueryWrapper<Order>()
                .eq(Order::getPayStatus, PayStatus.PAID.getCode()));
        vo.setRevenue(paidOrders.stream()
                .map(Order::getPayAmount)
                .filter(amount -> amount != null)
                .reduce(BigDecimal.ZERO, BigDecimal::add));

        vo.setDaily(buildDailyTrend(today));
        return vo;
    }

    private List<DailyStatVO> buildDailyTrend(LocalDate today) {
        LocalDate start = today.minusDays(TREND_DAYS - 1L);
        List<Order> orders = orderMapper.selectList(new LambdaQueryWrapper<Order>()
                .ge(Order::getCreatedAt, start.atStartOfDay()));
        Map<LocalDate, List<Order>> grouped = orders.stream()
                .filter(order -> order.getCreatedAt() != null)
                .collect(Collectors.groupingBy(order -> order.getCreatedAt().toLocalDate()));

        List<DailyStatVO> daily = new ArrayList<>();
        for (int i = 0; i < TREND_DAYS; i++) {
            LocalDate date = start.plusDays(i);
            List<Order> dayOrders = grouped.getOrDefault(date, List.of());
            BigDecimal revenue = dayOrders.stream()
                    .filter(order -> PayStatus.PAID.getCode().equals(order.getPayStatus()))
                    .map(Order::getPayAmount)
                    .filter(amount -> amount != null)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);
            daily.add(new DailyStatVO(date, (long) dayOrders.size(), revenue));
        }
        return daily;
    }
}
