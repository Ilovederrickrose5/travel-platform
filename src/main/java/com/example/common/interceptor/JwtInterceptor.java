package com.example.common.interceptor;

import com.example.common.context.UserContext;
import com.example.common.result.ResultCode;
import com.example.common.util.JwtUtil;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import java.nio.charset.StandardCharsets;

/**
 * 解析 Authorization 头中的 Bearer token，校验通过后写入 UserContext。
 * /api/admin/** 仅允许管理员角色（role=1）访问。
 */
@Component
@RequiredArgsConstructor
public class JwtInterceptor implements HandlerInterceptor {

    private static final int ADMIN_ROLE = 1;

    private final JwtUtil jwtUtil;

    @Value("${jwt.header:Authorization}")
    private String headerName;

    @Value("${jwt.prefix:Bearer }")
    private String tokenPrefix;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String header = request.getHeader(headerName);
        if (header == null || !header.startsWith(tokenPrefix)) {
            return reject(response, ResultCode.UNAUTHORIZED);
        }
        String token = header.substring(tokenPrefix.length()).trim();
        if (!jwtUtil.validateToken(token)) {
            return reject(response, ResultCode.UNAUTHORIZED);
        }

        Integer role = jwtUtil.getRole(token);
        if (request.getRequestURI().startsWith("/api/admin") && role != ADMIN_ROLE) {
            return reject(response, ResultCode.FORBIDDEN);
        }

        UserContext.set(jwtUtil.getUserId(token), role);
        return true;
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) {
        UserContext.clear();
    }

    private boolean reject(HttpServletResponse response, ResultCode resultCode) throws Exception {
        response.setStatus(resultCode.getCode());
        response.setCharacterEncoding(StandardCharsets.UTF_8.name());
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write("{\"code\":" + resultCode.getCode()
                + ",\"message\":\"" + resultCode.getMessage() + "\"}");
        return false;
    }
}
