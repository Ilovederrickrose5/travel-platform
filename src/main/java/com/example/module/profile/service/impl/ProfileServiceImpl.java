package com.example.module.profile.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.example.common.exception.BizException;
import com.example.common.result.ResultCode;
import com.example.common.util.PasswordUtil;
import com.example.module.auth.entity.User;
import com.example.module.auth.mapper.UserMapper;
import com.example.module.profile.dto.ChangePasswordDTO;
import com.example.module.profile.dto.ChangeUsernameDTO;
import com.example.module.profile.dto.UpdateProfileDTO;
import com.example.module.profile.service.ProfileService;
import com.example.module.profile.vo.ProfileVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;
import java.util.Set;
import java.util.UUID;
import java.util.regex.Pattern;

@Slf4j
@Service
@RequiredArgsConstructor
public class ProfileServiceImpl implements ProfileService {

    private static final int VISITOR_ROLE = 0;
    private static final int USERNAME_COOLDOWN_DAYS = 7;
    private static final long MAX_AVATAR_BYTES = 2L * 1024 * 1024;
    private static final Pattern USERNAME_PATTERN = Pattern.compile("^[A-Za-z][A-Za-z0-9_]{3,19}$");
    private static final Set<String> AVATAR_EXTENSIONS = Set.of("jpg", "jpeg", "png", "webp");
    private static final Set<String> AVATAR_CONTENT_TYPES = Set.of("image/jpeg", "image/jpg", "image/png", "image/webp");
    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

    private final UserMapper userMapper;

    @Value("${app.upload-dir:uploads}")
    private String uploadDir;

    @Override
    public ProfileVO getProfile(Long userId) {
        return toVO(requireVisitor(userId));
    }

    @Override
    public ProfileVO updateProfile(Long userId, UpdateProfileDTO dto) {
        requireVisitor(userId);
        String nickname = dto.getNickname() == null ? "" : dto.getNickname().trim();
        if (nickname.length() < 2 || nickname.length() > 20) {
            throw new BizException("昵称长度需在 2-20 个字符之间");
        }
        userMapper.update(null, new LambdaUpdateWrapper<User>()
                .eq(User::getId, userId)
                .set(User::getNickname, nickname)
                .set(User::getSignature, trimToNull(dto.getSignature()))
                .set(User::getPhone, trimToNull(dto.getPhone()))
                .set(User::getEmail, trimToNull(dto.getEmail())));
        return getProfile(userId);
    }

    @Override
    @Transactional
    public ProfileVO uploadAvatar(Long userId, MultipartFile file) {
        User user = requireVisitor(userId);
        if (file == null || file.isEmpty()) {
            throw new BizException("请选择头像图片");
        }
        if (file.getSize() > MAX_AVATAR_BYTES) {
            throw new BizException("头像图片不能超过 2MB");
        }
        String originalName = StringUtils.cleanPath(file.getOriginalFilename() == null ? "" : file.getOriginalFilename());
        String extension = StringUtils.getFilenameExtension(originalName);
        extension = extension == null ? "" : extension.toLowerCase(Locale.ROOT);
        String contentType = file.getContentType() == null ? "" : file.getContentType().toLowerCase(Locale.ROOT);
        if (!AVATAR_EXTENSIONS.contains(extension) || !AVATAR_CONTENT_TYPES.contains(contentType)) {
            throw new BizException("仅支持 JPG、PNG 或 WebP 格式的图片");
        }

        Path avatarDir = Paths.get(uploadDir).toAbsolutePath().normalize().resolve("avatars");
        String filename = UUID.randomUUID().toString().replace("-", "") + "." + extension;
        Path target = avatarDir.resolve(filename).normalize();
        try {
            Files.createDirectories(avatarDir);
            file.transferTo(target.toFile());
        } catch (IOException e) {
            log.error("头像保存失败", e);
            throw new BizException("头像上传失败，请稍后重试");
        }

        String avatarUrl = "/uploads/avatars/" + filename;
        userMapper.update(null, new LambdaUpdateWrapper<User>()
                .eq(User::getId, userId)
                .set(User::getAvatar, avatarUrl));
        deleteManagedAvatar(user.getAvatar());
        return getProfile(userId);
    }

