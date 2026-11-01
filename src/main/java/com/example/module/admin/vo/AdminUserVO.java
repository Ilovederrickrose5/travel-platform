package com.example.module.admin.vo;

import lombok.Data;

import java.time.LocalDateTime;

/**
 * 管理端游客账号视图。
 */
@Data
public class AdminUserVO {

    private Long id;

    private String username;

    private String nickname;

    private String phone;

    private String email;

    /**
     * 0-禁用 1-正常
     */
    private Integer status;

    private LocalDateTime createdAt;
}
