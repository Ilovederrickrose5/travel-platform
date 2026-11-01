package com.example.module.content.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.example.common.exception.BizException;
import com.example.common.result.ResultCode;
import com.example.module.content.entity.Attraction;
import com.example.module.content.entity.TicketType;
import com.example.module.content.mapper.AttractionMapper;
import com.example.module.content.mapper.TicketTypeMapper;
import com.example.module.content.service.AttractionService;
import com.example.module.content.vo.AttractionDetailVO;
import com.example.module.content.vo.AttractionMapVO;
import com.example.module.content.vo.TicketTypeVO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class AttractionServiceImpl implements AttractionService {

    private final AttractionMapper attractionMapper;
    private final TicketTypeMapper ticketTypeMapper;

    @Override
    public List<AttractionDetailVO> listAttractions(String keyword, String city) {
        LambdaQueryWrapper<Attraction> wrapper = new LambdaQueryWrapper<Attraction>()
                .eq(Attraction::getStatus, 1);
        applyCityFilter(wrapper, city);
        applyKeyword(wrapper, keyword);
        wrapper.orderByAsc(Attraction::getSort).orderByDesc(Attraction::getId);
        List<Attraction> attractions = attractionMapper.selectList(wrapper);
        return toDetailVOs(attractions, false);
    }

    @Override
    public List<AttractionMapVO> listMapAttractions() {
        List<Attraction> attractions = attractionMapper.selectList(new LambdaQueryWrapper<Attraction>()
                .eq(Attraction::getStatus, 1)
                .isNotNull(Attraction::getLongitude)
                .isNotNull(Attraction::getLatitude)
                .orderByAsc(Attraction::getSort)
                .orderByDesc(Attraction::getId));
        if (attractions.isEmpty()) {
            return Collections.emptyList();
        }
        Map<Long, List<TicketTypeVO>> ticketTypeMap = loadTicketTypes(
                attractions.stream().map(Attraction::getId).toList(), false);
        return attractions.stream().map(attraction -> {
            AttractionMapVO vo = new AttractionMapVO();
            BeanUtils.copyProperties(attraction, vo);
            vo.setMinPrice(ticketTypeMap.getOrDefault(attraction.getId(), Collections.emptyList()).stream()
                    .filter(ticket -> Integer.valueOf(1).equals(ticket.getStatus()))
                    .map(TicketTypeVO::getPrice)
                    .filter(price -> price != null)
                    .min(BigDecimal::compareTo)
                    .orElse(null));
            return vo;
        }).toList();
    }

    @Override
    public List<AttractionDetailVO> listAllForAdmin(String keyword, String city) {
        LambdaQueryWrapper<Attraction> wrapper = new LambdaQueryWrapper<>();
        applyCityFilter(wrapper, city);
        applyKeyword(wrapper, keyword);
        wrapper.orderByAsc(Attraction::getSort).orderByDesc(Attraction::getId);
        List<Attraction> attractions = attractionMapper.selectList(wrapper);
        return toDetailVOs(attractions, true);
    }

    @Override
    public AttractionDetailVO getDetail(Long id) {
        Attraction attraction = attractionMapper.selectById(id);
        if (attraction == null) {
            throw new BizException(ResultCode.NOT_FOUND.getCode(), "景点不存在");
        }
        List<TicketTypeVO> ticketTypes = loadTicketTypes(List.of(id), false)
                .getOrDefault(id, Collections.emptyList());
        return toDetailVO(attraction, ticketTypes);
    }

    @Override
    public Long create(Attraction attraction) {
        if (!StringUtils.hasText(attraction.getName())) {
            throw new BizException(ResultCode.PARAM_INVALID.getCode(), "景点名称不能为空");
        }
        attraction.setId(null);
        if (attraction.getStatus() == null) {
            attraction.setStatus(1);
        }
        if (attraction.getSort() == null) {
            attraction.setSort(0);
        }
        attractionMapper.insert(attraction);
        return attraction.getId();
    }

    @Override
    public void update(Attraction attraction) {
        if (attraction.getId() == null) {
            throw new BizException(ResultCode.PARAM_INVALID.getCode(), "景点 ID 不能为空");
        }
        if (attractionMapper.selectById(attraction.getId()) == null) {
            throw new BizException(ResultCode.NOT_FOUND.getCode(), "景点不存在");
        }
        attractionMapper.updateById(attraction);
    }

    @Override
    public void delete(Long id) {
        if (attractionMapper.selectById(id) == null) {
            throw new BizException(ResultCode.NOT_FOUND.getCode(), "景点不存在");
        }
        Long ticketTypeCount = ticketTypeMapper.selectCount(new LambdaQueryWrapper<TicketType>()
                .eq(TicketType::getAttractionId, id));
        if (ticketTypeCount != null && ticketTypeCount > 0) {
            throw new BizException("请先删除该景点下的票种");
        }
        attractionMapper.deleteById(id);
    }

    private void applyCityFilter(LambdaQueryWrapper<Attraction> wrapper, String city) {
        if (!StringUtils.hasText(city)) {
            return;
        }
        String value = city.trim();
        wrapper.and(condition -> condition
                .like(Attraction::getCity, value)
                .or().like(Attraction::getAddress, value));
    }

    private void applyKeyword(LambdaQueryWrapper<Attraction> wrapper, String keyword) {
        if (!StringUtils.hasText(keyword)) {
            return;
        }
        String value = keyword.trim();
        wrapper.and(condition -> condition
                .like(Attraction::getName, value)
                .or().like(Attraction::getCity, value)
                .or().like(Attraction::getAddress, value));
    }

    private List<AttractionDetailVO> toDetailVOs(List<Attraction> attractions, boolean includeOffSale) {
        if (attractions.isEmpty()) {
            return Collections.emptyList();
        }
        Map<Long, List<TicketTypeVO>> ticketTypeMap = loadTicketTypes(
                attractions.stream().map(Attraction::getId).toList(), includeOffSale);
        return attractions.stream()
                .map(attraction -> toDetailVO(attraction,
                        ticketTypeMap.getOrDefault(attraction.getId(), Collections.emptyList())))
                .toList();
    }

    private Map<Long, List<TicketTypeVO>> loadTicketTypes(List<Long> attractionIds, boolean includeOffSale) {
        List<TicketType> ticketTypes = ticketTypeMapper.selectList(new LambdaQueryWrapper<TicketType>()
                .in(TicketType::getAttractionId, attractionIds)
                .in(!includeOffSale, TicketType::getStatus, 1, 2)
                .orderByAsc(TicketType::getSort)
                .orderByAsc(TicketType::getId));
        return ticketTypes.stream()
                .map(this::toTicketTypeVO)
                .collect(Collectors.groupingBy(TicketTypeVO::getAttractionId));
    }

    private AttractionDetailVO toDetailVO(Attraction attraction, List<TicketTypeVO> ticketTypes) {
        AttractionDetailVO vo = new AttractionDetailVO();
        BeanUtils.copyProperties(attraction, vo);
        vo.setTicketTypes(ticketTypes);
        return vo;
    }

    private TicketTypeVO toTicketTypeVO(TicketType ticketType) {
        TicketTypeVO vo = new TicketTypeVO();
        BeanUtils.copyProperties(ticketType, vo);
        return vo;
    }
}
