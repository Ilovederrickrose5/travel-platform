package com.example.module.ticket.controller;

import com.example.common.result.Result;
import com.example.module.ticket.entity.InventoryCalendar;
import com.example.module.ticket.service.InventoryService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;

@Tag(name = "分时库存")
@RestController
@RequestMapping("/api/inventory")
@RequiredArgsConstructor
public class InventoryController {

    private final InventoryService inventoryService;

    @Operation(summary = "查询指定日期库存")
    @GetMapping
    public Result<InventoryCalendar> getInventory(@RequestParam Long ticketTypeId,
                                                  @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate visitDate) {
        return Result.success(inventoryService.getInventory(ticketTypeId, visitDate));
    }
}
