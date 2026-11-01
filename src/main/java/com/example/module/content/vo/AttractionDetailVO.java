package com.example.module.content.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.util.List;

@Data
public class AttractionDetailVO {

    private Long id;

    private String name;

    private String city;

    private String address;

    private String level;

    private String coverUrl;

    private String description;

    private String travelGuide;

    private String cultureIntro;

    private String localTips;

    private String openTime;

    private BigDecimal longitude;

    private BigDecimal latitude;

    private Integer status;

    private List<TicketTypeVO> ticketTypes;
}
