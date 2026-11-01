package com.example.module.admin.controller;

import com.example.common.result.Result;
import com.example.module.ticket.dto.InventoryConfigDTO;
import com.example.module.ticket.entity.InventoryCalendar;
import com.example.module.ticket.service.InventoryService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;
import java.util.List;

@Tag(name = "管理端-库存")
@RestController
@RequestMapping("/api/admin/inventory")
@RequiredArgsConstructor
public class AdminInventoryController {

    private final InventoryService inventoryService;

    @Operation(summary = "库存日历列表")
    @GetMapping
    public Result<List<InventoryCalendar>> list(
            @RequestParam Long ticketTypeId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {
        return Result.success(inventoryService.listInventory(ticketTypeId, startDate, endDate));
    }

    @Operation(summary = "配置库存")
    @PutMapping
    public Result<Void> config(@Valid @RequestBody InventoryConfigDTO dto) {
        inventoryService.configInventory(dto);
        return Result.success();
    }
}
