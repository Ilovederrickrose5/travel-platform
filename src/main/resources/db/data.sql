USE `travel_ticket`;

-- 演示账号：admin / admin123（管理员）
INSERT IGNORE INTO `app_user` (`id`, `username`, `password`, `nickname`, `phone`, `email`, `status`, `role`)
VALUES (1, 'admin', 'pbkdf2$120000$NstSPJdsoeDymSBSk2Vrqw==$mS0vhVaXoayaXrqPBuo3jrdyTW6fKj/RFhQcnNmaD2M=',
        '管理员', '13800000000', 'admin@example.com', 1, 1);

-- 演示账号：traveler / travel123（普通游客）
INSERT IGNORE INTO `app_user` (`id`, `username`, `password`, `nickname`, `phone`, `email`, `status`, `role`)
VALUES (2, 'traveler', 'pbkdf2$120000$QNoY4PC8jEQFg3ZzNlvfAw==$Me2jPt3u40cN8yYrYt8+GzKayhzJ+rpG9OT9ZZmRI8c=',
        '旅行者', '13900000000', 'traveler@example.com', 1, 0);

INSERT IGNORE INTO `attraction` (`id`, `name`, `city`, `address`, `level`, `cover_url`, `description`, `open_time`, `status`, `sort`)
VALUES (1, '西湖风景名胜区', '杭州', '浙江省杭州市西湖区龙井路1号', '5A', '/images/xihu.jpg',
        '三面云山一面城，中国首批国家重点风景名胜区。', '08:00-17:30', 1, 10),
       (2, '故宫博物院', '北京', '北京市东城区景山前街4号', '5A', '/images/gugong.jpg',
        '明清两代皇家宫殿，世界现存规模最大的木质结构古建筑群。', '08:30-17:00（周一闭馆）', 1, 20),
       (3, '鼓浪屿', '厦门', '福建省厦门市思明区鼓浪屿', '5A', '/images/gulangyu.jpg',
        '海上花园，万国建筑博览之地。', '全天开放', 1, 30),
       (4, '八达岭长城', '北京', '北京市延庆区军都山关沟古道北口', '5A', '/attraction/attraction_4_1.jpg',
        '明长城中保存最完好、最具代表性的段落，不到长城非好汉。', '07:30-17:00', 1, 40),
       (5, '秦始皇兵马俑博物馆', '西安', '陕西省西安市临潼区秦陵北路', '5A', '/attraction/attraction_5_1.jpg',
        '世界第八大奇迹，秦始皇陵陪葬坑出土的大型陶俑军阵。', '08:30-17:00', 1, 50),
       (6, '张家界国家森林公园', '张家界', '湖南省张家界市武陵源区', '5A', '/attraction/attraction_6_1.jpg',
        '三千奇峰拔地而起，电影《阿凡达》悬浮山取景灵感地。', '07:00-18:00', 1, 60),
       (7, '黄山风景区', '黄山', '安徽省黄山市黄山区汤口镇', '5A', '/attraction/attraction_7_1.jpg',
        '奇松、怪石、云海、温泉、冬雪五绝闻名天下。', '06:30-17:30', 1, 70),
       (8, '九寨沟景区', '阿坝', '四川省阿坝藏族羌族自治州九寨沟县', '5A', '/attraction/attraction_8_1.jpg',
        '翠海、叠瀑、彩林、雪峰，被誉为童话世界。', '08:00-17:00', 1, 80),
       (9, '桂林漓江景区', '桂林', '广西壮族自治区桂林市阳朔县', '5A', '/attraction/attraction_9_1.jpg',
        '百里漓江百里画廊，乘船可赏九马画山、黄布倒影。', '08:30-16:30', 1, 90),
       (10, '布达拉宫', '拉萨', '西藏自治区拉萨市城关区北京中路35号', '5A', '/attraction/attraction_10_1.jpg',
        '世界上海拔最高的宫堡式建筑群，藏传佛教圣地。', '09:00-16:00', 1, 100),
       (11, '泰山风景名胜区', '泰安', '山东省泰安市泰山区红门路', '5A', '/attraction/attraction_11_1.jpg',
        '五岳之首，历代帝王封禅之地，日出云海蔚为壮观。', '全天开放', 1, 110),
       (12, '东方明珠广播电视塔', '上海', '上海市浦东新区世纪大道1号', '5A', '/attraction/attraction_12_1.jpg',
        '上海城市地标，登塔可俯瞰黄浦江两岸全景。', '09:00-21:00', 1, 120),
       (13, '丽江古城', '丽江', '云南省丽江市古城区', '5A', '/attraction/attraction_13_1.jpg',
        '世界文化遗产，纳西族聚居的高原水乡古城。', '全天开放', 1, 130),
       (14, '峨眉山景区', '乐山', '四川省乐山市峨眉山市黄湾镇', '5A', '/attraction/attraction_14_1.jpg',
        '中国四大佛教名山之一，金顶佛光与云海闻名遐迩。', '06:00-18:00', 1, 140),
       (15, '莫高窟', '敦煌', '甘肃省敦煌市莫高镇', '5A', '/attraction/attraction_15_1.jpg',
        '千年佛教艺术宝库，保存大量壁画与彩塑。', '08:00-18:00', 1, 150),
       (16, '广州长隆旅游度假区', '广州', '广东省广州市番禺区汉溪大道东', '5A', '/attraction/attraction_16_1.jpg',
        '集欢乐世界、野生动物世界、水上乐园于一体的主题度假区。', '09:30-21:00', 1, 160),
       (17, '亚龙湾', '三亚', '海南省三亚市吉阳区亚龙湾', '5A', '/attraction/attraction_17_1.jpg',
        '天下第一湾，白沙碧海，热带滨海度假胜地。', '全天开放', 1, 170);

