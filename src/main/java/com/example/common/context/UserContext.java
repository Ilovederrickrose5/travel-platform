package com.example.common.context;

/**
 * 当前请求的登录用户上下文，由 JwtInterceptor 写入、请求结束时清理。
 */
public final class UserContext {

    private static final ThreadLocal<Long> USER_ID = new ThreadLocal<>();
    private static final ThreadLocal<Integer> ROLE = new ThreadLocal<>();

    private UserContext() {
    }

    public static void set(Long userId, Integer role) {
        USER_ID.set(userId);
        ROLE.set(role);
    }

    public static Long getUserId() {
        return USER_ID.get();
    }

    public static Integer getRole() {
        return ROLE.get();
    }

    public static Long requireUserId() {
        Long userId = USER_ID.get();
        if (userId == null) {
            throw new IllegalStateException("当前请求未携带登录用户");
        }
        return userId;
    }

    public static void clear() {
        USER_ID.remove();
        ROLE.remove();
    }
}
