CREATE DATABASE IF NOT EXISTS `travel_ticket`
    DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

USE `travel_ticket`;

CREATE TABLE IF NOT EXISTS `app_user`
(
    `id`         BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
    `username`   VARCHAR(50)  NOT NULL COMMENT '登录名',
    `password`   VARCHAR(255) NOT NULL COMMENT '密码哈希（PBKDF2）',
    `nickname`   VARCHAR(50)           DEFAULT NULL COMMENT '昵称',
    `phone`      VARCHAR(20)           DEFAULT NULL COMMENT '手机号',
    `email`      VARCHAR(100)          DEFAULT NULL COMMENT '邮箱',
    `avatar`     VARCHAR(255)          DEFAULT NULL COMMENT '头像地址',
    `signature`  VARCHAR(120)          DEFAULT NULL COMMENT '个性签名',
    `username_updated_at` DATETIME     DEFAULT NULL COMMENT '最近修改登录名时间',
    `status`     TINYINT      NOT NULL DEFAULT 1 COMMENT '0-禁用 1-正常',
    `role`       TINYINT      NOT NULL DEFAULT 0 COMMENT '0-普通游客 1-管理员',
    `created_at` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_username` (`username`),
    KEY `idx_phone` (`phone`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT ='用户表';

CREATE TABLE IF NOT EXISTS `user_favorite`
(
    `id`            BIGINT   NOT NULL AUTO_INCREMENT COMMENT '主键',
    `user_id`       BIGINT   NOT NULL COMMENT '游客 ID',
    `attraction_id` BIGINT   NOT NULL COMMENT '景点 ID',
    `created_at`    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_user_attraction` (`user_id`, `attraction_id`),
    KEY `idx_attraction` (`attraction_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT ='游客收藏';

CREATE TABLE IF NOT EXISTS `attraction`
(
    `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
    `name`        VARCHAR(100) NOT NULL COMMENT '景点名称',
    `city`        VARCHAR(50)           DEFAULT NULL COMMENT '所在城市',
    `address`     VARCHAR(255)          DEFAULT NULL COMMENT '详细地址',
    `level`       VARCHAR(20)           DEFAULT NULL COMMENT '景区等级，如 5A',
    `cover_url`   VARCHAR(255)          DEFAULT NULL COMMENT '封面图',
    `description` TEXT COMMENT '景点介绍',
    `travel_guide` TEXT COMMENT '游玩攻略',
    `culture_intro` TEXT COMMENT '风土人文',
    `local_tips`   TEXT COMMENT '在地贴士',
    `open_time`   VARCHAR(100)          DEFAULT NULL COMMENT '开放时间说明',
    `longitude`   DECIMAL(10, 6)        DEFAULT NULL COMMENT '经度',
    `latitude`    DECIMAL(10, 6)        DEFAULT NULL COMMENT '纬度',
    `status`      TINYINT      NOT NULL DEFAULT 1 COMMENT '0-下线 1-上线',
    `sort`        INT          NOT NULL DEFAULT 0 COMMENT '排序值，越小越靠前',
    `created_at`  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_city_status` (`city`, `status`),
    KEY `idx_sort` (`sort`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT ='景点表';

CREATE TABLE IF NOT EXISTS `ticket_type`
(
    `id`             BIGINT         NOT NULL AUTO_INCREMENT COMMENT '主键',
    `attraction_id`  BIGINT         NOT NULL COMMENT '所属景点',
    `name`           VARCHAR(100)   NOT NULL COMMENT '票种名称',
    `description`    VARCHAR(255)            DEFAULT NULL COMMENT '票种说明',
    `price`          DECIMAL(10, 2) NOT NULL DEFAULT 0.00 COMMENT '售价',
    `original_price` DECIMAL(10, 2)          DEFAULT NULL COMMENT '原价',
    `purchase_limit` INT            NOT NULL DEFAULT 5 COMMENT '每单限购',
    `status`         TINYINT        NOT NULL DEFAULT 1 COMMENT '0-下架 1-在售 2-售罄',
    `sort`           INT            NOT NULL DEFAULT 0 COMMENT '排序值',
    `created_at`     DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`     DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_attraction` (`attraction_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT ='票种表';

CREATE TABLE IF NOT EXISTS `inventory_calendar`
(
    `id`              BIGINT   NOT NULL AUTO_INCREMENT COMMENT '主键',
    `ticket_type_id`  BIGINT   NOT NULL COMMENT '票种 ID',
    `visit_date`      DATE     NOT NULL COMMENT '游玩日期',
    `total_stock`     INT      NOT NULL DEFAULT 0 COMMENT '总库存',
    `sold_stock`      INT      NOT NULL DEFAULT 0 COMMENT '已售数量',
    `available_stock` INT      NOT NULL DEFAULT 0 COMMENT '剩余可售',
    `status`          TINYINT  NOT NULL DEFAULT 1 COMMENT '0-关闭 1-开放',
    `version`         INT      NOT NULL DEFAULT 0 COMMENT '乐观锁版本号',
    `created_at`      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_ticket_date` (`ticket_type_id`, `visit_date`),
    KEY `idx_visit_date` (`visit_date`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT ='分时库存日历';

CREATE TABLE IF NOT EXISTS `orders`
(
    `id`            BIGINT         NOT NULL AUTO_INCREMENT COMMENT '主键',
    `order_no`      VARCHAR(32)    NOT NULL COMMENT '订单号',
    `user_id`       BIGINT         NOT NULL COMMENT '下单用户',
    `total_amount`  DECIMAL(10, 2) NOT NULL DEFAULT 0.00 COMMENT '订单总额',
    `pay_amount`    DECIMAL(10, 2) NOT NULL DEFAULT 0.00 COMMENT '应付金额',
    `order_status`  TINYINT        NOT NULL DEFAULT 0 COMMENT '见 OrderStatus',
    `pay_status`    TINYINT        NOT NULL DEFAULT 0 COMMENT '见 PayStatus',
    `checkin_status`   TINYINT     NOT NULL DEFAULT 0 COMMENT '见 CheckinStatus',
    `checked_quantity` INT         NOT NULL DEFAULT 0 COMMENT '已核销数量',
    `contact_name`  VARCHAR(50)             DEFAULT NULL COMMENT '联系人',
    `contact_phone` VARCHAR(20)             DEFAULT NULL COMMENT '联系电话',
    `visit_date`    DATE                    DEFAULT NULL COMMENT '游玩日期',
    `expire_time`   DATETIME                DEFAULT NULL COMMENT '支付超时时间',
    `pay_time`      DATETIME                DEFAULT NULL COMMENT '支付时间',
    `cancel_time`   DATETIME                DEFAULT NULL COMMENT '取消时间',
    `remark`        VARCHAR(255)            DEFAULT NULL COMMENT '备注',
    `created_at`    DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`    DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_order_no` (`order_no`),
    KEY `idx_user_created` (`user_id`, `created_at`),
    KEY `idx_status_expire` (`order_status`, `expire_time`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT ='订单主表';

CREATE TABLE IF NOT EXISTS `order_item`
(
    `id`             BIGINT         NOT NULL AUTO_INCREMENT COMMENT '主键',
    `order_id`       BIGINT         NOT NULL COMMENT '订单 ID',
    `ticket_type_id` BIGINT         NOT NULL COMMENT '票种 ID',
    `ticket_name`    VARCHAR(100)   NOT NULL COMMENT '票种名称快照',
    `visit_date`     DATE           NOT NULL COMMENT '游玩日期',
    `unit_price`     DECIMAL(10, 2) NOT NULL DEFAULT 0.00 COMMENT '单价快照',
    `quantity`       INT            NOT NULL DEFAULT 1 COMMENT '数量',
    `amount`         DECIMAL(10, 2) NOT NULL DEFAULT 0.00 COMMENT '小计',
    `created_at`     DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_order` (`order_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT ='订单明细表';

CREATE TABLE IF NOT EXISTS `payment_record`
(
    `id`            BIGINT         NOT NULL AUTO_INCREMENT COMMENT '主键',
    `payment_no`    VARCHAR(32)    NOT NULL COMMENT '支付流水号',
    `order_id`      BIGINT         NOT NULL COMMENT '订单 ID',
    `order_no`      VARCHAR(32)    NOT NULL COMMENT '订单号',
    `user_id`       BIGINT         NOT NULL COMMENT '用户 ID',
    `amount`        DECIMAL(10, 2) NOT NULL DEFAULT 0.00 COMMENT '支付金额',
    `pay_channel`   VARCHAR(20)             DEFAULT NULL COMMENT '支付渠道',
    `status`        TINYINT        NOT NULL DEFAULT 0 COMMENT '见 PayStatus',
    `trade_no`      VARCHAR(64)             DEFAULT NULL COMMENT '第三方交易号',
    `callback_time` DATETIME                DEFAULT NULL COMMENT '回调时间',
    `remark`        VARCHAR(255)            DEFAULT NULL COMMENT '备注',
    `created_at`    DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`    DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_payment_no` (`payment_no`),
    KEY `idx_order_no` (`order_no`),
    KEY `idx_trade_no` (`trade_no`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT ='支付流水表';