INSERT IGNORE INTO `ticket_type` (`id`, `attraction_id`, `name`, `description`, `price`, `original_price`, `purchase_limit`, `status`, `sort`)
VALUES (1, 1, '三潭印月游船票', '含画舫往返三潭印月（西湖免大门票）', 55.00, 55.00, 5, 1, 10),
       (2, 1, '儿童游船票', '身高 1.2-1.5 米适用，西湖免大门票', 30.00, 30.00, 5, 1, 20),
       (3, 2, '成人票', '含珍宝馆、钟表馆', 60.00, 80.00, 4, 1, 10),
       (4, 3, '往返船票', '厦门邮轮中心至鼓浪屿往返', 35.00, 45.00, 6, 1, 10),
       (5, 4, '成人票', '含八达岭长城景区大门票', 40.00, 45.00, 5, 1, 10),
       (6, 4, '学生票', '全日制学生凭学生证', 20.00, 25.00, 5, 1, 20),
       (7, 5, '成人票', '含兵马俑一、二、三号坑', 120.00, 150.00, 5, 1, 10),
       (8, 5, '学生票', '凭有效学生证', 60.00, 75.00, 5, 1, 20),
       (9, 6, '成人票', '含张家界国家森林公园大门票', 228.00, 260.00, 4, 1, 10),
       (10, 6, '优惠票', '学生、老人适用', 116.00, 130.00, 4, 1, 20),
       (11, 7, '成人票', '含黄山风景区大门票', 190.00, 230.00, 4, 1, 10),
       (12, 7, '索道联票', '门票 + 云谷索道单程', 270.00, 310.00, 4, 1, 20),
       (13, 8, '成人票', '含九寨沟门票 + 观光车', 169.00, 200.00, 4, 1, 10),
       (14, 8, '学生票', '凭学生证', 84.00, 100.00, 4, 1, 20),
       (15, 9, '漓江精华游船票', '竹江码头至阳朔', 215.00, 245.00, 5, 1, 10),
       (16, 9, '儿童票', '身高 1.2-1.5 米适用', 108.00, 130.00, 5, 1, 20),
       (17, 10, '成人票', '含布达拉宫参观', 200.00, 200.00, 2, 1, 10),
       (18, 10, '优惠票', '学生、老人适用', 100.00, 100.00, 2, 1, 20),
       (19, 11, '成人票', '含泰山景区大门票', 115.00, 125.00, 5, 1, 10),
       (20, 11, '学生票', '凭学生证半价', 57.00, 62.00, 5, 1, 20),
       (21, 12, '二球联票', '主观光层 + 透明悬空观光廊', 199.00, 220.00, 5, 1, 10),
       (22, 12, '三球联票', '含太空舱', 259.00, 280.00, 5, 1, 20),
       (23, 13, '古城维护费', '进入丽江古城需缴纳', 50.00, 50.00, 10, 1, 10),
       (24, 14, '成人票', '含峨眉山景区大门票', 160.00, 185.00, 4, 1, 10),
       (25, 14, '金顶索道票', '雷洞坪至金顶往返', 120.00, 140.00, 4, 1, 20),
       (26, 15, '成人票', '含数字展示中心 + 洞窟参观', 238.00, 238.00, 3, 1, 10),
       (27, 15, '学生票', '凭学生证', 120.00, 120.00, 3, 1, 20),
       (28, 16, '欢乐世界门票', '长隆欢乐世界全天票', 250.00, 300.00, 5, 1, 10),
       (29, 16, '野生动物世界门票', '长隆野生动物世界全天票', 300.00, 350.00, 5, 1, 20),
       (30, 17, '森林公园门票', '亚龙湾热带天堂森林公园', 158.00, 188.00, 5, 1, 10),
       (31, 17, '儿童票', '身高 1.2-1.5 米适用', 79.00, 94.00, 5, 1, 20);

INSERT IGNORE INTO `attraction` (`id`, `name`, `city`, `address`, `level`, `cover_url`, `description`, `open_time`, `status`, `sort`)
VALUES (18, '赛里木湖', '博乐', '新疆博尔塔拉蒙古自治州博乐市', '5A', NULL,
        '大西洋最后一滴眼泪，高山冷水湖与雪山草原相映。', '09:00-20:00', 1, 180),
       (19, '鸣沙山月牙泉', '敦煌', '甘肃省敦煌市鸣沙山月牙泉景区', '5A', NULL,
        '沙山环抱一泓月形清泉，千年不涸，沙鸣与泉影相映。', '05:30-21:00', 1, 190),
       (20, '青海湖', '海北', '青海省海北藏族自治州共和县', '5A', NULL,
        '中国最大的内陆咸水湖，油菜花、候鸟与湛蓝湖面构成高原画卷。', '全天开放', 1, 200),
       (21, '华山', '渭南', '陕西省渭南市华阴市华山镇', '5A', NULL,
        '奇险天下第一山，长空栈道与鹞子翻身令人生畏。', '07:00-19:00', 1, 210),
       (22, '衡山', '衡阳', '湖南省衡阳市南岳区', '5A', NULL,
        '南岳衡山，寿文化与佛道共存，雾凇云海四季不同。', '全天开放', 1, 220),
       (23, '恒山', '大同', '山西省大同市浑源县', '4A', NULL,
        '北岳恒山，悬空寺贴壁而建，山势雄浑。', '08:00-18:00', 1, 230),
       (24, '嵩山', '郑州', '河南省郑州市登封市嵩山风景名胜区', '5A', NULL,
        '中岳嵩山，少林寺与塔林坐落山间，禅武文化源远流长。', '08:00-18:00', 1, 240),
       (25, '庐山', '九江', '江西省九江市庐山市', '5A', NULL,
        '不识庐山真面目，云海、瀑布与近代别墅群交织。', '全天开放', 1, 250),
       (26, '雁荡山', '温州', '浙江省温州市乐清市雁荡镇', '5A', NULL,
        '东南第一山，灵峰夜景与飞瀑奇岩自成一格。', '08:00-17:30', 1, 260),
       (27, '黄鹤楼', '武汉', '湖北省武汉市武昌区蛇山西山坡特1号', '5A', NULL,
        '江南三大名楼之首，登楼可望长江与武汉三镇。', '08:00-18:00', 1, 270),
       (28, '夫子庙·秦淮河', '南京', '江苏省南京市秦淮区贡院街', '5A', NULL,
        '十里秦淮穿城而过，夫子庙、乌衣巷与画舫灯影相映。', '全天开放', 1, 280),
       (29, '玄武湖', '南京', '江苏省南京市玄武区玄武巷1号', '4A', NULL,
        '金陵明珠，五洲相连，湖光与明城墙相映。', '06:00-22:00', 1, 290),
       (30, '喀纳斯', '阿勒泰', '新疆阿勒泰地区布尔津县', '5A', NULL,
        '阿尔泰山深处的变色湖，图瓦村落与白桦林环绕。', '08:00-20:00', 1, 300),
       (31, '天山天池', '昌吉', '新疆昌吉回族自治州阜康市', '5A', NULL,
        '博格达峰下的高山湖泊，雪峰倒映，云杉环湖。', '09:00-19:00', 1, 310),
       (32, '那拉提草原', '伊犁', '新疆伊犁哈萨克自治州新源县', '5A', NULL,
        '空中草原，雪山、河谷与哈萨克牧群构成辽阔牧歌。', '08:30-20:00', 1, 320),
       (33, '张掖七彩丹霞', '张掖', '甘肃省张掖市临泽县倪家营镇', '5A', NULL,
        '层理交错的彩色丘陵，日落时如大地调色盘。', '06:00-20:00', 1, 330),
       (34, '嘉峪关关城', '嘉峪关', '甘肃省嘉峪关市雄关区', '5A', NULL,
        '天下第一雄关，明长城西端起点，戈壁上的军事要塞。', '08:30-18:00', 1, 340),
       (35, '茶卡盐湖', '海西', '青海省海西蒙古族藏族自治州乌兰县', '4A', NULL,
        '天空之镜，盐湖倒映云影，小火车驶向湖心。', '07:00-19:00', 1, 350),
       (36, '塔尔寺', '西宁', '青海省西宁市湟中区鲁沙尔镇', '5A', NULL,
        '藏传佛教格鲁派六大寺院之一，酥油花、堆绣与壁画称绝。', '08:00-17:00', 1, 360),
       (37, '五台山', '忻州', '山西省忻州市五台县', '5A', NULL,
        '文殊道场，汉藏佛教共存，台怀镇寺院群依山而建。', '全天开放', 1, 370);

