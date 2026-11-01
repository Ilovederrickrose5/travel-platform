package com.example.module.order.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.example.module.order.entity.OrderItem;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface OrderItemMapper extends BaseMapper<OrderItem> {
}
