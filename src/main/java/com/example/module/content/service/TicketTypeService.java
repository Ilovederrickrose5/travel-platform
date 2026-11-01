package com.example.module.content.service;

import com.example.module.content.entity.TicketType;
import com.example.module.content.vo.TicketTypeVO;

import java.util.List;

public interface TicketTypeService {

    List<TicketTypeVO> listByAttractionId(Long attractionId);

    /**
     * 管理端查询景点下全部票种，包含已下架。
     */
    List<TicketTypeVO> listByAttractionIdForAdmin(Long attractionId);

    TicketTypeVO getDetail(Long id);

    Long create(TicketType ticketType);

    void update(TicketType ticketType);

    void delete(Long id);
}
