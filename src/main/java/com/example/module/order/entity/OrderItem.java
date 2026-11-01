package com.example.module.order.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 订单明细表 order_item。
 */
@Data
@TableName("order_item")
public class OrderItem {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long orderId;

    private Long ticketTypeId;

    /**
     * 下单时的票种名称快照
     */
    private String ticketName;

    private LocalDate visitDate;

    private BigDecimal unitPrice;

    private Integer quantity;

    private BigDecimal amount;

    private LocalDateTime createdAt;
}
