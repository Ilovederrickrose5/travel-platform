package com.example.module.content.controller;

import com.example.common.result.Result;
import com.example.module.content.service.TicketTypeService;
import com.example.module.content.vo.TicketTypeVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Tag(name = "票种")
@RestController
@RequestMapping("/api/ticket-types")
@RequiredArgsConstructor
public class TicketTypeController {

    private final TicketTypeService ticketTypeService;

    @Operation(summary = "按景点查询票种")
    @GetMapping
    public Result<List<TicketTypeVO>> list(@RequestParam Long attractionId) {
        return Result.success(ticketTypeService.listByAttractionId(attractionId));
    }

    @Operation(summary = "票种详情")
    @GetMapping("/{id}")
    public Result<TicketTypeVO> detail(@PathVariable Long id) {
        return Result.success(ticketTypeService.getDetail(id));
    }
}
