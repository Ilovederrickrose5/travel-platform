package com.example.module.content.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 景点表 attraction。
 */
@Data
@TableName("attraction")
public class Attraction {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String name;

    private String city;

    private String address;

    /**
     * 景区等级，如 5A / 4A
     */
    private String level;

    private String coverUrl;

    private String description;

    /**
     * 游玩攻略
     */
    private String travelGuide;

    /**
     * 风土人文
     */
    private String cultureIntro;

    /**
     * 在地贴士
     */
    private String localTips;

    private String openTime;

    private BigDecimal longitude;

    private BigDecimal latitude;

    /**
     * 0-下线 1-上线
     */
    private Integer status;

    private Integer sort;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;
}
