package com.example.module.favorite.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class FavoriteVO {

    private Long attractionId;

    private String name;

    private String city;

    private String level;

    private String coverUrl;

    private BigDecimal minPrice;

    private LocalDateTime favoritedAt;
}
