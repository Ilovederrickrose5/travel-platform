package com.example.module.recommend.controller;

import com.example.common.result.Result;
import com.example.module.recommend.service.RecommendService;
import com.example.module.recommend.vo.RecommendItemVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Tag(name = "推荐")
@RestController
@RequestMapping("/api/recommend")
@RequiredArgsConstructor
public class RecommendController {

    private final RecommendService recommendService;

    @Operation(summary = "景点推荐")
    @GetMapping
    public Result<List<RecommendItemVO>> recommend(@RequestParam(required = false) Long userId,
                                                   @RequestParam(required = false) Integer limit) {
        return Result.success(recommendService.recommend(userId, limit));
    }
}
