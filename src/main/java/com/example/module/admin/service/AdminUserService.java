package com.example.module.admin.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.example.common.exception.BizException;
import com.example.common.util.PasswordUtil;
import com.example.module.admin.vo.AdminUserVO;
import com.example.module.auth.entity.User;
import com.example.module.auth.mapper.UserMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.security.SecureRandom;
import java.util.List;

@Service
@RequiredArgsConstructor
public class AdminUserService {

    private static final int VISITOR_ROLE = 0;
    private static final SecureRandom SECURE_RANDOM = new SecureRandom();
    private static final char[] PASSWORD_CHARS =
            "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789".toCharArray();

    private final UserMapper userMapper;

    public List<AdminUserVO> listVisitors(String keyword, Integer status) {
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<User>()
                .eq(User::getRole, VISITOR_ROLE)
                .eq(status != null, User::getStatus, status)
                .orderByDesc(User::getId);
        if (StringUtils.hasText(keyword)) {
            String value = keyword.trim();
            wrapper.and(w -> w.like(User::getUsername, value)
                    .or().like(User::getNickname, value)
                    .or().like(User::getPhone, value));
        }
        return userMapper.selectList(wrapper).stream().map(this::toVO).toList();
    }

    public void updateStatus(Long id, Integer status) {
        if (status == null || (status != 0 && status != 1)) {
            throw new BizException("状态值不合法");
        }
        User user = requireVisitor(id);
        if (status.equals(user.getStatus())) {
            return;
        }
        User update = new User();
        update.setId(user.getId());
        update.setStatus(status);
        userMapper.updateById(update);
    }

    public String resetPassword(Long id) {
        User user = requireVisitor(id);
        String newPassword = generatePassword();
        User update = new User();
        update.setId(user.getId());
        update.setPassword(PasswordUtil.encode(newPassword));
        userMapper.updateById(update);
        return newPassword;
    }

    private String generatePassword() {
        StringBuilder password = new StringBuilder(12);
        for (int i = 0; i < 12; i++) {
            password.append(PASSWORD_CHARS[SECURE_RANDOM.nextInt(PASSWORD_CHARS.length)]);
        }
        return password.toString();
    }

    private User requireVisitor(Long id) {
        User user = userMapper.selectById(id);
        if (user == null || !Integer.valueOf(VISITOR_ROLE).equals(user.getRole())) {
            throw new BizException("游客账号不存在");
        }
        return user;
    }

    private AdminUserVO toVO(User user) {
        AdminUserVO vo = new AdminUserVO();
        vo.setId(user.getId());
        vo.setUsername(user.getUsername());
        vo.setNickname(user.getNickname());
        vo.setPhone(user.getPhone());
        vo.setEmail(user.getEmail());
        vo.setStatus(user.getStatus());
        vo.setCreatedAt(user.getCreatedAt());
        return vo;
    }
}