    @Override
    public void changePassword(Long userId, ChangePasswordDTO dto) {
        User user = requireVisitor(userId);
        if (!PasswordUtil.matches(dto.getOldPassword(), user.getPassword())) {
            throw new BizException("当前密码不正确");
        }
        if (dto.getOldPassword().equals(dto.getNewPassword())) {
            throw new BizException("新密码不能与当前密码相同");
        }
        userMapper.update(null, new LambdaUpdateWrapper<User>()
                .eq(User::getId, userId)
                .set(User::getPassword, PasswordUtil.encode(dto.getNewPassword())));
    }

    @Override
    @Transactional
    public ProfileVO changeUsername(Long userId, ChangeUsernameDTO dto) {
        User user = requireVisitor(userId);
        String username = dto.getUsername() == null ? "" : dto.getUsername().trim();
        if (!USERNAME_PATTERN.matcher(username).matches()) {
            throw new BizException("登录账号需 4-20 位，以字母开头，仅含字母、数字或下划线");
        }
        if (!PasswordUtil.matches(dto.getPassword(), user.getPassword())) {
            throw new BizException("当前密码不正确");
        }
        if (username.equalsIgnoreCase(user.getUsername())) {
            throw new BizException("新登录账号与当前账号相同");
        }
        if (user.getUsernameUpdatedAt() != null) {
            LocalDateTime nextAvailable = user.getUsernameUpdatedAt().plusDays(USERNAME_COOLDOWN_DAYS);
            if (LocalDateTime.now().isBefore(nextAvailable)) {
                throw new BizException("登录账号每 7 天只能修改一次，下次可修改时间：" + nextAvailable.format(DATE_TIME_FORMATTER));
            }
        }
        Long used = userMapper.selectCount(new LambdaQueryWrapper<User>()
                .eq(User::getUsername, username)
                .ne(User::getId, userId));
        if (used != null && used > 0) {
            throw new BizException("该登录账号已被使用");
        }
        try {
            userMapper.update(null, new LambdaUpdateWrapper<User>()
                    .eq(User::getId, userId)
                    .set(User::getUsername, username)
                    .set(User::getUsernameUpdatedAt, LocalDateTime.now()));
        } catch (DuplicateKeyException e) {
            throw new BizException("该登录账号已被使用");
        }
        return getProfile(userId);
    }

    private User requireVisitor(Long userId) {
        User user = userMapper.selectById(userId);
        if (user == null || !Integer.valueOf(VISITOR_ROLE).equals(user.getRole())) {
            throw new BizException(ResultCode.FORBIDDEN.getCode(), "游客账号不存在");
        }
        return user;
    }

    private ProfileVO toVO(User user) {
        ProfileVO vo = new ProfileVO();
        vo.setUserId(user.getId());
        vo.setUsername(user.getUsername());
        vo.setNickname(user.getNickname());
        vo.setAvatar(user.getAvatar());
        vo.setSignature(user.getSignature());
        vo.setPhone(user.getPhone());
        vo.setEmail(user.getEmail());
        vo.setUsernameUpdatedAt(user.getUsernameUpdatedAt());
        vo.setCreatedAt(user.getCreatedAt());
        return vo;
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private void deleteManagedAvatar(String avatarUrl) {
        if (avatarUrl == null || !avatarUrl.startsWith("/uploads/")) {
            return;
        }
        Path base = Paths.get(uploadDir).toAbsolutePath().normalize();
        Path file = base.resolve(avatarUrl.substring("/uploads/".length())).normalize();
        if (!file.startsWith(base)) {
            return;
        }
        try {
            Files.deleteIfExists(file);
        } catch (IOException e) {
            log.warn("旧头像删除失败: {}", file, e);
        }
    }
}
