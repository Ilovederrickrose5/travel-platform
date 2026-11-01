package com.example.module.checkin.service;

import com.example.module.checkin.dto.CheckinDTO;

public interface CheckinService {

    void checkin(CheckinDTO dto);

    boolean isCheckedIn(String orderNo);
}
