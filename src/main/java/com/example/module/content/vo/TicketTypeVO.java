package com.example.module.content.vo;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class TicketTypeVO {

    private Long id;

    private Long attractionId;

    private String name;

    private String description;

    private BigDecimal price;

    private BigDecimal originalPrice;

    private Integer purchaseLimit;

    private Integer status;
}
