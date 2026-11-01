package com.example.module.ticket.service;

import com.example.module.ticket.dto.InventoryConfigDTO;
import com.example.module.ticket.entity.InventoryCalendar;

import java.time.LocalDate;
import java.util.List;

public interface InventoryService {

    InventoryCalendar getInventory(Long ticketTypeId, LocalDate visitDate);

    List<InventoryCalendar> listInventory(Long ticketTypeId, LocalDate startDate, LocalDate endDate);

    void configInventory(InventoryConfigDTO dto);
}
