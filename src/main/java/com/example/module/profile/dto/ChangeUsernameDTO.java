package com.example.module.profile.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class ChangeUsernameDTO {

    @NotBlank(message = "请输入新登录账号")
    private String username;

    @NotBlank(message = "请输入当前密码")
    private String password;
}
