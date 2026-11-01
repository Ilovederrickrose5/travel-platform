package com.example.module.ticket.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDate;

@Data
public class InventoryConfigDTO {

    @NotNull(message = "票种 ID 不能为空")
    private Long ticketTypeId;

    @NotNull(message = "游玩日期不能为空")
    private LocalDate visitDate;

    @NotNull(message = "总库存不能为空")
    @Min(value = 0, message = "总库存不能小于 0")
    private Integer totalStock;

    /**
     * 0-关闭 1-开放
     */
    private Integer status;
}
