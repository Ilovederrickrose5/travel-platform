package com.example.module.recommend.vo;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class RecommendItemVO {

    private Long attractionId;

    private String name;

    private String city;

    private String coverUrl;

    private BigDecimal price;

    /**
     * 推荐得分
     */
    private BigDecimal score;

    /**
     * 推荐理由
     */
    private String reason;
}
