package com.example.module.content.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.example.common.exception.BizException;
import com.example.common.result.ResultCode;
import com.example.module.content.entity.TicketType;
import com.example.module.content.mapper.AttractionMapper;
import com.example.module.content.mapper.TicketTypeMapper;
import com.example.module.content.service.TicketTypeService;
import com.example.module.content.vo.TicketTypeVO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.util.List;

@Service
@RequiredArgsConstructor
public class TicketTypeServiceImpl implements TicketTypeService {

    private final TicketTypeMapper ticketTypeMapper;
    private final AttractionMapper attractionMapper;

    @Override
    public List<TicketTypeVO> listByAttractionId(Long attractionId) {
        if (attractionId == null) {
            throw new BizException(ResultCode.PARAM_INVALID.getCode(), "景点 ID 不能为空");
        }
        return ticketTypeMapper.selectList(new LambdaQueryWrapper<TicketType>()
                        .eq(TicketType::getAttractionId, attractionId)
                        .in(TicketType::getStatus, 1, 2)
                        .orderByAsc(TicketType::getSort)
                        .orderByAsc(TicketType::getId))
                .stream()
                .map(this::toVO)
                .toList();
    }

    @Override
    public List<TicketTypeVO> listByAttractionIdForAdmin(Long attractionId) {
        if (attractionId == null) {
            throw new BizException(ResultCode.PARAM_INVALID.getCode(), "景点 ID 不能为空");
        }
        return ticketTypeMapper.selectList(new LambdaQueryWrapper<TicketType>()
                        .eq(TicketType::getAttractionId, attractionId)
                        .orderByAsc(TicketType::getSort)
                        .orderByAsc(TicketType::getId))
                .stream()
                .map(this::toVO)
                .toList();
    }

    @Override
    public TicketTypeVO getDetail(Long id) {
        TicketType ticketType = ticketTypeMapper.selectById(id);
        if (ticketType == null) {
            throw new BizException(ResultCode.NOT_FOUND.getCode(), "票种不存在");
        }
        return toVO(ticketType);
    }

    @Override
    public Long create(TicketType ticketType) {
        if (!StringUtils.hasText(ticketType.getName())) {
            throw new BizException(ResultCode.PARAM_INVALID.getCode(), "票种名称不能为空");
        }
        if (ticketType.getAttractionId() == null
                || attractionMapper.selectById(ticketType.getAttractionId()) == null) {
            throw new BizException(ResultCode.NOT_FOUND.getCode(), "景点不存在");
        }
        ticketType.setId(null);
        if (ticketType.getPrice() == null) {
            ticketType.setPrice(BigDecimal.ZERO);
        }
        if (ticketType.getPurchaseLimit() == null) {
            ticketType.setPurchaseLimit(5);
        }
        if (ticketType.getStatus() == null) {
            ticketType.setStatus(1);
        }
        if (ticketType.getSort() == null) {
            ticketType.setSort(0);
        }
        ticketTypeMapper.insert(ticketType);
        return ticketType.getId();
    }

    @Override
    public void update(TicketType ticketType) {
        if (ticketType.getId() == null) {
            throw new BizException(ResultCode.PARAM_INVALID.getCode(), "票种 ID 不能为空");
        }
        if (ticketTypeMapper.selectById(ticketType.getId()) == null) {
            throw new BizException(ResultCode.NOT_FOUND.getCode(), "票种不存在");
        }
        ticketTypeMapper.updateById(ticketType);
    }

    @Override
    public void delete(Long id) {
        if (ticketTypeMapper.selectById(id) == null) {
            throw new BizException(ResultCode.NOT_FOUND.getCode(), "票种不存在");
        }
        ticketTypeMapper.deleteById(id);
    }

    private TicketTypeVO toVO(TicketType ticketType) {
        TicketTypeVO vo = new TicketTypeVO();
        BeanUtils.copyProperties(ticketType, vo);
        return vo;
    }
}
