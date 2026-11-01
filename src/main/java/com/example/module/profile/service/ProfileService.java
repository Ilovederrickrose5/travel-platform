package com.example.module.profile.service;

import com.example.module.profile.dto.ChangePasswordDTO;
import com.example.module.profile.dto.ChangeUsernameDTO;
import com.example.module.profile.dto.UpdateProfileDTO;
import com.example.module.profile.vo.ProfileVO;
import org.springframework.web.multipart.MultipartFile;

public interface ProfileService {

    ProfileVO getProfile(Long userId);

    ProfileVO updateProfile(Long userId, UpdateProfileDTO dto);

    ProfileVO uploadAvatar(Long userId, MultipartFile file);

    void changePassword(Long userId, ChangePasswordDTO dto);

    ProfileVO changeUsername(Long userId, ChangeUsernameDTO dto);
}