INSERT IGNORE INTO `ticket_type` (`id`, `attraction_id`, `name`, `description`, `price`, `original_price`, `purchase_limit`, `status`, `sort`)
VALUES (32, 18, '成人票', '含赛里木湖景区门票', 145.00, 160.00, 5, 1, 10),
       (33, 19, '成人票', '含鸣沙山月牙泉景区门票', 110.00, 120.00, 5, 1, 10),
       (34, 20, '成人票', '含青海湖景区门票', 100.00, 120.00, 5, 1, 10),
       (35, 21, '成人票', '含华山景区门票', 160.00, 180.00, 5, 1, 10),
       (36, 22, '成人票', '含南岳衡山景区门票', 110.00, 120.00, 5, 1, 10),
       (37, 23, '成人票', '含恒山景区门票', 55.00, 60.00, 5, 1, 10),
       (38, 24, '成人票', '含嵩山景区门票', 80.00, 100.00, 5, 1, 10),
       (39, 25, '成人票', '含庐山景区门票', 160.00, 180.00, 5, 1, 10),
       (40, 26, '成人票', '含雁荡山景区门票', 120.00, 140.00, 5, 1, 10),
       (41, 27, '成人票', '含黄鹤楼公园门票', 70.00, 80.00, 5, 1, 10),
       (42, 28, '画舫游船票', '秦淮河画舫夜游票', 80.00, 100.00, 5, 1, 10),
       (43, 29, '游船票', '玄武湖游船票', 60.00, 70.00, 5, 1, 10),
       (44, 30, '成人票', '含喀纳斯景区门票', 160.00, 185.00, 5, 1, 10),
       (45, 31, '成人票', '含天山天池门票', 95.00, 110.00, 5, 1, 10),
       (46, 32, '成人票', '含那拉提草原门票', 95.00, 110.00, 5, 1, 10),
       (47, 33, '成人票', '含七彩丹霞景区门票', 74.00, 90.00, 5, 1, 10),
       (48, 34, '成人票', '含嘉峪关关城门票', 110.00, 120.00, 5, 1, 10),
       (49, 35, '成人票', '含茶卡盐湖门票', 60.00, 70.00, 5, 1, 10),
       (50, 36, '成人票', '含塔尔寺门票', 70.00, 80.00, 5, 1, 10),
       (51, 37, '成人票', '含五台山景区门票', 135.00, 150.00, 5, 1, 10);

INSERT IGNORE INTO `attraction` (`id`, `name`, `city`, `address`, `level`, `cover_url`, `description`, `open_time`, `status`, `sort`)
VALUES (38, '长白山', '延边', '吉林省延边朝鲜族自治州安图县', '5A', NULL,
        '关东第一山，天池、瀑布与原始森林层次分明。', '07:30-17:00', 1, 380),
       (39, '崂山', '青岛', '山东省青岛市崂山区', '5A', NULL,
        '海上第一名山，山海相接，道观与渔村散落山间。', '07:00-17:30', 1, 390),
       (40, '蓬莱阁', '烟台', '山东省烟台市蓬莱区', '5A', NULL,
        '人间仙境，八仙过海传说与海市蜃楼在此交汇。', '08:00-17:30', 1, 400),
       (41, '三清山', '上饶', '江西省上饶市玉山县', '5A', NULL,
        '道教名山，花岗岩峰林与云海栈道如仙境。', '08:00-17:00', 1, 410),
       (42, '武夷山', '南平', '福建省南平市武夷山市', '5A', NULL,
        '碧水丹山，九曲溪竹筏与岩茶文化相伴。', '08:00-17:30', 1, 420),
       (43, '武当山', '十堰', '湖北省十堰市丹江口市', '5A', NULL,
        '道教圣地，金顶宫观群与太极文化闻名。', '07:30-17:30', 1, 430),
       (44, '玉龙雪山', '丽江', '云南省丽江市玉龙纳西族自治县', '5A', NULL,
        '纳西族神山，冰川、蓝月谷与高原草甸相映。', '07:00-18:00', 1, 440),
       (45, '黄果树瀑布', '安顺', '贵州省安顺市镇宁布依族苗族自治县', '5A', NULL,
        '亚洲最大瀑布群，水帘洞可从瀑布内侧穿行。', '07:00-18:30', 1, 450),
       (46, '平遥古城', '晋中', '山西省晋中市平遥县', '5A', NULL,
        '保存完整的明清县城，票号、镖局与城墙讲述晋商往事。', '08:00-18:00', 1, 460),
       (47, '云冈石窟', '大同', '山西省大同市云冈区', '5A', NULL,
        '北魏皇家石窟，五万余尊造像见证民族融合。', '08:30-17:30', 1, 470),
       (48, '龙门石窟', '洛阳', '河南省洛阳市洛龙区', '5A', NULL,
        '伊河两岸的北魏与唐代造像，卢舍那大佛慈悲凝望。', '08:00-18:00', 1, 480),
       (49, '清明上河园', '开封', '河南省开封市龙亭区', '5A', NULL,
        '以《清明上河图》为蓝本的宋文化主题园区。', '09:00-22:00', 1, 490),
       (50, '曲阜三孔', '济宁', '山东省济宁市曲阜市', '5A', NULL,
        '孔庙、孔府、孔林构成的儒家文化圣地。', '08:00-17:30', 1, 500),
       (51, '拙政园', '苏州', '江苏省苏州市姑苏区东北街178号', '5A', NULL,
        '江南园林之冠，水榭回廊与四季花木互为借景。', '07:30-17:30', 1, 510),
       (52, '乌镇', '嘉兴', '浙江省嘉兴市桐乡市乌镇', '5A', NULL,
        '枕水人家，西栅夜色与蓝印花布染坊最具江南气韵。', '09:00-22:00', 1, 520),
       (53, '三坊七巷', '福州', '福建省福州市鼓楼区南后街', '5A', NULL,
        '明清坊巷格局完整，林则徐、严复等名人故居聚集。', '全天开放', 1, 530),
       (54, '开平碉楼', '江门', '广东省江门市开平市', '5A', NULL,
        '华侨兴建的碉楼与村落，中西合璧的侨乡记忆。', '08:30-17:30', 1, 540),
       (55, '大足石刻', '重庆', '重庆市大足区宝顶镇', '5A', NULL,
        '唐宋摩崖造像群，世俗生活与佛教故事同刻一壁。', '08:30-18:00', 1, 550),
       (56, '都江堰', '成都', '四川省成都市都江堰市', '5A', NULL,
        '两千多年仍在运行的水利工程，鱼嘴、飞沙堰与宝瓶口。', '08:00-18:00', 1, 560),
       (57, '乐山大佛', '乐山', '四川省乐山市市中区凌云路', '5A', NULL,
        '三江汇流处的唐代弥勒坐像，山是一尊佛。', '07:30-18:30', 1, 570);

