package com.example.module.order.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class OrderDetailVO {

    private String orderNo;

    private Integer orderStatus;

    private Integer payStatus;

    private Integer checkinStatus;

    private Integer checkedQuantity;

    private BigDecimal totalAmount;

    private BigDecimal payAmount;

    private String contactName;

    private String contactPhone;

    private LocalDate visitDate;

    private LocalDateTime expireTime;

    private LocalDateTime payTime;

    private LocalDateTime createdAt;

    private List<OrderItemVO> items;
}
