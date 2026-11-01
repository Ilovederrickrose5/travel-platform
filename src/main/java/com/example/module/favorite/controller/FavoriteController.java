package com.example.module.favorite.controller;

import com.example.common.context.UserContext;
import com.example.common.result.Result;
import com.example.module.favorite.service.FavoriteService;
import com.example.module.favorite.vo.FavoriteVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Tag(name = "游客收藏")
@RestController
@RequestMapping("/api/favorites")
@RequiredArgsConstructor
public class FavoriteController {

    private final FavoriteService favoriteService;

    @Operation(summary = "收藏列表")
    @GetMapping
    public Result<List<FavoriteVO>> list() {
        return Result.success(favoriteService.listFavorites(UserContext.requireUserId()));
    }

    @Operation(summary = "收藏的景点 ID 列表")
    @GetMapping("/ids")
    public Result<List<Long>> ids() {
        return Result.success(favoriteService.listFavoriteIds(UserContext.requireUserId()));
    }

    @Operation(summary = "收藏景点")
    @PostMapping("/{attractionId}")
    public Result<Void> add(@PathVariable Long attractionId) {
        favoriteService.addFavorite(UserContext.requireUserId(), attractionId);
        return Result.success();
    }

    @Operation(summary = "取消收藏")
    @DeleteMapping("/{attractionId}")
    public Result<Void> remove(@PathVariable Long attractionId) {
        favoriteService.removeFavorite(UserContext.requireUserId(), attractionId);
        return Result.success();
    }
}
