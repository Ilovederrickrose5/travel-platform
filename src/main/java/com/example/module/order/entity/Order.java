package com.example.module.order.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 订单主表 orders。
 */
@Data
@TableName("orders")
public class Order {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String orderNo;

    private Long userId;

    private BigDecimal totalAmount;

    private BigDecimal payAmount;

    private Integer orderStatus;

    private Integer payStatus;

    /**
     * 核销状态，见 CheckinStatus
     */
    private Integer checkinStatus;

    /**
     * 已核销数量
     */
    private Integer checkedQuantity;

    private String contactName;

    private String contactPhone;

    private LocalDate visitDate;

    /**
     * 支付超时时间，用于超时关单
     */
    private LocalDateTime expireTime;

    private LocalDateTime payTime;

    private LocalDateTime cancelTime;

    private String remark;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;
}
