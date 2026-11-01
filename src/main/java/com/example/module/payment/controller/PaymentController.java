package com.example.module.payment.controller;

import com.example.common.result.Result;
import com.example.module.payment.dto.PaymentCallbackDTO;
import com.example.module.payment.service.PaymentService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Tag(name = "支付")
@RestController
@RequestMapping("/api/payments")
@RequiredArgsConstructor
public class PaymentController {

    private final PaymentService paymentService;

    @Operation(summary = "发起模拟支付")
    @PostMapping("/{orderNo}/pay")
    public Result<String> pay(@PathVariable String orderNo) {
        return Result.success(paymentService.pay(orderNo));
    }

    @Operation(summary = "模拟支付回调")
    @PostMapping("/callback")
    public Result<String> callback(@Valid @RequestBody PaymentCallbackDTO dto) {
        return Result.success(paymentService.handleCallback(dto));
    }
}