INSERT IGNORE INTO `ticket_type` (`id`, `attraction_id`, `name`, `description`, `price`, `original_price`, `purchase_limit`, `status`, `sort`)
VALUES (52, 38, '成人票', '含长白山北景区门票', 105.00, 120.00, 5, 1, 10),
       (53, 39, '成人票', '含崂山景区门票', 90.00, 100.00, 5, 1, 10),
       (54, 40, '成人票', '含蓬莱阁景区门票', 100.00, 120.00, 5, 1, 10),
       (55, 41, '成人票', '含三清山景区门票', 120.00, 140.00, 5, 1, 10),
       (56, 42, '成人票', '含武夷山景区门票', 140.00, 160.00, 5, 1, 10),
       (57, 43, '成人票', '含武当山景区门票', 130.00, 150.00, 5, 1, 10),
       (58, 44, '成人票', '含玉龙雪山景区门票', 100.00, 120.00, 5, 1, 10),
       (59, 45, '成人票', '含黄果树瀑布景区门票', 160.00, 180.00, 5, 1, 10),
       (60, 46, '成人票', '含平遥古城通票', 125.00, 150.00, 5, 1, 10),
       (61, 47, '成人票', '含云冈石窟门票', 120.00, 135.00, 5, 1, 10),
       (62, 48, '成人票', '含龙门石窟门票', 90.00, 100.00, 5, 1, 10),
       (63, 49, '成人票', '含清明上河园门票', 120.00, 140.00, 5, 1, 10),
       (64, 50, '联票', '含孔庙、孔府、孔林', 140.00, 160.00, 5, 1, 10),
       (65, 51, '成人票', '含拙政园门票', 70.00, 80.00, 5, 1, 10),
       (66, 52, '成人票', '含乌镇西栅景区门票', 110.00, 120.00, 5, 1, 10),
       (67, 53, '联票', '含三坊七巷部分名人故居', 60.00, 70.00, 5, 1, 10),
       (68, 54, '成人票', '含开平碉楼文化旅游区门票', 90.00, 100.00, 5, 1, 10),
       (69, 55, '成人票', '含大足石刻宝顶山景区门票', 115.00, 125.00, 5, 1, 10),
       (70, 56, '成人票', '含都江堰景区门票', 80.00, 90.00, 5, 1, 10),
       (71, 57, '成人票', '含乐山大佛景区门票', 80.00, 90.00, 5, 1, 10);

INSERT IGNORE INTO `attraction` (`id`, `name`, `city`, `address`, `level`, `cover_url`, `description`, `open_time`, `status`, `sort`)
VALUES (58, '天坛', '北京', '北京市东城区天坛东里甲1号', '5A', NULL,
        '明清帝王祭天祈谷之所，祈年殿与回音壁举世闻名。', '06:00-22:00', 1, 580),
       (59, '颐和园', '北京', '北京市海淀区新建宫门路19号', '5A', NULL,
        '皇家园林典范，昆明湖与万寿山构成山水长卷。', '06:30-18:00', 1, 590),
       (60, '避暑山庄', '承德', '河北省承德市双桥区', '5A', NULL,
        '清代皇家夏宫，园林、草原与寺庙群融为一体。', '07:30-17:30', 1, 600),
       (61, '山海关', '秦皇岛', '河北省秦皇岛市山海关区', '5A', NULL,
        '天下第一关，老龙头伸入渤海，长城与海相接。', '07:30-17:30', 1, 610),
       (62, '五大道', '天津', '天津市和平区五大道', '4A', NULL,
        '万国建筑博览区，小洋楼与梧桐街道适合慢行。', '全天开放', 1, 620),
       (63, '沈阳故宫', '沈阳', '辽宁省沈阳市沈河区沈阳路171号', '4A', NULL,
        '清初皇宫，满汉蒙建筑风格交融。', '08:30-17:30', 1, 630),
       (64, '伪满皇宫', '长春', '吉林省长春市宽城区光复北路5号', '5A', NULL,
        '末代皇帝溥仪的宫廷旧址，近代史的重要见证。', '08:30-17:00', 1, 640),
       (65, '中央大街', '哈尔滨', '黑龙江省哈尔滨市道里区中央大街', '4A', NULL,
        '百年面包石街道，欧式建筑与冰雪风情交织。', '全天开放', 1, 650),
       (66, '趵突泉', '济南', '山东省济南市历下区趵突泉南路1号', '5A', NULL,
        '天下第一泉，三股泉水昼夜喷涌，观澜亭与李清照纪念堂相伴。', '07:00-19:00', 1, 660),
       (67, '栈桥', '青岛', '山东省青岛市市南区太平路12号', '4A', NULL,
        '青岛百年地标，回澜阁伸入海中，冬季可看海鸥。', '全天开放', 1, 670),
       (68, '中山陵', '南京', '江苏省南京市玄武区石象路7号', '5A', NULL,
        '孙中山先生陵寝，392级台阶依山而建。', '08:30-17:00', 1, 680),
       (69, '瘦西湖', '扬州', '江苏省扬州市邗江区大虹桥路28号', '5A', NULL,
        '两堤花柳全依水，五亭桥与白塔构成扬州名片。', '07:30-17:30', 1, 690),
       (70, '滕王阁', '南昌', '江西省南昌市东湖区仿古街58号', '5A', NULL,
        '江南三大名楼之一，落霞与孤鹜齐飞之处。', '08:00-18:30', 1, 700),
       (71, '橘子洲', '长沙', '湖南省长沙市岳麓区橘子洲头', '5A', NULL,
        '湘江中的长岛，青年毛泽东艺术雕塑与江天暮雪。', '07:00-22:00', 1, 710),
       (72, '岳阳楼', '岳阳', '湖南省岳阳市岳阳楼区洞庭北路', '5A', NULL,
        '江南三大名楼之一，先天下之忧而忧的千古名篇诞生地。', '07:30-18:00', 1, 720),
       (73, '陈家祠', '广州', '广东省广州市荔湾区中山七路恩龙里34号', '4A', NULL,
        '岭南宗祠建筑瑰宝，木雕砖雕灰塑满目。', '09:00-17:00', 1, 730),
       (74, '晋祠', '太原', '山西省太原市晋源区晋祠镇', '4A', NULL,
        '晋国宗祠园林，圣母殿宋代彩塑与难老泉闻名。', '08:00-18:00', 1, 740),
       (75, '赵州桥', '石家庄', '河北省石家庄市赵县赵州镇', '4A', NULL,
        '隋代敞肩石拱桥，千年古桥仍横跨洨河。', '08:30-17:30', 1, 750),
       (76, '天一阁·月湖', '宁波', '浙江省宁波市海曙区天一街10号', '5A', NULL,
        '中国现存最古老的私家藏书楼，书藏古今，港通天下。', '08:30-17:30', 1, 760),
       (77, '鼋头渚', '无锡', '江苏省无锡市滨湖区鼋渚路1号', '5A', NULL,
        '太湖佳绝处，樱花、湖帆与鹿顶迎晖。', '08:00-17:00', 1, 770);

