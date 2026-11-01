package com.example.module.ticket.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.annotation.Version;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 分时库存日历表 inventory_calendar。
 */
@Data
@TableName("inventory_calendar")
public class InventoryCalendar {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long ticketTypeId;

    private LocalDate visitDate;

    private Integer totalStock;

    private Integer soldStock;

    private Integer availableStock;

    /**
     * 0-关闭 1-开放
     */
    private Integer status;

    @Version
    private Integer version;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;
}
