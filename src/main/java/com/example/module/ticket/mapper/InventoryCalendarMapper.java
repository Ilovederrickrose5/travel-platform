package com.example.module.ticket.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.example.module.ticket.entity.InventoryCalendar;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Update;

import java.time.LocalDate;

@Mapper
public interface InventoryCalendarMapper extends BaseMapper<InventoryCalendar> {

    /**
     * 原子扣减库存，available_stock >= quantity 作为条件，防超卖。
     * 返回影响行数，0 表示库存不足。
     */
    @Update("UPDATE inventory_calendar " +
            "SET sold_stock = sold_stock + #{quantity}, available_stock = available_stock - #{quantity} " +
            "WHERE ticket_type_id = #{ticketTypeId} AND visit_date = #{visitDate} " +
            "AND status = 1 AND available_stock >= #{quantity}")
    int deductStock(@Param("ticketTypeId") Long ticketTypeId,
                    @Param("visitDate") LocalDate visitDate,
                    @Param("quantity") int quantity);

    /**
     * 回滚库存，sold_stock >= quantity 作为条件，防止回滚导致已售为负。
     */
    @Update("UPDATE inventory_calendar " +
            "SET sold_stock = sold_stock - #{quantity}, available_stock = available_stock + #{quantity} " +
            "WHERE ticket_type_id = #{ticketTypeId} AND visit_date = #{visitDate} " +
            "AND sold_stock >= #{quantity}")
    int restoreStock(@Param("ticketTypeId") Long ticketTypeId,
                     @Param("visitDate") LocalDate visitDate,
                     @Param("quantity") int quantity);
}
