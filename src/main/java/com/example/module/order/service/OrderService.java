package com.example.module.order.service;

import com.example.module.order.dto.CreateOrderDTO;
import com.example.module.order.vo.OrderDetailVO;
import com.example.module.order.vo.OrderListVO;

import java.util.List;

public interface OrderService {

    /**
     * 当前登录用户下单，原子扣减库存并生成订单。
     */
    OrderDetailVO create(CreateOrderDTO dto);

    /**
     * 当前登录用户查询自己的订单详情。
     */
    OrderDetailVO getByOrderNo(String orderNo);

    /**
     * 管理端查询任意订单详情。
     */
    OrderDetailVO getAdminOrderDetail(String orderNo);

    /**
     * 当前登录用户的订单列表。
     */
    List<OrderListVO> listByUser();

    /**
     * 管理端订单列表。
     */
    List<OrderListVO> listAll(Integer orderStatus);

    /**
     * 当前登录用户取消自己的订单并回滚库存。
     */
    void cancel(String orderNo);

    /**
     * 管理端关闭订单并回滚库存。
     */
    void close(String orderNo);
}
