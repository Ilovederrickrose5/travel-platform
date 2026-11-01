package com.example.common.constant;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 票种状态。
 */
@Getter
@AllArgsConstructor
public enum TicketStatus {

    OFF_SALE(0, "已下架"),
    ON_SALE(1, "在售"),
    SOLD_OUT(2, "已售罄");

    private final Integer code;
    private final String desc;
}
