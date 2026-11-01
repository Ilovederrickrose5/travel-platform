package com.example.module.recommend.service;

import com.example.module.recommend.vo.RecommendItemVO;

import java.util.List;

public interface RecommendService {

    List<RecommendItemVO> recommend(Long userId, Integer limit);
}
