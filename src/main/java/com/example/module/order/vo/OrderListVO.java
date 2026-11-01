package com.example.module.order.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class OrderListVO {

    private String orderNo;

    private Integer orderStatus;

    private Integer payStatus;

    private Integer checkinStatus;

    private Integer checkedQuantity;

    private BigDecimal totalAmount;

    private LocalDate visitDate;

    private LocalDateTime createdAt;
}