INSERT IGNORE INTO `ticket_type` (`id`, `attraction_id`, `name`, `description`, `price`, `original_price`, `purchase_limit`, `status`, `sort`)
VALUES (72, 58, '成人票', '含天坛公园联票', 34.00, 35.00, 5, 1, 10),
       (73, 59, '成人票', '含颐和园门票', 30.00, 35.00, 5, 1, 10),
       (74, 60, '成人票', '含避暑山庄门票', 90.00, 100.00, 5, 1, 10),
       (75, 61, '成人票', '含山海关景区门票', 50.00, 60.00, 5, 1, 10),
       (76, 62, '街区观光票', '五大道观光体验', 50.00, 60.00, 5, 1, 10),
       (77, 63, '成人票', '含沈阳故宫门票', 50.00, 60.00, 5, 1, 10),
       (78, 64, '成人票', '含伪满皇宫博物院门票', 70.00, 80.00, 5, 1, 10),
       (79, 65, '街区观光票', '中央大街观光体验', 20.00, 30.00, 5, 1, 10),
       (80, 66, '成人票', '含趵突泉、大明湖等景区', 40.00, 50.00, 5, 1, 10),
       (81, 67, '观光票', '栈桥及回澜阁参观', 20.00, 30.00, 5, 1, 10),
       (82, 68, '预约票', '中山陵陵寝预约服务', 10.00, 10.00, 5, 1, 10),
       (83, 69, '成人票', '含瘦西湖景区门票', 100.00, 120.00, 5, 1, 10),
       (84, 70, '成人票', '含滕王阁景区门票', 50.00, 60.00, 5, 1, 10),
       (85, 71, '观光车票', '橘子洲景区观光车', 20.00, 30.00, 5, 1, 10),
       (86, 72, '成人票', '含岳阳楼景区门票', 70.00, 80.00, 5, 1, 10),
       (87, 73, '成人票', '含陈家祠门票', 10.00, 10.00, 5, 1, 10),
       (88, 74, '成人票', '含晋祠博物馆门票', 80.00, 90.00, 5, 1, 10),
       (89, 75, '成人票', '含赵州桥景区门票', 40.00, 50.00, 5, 1, 10),
       (90, 76, '成人票', '含天一阁博物院门票', 30.00, 35.00, 5, 1, 10),
       (91, 77, '成人票', '含鼋头渚景区门票', 90.00, 100.00, 5, 1, 10);

