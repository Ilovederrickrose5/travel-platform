package com.example.module.order.controller;

import com.example.common.result.Result;
import com.example.module.order.dto.CreateOrderDTO;
import com.example.module.order.service.OrderService;
import com.example.module.order.vo.OrderDetailVO;
import com.example.module.order.vo.OrderListVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Tag(name = "订单")
@RestController
@RequestMapping("/api/orders")
@RequiredArgsConstructor
public class OrderController {

    private final OrderService orderService;

    @Operation(summary = "创建订单")
    @PostMapping
    public Result<OrderDetailVO> create(@Valid @RequestBody CreateOrderDTO dto) {
        return Result.success(orderService.create(dto));
    }

    @Operation(summary = "我的订单列表")
    @GetMapping
    public Result<List<OrderListVO>> list() {
        return Result.success(orderService.listByUser());
    }

    @Operation(summary = "订单详情")
    @GetMapping("/{orderNo}")
    public Result<OrderDetailVO> detail(@PathVariable String orderNo) {
        return Result.success(orderService.getByOrderNo(orderNo));
    }

    @Operation(summary = "取消订单")
    @PostMapping("/{orderNo}/cancel")
    public Result<Void> cancel(@PathVariable String orderNo) {
        orderService.cancel(orderNo);
        return Result.success();
    }
}
