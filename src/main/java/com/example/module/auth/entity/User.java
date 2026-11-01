package com.example.module.auth.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 用户表 app_user。
 */
@Data
@TableName("app_user")
public class User {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String username;

    private String password;

    private String nickname;

    private String phone;

    private String email;

    private String avatar;

    private String signature;

    private LocalDateTime usernameUpdatedAt;

    /**
     * 0-禁用 1-正常
     */
    private Integer status;

    /**
     * 0-普通游客 1-管理员
     */
    private Integer role;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;
}
