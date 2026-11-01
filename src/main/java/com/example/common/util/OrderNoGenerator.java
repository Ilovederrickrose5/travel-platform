package com.example.common.util;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.concurrent.ThreadLocalRandom;

/**
 * 订单号：T + yyyyMMddHHmmssSSS + 6 位随机数，共 20 位。
 */
public final class OrderNoGenerator {

    private static final String PREFIX = "T";
    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyyMMddHHmmssSSS");

    private OrderNoGenerator() {
    }

    public static String generate() {
        return PREFIX
                + LocalDateTime.now().format(FORMATTER)
                + String.format("%06d", ThreadLocalRandom.current().nextInt(1_000_000));
    }
}
