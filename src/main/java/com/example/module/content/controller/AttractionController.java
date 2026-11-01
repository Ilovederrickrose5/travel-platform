package com.example.module.content.controller;

import com.example.common.result.Result;
import com.example.module.content.service.AttractionService;
import com.example.module.content.vo.AttractionDetailVO;
import com.example.module.content.vo.AttractionMapVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Tag(name = "景点")
@RestController
@RequestMapping("/api/attractions")
@RequiredArgsConstructor
public class AttractionController {

    private final AttractionService attractionService;

    @Operation(summary = "景点列表")
    @GetMapping
    public Result<List<AttractionDetailVO>> list(@RequestParam(required = false) String keyword,
                                                 @RequestParam(required = false) String city) {
        return Result.success(attractionService.listAttractions(keyword, city));
    }

    @Operation(summary = "地图点位列表")
    @GetMapping("/map")
    public Result<List<AttractionMapVO>> map() {
        return Result.success(attractionService.listMapAttractions());
    }

    @Operation(summary = "景点详情")
    @GetMapping("/{id}")
    public Result<AttractionDetailVO> detail(@PathVariable Long id) {
        return Result.success(attractionService.getDetail(id));
    }
}