INSERT IGNORE INTO `attraction` (`id`, `name`, `city`, `address`, `level`, `cover_url`, `description`, `open_time`, `status`, `sort`)
VALUES (78, '大召寺', '呼和浩特', '内蒙古呼和浩特市玉泉区大召前街', '4A', NULL,
        '呼和浩特最早兴建的藏传佛教寺院，银佛与壁画珍贵。', '08:00-18:00', 1, 780),
       (79, '中山桥·白塔山', '兰州', '甘肃省兰州市城关区', '4A', NULL,
        '黄河第一桥与白塔山隔河相望，是兰州的城市封面。', '全天开放', 1, 790),
       (80, '普陀山', '舟山', '浙江省舟山市普陀区', '5A', NULL,
        '海天佛国，观音道场，寺院与海岛相拥。', '06:30-17:30', 1, 800),
       (81, '洪崖洞', '重庆', '重庆市渝中区嘉陵江滨江路', '4A', NULL,
        '依山而建的吊脚楼群，夜色与江景层叠。', '全天开放', 1, 810),
       (82, '武侯祠', '成都', '四川省成都市武侯区武侯祠大街231号', '5A', NULL,
        '君臣合祀祠庙，三国文化与红墙竹影。', '08:00-18:00', 1, 820),
       (83, '大熊猫繁育研究基地', '成都', '四川省成都市成华区熊猫大道1375号', '4A', NULL,
        '近距离观察大熊猫与幼崽，竹林掩映的生态园区。', '07:30-18:00', 1, 830),
       (84, '石林', '昆明', '云南省昆明市石林彝族自治县', '5A', NULL,
        '喀斯特石峰如林，撒尼族阿诗玛传说流传其间。', '08:00-18:00', 1, 840),
       (85, '崇圣寺三塔', '大理', '云南省大理白族自治州大理市', '5A', NULL,
        '苍山洱海之间的千年三塔，大理历史的地标。', '07:30-18:00', 1, 850),
       (86, '青岩古镇', '贵阳', '贵州省贵阳市花溪区青岩镇', '5A', NULL,
        '明代屯堡古镇，石巷、城墙与状元府。', '08:30-17:30', 1, 860),
       (87, '梵净山', '铜仁', '贵州省铜仁市江口县', '5A', NULL,
        '武陵之巅，红云金顶与蘑菇石立于云海。', '07:00-17:00', 1, 870),
       (88, '大昭寺', '拉萨', '西藏拉萨市城关区八廓街', '5A', NULL,
        '藏传佛教信仰中心，释迦牟尼十二岁等身像供奉于此。', '09:00-17:30', 1, 880),
       (89, '纳木错', '拉萨', '西藏拉萨市当雄县', '5A', NULL,
        '天湖纳木错，念青唐古拉雪山倒映在圣湖之中。', '07:00-18:00', 1, 890),
       (90, '镇北堡西部影城', '银川', '宁夏银川市西夏区镇北堡镇', '5A', NULL,
        '荒凉古堡中的电影场景，《大话西游》取景地。', '08:00-18:00', 1, 900),
       (91, '国际大巴扎', '乌鲁木齐', '新疆乌鲁木齐市天山区解放南路', '4A', NULL,
        '中亚风情市集，干果、地毯与手工艺品汇聚。', '10:00-22:00', 1, 910),
       (92, '沙坡头', '中卫', '宁夏中卫市沙坡头区', '5A', NULL,
        '腾格里沙漠与黄河交汇，滑沙、羊皮筏子与星空。', '08:00-18:00', 1, 920),
       (93, '青秀山', '南宁', '广西南宁市青秀区青山路19号', '5A', NULL,
        '南宁城市绿肺，苏铁园、观音禅寺与邕江全景。', '07:00-18:00', 1, 930),
       (94, '天涯海角', '三亚', '海南省三亚市天涯区', '5A', NULL,
        '天涯石与海角石立于南海之滨，热带海岸风光。', '07:30-18:30', 1, 940),
       (95, '骑楼老街', '海口', '海南省海口市龙华区中山路', '4A', NULL,
        '南洋风格骑楼街区，老爸茶与市井生活气息。', '全天开放', 1, 950),
       (96, '天门山', '张家界', '湖南省张家界市永定区', '5A', NULL,
        '天门洞与盘山公路奇观，索道横跨城市与山巅。', '08:00-18:00', 1, 960),
       (97, '稻城亚丁', '甘孜', '四川省甘孜藏族自治州稻城县', '5A', NULL,
        '蓝色星球最后一片净土，仙乃日、央迈勇、夏诺多吉三神山。', '07:00-18:00', 1, 970),
       (98, '大明湖', '济南', '山东省济南市历下区大明湖路271号', '5A', NULL,
        '由众泉汇流而成的城中湖，历下亭、超然楼与荷塘水街构成泉城水上风景。', '05:00-22:00', 1, 665);

INSERT IGNORE INTO `ticket_type` (`id`, `attraction_id`, `name`, `description`, `price`, `original_price`, `purchase_limit`, `status`, `sort`)
VALUES (92, 78, '成人票', '含大召寺门票', 35.00, 40.00, 5, 1, 10),
       (93, 79, '白塔山公园门票', '含白塔山公园', 10.00, 10.00, 5, 1, 10),
       (94, 80, '成人票', '含普陀山景区门票', 160.00, 180.00, 5, 1, 10),
       (95, 81, '两江夜游船票', '洪崖洞码头登船，夜游两江', 128.00, 158.00, 5, 1, 10),
       (96, 82, '成人票', '含武侯祠博物馆门票', 50.00, 60.00, 5, 1, 10),
       (97, 83, '成人票', '含大熊猫繁育研究基地门票', 55.00, 60.00, 5, 1, 10),
       (98, 84, '成人票', '含石林景区门票', 130.00, 150.00, 5, 1, 10),
       (99, 85, '成人票', '含崇圣寺三塔门票', 75.00, 90.00, 5, 1, 10),
       (100, 86, '成人票', '含青岩古镇门票', 60.00, 70.00, 5, 1, 10),
       (101, 87, '成人票', '含梵净山景区门票', 100.00, 120.00, 5, 1, 10),
       (102, 88, '成人票', '含大昭寺门票', 85.00, 85.00, 5, 1, 10),
       (103, 89, '成人票', '含纳木错景区门票', 120.00, 130.00, 5, 1, 10),
       (104, 90, '成人票', '含镇北堡西部影城门票', 100.00, 110.00, 5, 1, 10),
       (105, 91, '观光票', '国际大巴扎观光体验', 30.00, 30.00, 5, 1, 10),
       (106, 92, '成人票', '含沙坡头景区门票', 80.00, 100.00, 5, 1, 10),
       (107, 93, '成人票', '含青秀山景区门票', 20.00, 25.00, 5, 1, 10),
       (108, 94, '成人票', '含天涯海角景区门票', 68.00, 80.00, 5, 1, 10),
       (109, 95, '文化馆联票', '骑楼老街文化展馆联票', 30.00, 30.00, 5, 1, 10),
       (110, 96, '成人票', '含天门山景区门票', 278.00, 300.00, 5, 1, 10),
       (111, 97, '成人票', '含稻城亚丁景区门票', 146.00, 160.00, 5, 1, 10),
       (112, 98, '游船票', '大明湖画舫游船（景区免费开放）', 30.00, 40.00, 5, 1, 10),
       (113, 98, '免费预约票', '大明湖免费开放，预约入园；游船另购', 0.00, 0.00, 5, 1, 5),
       (114, 81, '免费预约票', '洪崖洞免费开放，预约入园；夜游船另购', 0.00, 0.00, 5, 1, 5),
       (115, 1, '免费预约票', '西湖免费开放，预约入园；游船另购', 0.00, 0.00, 5, 1, 5),
       (116, 29, '免费预约票', '玄武湖免费开放，预约入园；游船另购', 0.00, 0.00, 5, 1, 5),
       (117, 53, '免费预约票', '街区免费开放，预约入园；展馆联票另购', 0.00, 0.00, 5, 1, 5),
       (118, 62, '免费预约票', '街区免费开放，预约入园；观光马车等另购', 0.00, 0.00, 5, 1, 5),
       (119, 65, '免费预约票', '街区免费开放，预约入园', 0.00, 0.00, 5, 1, 5),
       (120, 67, '免费预约票', '栈桥免费开放，预约入园', 0.00, 0.00, 5, 1, 5),
       (121, 71, '免费预约票', '橘子洲免费开放，预约入园；观光车另购', 0.00, 0.00, 5, 1, 5),
       (122, 95, '免费预约票', '街区免费开放，预约入园；展馆联票另购', 0.00, 0.00, 5, 1, 5);

-- 「趵突泉·大明湖」拆分为趵突泉、大明湖两个景点（兼容已初始化的库）
UPDATE `attraction` SET `name` = '趵突泉', `address` = '山东省济南市历下区趵突泉南路1号',
       `description` = '天下第一泉，三股泉水昼夜喷涌，观澜亭与李清照纪念堂相伴。'
