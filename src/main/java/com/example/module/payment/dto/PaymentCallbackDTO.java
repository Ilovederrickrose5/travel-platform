package com.example.module.payment.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class PaymentCallbackDTO {

    @NotBlank(message = "支付单号不能为空")
    private String paymentNo;

    @NotBlank(message = "订单号不能为空")
    private String orderNo;

    @NotBlank(message = "第三方交易号不能为空")
    private String tradeNo;

    @NotNull(message = "支付金额不能为空")
    private BigDecimal amount;

    @NotNull(message = "支付状态不能为空")
    private Integer status;

    private LocalDateTime callbackTime;

    private String sign;
}
