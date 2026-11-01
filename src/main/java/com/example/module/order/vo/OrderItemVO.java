package com.example.module.order.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class OrderItemVO {

    private Long ticketTypeId;

    private String ticketName;

    private LocalDate visitDate;

    private BigDecimal unitPrice;

    private Integer quantity;

    private BigDecimal amount;
}