WHERE id = 66 AND `name` = '趵突泉·大明湖';
UPDATE `ticket_type` SET `description` = '含趵突泉景区门票'
WHERE id = 80 AND `description` = '含趵突泉、大明湖等景区';
-- 洪崖洞免费开放，原观光电梯票改为两江夜游船票
UPDATE `ticket_type` SET `name` = '两江夜游船票', `description` = '洪崖洞码头登船，夜游两江',
       `price` = 128.00, `original_price` = 158.00
WHERE id = 95 AND `name` = '观光电梯票';
-- 西湖免大门票，原大门票票种改为三潭印月游船票
UPDATE `ticket_type` SET `name` = '三潭印月游船票', `description` = '含画舫往返三潭印月（西湖免大门票）',
       `price` = 55.00, `original_price` = 55.00
WHERE id = 1 AND `name` = '成人票';
UPDATE `ticket_type` SET `name` = '儿童游船票', `description` = '身高 1.2-1.5 米适用，西湖免大门票',
       `price` = 30.00, `original_price` = 30.00
WHERE id = 2 AND `name` = '儿童票';

-- 为新增景点补封面图（Pexels，CC0 免费商用）
UPDATE `attraction` SET cover_url = '/attraction/attraction_18_1.jpg' WHERE id = 18 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_19_1.jpg' WHERE id = 19 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_20_1.jpg' WHERE id = 20 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_21_1.jpg' WHERE id = 21 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_22_1.jpg' WHERE id = 22 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_23_1.jpg' WHERE id = 23 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_24_1.jpg' WHERE id = 24 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_25_1.jpg' WHERE id = 25 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_26_1.jpg' WHERE id = 26 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_27_1.jpg' WHERE id = 27 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_28_1.jpg' WHERE id = 28 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_29_1.jpg' WHERE id = 29 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_30_1.jpg' WHERE id = 30 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_31_1.jpg' WHERE id = 31 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_32_1.jpg' WHERE id = 32 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_33_1.jpg' WHERE id = 33 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_34_1.jpg' WHERE id = 34 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_35_1.jpg' WHERE id = 35 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_36_1.jpg' WHERE id = 36 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_37_1.jpg' WHERE id = 37 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_38_1.jpg' WHERE id = 38 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_39_1.jpg' WHERE id = 39 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_40_1.jpg' WHERE id = 40 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_41_1.jpg' WHERE id = 41 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_42_1.jpg' WHERE id = 42 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_43_1.jpg' WHERE id = 43 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_44_1.jpg' WHERE id = 44 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_45_1.jpg' WHERE id = 45 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_46_1.jpg' WHERE id = 46 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_47_1.jpg' WHERE id = 47 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_48_1.jpg' WHERE id = 48 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_49_1.jpg' WHERE id = 49 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_50_1.jpg' WHERE id = 50 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_51_1.jpg' WHERE id = 51 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_52_1.jpg' WHERE id = 52 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_53_1.jpg' WHERE id = 53 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_54_1.jpg' WHERE id = 54 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_55_1.jpg' WHERE id = 55 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_56_1.jpg' WHERE id = 56 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_57_1.jpg' WHERE id = 57 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_58_1.jpg' WHERE id = 58 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_59_1.jpg' WHERE id = 59 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_60_1.jpg' WHERE id = 60 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_61_1.jpg' WHERE id = 61 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_62_1.jpg' WHERE id = 62 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_63_1.jpg' WHERE id = 63 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_64_1.jpg' WHERE id = 64 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_65_1.jpg' WHERE id = 65 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_66_1.jpg' WHERE id = 66 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_67_1.jpg' WHERE id = 67 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_68_1.jpg' WHERE id = 68 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_69_1.jpg' WHERE id = 69 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_70_1.jpg' WHERE id = 70 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_71_1.jpg' WHERE id = 71 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_72_1.jpg' WHERE id = 72 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_73_1.jpg' WHERE id = 73 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_74_1.jpg' WHERE id = 74 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_75_1.jpg' WHERE id = 75 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_76_1.jpg' WHERE id = 76 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_77_1.jpg' WHERE id = 77 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_78_1.jpg' WHERE id = 78 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_79_1.jpg' WHERE id = 79 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_80_1.jpg' WHERE id = 80 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_81_1.jpg' WHERE id = 81 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_82_1.jpg' WHERE id = 82 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_83_1.jpg' WHERE id = 83 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_84_1.jpg' WHERE id = 84 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_85_1.jpg' WHERE id = 85 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_86_1.jpg' WHERE id = 86 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_87_1.jpg' WHERE id = 87 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_88_1.jpg' WHERE id = 88 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_89_1.jpg' WHERE id = 89 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_90_1.jpg' WHERE id = 90 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_91_1.jpg' WHERE id = 91 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_92_1.jpg' WHERE id = 92 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_93_1.jpg' WHERE id = 93 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_94_1.jpg' WHERE id = 94 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_95_1.jpg' WHERE id = 95 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_96_1.jpg' WHERE id = 96 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_97_1.jpg' WHERE id = 97 AND (cover_url IS NULL OR cover_url = '');
UPDATE `attraction` SET cover_url = '/attraction/attraction_98_1.jpg' WHERE id = 98 AND (cover_url IS NULL OR cover_url = '');
-- 未来 7 天库存，默认每日 100 张
INSERT IGNORE INTO `inventory_calendar` (`ticket_type_id`, `visit_date`, `total_stock`, `sold_stock`, `available_stock`, `status`)
SELECT t.id, DATE_ADD(CURDATE(), INTERVAL d.n DAY), 100, 0, 100, 1
FROM `ticket_type` t
         JOIN (SELECT 0 AS n
               UNION ALL SELECT 1
               UNION ALL SELECT 2
               UNION ALL SELECT 3
               UNION ALL SELECT 4
               UNION ALL SELECT 5
               UNION ALL SELECT 6) d;

