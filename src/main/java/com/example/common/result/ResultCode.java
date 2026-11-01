package com.example.common.result;

import lombok.Getter;

/**
 * 统一响应码。
 */
@Getter
public enum ResultCode {

    SUCCESS(200, "操作成功"),
    BAD_REQUEST(400, "请求参数错误"),
    UNAUTHORIZED(401, "未登录或登录已过期"),
    FORBIDDEN(403, "没有操作权限"),
    NOT_FOUND(404, "资源不存在"),
    INTERNAL_ERROR(500, "系统内部错误"),

    BIZ_ERROR(1000, "业务处理失败"),
    PARAM_INVALID(1001, "参数校验失败"),
    STOCK_NOT_ENOUGH(1002, "库存不足"),
    PURCHASE_LIMIT_EXCEEDED(1003, "超过限购数量"),
    TICKET_NOT_ON_SALE(1004, "票种未开售"),

    ORDER_NOT_FOUND(2001, "订单不存在"),
    ORDER_STATUS_INVALID(2002, "订单状态不允许该操作"),
    ORDER_EXPIRED(2003, "订单已超时关闭"),

    PAYMENT_FAILED(3001, "支付失败"),
    PAYMENT_DUPLICATED(3002, "支付回调已处理"),

    CHECKIN_FAILED(4001, "核销失败"),
    CHECKIN_DUPLICATED(4002, "该凭证已核销");

    private final Integer code;
    private final String message;

    ResultCode(Integer code, String message) {
        this.code = code;
        this.message = message;
    }
}
