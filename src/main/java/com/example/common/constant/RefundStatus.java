package com.example.common.constant;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 退款状态。
 */
@Getter
@AllArgsConstructor
public enum RefundStatus {

    NONE(0, "无退款"),
    APPLIED(1, "退款申请中"),
    APPROVED(2, "退款已通过"),
    REJECTED(3, "退款已拒绝"),
    REFUNDED(4, "已退款");

    private final Integer code;
    private final String desc;
}
