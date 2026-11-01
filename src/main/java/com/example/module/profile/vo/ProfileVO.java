package com.example.module.profile.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ProfileVO {

    private Long userId;

    private String username;

    private String nickname;

    private String avatar;

    private String signature;

    private String phone;

    private String email;

    private LocalDateTime usernameUpdatedAt;

    private LocalDateTime createdAt;
}
