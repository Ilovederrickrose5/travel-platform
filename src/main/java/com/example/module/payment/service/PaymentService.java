package com.example.module.payment.service;

import com.example.module.payment.dto.PaymentCallbackDTO;

public interface PaymentService {

    /**
     * 发起模拟支付，返回支付单号（或支付跳转地址）。
     */
    String pay(String orderNo);

    /**
     * 处理支付回调，需保证幂等。
     */
    String handleCallback(PaymentCallbackDTO dto);
}
