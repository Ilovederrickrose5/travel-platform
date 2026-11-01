package com.example.module.admin.controller;

import com.example.common.result.Result;
import com.example.module.order.service.OrderService;
import com.example.module.order.vo.OrderDetailVO;
import com.example.module.order.vo.OrderListVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Tag(name = "管理端-订单")
@RestController
@RequestMapping("/api/admin/orders")
@RequiredArgsConstructor
public class AdminOrderController {

    private final OrderService orderService;

    @Operation(summary = "订单列表")
    @GetMapping
    public Result<List<OrderListVO>> list(@RequestParam(required = false) Integer orderStatus) {
        return Result.success(orderService.listAll(orderStatus));
    }

    @Operation(summary = "订单详情")
    @GetMapping("/{orderNo}")
    public Result<OrderDetailVO> detail(@PathVariable String orderNo) {
        return Result.success(orderService.getAdminOrderDetail(orderNo));
    }

    @Operation(summary = "关闭订单")
    @PostMapping("/{orderNo}/close")
    public Result<Void> close(@PathVariable String orderNo) {
        orderService.close(orderNo);
        return Result.success();
    }
}
