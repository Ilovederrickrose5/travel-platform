package com.example.module.admin.controller;

import com.example.common.result.Result;
import com.example.module.content.entity.TicketType;
import com.example.module.content.service.TicketTypeService;
import com.example.module.content.vo.TicketTypeVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Tag(name = "管理端-票种")
@RestController
@RequestMapping("/api/admin/ticket-types")
@RequiredArgsConstructor
public class AdminTicketTypeController {

    private final TicketTypeService ticketTypeService;

    @Operation(summary = "景点下全部票种（含下架）")
    @GetMapping
    public Result<List<TicketTypeVO>> list(@RequestParam Long attractionId) {
        return Result.success(ticketTypeService.listByAttractionIdForAdmin(attractionId));
    }

    @Operation(summary = "修改票种")
    @PutMapping("/{id}")
    public Result<Void> update(@PathVariable Long id, @RequestBody TicketType ticketType) {
        ticketType.setId(id);
        ticketTypeService.update(ticketType);
        return Result.success();
    }

    @Operation(summary = "删除票种")
    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        ticketTypeService.delete(id);
        return Result.success();
    }
}
