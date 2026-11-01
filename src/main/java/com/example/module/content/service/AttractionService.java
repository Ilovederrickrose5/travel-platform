package com.example.module.content.service;

import com.example.module.content.entity.Attraction;
import com.example.module.content.vo.AttractionDetailVO;
import com.example.module.content.vo.AttractionMapVO;

import java.util.List;

public interface AttractionService {

    List<AttractionDetailVO> listAttractions(String keyword, String city);

    /**
     * 地图页景点点位，仅返回有经纬度的上线景点。
     */
    List<AttractionMapVO> listMapAttractions();

    /**
     * 管理端景点列表，包含已下线景点。
     */
    List<AttractionDetailVO> listAllForAdmin(String keyword, String city);

    AttractionDetailVO getDetail(Long id);

    Long create(Attraction attraction);

    void update(Attraction attraction);

    void delete(Long id);
}