-- 地图点位：景点经纬度（仅首次为空时写入，保留管理端后续修改）
UPDATE `attraction` SET `longitude` = 120.145000, `latitude` = 30.244000 WHERE id = 1 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 116.397000, `latitude` = 39.916300 WHERE id = 2 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 118.066000, `latitude` = 24.447000 WHERE id = 3 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 116.016000, `latitude` = 40.356000 WHERE id = 4 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 109.278000, `latitude` = 34.385000 WHERE id = 5 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 110.434000, `latitude` = 29.315000 WHERE id = 6 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 118.167000, `latitude` = 30.130000 WHERE id = 7 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 103.920000, `latitude` = 33.260000 WHERE id = 8 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 110.496000, `latitude` = 24.778000 WHERE id = 9 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 91.117000, `latitude` = 29.657800 WHERE id = 10 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 117.100000, `latitude` = 36.256000 WHERE id = 11 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 121.499800, `latitude` = 31.239700 WHERE id = 12 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 100.234000, `latitude` = 26.872000 WHERE id = 13 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 103.332000, `latitude` = 29.520000 WHERE id = 14 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 94.809000, `latitude` = 40.042000 WHERE id = 15 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 113.325000, `latitude` = 22.997000 WHERE id = 16 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 109.639000, `latitude` = 18.228000 WHERE id = 17 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 81.185000, `latitude` = 44.600000 WHERE id = 18 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 94.668000, `latitude` = 40.087000 WHERE id = 19 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 100.190000, `latitude` = 36.895000 WHERE id = 20 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 110.083000, `latitude` = 34.480000 WHERE id = 21 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 112.694000, `latitude` = 27.256000 WHERE id = 22 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 113.730000, `latitude` = 39.674000 WHERE id = 23 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 113.030000, `latitude` = 34.482000 WHERE id = 24 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 115.980000, `latitude` = 29.558000 WHERE id = 25 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 121.050000, `latitude` = 28.370000 WHERE id = 26 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 114.302000, `latitude` = 30.544000 WHERE id = 27 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 118.788000, `latitude` = 32.023000 WHERE id = 28 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 118.796000, `latitude` = 32.074000 WHERE id = 29 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 87.030000, `latitude` = 48.700000 WHERE id = 30 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 88.129000, `latitude` = 43.886000 WHERE id = 31 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 84.070000, `latitude` = 43.330000 WHERE id = 32 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 100.070000, `latitude` = 38.930000 WHERE id = 33 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 98.229000, `latitude` = 39.801000 WHERE id = 34 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 99.080000, `latitude` = 36.700000 WHERE id = 35 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 101.569000, `latitude` = 36.482000 WHERE id = 36 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 113.590000, `latitude` = 38.980000 WHERE id = 37 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 128.060000, `latitude` = 42.050000 WHERE id = 38 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 120.620000, `latitude` = 36.160000 WHERE id = 39 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 120.760000, `latitude` = 37.810000 WHERE id = 40 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 118.060000, `latitude` = 28.910000 WHERE id = 41 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 117.680000, `latitude` = 27.720000 WHERE id = 42 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 111.000000, `latitude` = 32.400000 WHERE id = 43 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 100.180000, `latitude` = 27.100000 WHERE id = 44 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 105.667000, `latitude` = 25.990000 WHERE id = 45 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 112.176000, `latitude` = 37.189000 WHERE id = 46 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 113.133000, `latitude` = 40.110000 WHERE id = 47 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 112.470000, `latitude` = 34.555000 WHERE id = 48 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 114.340000, `latitude` = 34.810000 WHERE id = 49 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 116.986000, `latitude` = 35.594000 WHERE id = 50 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 120.629000, `latitude` = 31.323000 WHERE id = 51 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 120.490000, `latitude` = 30.745000 WHERE id = 52 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 119.296000, `latitude` = 26.086000 WHERE id = 53 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 112.560000, `latitude` = 22.370000 WHERE id = 54 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 105.800000, `latitude` = 29.700000 WHERE id = 55 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 103.606000, `latitude` = 31.003000 WHERE id = 56 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 103.771000, `latitude` = 29.547000 WHERE id = 57 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 116.410000, `latitude` = 39.882000 WHERE id = 58 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 116.275000, `latitude` = 39.999000 WHERE id = 59 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 117.938000, `latitude` = 40.988000 WHERE id = 60 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 119.754000, `latitude` = 40.009000 WHERE id = 61 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 117.202000, `latitude` = 39.108000 WHERE id = 62 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 123.456000, `latitude` = 41.796000 WHERE id = 63 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 125.355000, `latitude` = 43.903000 WHERE id = 64 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 126.616000, `latitude` = 45.772000 WHERE id = 65 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 117.010000, `latitude` = 36.662000 WHERE id = 66 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 120.320000, `latitude` = 36.061000 WHERE id = 67 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 118.848000, `latitude` = 32.059000 WHERE id = 68 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 119.418000, `latitude` = 32.401000 WHERE id = 69 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 115.880000, `latitude` = 28.684000 WHERE id = 70 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 112.956000, `latitude` = 28.184000 WHERE id = 71 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 113.090000, `latitude` = 29.385000 WHERE id = 72 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 113.244000, `latitude` = 23.129000 WHERE id = 73 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 112.439000, `latitude` = 37.707000 WHERE id = 74 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 114.642000, `latitude` = 37.732000 WHERE id = 75 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 121.546000, `latitude` = 29.873000 WHERE id = 76 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 120.223000, `latitude` = 31.533000 WHERE id = 77 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 111.660000, `latitude` = 40.817000 WHERE id = 78 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 103.826000, `latitude` = 36.064000 WHERE id = 79 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 122.390000, `latitude` = 30.010000 WHERE id = 80 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 106.579000, `latitude` = 29.563000 WHERE id = 81 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 104.048000, `latitude` = 30.646000 WHERE id = 82 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 104.147000, `latitude` = 30.738000 WHERE id = 83 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 103.327000, `latitude` = 24.810000 WHERE id = 84 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 100.143000, `latitude` = 25.859000 WHERE id = 85 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 106.684000, `latitude` = 26.331000 WHERE id = 86 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 108.694000, `latitude` = 27.910000 WHERE id = 87 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 91.132000, `latitude` = 29.653000 WHERE id = 88 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 90.700000, `latitude` = 30.700000 WHERE id = 89 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 106.070000, `latitude` = 38.620000 WHERE id = 90 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 87.608000, `latitude` = 43.781000 WHERE id = 91 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 105.000000, `latitude` = 37.480000 WHERE id = 92 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 108.390000, `latitude` = 22.785000 WHERE id = 93 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 109.348000, `latitude` = 18.296000 WHERE id = 94 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 110.343000, `latitude` = 20.045000 WHERE id = 95 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 110.475000, `latitude` = 29.050000 WHERE id = 96 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 100.330000, `latitude` = 28.440000 WHERE id = 97 AND `longitude` IS NULL AND `latitude` IS NULL;
UPDATE `attraction` SET `longitude` = 117.023000, `latitude` = 36.674000 WHERE id = 98 AND `longitude` IS NULL AND `latitude` IS NULL;
