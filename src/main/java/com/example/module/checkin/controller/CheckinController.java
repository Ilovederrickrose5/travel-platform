package com.example.module.checkin.controller;

import com.example.common.result.Result;
import com.example.module.checkin.dto.CheckinDTO;
import com.example.module.checkin.service.CheckinService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Tag(name = "管理端-核销")
@RestController
@RequestMapping("/api/admin/checkin")
@RequiredArgsConstructor
public class CheckinController {

    private final CheckinService checkinService;

    @Operation(summary = "订单核销")
    @PostMapping
    public Result<Void> checkin(@Valid @RequestBody CheckinDTO dto) {
        checkinService.checkin(dto);
        return Result.success();
    }

    @Operation(summary = "查询核销状态")
    @GetMapping("/{orderNo}/status")
    public Result<Boolean> status(@PathVariable String orderNo) {
        return Result.success(checkinService.isCheckedIn(orderNo));
    }
}
