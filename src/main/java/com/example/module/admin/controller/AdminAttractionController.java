package com.example.module.admin.controller;

import com.example.common.result.Result;
import com.example.module.content.entity.Attraction;
import com.example.module.content.entity.TicketType;
import com.example.module.content.service.AttractionService;
import com.example.module.content.service.TicketTypeService;
import com.example.module.content.vo.AttractionDetailVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Tag(name = "管理端-景点")
@RestController
@RequestMapping("/api/admin/attractions")
@RequiredArgsConstructor
public class AdminAttractionController {

    private final AttractionService attractionService;
    private final TicketTypeService ticketTypeService;

    @Operation(summary = "景点列表（含下线）")
    @GetMapping
    public Result<List<AttractionDetailVO>> list(@RequestParam(required = false) String keyword,
                                                 @RequestParam(required = false) String city) {
        return Result.success(attractionService.listAllForAdmin(keyword, city));
    }

    @Operation(summary = "新增景点")
    @PostMapping
    public Result<Long> create(@RequestBody Attraction attraction) {
        return Result.success(attractionService.create(attraction));
    }

    @Operation(summary = "修改景点")
    @PutMapping("/{id}")
    public Result<Void> update(@PathVariable Long id, @RequestBody Attraction attraction) {
        attraction.setId(id);
        attractionService.update(attraction);
        return Result.success();
    }

    @Operation(summary = "删除景点")
    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        attractionService.delete(id);
        return Result.success();
    }

    @Operation(summary = "新增票种")
    @PostMapping("/{attractionId}/ticket-types")
    public Result<Long> createTicketType(@PathVariable Long attractionId, @RequestBody TicketType ticketType) {
        ticketType.setAttractionId(attractionId);
        return Result.success(ticketTypeService.create(ticketType));
    }
}
