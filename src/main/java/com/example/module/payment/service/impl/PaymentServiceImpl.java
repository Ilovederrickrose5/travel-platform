package com.example.module.payment.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.example.common.constant.OrderStatus;
import com.example.common.constant.PayStatus;
import com.example.common.context.UserContext;
import com.example.common.exception.BizException;
import com.example.common.result.ResultCode;
import com.example.module.order.entity.Order;
import com.example.module.order.mapper.OrderMapper;
import com.example.module.payment.dto.PaymentCallbackDTO;
import com.example.module.payment.entity.PaymentRecord;
import com.example.module.payment.mapper.PaymentRecordMapper;
import com.example.module.payment.service.PaymentService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.concurrent.ThreadLocalRandom;

@Slf4j
@Service
@RequiredArgsConstructor
public class PaymentServiceImpl implements PaymentService {

    private static final String MOCK_CHANNEL = "MOCK";
    private static final DateTimeFormatter PAYMENT_NO_FORMATTER =
            DateTimeFormatter.ofPattern("yyyyMMddHHmmssSSS");

    private final PaymentRecordMapper paymentRecordMapper;
    private final OrderMapper orderMapper;

    @Override
    public String pay(String orderNo) {
        Order order = findOrder(orderNo);
        if (!order.getUserId().equals(UserContext.requireUserId())) {
            throw new BizException(ResultCode.FORBIDDEN);
        }
        if (!OrderStatus.PENDING_PAYMENT.getCode().equals(order.getOrderStatus())
                || !PayStatus.UNPAID.getCode().equals(order.getPayStatus())) {
            throw new BizException(ResultCode.ORDER_STATUS_INVALID);
        }
        if (order.getExpireTime() != null && order.getExpireTime().isBefore(LocalDateTime.now())) {
            throw new BizException(ResultCode.ORDER_EXPIRED);
        }

        PaymentRecord existing = paymentRecordMapper.selectOne(new LambdaQueryWrapper<PaymentRecord>()
                .eq(PaymentRecord::getOrderId, order.getId())
                .eq(PaymentRecord::getStatus, PayStatus.UNPAID.getCode())
                .orderByDesc(PaymentRecord::getId)
                .last("LIMIT 1"));
        if (existing != null) {
            return existing.getPaymentNo();
        }

        PaymentRecord record = new PaymentRecord();
        record.setPaymentNo(generatePaymentNo());
        record.setOrderId(order.getId());
        record.setOrderNo(order.getOrderNo());
        record.setUserId(order.getUserId());
        record.setAmount(order.getPayAmount());
        record.setPayChannel(MOCK_CHANNEL);
        record.setStatus(PayStatus.UNPAID.getCode());
        paymentRecordMapper.insert(record);
        return record.getPaymentNo();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public String handleCallback(PaymentCallbackDTO dto) {
        PaymentRecord record = paymentRecordMapper.selectOne(new LambdaQueryWrapper<PaymentRecord>()
                .eq(PaymentRecord::getPaymentNo, dto.getPaymentNo()));
        if (record == null) {
            throw new BizException(ResultCode.PAYMENT_FAILED.getCode(), "支付单不存在");
        }
        if (!record.getOrderNo().equals(dto.getOrderNo())) {
            throw new BizException(ResultCode.PAYMENT_FAILED.getCode(), "支付单与订单不匹配");
        }
        if (dto.getAmount() == null || dto.getAmount().compareTo(record.getAmount()) != 0) {
            throw new BizException(ResultCode.PAYMENT_FAILED.getCode(), "支付金额与订单应付金额不一致");
        }

        LocalDateTime callbackTime = dto.getCallbackTime() == null ? LocalDateTime.now() : dto.getCallbackTime();
        if (!PayStatus.PAID.getCode().equals(dto.getStatus())) {
            markFailed(record, dto, callbackTime);
            return "FAILED";
        }

        // 以「支付单未处理」为条件更新，重复回调时影响行数为 0，直接幂等返回
        int updated = paymentRecordMapper.update(null, new LambdaUpdateWrapper<PaymentRecord>()
                .eq(PaymentRecord::getId, record.getId())
                .eq(PaymentRecord::getStatus, PayStatus.UNPAID.getCode())
                .set(PaymentRecord::getStatus, PayStatus.PAID.getCode())
                .set(PaymentRecord::getTradeNo, dto.getTradeNo())
                .set(PaymentRecord::getCallbackTime, callbackTime));
        if (updated == 0) {
            log.info("重复支付回调，已幂等忽略: paymentNo={}", dto.getPaymentNo());
            return "SUCCESS";
        }

        int orderUpdated = orderMapper.update(null, new LambdaUpdateWrapper<Order>()
                .eq(Order::getId, record.getOrderId())
                .eq(Order::getOrderStatus, OrderStatus.PENDING_PAYMENT.getCode())
                .eq(Order::getPayStatus, PayStatus.UNPAID.getCode())
                .set(Order::getOrderStatus, OrderStatus.PAID.getCode())
                .set(Order::getPayStatus, PayStatus.PAID.getCode())
                .set(Order::getPayTime, callbackTime));
        if (orderUpdated == 0) {
            log.warn("支付成功但订单状态不是待支付，需人工核查: orderNo={}, paymentNo={}",
                    record.getOrderNo(), record.getPaymentNo());
        }
        return "SUCCESS";
    }

    private void markFailed(PaymentRecord record, PaymentCallbackDTO dto, LocalDateTime callbackTime) {
        paymentRecordMapper.update(null, new LambdaUpdateWrapper<PaymentRecord>()
                .eq(PaymentRecord::getId, record.getId())
                .eq(PaymentRecord::getStatus, PayStatus.UNPAID.getCode())
                .set(PaymentRecord::getStatus, PayStatus.FAILED.getCode())
                .set(PaymentRecord::getTradeNo, dto.getTradeNo())
                .set(PaymentRecord::getCallbackTime, callbackTime));
    }

    private Order findOrder(String orderNo) {
        Order order = orderMapper.selectOne(new LambdaQueryWrapper<Order>()
                .eq(Order::getOrderNo, orderNo));
        if (order == null) {
            throw new BizException(ResultCode.ORDER_NOT_FOUND);
        }
        return order;
    }

    private String generatePaymentNo() {
        return "P"
                + LocalDateTime.now().format(PAYMENT_NO_FORMATTER)
                + String.format("%06d", ThreadLocalRandom.current().nextInt(1_000_000));
    }
}
