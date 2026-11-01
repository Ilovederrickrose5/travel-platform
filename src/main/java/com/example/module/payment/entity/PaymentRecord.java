package com.example.module.payment.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 支付流水表 payment_record。
 */
@Data
@TableName("payment_record")
public class PaymentRecord {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String paymentNo;

    private Long orderId;

    private String orderNo;

    private Long userId;

    private BigDecimal amount;

    private String payChannel;

    /**
     * 支付状态，见 PayStatus
     */
    private Integer status;

    /**
     * 第三方交易号
     */
    private String tradeNo;

    private LocalDateTime callbackTime;

    private String remark;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;
}
