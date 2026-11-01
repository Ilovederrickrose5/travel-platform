package com.example.module.admin.vo;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@AllArgsConstructor
public class DailyStatVO {

    private LocalDate date;

    private Long orderCount;

    private BigDecimal revenue;
}
