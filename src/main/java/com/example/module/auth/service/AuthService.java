package com.example.module.auth.service;

import com.example.module.auth.dto.LoginDTO;
import com.example.module.auth.dto.RegisterDTO;
import com.example.module.auth.vo.LoginVO;

public interface AuthService {

    LoginVO login(LoginDTO dto);

    LoginVO loginAdmin(LoginDTO dto);

    Long register(RegisterDTO dto);
}
