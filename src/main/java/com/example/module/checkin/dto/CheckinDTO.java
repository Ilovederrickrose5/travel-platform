package com.example.module.checkin.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class CheckinDTO {

    @NotBlank(message = "订单号不能为空")
    private String orderNo;

    @NotNull(message = "核销数量不能为空")
    private Integer quantity;

    /**
     * 核销操作人
     */
    private Long operatorId;
}
