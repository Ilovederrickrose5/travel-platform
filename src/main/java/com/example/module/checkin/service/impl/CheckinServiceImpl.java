package com.example.module.checkin.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.example.common.constant.CheckinStatus;
import com.example.common.constant.OrderStatus;
import com.example.common.exception.BizException;
import com.example.common.result.ResultCode;
import com.example.module.checkin.dto.CheckinDTO;
import com.example.module.checkin.service.CheckinService;
import com.example.module.order.entity.Order;
import com.example.module.order.entity.OrderItem;
import com.example.module.order.mapper.OrderItemMapper;
import com.example.module.order.mapper.OrderMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CheckinServiceImpl implements CheckinService {

    private final OrderMapper orderMapper;
    private final OrderItemMapper orderItemMapper;

    @Override
    public void checkin(CheckinDTO dto) {
        if (dto.getQuantity() == null || dto.getQuantity() <= 0) {
            throw new BizException(ResultCode.PARAM_INVALID.getCode(), "核销数量必须大于 0");
        }
        Order order = findByOrderNo(dto.getOrderNo());
        if (!OrderStatus.PAID.getCode().equals(order.getOrderStatus())) {
            throw new BizException(ResultCode.ORDER_STATUS_INVALID);
        }
        if (CheckinStatus.CHECKED_IN.getCode().equals(order.getCheckinStatus())) {
            throw new BizException(ResultCode.CHECKIN_DUPLICATED);
        }

        int totalQuantity = totalQuantity(order.getId());
        int checkedQuantity = order.getCheckedQuantity() == null ? 0 : order.getCheckedQuantity();
        int remaining = totalQuantity - checkedQuantity;
        if (dto.getQuantity() > remaining) {
            throw new BizException(ResultCode.CHECKIN_FAILED.getCode(),
                    "核销数量超过可核销上限（剩余 " + remaining + "）");
        }

        int newCheckedQuantity = checkedQuantity + dto.getQuantity();
        Integer newStatus = newCheckedQuantity >= totalQuantity
                ? CheckinStatus.CHECKED_IN.getCode()
                : CheckinStatus.NOT_CHECKED_IN.getCode();
        // 以已核销数量做条件更新，避免并发重复核销
        int updated = orderMapper.update(null, new LambdaUpdateWrapper<Order>()
                .eq(Order::getId, order.getId())
                .eq(Order::getCheckinStatus, CheckinStatus.NOT_CHECKED_IN.getCode())
                .eq(Order::getCheckedQuantity, checkedQuantity)
                .set(Order::getCheckedQuantity, newCheckedQuantity)
                .set(Order::getCheckinStatus, newStatus));
        if (updated == 0) {
            throw new BizException(ResultCode.CHECKIN_FAILED.getCode(), "核销冲突，请重试");
        }
    }

    @Override
    public boolean isCheckedIn(String orderNo) {
        return CheckinStatus.CHECKED_IN.getCode().equals(findByOrderNo(orderNo).getCheckinStatus());
    }

    private Order findByOrderNo(String orderNo) {
        Order order = orderMapper.selectOne(new LambdaQueryWrapper<Order>()
                .eq(Order::getOrderNo, orderNo));
        if (order == null) {
            throw new BizException(ResultCode.ORDER_NOT_FOUND);
        }
        return order;
    }

    private int totalQuantity(Long orderId) {
        List<OrderItem> items = orderItemMapper.selectList(new LambdaQueryWrapper<OrderItem>()
                .eq(OrderItem::getOrderId, orderId));
        return items.stream()
                .mapToInt(item -> item.getQuantity() == null ? 0 : item.getQuantity())
                .sum();
    }
}
