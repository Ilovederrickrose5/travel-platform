package com.example.module.content.vo;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class AttractionMapVO {

    private Long id;

    private String name;

    private String city;

    private String level;

    private String coverUrl;

    private BigDecimal longitude;

    private BigDecimal latitude;

    private BigDecimal minPrice;
}
