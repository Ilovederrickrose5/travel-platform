package com.example.common.constant;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 支付状态。
 */
@Getter
@AllArgsConstructor
public enum PayStatus {

    UNPAID(0, "未支付"),
    PAID(1, "已支付"),
    REFUNDED(2, "已退款"),
    FAILED(3, "支付失败");

    private final Integer code;
    private final String desc;
}
