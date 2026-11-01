package com.example.module.admin.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.util.List;

@Data
public class DashboardStatsVO {

    private Long attractionCount;

    private Long onlineAttractionCount;

    private Long ticketTypeCount;

    private Long orderCount;

    private Long todayOrderCount;

    private Long checkedOrderCount;

    private Long checkedQuantity;

    private BigDecimal revenue;

    private List<DailyStatVO> daily;
}
