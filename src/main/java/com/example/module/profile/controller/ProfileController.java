package com.example.module.profile.controller;

import com.example.common.context.UserContext;
import com.example.common.result.Result;
import com.example.module.profile.dto.ChangePasswordDTO;
import com.example.module.profile.dto.ChangeUsernameDTO;
import com.example.module.profile.dto.UpdateProfileDTO;
import com.example.module.profile.service.ProfileService;
import com.example.module.profile.vo.ProfileVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@Tag(name = "游客个人中心")
@RestController
@RequestMapping("/api/profile")
@RequiredArgsConstructor
public class ProfileController {

    private final ProfileService profileService;

    @Operation(summary = "获取个人资料")
    @GetMapping
    public Result<ProfileVO> getProfile() {
        return Result.success(profileService.getProfile(UserContext.requireUserId()));
    }

    @Operation(summary = "更新基本资料")
    @PutMapping
    public Result<ProfileVO> updateProfile(@Valid @RequestBody UpdateProfileDTO dto) {
        return Result.success(profileService.updateProfile(UserContext.requireUserId(), dto));
    }

    @Operation(summary = "上传头像")
    @PostMapping("/avatar")
    public Result<ProfileVO> uploadAvatar(@RequestParam("file") MultipartFile file) {
        return Result.success(profileService.uploadAvatar(UserContext.requireUserId(), file));
    }

    @Operation(summary = "修改密码")
    @PutMapping("/password")
    public Result<Void> changePassword(@Valid @RequestBody ChangePasswordDTO dto) {
        profileService.changePassword(UserContext.requireUserId(), dto);
        return Result.success();
    }

    @Operation(summary = "修改登录账号")
    @PutMapping("/username")
    public Result<ProfileVO> changeUsername(@Valid @RequestBody ChangeUsernameDTO dto) {
        return Result.success(profileService.changeUsername(UserContext.requireUserId(), dto));
    }
}
