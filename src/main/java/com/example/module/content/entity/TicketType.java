package com.example.module.content.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 票种表 ticket_type。
 */
@Data
@TableName("ticket_type")
public class TicketType {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long attractionId;

    private String name;

    private String description;

    private BigDecimal price;

    private BigDecimal originalPrice;

    /**
     * 每单限购数量
     */
    private Integer purchaseLimit;

    /**
     * 0-下架 1-在售 2-售罄
     */
    private Integer status;

    private Integer sort;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;
}
