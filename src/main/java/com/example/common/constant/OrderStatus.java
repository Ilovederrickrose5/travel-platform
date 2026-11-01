package com.example.common.constant;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 订单状态。
 */
@Getter
@AllArgsConstructor
public enum OrderStatus {

    PENDING_PAYMENT(0, "待支付"),
    PAID(10, "已支付"),
    CANCELLED(20, "已取消"),
    COMPLETED(30, "已完成"),
    REFUNDING(40, "退款中"),
    REFUNDED(50, "已退款");

    private final Integer code;
    private final String desc;
}
