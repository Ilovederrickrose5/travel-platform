package com.example.common.exception;

import com.example.common.result.ResultCode;
import lombok.Getter;

import java.io.Serial;

/**
 * 业务异常，由 {@link GlobalExceptionHandler} 统一转换为 Result。
 */
@Getter
public class BizException extends RuntimeException {

    @Serial
    private static final long serialVersionUID = 1L;

    private final Integer code;

    public BizException(String message) {
        super(message);
        this.code = ResultCode.BIZ_ERROR.getCode();
    }

    public BizException(ResultCode resultCode) {
        super(resultCode.getMessage());
        this.code = resultCode.getCode();
    }

    public BizException(Integer code, String message) {
        super(message);
        this.code = code;
    }
}
