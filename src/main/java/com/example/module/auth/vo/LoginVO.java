package com.example.module.auth.vo;

import lombok.Data;

@Data
public class LoginVO {

    private Long userId;

    private String username;

    private String nickname;

    private String avatar;

    private String signature;

    private Integer role;

    private String token;

    private String tokenType;

    private Long expiresIn;
}
