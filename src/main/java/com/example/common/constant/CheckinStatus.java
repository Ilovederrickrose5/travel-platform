package com.example.common.constant;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 核销状态。
 */
@Getter
@AllArgsConstructor
public enum CheckinStatus {

    NOT_CHECKED_IN(0, "未核销"),
    CHECKED_IN(1, "已核销");

    private final Integer code;
    private final String desc;
}
