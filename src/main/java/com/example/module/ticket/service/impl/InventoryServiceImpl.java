package com.example.module.ticket.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.example.common.exception.BizException;
import com.example.common.result.ResultCode;
import com.example.module.content.mapper.TicketTypeMapper;
import com.example.module.ticket.dto.InventoryConfigDTO;
import com.example.module.ticket.entity.InventoryCalendar;
import com.example.module.ticket.mapper.InventoryCalendarMapper;
import com.example.module.ticket.service.InventoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
public class InventoryServiceImpl implements InventoryService {

    private final InventoryCalendarMapper inventoryCalendarMapper;
    private final TicketTypeMapper ticketTypeMapper;

    @Override
    public InventoryCalendar getInventory(Long ticketTypeId, LocalDate visitDate) {
        return inventoryCalendarMapper.selectOne(new LambdaQueryWrapper<InventoryCalendar>()
                .eq(InventoryCalendar::getTicketTypeId, ticketTypeId)
                .eq(InventoryCalendar::getVisitDate, visitDate));
    }

    @Override
    public List<InventoryCalendar> listInventory(Long ticketTypeId, LocalDate startDate, LocalDate endDate) {
        if (startDate == null || endDate == null) {
            throw new BizException(ResultCode.PARAM_INVALID.getCode(), "日期区间不能为空");
        }
        if (startDate.isAfter(endDate)) {
            throw new BizException(ResultCode.PARAM_INVALID.getCode(), "开始日期不能晚于结束日期");
        }
        return inventoryCalendarMapper.selectList(new LambdaQueryWrapper<InventoryCalendar>()
                .eq(InventoryCalendar::getTicketTypeId, ticketTypeId)
                .between(InventoryCalendar::getVisitDate, startDate, endDate)
                .orderByAsc(InventoryCalendar::getVisitDate));
    }

    @Override
    public void configInventory(InventoryConfigDTO dto) {
        if (ticketTypeMapper.selectById(dto.getTicketTypeId()) == null) {
            throw new BizException(ResultCode.NOT_FOUND.getCode(), "票种不存在");
        }
        InventoryCalendar existing = getInventory(dto.getTicketTypeId(), dto.getVisitDate());
        if (existing != null) {
            applyConfig(existing, dto);
            return;
        }
        InventoryCalendar calendar = new InventoryCalendar();
        calendar.setTicketTypeId(dto.getTicketTypeId());
        calendar.setVisitDate(dto.getVisitDate());
        calendar.setSoldStock(0);
        calendar.setTotalStock(dto.getTotalStock());
        calendar.setAvailableStock(dto.getTotalStock());
        calendar.setStatus(dto.getStatus() == null ? 1 : dto.getStatus());
        calendar.setVersion(0);
        try {
            inventoryCalendarMapper.insert(calendar);
        } catch (DuplicateKeyException e) {
            // 并发配置同一天时唯一键冲突，退化为更新已有记录
            applyConfig(getInventory(dto.getTicketTypeId(), dto.getVisitDate()), dto);
        }
    }

    private void applyConfig(InventoryCalendar existing, InventoryConfigDTO dto) {
        int soldStock = existing.getSoldStock() == null ? 0 : existing.getSoldStock();
        if (dto.getTotalStock() < soldStock) {
            throw new BizException(ResultCode.PARAM_INVALID.getCode(),
                    "总库存不能小于已售数量（已售 " + soldStock + "）");
        }
        existing.setTotalStock(dto.getTotalStock());
        existing.setAvailableStock(dto.getTotalStock() - soldStock);
        if (dto.getStatus() != null) {
            existing.setStatus(dto.getStatus());
        }
        inventoryCalendarMapper.updateById(existing);
    }
}
