package com.example.module.auth.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.example.common.exception.BizException;
import com.example.common.result.ResultCode;
import com.example.common.util.JwtUtil;
import com.example.common.util.PasswordUtil;
import com.example.module.auth.dto.LoginDTO;
import com.example.module.auth.dto.RegisterDTO;
import com.example.module.auth.entity.User;
import com.example.module.auth.mapper.UserMapper;
import com.example.module.auth.service.AuthService;
import com.example.module.auth.vo.LoginVO;
import lombok.RequiredArgsConstructor;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final UserMapper userMapper;
    private final JwtUtil jwtUtil;

    @Override
    public LoginVO login(LoginDTO dto) {
        return authenticate(dto, null, null);
    }

    @Override
    public LoginVO loginAdmin(LoginDTO dto) {
        return authenticate(dto, 1, "该账号不是管理员账号");
    }

    private LoginVO authenticate(LoginDTO dto, Integer expectedRole, String roleMismatchMessage) {
        User user = findByUsername(dto.getUsername());
        if (user == null || !PasswordUtil.matches(dto.getPassword(), user.getPassword())) {
            throw new BizException(ResultCode.UNAUTHORIZED.getCode(), "用户名或密码错误");
        }
        if (user.getStatus() != null && user.getStatus() == 0) {
            throw new BizException(ResultCode.FORBIDDEN.getCode(), "账号已被禁用");
        }
        int role = user.getRole() == null ? 0 : user.getRole();
        if (expectedRole != null && role != expectedRole) {
            throw new BizException(ResultCode.FORBIDDEN.getCode(), roleMismatchMessage);
        }

        LoginVO vo = new LoginVO();
        vo.setUserId(user.getId());
        vo.setUsername(user.getUsername());
        vo.setNickname(user.getNickname());
        vo.setAvatar(user.getAvatar());
        vo.setSignature(user.getSignature());
        vo.setRole(role);
        vo.setToken(jwtUtil.generateToken(user.getId(), user.getUsername(), role));
        vo.setTokenType("Bearer");
        vo.setExpiresIn(jwtUtil.getExpireSeconds());
        return vo;
    }

    @Override
    public Long register(RegisterDTO dto) {
        if (findByUsername(dto.getUsername()) != null) {
            throw new BizException("用户名已存在");
        }

        User user = new User();
        user.setUsername(dto.getUsername());
        user.setPassword(PasswordUtil.encode(dto.getPassword()));
        user.setNickname(dto.getNickname() == null || dto.getNickname().isBlank()
                ? dto.getUsername() : dto.getNickname());
        user.setPhone(dto.getPhone());
        user.setEmail(dto.getEmail());
        user.setStatus(1);
        user.setRole(0);

        try {
            userMapper.insert(user);
        } catch (DuplicateKeyException e) {
            throw new BizException("用户名已存在");
        }
        return user.getId();
    }

    private User findByUsername(String username) {
        return userMapper.selectOne(new LambdaQueryWrapper<User>()
                .eq(User::getUsername, username));
    }
}
