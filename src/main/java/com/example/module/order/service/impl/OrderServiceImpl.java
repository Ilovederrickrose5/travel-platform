package com.example.module.order.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.example.common.constant.CheckinStatus;
import com.example.common.constant.OrderStatus;
import com.example.common.constant.PayStatus;
import com.example.common.constant.TicketStatus;
import com.example.common.context.UserContext;
import com.example.common.exception.BizException;
import com.example.common.result.ResultCode;
import com.example.common.util.OrderNoGenerator;
import com.example.module.content.entity.TicketType;
import com.example.module.content.mapper.TicketTypeMapper;
import com.example.module.order.dto.CreateOrderDTO;
import com.example.module.order.entity.Order;
import com.example.module.order.entity.OrderItem;
import com.example.module.order.mapper.OrderItemMapper;
import com.example.module.order.mapper.OrderMapper;
import com.example.module.order.service.OrderService;
import com.example.module.order.vo.OrderDetailVO;
import com.example.module.order.vo.OrderItemVO;
import com.example.module.order.vo.OrderListVO;
import com.example.module.ticket.entity.InventoryCalendar;
import com.example.module.ticket.mapper.InventoryCalendarMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class OrderServiceImpl implements OrderService {

    private static final int ORDER_EXPIRE_MINUTES = 15;

    private final OrderMapper orderMapper;
    private final OrderItemMapper orderItemMapper;
    private final TicketTypeMapper ticketTypeMapper;
    private final InventoryCalendarMapper inventoryCalendarMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public OrderDetailVO create(CreateOrderDTO dto) {
        Long userId = UserContext.requireUserId();

        TicketType ticketType = ticketTypeMapper.selectById(dto.getTicketTypeId());
        if (ticketType == null || !TicketStatus.ON_SALE.getCode().equals(ticketType.getStatus())) {
            throw new BizException(ResultCode.TICKET_NOT_ON_SALE);
        }
        if (dto.getQuantity() > ticketType.getPurchaseLimit()) {
            throw new BizException(ResultCode.PURCHASE_LIMIT_EXCEEDED);
        }

        InventoryCalendar inventory = inventoryCalendarMapper.selectOne(new LambdaQueryWrapper<InventoryCalendar>()
                .eq(InventoryCalendar::getTicketTypeId, dto.getTicketTypeId())
                .eq(InventoryCalendar::getVisitDate, dto.getVisitDate()));
        if (inventory == null || !Integer.valueOf(1).equals(inventory.getStatus())) {
            throw new BizException(ResultCode.STOCK_NOT_ENOUGH.getCode(), "该日期暂未开放库存");
        }

        // 原子扣减，available_stock >= quantity 条件防超卖；影响 0 行即库存不足
        int deducted = inventoryCalendarMapper.deductStock(
                dto.getTicketTypeId(), dto.getVisitDate(), dto.getQuantity());
        if (deducted == 0) {
            throw new BizException(ResultCode.STOCK_NOT_ENOUGH);
        }

        BigDecimal unitPrice = ticketType.getPrice();
        BigDecimal amount = unitPrice.multiply(BigDecimal.valueOf(dto.getQuantity()));
        boolean free = amount.signum() == 0;
        LocalDateTime now = LocalDateTime.now();

        Order order = new Order();
        order.setOrderNo(OrderNoGenerator.generate());
        order.setUserId(userId);
        order.setTotalAmount(amount);
        order.setPayAmount(amount);
        // 免费预约票（如大明湖、洪崖洞）金额为 0，下单即确认，不再走支付
        order.setOrderStatus(free ? OrderStatus.PAID.getCode() : OrderStatus.PENDING_PAYMENT.getCode());
        order.setPayStatus(free ? PayStatus.PAID.getCode() : PayStatus.UNPAID.getCode());
        order.setPayTime(free ? now : null);
        order.setCheckinStatus(CheckinStatus.NOT_CHECKED_IN.getCode());
        order.setCheckedQuantity(0);
        order.setContactName(dto.getContactName());
        order.setContactPhone(dto.getContactPhone());
        order.setVisitDate(dto.getVisitDate());
        order.setExpireTime(now.plusMinutes(ORDER_EXPIRE_MINUTES));
        order.setRemark(dto.getRemark());
        orderMapper.insert(order);

        OrderItem item = new OrderItem();
        item.setOrderId(order.getId());
        item.setTicketTypeId(ticketType.getId());
        item.setTicketName(ticketType.getName());
        item.setVisitDate(dto.getVisitDate());
        item.setUnitPrice(unitPrice);
        item.setQuantity(dto.getQuantity());
        item.setAmount(amount);
        orderItemMapper.insert(item);

        return toDetailVO(order, List.of(item));
    }

    @Override
    public OrderDetailVO getByOrderNo(String orderNo) {
        Long userId = UserContext.requireUserId();
        Order order = findOrder(orderNo);
        if (!order.getUserId().equals(userId)) {
            throw new BizException(ResultCode.FORBIDDEN);
        }
        return toDetailVO(order, loadItems(order.getId()));
    }

    @Override
    public OrderDetailVO getAdminOrderDetail(String orderNo) {
        Order order = findOrder(orderNo);
        return toDetailVO(order, loadItems(order.getId()));
    }

    @Override
    public List<OrderListVO> listByUser() {
        Long userId = UserContext.requireUserId();
        List<Order> orders = orderMapper.selectList(new LambdaQueryWrapper<Order>()
                .eq(Order::getUserId, userId)
                .orderByDesc(Order::getId));
        return orders.stream().map(this::toListVO).toList();
    }

    @Override
    public List<OrderListVO> listAll(Integer orderStatus) {
        List<Order> orders = orderMapper.selectList(new LambdaQueryWrapper<Order>()
                .eq(orderStatus != null, Order::getOrderStatus, orderStatus)
                .orderByDesc(Order::getId));
        return orders.stream().map(this::toListVO).toList();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void cancel(String orderNo) {
        Long userId = UserContext.requireUserId();
        Order order = findOrder(orderNo);
        if (!order.getUserId().equals(userId)) {
            throw new BizException(ResultCode.FORBIDDEN);
        }
        doCancel(order);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void close(String orderNo) {
        doCancel(findOrder(orderNo));
    }

    /**
     * 取消/关闭订单：条件更新只允许「待支付 → 已取消」，再回滚库存。
     */
    private void doCancel(Order order) {
        int updated = orderMapper.update(null, new LambdaUpdateWrapper<Order>()
                .eq(Order::getId, order.getId())
                .eq(Order::getOrderStatus, OrderStatus.PENDING_PAYMENT.getCode())
                .set(Order::getOrderStatus, OrderStatus.CANCELLED.getCode())
                .set(Order::getCancelTime, LocalDateTime.now()));
        if (updated == 0) {
            throw new BizException(ResultCode.ORDER_STATUS_INVALID);
        }

        List<OrderItem> items = loadItems(order.getId());
        for (OrderItem item : items) {
            int restored = inventoryCalendarMapper.restoreStock(
                    item.getTicketTypeId(), item.getVisitDate(), item.getQuantity());
            if (restored == 0) {
                throw new BizException(ResultCode.INTERNAL_ERROR.getCode(),
                        "库存回滚失败，订单已标记取消，请人工核查库存: orderNo=" + order.getOrderNo());
            }
        }
    }

    private Order findOrder(String orderNo) {
        Order order = orderMapper.selectOne(new LambdaQueryWrapper<Order>()
                .eq(Order::getOrderNo, orderNo));
        if (order == null) {
            throw new BizException(ResultCode.ORDER_NOT_FOUND);
        }
        return order;
    }

    private List<OrderItem> loadItems(Long orderId) {
        return orderItemMapper.selectList(new LambdaQueryWrapper<OrderItem>()
                .eq(OrderItem::getOrderId, orderId));
    }

    private OrderListVO toListVO(Order order) {
        OrderListVO vo = new OrderListVO();
        BeanUtils.copyProperties(order, vo);
        return vo;
    }

    private OrderDetailVO toDetailVO(Order order, List<OrderItem> items) {
        OrderDetailVO vo = new OrderDetailVO();
        BeanUtils.copyProperties(order, vo);
        vo.setItems(items.stream().map(this::toItemVO).toList());
        return vo;
    }

    private OrderItemVO toItemVO(OrderItem item) {
        OrderItemVO vo = new OrderItemVO();
        BeanUtils.copyProperties(item, vo);
        return vo;
    }
}
