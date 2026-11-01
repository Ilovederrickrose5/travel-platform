package com.example.module.admin.controller;

import com.example.common.result.Result;
import com.example.module.admin.service.AdminUserService;
import com.example.module.admin.vo.AdminUserVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Tag(name = "管理端-游客账号")
@RestController
@RequestMapping("/api/admin/users")
@RequiredArgsConstructor
public class AdminUserController {

    private final AdminUserService adminUserService;

    @Operation(summary = "游客账号列表")
    @GetMapping
    public Result<List<AdminUserVO>> list(@RequestParam(required = false) String keyword,
                                          @RequestParam(required = false) Integer status) {
        return Result.success(adminUserService.listVisitors(keyword, status));
    }

    @Operation(summary = "启用/禁用游客账号")
    @PutMapping("/{id}/status")
    public Result<Void> updateStatus(@PathVariable Long id, @RequestParam Integer status) {
        adminUserService.updateStatus(id, status);
        return Result.success();
    }

    @Operation(summary = "重置游客密码")
    @PostMapping("/{id}/reset-password")
    public Result<String> resetPassword(@PathVariable Long id) {
        return Result.success(adminUserService.resetPassword(id));
    }
}
