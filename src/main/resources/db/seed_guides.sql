USE `travel_ticket`;
SET NAMES utf8mb4;

-- 攻略示例内容：仅填充空字段，可重复执行，不覆盖管理员已编辑的内容。

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '西湖早已不只是风景，它是杭州人的日常：清晨苏堤上打太极的老人，湖畔茶馆里的一壶龙井，断桥边偶尔飘来的越剧唱腔。历代文人把诗词题刻留在山水之间，让自然与人文彼此成全。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '经典环湖线可走断桥—白堤—孤山—苏堤—花港观鱼，步行约四小时。\n清晨与傍晚光线柔和、游人较少，适合拍照与慢走。\n想读城市故事，可沿北山街看民国建筑，再拐进湖边茶室坐一坐。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '环湖公交和共享单车比打车更方便。\n春季多雨，随身带伞；夏季注意防晒补水。\n湖畔茶馆价格差异较大，落座前先看菜单。')
WHERE id = 1;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '紫禁城是明清两代的皇家中枢，红墙黄瓦之间藏着六百年的礼制、工艺与生活。今天的故宫依然鲜活：角楼下的摄影师、宫墙边写生的学生、文创店里讨论纹样的年轻人，让古老宫城有了新的日常。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '建议午门进、神武门出，先走中轴线三大殿，再折向西六宫慢慢看。\n上午开馆后人相对少，热门展馆记得提前预约。\n珍宝馆与钟表馆需单独购票，值得各留半小时以上。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '周一闭馆，务必提前实名预约。\n宫内步行距离长，穿一双舒服的鞋。\n雨雪天石板路湿滑，注意脚下。')
WHERE id = 2;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '鼓浪屿是一座没有机动车的小岛，琴声、海浪与老别墅的百叶窗构成它的日常。岛上中西合璧的骑楼与庭院，记录着华侨下南洋的故事；巷口小店的一杯茶，也带着闽南人的慢与热络。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '建议从三丘田码头上岛，沿龙头路—福建路—笔山路慢慢绕行，避开主街人流。\n清晨与傍晚最适合拍老别墅与海景，正午可躲进咖啡馆。\n日光岩、菽庄花园可择一登高，看整座岛的屋顶与海面。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '上岛需提前购买船票并携带身份证。\n岛上坡多巷窄，行李尽量轻便。\n海鲜排档先问清单价与重量再下单。')
WHERE id = 3;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '长城不只是砖石防线，也是沿线村落世代生活的背景。八达岭段山势陡峭、敌楼密集，脚下的城砖被无数脚步磨得发亮；关沟一带的旧驿道与山村，还留着往来商旅的痕迹。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '北线坡度更陡、视野开阔，南线相对平缓，可按时长和体力选择。\n建议早上八点前抵达，避开旅行团高峰。\n体力一般可乘缆车上行，再步行下山看敌楼与山色。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '山区昼夜温差大，带一件外套。\n城砖台阶高低不一，穿防滑鞋。\n旺季停车位紧张，优先选择市郊铁路或景区接驳。')
WHERE id = 4;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '兵马俑是秦帝国留给后世的军阵切片，每一张面孔、每一道发髻都不相同。临潼一带的村民至今仍会讲起 1974 年打井发现陶俑的故事，考古与在地生活在这片土地上交织。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '建议按一号坑—三号坑—二号坑顺序参观，先看规模再看细节。\n请一位讲解或租语音导览，能读懂军阵与工艺。\n参观后可去铜车马展厅，预留约一小时。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '馆内人流大，尽量避开上午十点后的团队高峰。\n西安市区往返约一小时车程，提前规划交通。\n展厅内禁用闪光灯，注意保护文物。')
WHERE id = 5;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '武陵源的石峰间散落着土家族村寨，吊脚楼、梯田与山歌仍在日常里延续。当地人对山的称呼、对雨的判断，都来自世代与森林相处的经验，让这片奇峰有了人情的温度。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '经典路线为袁家界—天子山—金鞭溪，可分两天走完。\n清晨山谷易起雾，想看云海可早早上山。\n金鞭溪平缓适合慢走，沿途溪水与猕猴是意外惊喜。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '山区天气多变，备雨衣比雨伞实用。\n不要投喂野生猕猴，收好随身食物。\n索道与环保车旺季排队久，预留充足时间。')
WHERE id = 6;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '黄山脚下的徽州村落，白墙黛瓦、祠堂牌坊与晒秋的竹匾，构成另一种风景。登山之外，走进汤口或宏村的小巷，能看见茶农、木雕匠人与民宿主人如何把山居日子过得讲究。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '想看日出可住山上，凌晨前往光明顶或始信峰。\n前山玉屏楼看迎客松，后山始信峰看怪石，体力好可一日连走。\n云谷索道与玉屏索道可组合上下，减少重复路段。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '山顶住宿紧张，务必提前预订。\n山路石阶湿滑，登山杖与防滑鞋很有用。\n山上物价较高，可自带少量水和干粮。')
WHERE id = 7;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '九寨沟的名字来自沟内九个藏族村寨，经幡、木楼与青稞田仍在山谷间。当地人把海子视作神灵的居所，转山、敬水的习惯延续至今，让这片水色多了一层敬畏。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '景区呈 Y 字形，建议先坐观光车到长海或原始森林，再逐段步行下行。\n五花海、镜海清晨最安静，倒影也最完整。\n秋季彩林与湖水相映，是全年色彩最丰富的时候。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '高原地区注意防晒与补水，动作放慢。\n景区内禁止吸烟与投喂动物。\n昼夜温差大，夏季也建议带外套。')
WHERE id = 8;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '漓江两岸的村落以捕鱼、种竹和船运为生，鸬鹚、竹筏与山歌曾是江面日常。阳朔西街的热闹之外，拐进遇龙河边的村子，还能看到晒谷、织布与老屋门前的慢生活。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '桂林至阳朔的漓江游船约四小时，九马画山、黄布倒影是精华段。\n想更自在可去遇龙河坐竹筏，水面安静、田园感更强。\n傍晚到兴坪看老寨山日落，能俯瞰漓江大转弯。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '游船班次固定，提前一天确认码头与开船时间。\n雨季水位变化大，关注景区通知。\n江面日晒强，帽子与防晒霜必备。')
WHERE id = 9;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '布达拉宫依红山而建，是藏地信仰、建筑与艺术的集中呈现。宫墙外的转经道每天清晨就有人顺时针行走，酥油灯、经幡与低声诵经，让这座宫殿始终与城市生活相连。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '参观需按预约时段入宫，建议提前到达排队安检。\n宫内台阶多、海拔高，放慢脚步，分段休息。\n参观结束后可沿宗角禄康公园转一圈，看当地人跳锅庄。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '高原反应因人而异，抵达拉萨后先适应一两天。\n宫内多数区域禁止拍照，遵守现场标识。\n早晚温差大，注意保暖与防晒。')
WHERE id = 10;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '泰山自古被视为直通帝座的神山，封禅、碑刻与石阶共同构成它的文化层。山脚下的泰安城里，清晨爬山的市民、红门附近的小吃摊，让登山不只是游客的仪式。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '经典徒步线为红门—中天门—十八盘—南天门，约四到六小时。\n想看日出可夜爬或住山顶，提前查好日出时间。\n体力有限可从天外村坐车到中天门，再换索道上山。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '夜爬气温低，带保暖衣物与头灯。\n十八盘台阶陡，注意节奏，避免猛冲。\n山顶物价较高，适量自带水和补给。')
WHERE id = 11;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '东方明珠是浦东开发开放的地标，也是上海人日常背景的一部分。塔下滨江步道上，晨跑者、拍照的游客与遛狗居民共享同一段江风，陆家嘴的玻璃幕墙映着黄浦江的旧与新。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '主观光层适合看外滩全景，透明悬空观光廊更刺激。\n傍晚时段可一次看到日落与夜景，建议提前预约。\n参观后可沿滨江大道步行到正大广场，继续看江景。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '节假日排队时间长，尽量错峰。\n观光层风大，外套比想象中需要。\n拍照注意玻璃反光，可用手或衣物遮挡镜头边缘。')
WHERE id = 12;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '丽江古城是纳西族聚居的高原水乡，玉河水系穿街过巷，三眼井边至今有人洗菜、取水。东巴文字、纳西古乐与院子里晒太阳的猫，让这座古城保留着缓慢的生活节奏。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '建议清晨从四方街出发，沿五一街—七一街慢慢走，避开午后人流。\n登狮子山万古楼可俯瞰古城屋顶与玉龙雪山。\n傍晚去束河古镇住一晚，能体会更安静的纳西村落。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '古城石板路凹凸不平，穿舒适的鞋。\n高原紫外线强，注意防晒与补水。\n酒吧街夜间喧闹，介意的话选择外围客栈。')
WHERE id = 13;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '峨眉山是佛教名山，山间的寺院、钟声与常年云雾相伴。山脚报国寺一带，香客与徒步者清晨同行；山中猴群与茶农的日常，也让这座山多了几分烟火气。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '经典路线为报国寺—清音阁—万年寺—雷洞坪—金顶，可分两天。\n金顶日出与云海最值得早起，注意查看天气预报。\n清音阁至生态猴区一段溪山清幽，适合慢走。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '山中湿度大，备防滑鞋与雨具。\n遇猴群不要手提塑料袋或外露食物。\n金顶海拔高、气温低，带保暖衣物。')
WHERE id = 14;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '莫高窟的洞窟里保存着千年壁画与彩塑，飞天、经变与供养人画像记录着丝路上的信仰与生活。敦煌城里的研究院、临摹室与夜市，让这份古老艺术仍在当代延续。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '参观先到数字展示中心看球幕电影，再乘接驳车前往洞窟。\n洞窟由讲解员带队参观，随机开放，保持安静与距离。\n建议预留半天，结束后可去敦煌研究院陈列中心补看细节。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '旺季务必提前在官方渠道预约。\n洞窟内严禁拍照、触摸壁画。\n敦煌干燥且昼夜温差大，注意补水与防晒。')
WHERE id = 15;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '长隆所在的大石一带，曾是广州南部的村镇与果园。如今主题乐园与野生动物世界改变了地貌，但岭南人爱热闹、重家庭出游的习惯，仍在周末的园区里延续。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '欢乐世界适合追求刺激项目，建议开园即入园先玩热门过山车。\n野生动物世界可乘小火车看散养区，步行区留足半天。\n带孩子的家庭可把行程拆成两天，避免体力透支。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '暑期与节假日人多，提前购票并预约入园。\n园区较大，穿舒适鞋并准备防晒。\n部分项目有身高限制，入园前查看说明。')
WHERE id = 16;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '亚龙湾周边的黎族村落保留着船形屋、黎锦与山兰酒的传统。海湾的度假酒店之外，走进博后村或六盘村，能看到热带田洋、槟榔树与村民的日常。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '上午海水最清，适合浮潜或下海游泳。\n热带天堂森林公园可走栈道看海湾全景，避开正午暴晒。\n傍晚沿海岸线散步，日落与椰林是最好看的时段。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '紫外线极强，防晒霜、帽子和墨镜必备。\n下海注意景区警示旗，勿在无人看护区域游泳。\n海鲜市场购买后先确认加工费再下单。')
WHERE id = 17;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '赛里木湖被称作大西洋最后一滴眼泪，湖水来自天山冰雪融水。湖畔的哈萨克牧民逐水草而居，转场时牛羊与毡房沿湖移动，构成高原上流动的生活。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '环湖公路约90公里，自驾或包车最方便，东门进南门出可看不同角度。\n清晨湖面平静，雪山倒影最清晰；傍晚西岸光线柔和。\n夏季可沿木栈道走到湖边草甸，注意不要踩踏牧草。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '湖区海拔约2000米，昼夜温差大，备一件外套。\n紫外线强，防晒和墨镜必备。\n环湖餐饮较少，出发前备好水和干粮。')
WHERE id = 18;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '鸣沙山与月牙泉在敦煌城南相依千年，沙山环抱一泓月形泉水，风沙不掩。当地人有攀登沙山看日落的习惯，驼队铃声是丝路记忆的延续。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '下午四点后进景区最舒服，先骑骆驼到沙山深处，再登沙脊看日落。\n月牙泉边的阁楼与芦苇适合拍照，光线柔和时层次最好。\n景区内有滑沙、沙地摩托等项目，按需选择。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '沙漠昼夜温差大，带外套和防沙鞋套。\n相机和手机注意防沙，风大时少换镜头。\n日落前后人流集中，返程预留排队时间。')
WHERE id = 19;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '青海湖是藏民心中的圣湖，环湖公路串起牧场、寺院与村落。每年夏季油菜花沿湖盛开，藏族村民在湖边经营帐篷客栈，酥油茶与糌粑是待客日常。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '环湖约360公里，建议两天，第一天走南线到黑马河看日出，第二天走北线。\n二郎剑、仙女湾适合近水观湖，鸟岛按季节开放。\n七月油菜花与湖蓝相接，是最热闹的时段。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '海拔约3200米，初到避免剧烈运动。\n湖边风大且晒，冲锋衣、帽子和防晒霜都要带。\n环湖住宿旺季紧张，提前预订。')
WHERE id = 20;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '华山以险著称，自古为道教全真派圣地，山间道观与摩崖题刻遍布。当地挑山工与守山人的故事，让这座山除险峻之外多了人情温度。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '经典路线是西峰索道上、北峰索道下，可一日走完五峰。\n长空栈道、鹞子翻身需另购安全绳，恐高者量力而行。\n夜爬看日出从玉泉院出发，需带头灯和保暖衣物。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '山上物价高，备足水和能量食品。\n手套必备，铁链和石阶会磨手。\n雨雪天部分险道关闭，出发前查景区公告。')
WHERE id = 21;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '南岳衡山是寿文化与佛道共存的灵山，山间寺观林立，香客终年不断。当地人有登祝融峰祈福的习惯，山脚下的南岳古镇保留着香市与素斋传统。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '可乘环保车到南天门，再步行登祝融峰，体力好可从山脚全程徒步。\n清晨看云海日出，午后走访福严寺、南台寺。\n秋季层林尽染，冬季雾凇是另一番景象。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '山上气候多变，带雨具和薄羽绒。\n香烛在指定区域焚烧，注意防火。\n节假日索道排队久，尽量早出发。')
WHERE id = 22;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '北岳恒山横亘晋北，悬空寺以横梁插入崖壁的方式悬在金龙峡西侧，儒释道三教同殿。当地流传着工匠以绳索悬空施工的传说。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '先游悬空寺，再登恒山主峰天峰岭，全程约半天。\n悬空寺限流，建议提前预约并早到。\n山道石阶较陡，慢行即可。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '悬空寺栈道狭窄，恐高者谨慎。\n晋北风大干燥，注意补水。\n冬季部分路段结冰，穿防滑鞋。')
WHERE id = 23;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '中岳嵩山是禅宗祖庭与少林武术的发源地，少林寺、塔林与初祖庵沿山分布。山下的登封小城仍保留着习武传统，清晨公园里常见练拳的人。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '少林景区可看常住院、塔林与武术表演，再乘索道上三皇寨。\n中岳庙与嵩阳书院适合喜欢古建和儒学的游客。\n两日游可把太室山与少室山分开走。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '武术表演有固定场次，进景区先看时间表。\n索道与步道选择多，按体力安排。\n景区跨度大，穿舒适徒步鞋。')
WHERE id = 24;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '庐山既有李白、苏轼留下的诗篇，也有近代避暑别墅群。牯岭镇的教堂、别墅与老街，记录着中西文化在云中山城的相遇。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '乘观光车串联如琴湖、花径、锦绣谷、仙人洞，再走含鄱口看日出。\n三叠泉往返约三小时，台阶多但值得。\n雨后云雾最出片，注意路滑。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '山上牯岭镇住宿方便，旺季提前订。\n云雾多，带防水外套。\n景区观光车为必乘，私家车不能上山。')
WHERE id = 25;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '雁荡山以奇峰、飞瀑与夜景著称，灵峰夜景在月色下变幻出各种剪影。山间观音洞、北斗洞等寺观依崖而建，香火与山水相伴。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '灵峰、灵岩、大龙湫是核心三景，可安排两天。\n灵岩飞渡表演有固定时间，提前占位。\n夜晚再看灵峰夜景，白天与夜晚是两种山形。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '景点分散，自驾或包车更省时。\n雨后瀑布水量大，但石阶湿滑。\n夜间看景带手电，注意脚下。')
WHERE id = 26;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '黄鹤楼因崔颢、李白诗篇闻名，历经多次重建，如今的楼阁立于蛇山之巅。登楼可望长江大桥与武汉三镇，楼下的户部巷是武汉过早文化的缩影。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '从西门进园，先看岳飞亭与搁笔亭，再登主楼。\n上午人少，顶层视野最好。\n游完可步行到户部巷吃热干面、豆皮。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '登楼需排队，错峰前往。\n武汉夏季闷热，备水和遮阳。\n周边停车紧张，建议地铁出行。')
WHERE id = 27;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '秦淮河是南京的母亲河，夫子庙、江南贡院与乌衣巷沿河分布。夜晚画舫灯影、桨声水声，延续着六朝金粉的市井记忆。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '白天逛夫子庙与江南贡院，傍晚坐画舫夜游秦淮河。\n老门东离得不远，可顺路看城南民居与小吃。\n元宵前后灯会最热闹，也最拥挤。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '画舫分日游和夜游，夜游更值得但需排队。\n景区小吃价格偏高，可往老门东方向找本地店。\n节假日人流大，看管好随身物品。')
WHERE id = 28;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '玄武湖古称桑泊，是南京城北的水上客厅。五洲之间桥堤相连，清晨环湖跑步、傍晚湖边唱戏，是南京人日常的一部分。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '从玄武门进，沿环洲、樱洲、梁洲慢慢走，可租船游湖。\n春天樱洲赏樱，秋天梁洲看银杏。\n湖边可远眺明城墙与紫金山。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '公园免费开放，游船另收费。\n周末环湖路人多，骑行注意避让。\n夏季蚊虫多，备驱蚊液。')
WHERE id = 29;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '喀纳斯湖畔的图瓦人村落保留着木屋、奶酒与苏尔演奏的传统。关于湖怪的传说流传已久，给这片原始森林添了神秘气息。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '先到换乘中心，再乘区间车游三湾，神仙湾晨雾最美。\n观鱼台可俯瞰湖面，需另购区间车票。\n秋季白桦林金黄，是摄影旺季。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '景区大，区间车换乘耗时，尽早进山。\n昼夜温差极大，备厚外套。\n秋季住宿紧张，提前预订。')
WHERE id = 30;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '天池古称瑶池，西王母传说与哈萨克牧歌在此交汇。湖畔的西王母庙会与民族歌舞，让雪山湖泊多了人间烟火。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '乘区间车到湖边，沿栈道走东岸，再乘马牙山索道俯瞰天池。\n上午光线好，湖面倒影清晰。\n可顺路看定海神针与东小天池。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '海拔约1900米，一般无明显高反。\n湖边风大，带防风外套。\n区间车与索道分开购票，预留时间。')
WHERE id = 31;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '那拉提草原是哈萨克牧民的夏季牧场，毡房、马群与冬不拉歌声构成草原日常。每年六月转场与赛马会，是感受游牧文化的好时机。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '空中草原与河谷草原分两条线，可乘区间车加徒步。\n清晨看晨雾中的毡房，傍晚等日落染红草坡。\n骑马按小时计费，先谈好价格。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '草原紫外线强，防晒从头到脚。\n昼夜温差大，带抓绒衣。\n尊重牧民生活区域，拍照先征得同意。')
WHERE id = 32;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '七彩丹霞的彩色丘陵由白垩纪砂岩经风蚀雨蚀形成，裕固族牧民世代在此放牧。日落时分，山体颜色层层加深，像大地打翻的调色盘。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '从北门或西门进，乘区间车依次游览四个观景台。\n下午四点后光线最好，日落观景台最热门。\n雨后色彩更饱和，但注意栈道湿滑。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '西北干燥，备水和润唇膏。\n日落散场集中，预留返程时间。\n禁止踩踏彩色山体，按栈道行走。')
WHERE id = 33;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '嘉峪关是明长城西端起点，关城由内城、外城与城壕组成。戈壁风沙中，这座军事要塞见证了丝路商旅与戍边将士的往来。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '先游关城，再往南看天下第一墩，往北看悬壁长城。\n上午光线适合拍关楼，下午可去长城第一墩看讨赖河峡谷。\n三处景点可买联票。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '戈壁风大日晒强，帽子墨镜必备。\n景点之间距离远，自驾或包车方便。\n旺季中午炎热，安排室内休息。')
WHERE id = 34;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '茶卡盐湖曾是采盐地，如今以天空之镜闻名。盐工、小火车与盐雕记录着湖区的工业记忆，藏族牧民则把盐湖视为自然的馈赠。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '乘小火车到湖心，赤脚或穿鞋套下湖拍照。\n上午和傍晚倒影最清楚，正午光线太硬。\n可顺路看盐雕群与盐文化馆。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '高原紫外线强，防晒和墨镜必备。\n下湖注意盐壳锋利，穿鞋套或防滑鞋。\n风大时湖面起波，倒影效果打折。')
WHERE id = 35;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '塔尔寺是宗喀巴大师诞生地，酥油花、壁画和堆绣被称为艺术三绝。寺外八座如意宝塔与转经的信众，构成湟中谷地的信仰日常。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '按顺时针方向参观大金瓦殿、小金瓦殿、酥油花馆。\n请讲解员能听懂更多壁画与佛像故事。\n清晨转经人多，氛围最好。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '寺内禁止拍照的区域遵守标识。\n着装得体，不穿短裙短裤。\n高原气候干燥，注意补水。')
WHERE id = 36;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '五台山是文殊菩萨道场，汉传与藏传佛教寺院并存。台怀镇晨钟暮鼓，朝台的信众沿山路叩拜，香火与山雾交织。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '核心寺院群集中在台怀镇，可步行游显通寺、塔院寺、菩萨顶。\n大朝台需包车或徒步，五座台顶各有风景。\n夏季清凉，是避暑与朝台旺季。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '山上气温低，夏季也需外套。\n寺院内保持安静，尊重宗教礼仪。\n节假日住宿紧张，提前安排。')
WHERE id = 37;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '长白山是满族发祥地，天池在火山口上终年云雾缭绕。山下的朝鲜族村落保留着打糕、冷面与秋千传统，林区采参文化也延续至今。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '北坡看天池最经典，西坡台阶多但视野开阔。\n天池能否露出看天气，建议住二道白河两天增加机会。\n可顺路看长白瀑布与绿渊潭。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '山上气温低，夏季也带冲锋衣。\n天池天气多变，出发前看预报。\n景区区间车排队久，早进山。')
WHERE id = 38;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '崂山是道教名山，太清宫、上清宫依海而建。山下的渔村以海草房、渔船和崂山绿茶为生，山海之间保留着朴素的渔家生活。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '太清线看道观与海岸，巨峰线适合登高，北九水看溪谷。\n可安排一天走太清景区，沿海栈道风景最好。\n春季樱桃与绿茶上市，适合慢游。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '景区分散，选一条线深度游即可。\n海边风大，带外套。\n旺季停车难，尽量早到。')
WHERE id = 39;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '蓬莱阁临海而建，八仙过海传说与海市蜃楼让这里自带仙气。水城、古船馆与戚继光故里，记录着登州古港的海防与海运历史。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '先登蓬莱阁看海，再逛水城与古船博物馆。\n天气通透时可远眺长岛。\n可顺路去蓬莱海洋极地世界，适合亲子。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '海边风大，夏季也备薄外套。\n海市蜃楼可遇不可求，别抱过高期待。\n海鲜市场先问价再加工。')
WHERE id = 40;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '三清山因玉京、玉虚、玉华三峰得名，是道教名山。花岗岩峰林间栈道盘旋，巨蟒出山、东方女神等象形石引人遐想。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '金沙索道上山，走南清园看巨蟒出山与东方女神，再走西海岸栈道。\n全程约一天，体力好可加三清宫。\n雨后云海概率高。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '山上台阶多，护膝和登山杖有用。\n天气多变，带雨衣。\n索道停运时间要留意，别错过末班。')
WHERE id = 41;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '武夷山是朱子理学与岩茶文化的交汇地，九曲溪两岸丹崖上留有历代摩崖石刻。天游峰下的茶农至今沿用传统制茶工艺。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '上午乘竹筏游九曲溪，下午登天游峰看全景。\n大红袍景区可走岩骨花香漫游道。\n印象大红袍演出适合晚上看。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '竹筏票紧张，提前预约。\n夏季湿热，备防蚊用品。\n爬山穿防滑鞋，雨后石阶湿滑。')
WHERE id = 42;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '武当山是真武大帝道场，紫霄宫、南岩宫与金顶构成庞大的道教建筑群。山间晨练太极的人与古建相映，武术与养生文化延续至今。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '乘索道上金顶，再步行下山看南岩宫、紫霄宫。\n太子坡九曲黄河墙适合拍照。\n两天游可住山上，看日出与云海。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '金顶台阶陡，量力而行。\n山上物价高，备水和干粮。\n道教场所注意着装与礼仪。')
WHERE id = 43;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '玉龙雪山是纳西族心中的神山，东巴经里记载着人与自然的古老契约。山下的蓝月谷、甘海子与纳西村落，构成雪山脚下的生活图景。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '大索道上冰川公园，需提前抢票；中小索道分别去牦牛坪和云杉坪。\n蓝月谷可步行或乘电瓶车。\n上午天气较稳，尽量早去。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '海拔高，备氧气瓶并缓慢行动。\n索道票实名预约，旺季难抢。\n山上寒冷，租羽绒服或自带厚衣。')
WHERE id = 44;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '黄果树瀑布是白水河上的瀑布群核心，布依族村寨散落在河谷两岸。水帘洞可从瀑布内侧穿行，当地人对水的敬畏与利用延续至今。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '先看大瀑布，再走天星桥看石林与水景，最后去陡坡塘。\n丰水期水量最大，水帘洞可能关闭。\n全程约一天，穿防滑鞋。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '瀑布水雾大，备雨衣保护相机。\n景区区间车串联各点，按指示换乘。\n夏季蚊虫多，带驱蚊液。')
WHERE id = 45;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '平遥古城保存着明清县城格局，票号、镖局、县衙与城墙共同讲述晋商故事。日昇昌票号被称为中国现代银行的乡下祖父。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '登城墙看古城全景，再逛日昇昌、协同庆、县衙。\n傍晚去明清街吃平遥牛肉与碗托。\n可顺路看双林寺与镇国寺。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '古城内步行即可，穿舒适鞋。\n通票包含多数景点，按需购买。\n节假日人多，住宿提前订。')
WHERE id = 46;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '云冈石窟开凿于北魏，昙曜五窟与五华洞的造像融合了印度、中亚与中原风格。石窟前的工人村与煤矿记忆，也是大同城市史的一部分。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '按1至20窟顺序参观，重点看第5、6、20窟。\n建议请讲解或租语音导览。\n下午光线适合看露天大佛。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '石窟内禁止闪光灯。\n大同风大干燥，注意补水。\n景区较大，预留半天时间。')
WHERE id = 47;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '龙门石窟历经北魏至唐代开凿，伊河两岸崖壁上密布窟龛。卢舍那大佛以雍容微笑成为盛唐气象的象征，附近的白园与香山寺串起洛阳人文。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '从西山石窟进，过桥到东山石窟，再远眺大佛全景。\n傍晚亮灯后氛围不同，可安排夜游。\n可顺路去白园与香山寺。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '景区步行距离长，穿舒适鞋。\n夏季炎热，备水和遮阳。\n石窟内禁止触摸造像。')
WHERE id = 48;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '清明上河园以张择端《清明上河图》为蓝本，复原汴河两岸的市井生活。盘鼓、斗鸡、木偶戏与宋代服饰，让游客走进画中东京。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '白天看民俗表演与汴河漕运，晚上看《大宋·东京梦华》实景演出。\n按节目单安排路线，避免来回折返。\n可顺路游龙亭与开封府。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '演出票与门票分开，提前确认。\n节假日人多，看表演提前占位。\n开封小吃集中在鼓楼夜市。')
WHERE id = 49;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '曲阜是孔子故里，孔庙、孔府、孔林合称三孔。大成殿的祭孔乐舞、孔府的家族档案与孔林的古树，共同构成儒家文化的物质记忆。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '上午游孔庙、孔府，下午去孔林，可乘电瓶车。\n请讲解能理解更多礼制细节。\n每年祭孔大典期间氛围最盛。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '三孔联票更划算。\n景区内古树多，注意防火。\n曲阜东站离景区较远，预留交通时间。')
WHERE id = 50;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '拙政园是江南私家园林的代表，水为中心，亭台楼榭依水而建。园主王献臣与文徵明的交往，让园林多了文人雅集的底色。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '从东园进，沿水榭、远香堂、小飞虹慢慢走。\n清晨开园时人少，适合拍照。\n可顺路逛苏州博物馆与平江路。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '旺季需提前预约。\n园内窄路多，避开高峰。\n雨天园林更有江南味道，备伞。')
WHERE id = 51;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '乌镇是典型的江南水乡，西栅的枕水人家、蓝印花布染坊与水上戏台保存着旧时生活。茅盾故居与木心美术馆让古镇多了文学气息。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '白天逛东栅看原住民生活，傍晚进西栅看夜景。\n住西栅内可避开日间人流。\n坐摇橹船看两岸灯火。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '东西栅联票更划算，但一天较赶。\n夜景是精华，安排住一晚。\n节假日住宿价格高，提前订。')
WHERE id = 52;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '三坊七巷保留着唐宋以来的坊巷格局，林则徐、严复、冰心等名人故居散落其间。南后街的油纸伞、软木画与鱼丸店，延续着福州日常。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '从南后街进，按坊巷指示牌走访林则徐纪念馆、严复故居。\n傍晚灯亮后适合拍照。\n可顺路去上下杭与烟台山。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '街区免费，部分故居单独收费。\n福州夏季炎热，备水和伞。\n南后街小吃价格偏高，可往巷内找老店。')
WHERE id = 53;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '开平碉楼是华侨为防匪患而建的防御性建筑，中西合璧的立面记录着侨乡历史。自力村的碉楼群与稻田相映，是电影《让子弹飞》的取景地。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '自力村看碉楼群，马降龙看竹林村落，立园看园林别墅。\n自驾最方便，景点之间距离较远。\n傍晚稻田光线柔和。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '景点分散，规划好路线。\n广东夏季炎热，备防晒。\n碉楼内部狭窄，注意安全。')
WHERE id = 54;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '大足石刻以宝顶山、北山为代表，唐宋造像把佛教故事与世俗生活刻在一起。牧牛图、父母恩重经变相充满人间温度。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '上午看宝顶山，下午看北山，两地相距约15公里。\n请讲解能读懂造像背后的故事。\n可顺路去大足城区吃邮亭鲫鱼。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '石刻禁止触摸和闪光灯。\n景区台阶多，穿舒适鞋。\n重庆夏季炎热，备水。')
WHERE id = 55;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '都江堰由李冰父子主持修建，鱼嘴分水、飞沙堰泄洪、宝瓶口引水，两千多年仍在灌溉成都平原。二王庙与安澜索桥记录着后世对治水者的感念。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '从离堆公园进，看宝瓶口、飞沙堰，再过安澜索桥到二王庙。\n可乘景区观光车节省体力。\n顺路去青城山安排两天。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '景区步行距离长，穿舒适鞋。\n夏季水量大，靠近水边注意安全。\n都江堰与青城山联票更划算。')
WHERE id = 56;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '乐山大佛开凿于唐代，依凌云山崖而建，面对三江汇流。海通禅师募建大佛的故事，与历代修缮记录一起刻在崖壁之间。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '步行栈道可近看大佛，九曲栈道较陡；乘船可看大佛全景。\n上午光线好，排队相对短。\n可顺路游凌云寺与乌尤寺。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '栈道限流，旺季排队久。\n江边风大，注意保暖。\n不要翻越护栏拍照。')
WHERE id = 57;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '天坛是明清帝王祭天祈谷的场所，祈年殿的圆形攒尖顶象征天圆地方。清晨公园里唱戏、抖空竹、打太极的市民，让皇家坛庙融入日常。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '从南门进，依次看圜丘、回音壁、祈年殿。\n上午光线适合拍祈年殿。\n可顺路去前门大街。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '联票包含祈年殿等核心景点。\n公园晨练人多，注意避让。\n北京春秋风大，备外套。')
WHERE id = 58;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '颐和园以昆明湖、万寿山为骨架，长廊、佛香阁与十七孔桥构成皇家园林的经典画面。慈禧太后的园居生活与造园工艺，都留在这片山水里。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '从东宫门进，沿长廊到佛香阁，再乘船到南湖岛看十七孔桥。\n下午光线柔和，适合拍湖景。\n冬季可看昆明湖冰场。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '园区很大，穿舒适鞋。\n旺季提前预约。\n湖边风大，夏季也备薄外套。')
WHERE id = 59;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '避暑山庄是清代皇家夏宫，山区、平原与湖区兼具，外八庙环绕四周。康熙、乾隆在此处理政务，山庄成为多民族交往的历史现场。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '上午游湖区与平原区，下午乘环山车看山区。\n可顺路看普宁寺、普陀宗乘之庙。\n夏季荷花盛开时最美。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '山庄面积大，穿舒适鞋。\n外八庙单独购票，安排半天。\n承德早晚温差大，备外套。')
WHERE id = 60;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '山海关是明长城东端的重要关隘，老龙头伸入渤海，形成长城入海的奇观。关城内的钟鼓楼、兵部分司署记录着戍边与商贸历史。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '上午游天下第一关，下午去老龙头看海。\n可顺路看孟姜女庙与角山长城。\n关城步行即可逛完。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '海边风大，夏季也备外套。\n老龙头与关城分开购票。\n旺季停车难，早到。')
WHERE id = 61;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '五大道聚集着上千座近代小洋楼，英式、法式、意式建筑并存。名人故居与梧桐街道，记录着天津开埠后的城市记忆。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '租自行车或乘马车慢慢逛，重点看睦南道、马场道。\n可进庆王府、静园等开放故居。\n傍晚光线适合拍街景。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '街区免费，故居单独购票。\n周末人多，骑行注意安全。\n天津小吃可去附近居民区找。')
WHERE id = 62;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '沈阳故宫是清初皇宫，大政殿与十王亭的布局体现八旗制度。满汉蒙建筑风格交融，见证清朝入关前的历史。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '从大清门进，依次看大政殿、崇政殿、凤凰楼。\n请讲解能理解八旗与宫廷制度。\n可顺路逛中街与张氏帅府。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '旺季提前预约。\n宫殿内禁止触摸文物。\n冬季沈阳寒冷，注意保暖。')
WHERE id = 63;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '伪满皇宫是末代皇帝溥仪在长春的宫廷旧址，同德殿、缉熙楼与防空洞记录着伪满洲国这段特殊历史。展览以实物与档案还原时代细节。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '按指示路线看同德殿、缉熙楼、勤民楼与东北沦陷史陈列馆。\n建议留半天，慢慢读展板。\n可顺路看长影旧址博物馆。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '展馆内保持安静。\n部分区域禁止拍照。\n长春冬季寒冷，注意保暖。')
WHERE id = 64;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '中央大街始建于1898年，面包石路面与欧式建筑记录着哈尔滨的开埠历史。马迭尔冰棍、俄式西餐与街头音乐，构成冰城的日常。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '从防洪纪念塔沿街走到经纬街，慢慢看建筑立面。\n傍晚灯亮后氛围最好。\n可顺路去圣索菲亚教堂与松花江边。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '冬季路面结冰，穿防滑鞋。\n马迭尔冰棍在冬天吃别有滋味。\n节假日人流大，注意随身物品。')
WHERE id = 65;

-- 原「趵突泉·大明湖」拆分：66 趵突泉、98 大明湖
UPDATE `attraction` SET
  culture_intro = '济南因泉得名，趵突泉三股水昼夜喷涌，被誉为天下第一泉。泉池边的观澜亭、漱玉泉与李清照纪念堂，串起泉城的文脉。',
  travel_guide = '从东门入园，先到泉池看三股水，再逛漱玉泉与李清照纪念堂。\n泉池周边柳荫浓密，上午光线最好。\n可沿护城河步行或乘船前往大明湖。',
  local_tips = '泉水常年 18℃ 左右，冬天水面会起雾。\n泉边地面湿滑，注意脚下。\n节假日排队入园，建议早到。'
WHERE id = 66;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '大明湖由城内众泉汇流而成，历下亭、铁公祠与超然楼环湖而立。「四面荷花三面柳，一城山色半城湖」说的就是这里。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '从南门进，沿湖走到历下亭，再往东看超然楼。\n傍晚登超然楼，亮灯后是济南最出片的夜景。\n夏季荷花盛开，可乘画舫游湖。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '景区免费开放，超然楼与游船单独收费。\n环湖一圈约 5 公里，步行约 1.5 小时。\n夏季蚊虫多，备驱蚊液。')
WHERE id = 98;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '栈桥始建于1892年，是青岛最早的码头，回澜阁伸入海中。冬季海鸥聚集，市民喂鸥、拍照，构成青岛的海滨日常。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '清晨或傍晚来，光线柔和人也少。\n沿栈桥走到回澜阁，再沿海边去小青岛。\n冬季看海鸥最佳。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '海边风大，注意保暖。\n礁石湿滑，不要下到危险区域。\n周边停车紧张，建议公共交通。')
WHERE id = 67;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '中山陵是孙中山先生的陵寝，392级台阶依紫金山而建，从博爱坊到祭堂层层递进。陵园与明孝陵、灵谷寺共同构成钟山风景区。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '从博爱坊步行上台阶到祭堂，约半小时。\n上午人少，秋季梧桐最美。\n可顺路游明孝陵与音乐台。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '陵寝免费，需提前预约。\n台阶多，穿舒适鞋。\n景区较大，可乘观光车。')
WHERE id = 68;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '瘦西湖以水见长，五亭桥、白塔、二十四桥沿湖展开。清代盐商的园林营建与扬州画派的雅集，让这片湖山带着文人气息。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '从南门进，沿长堤春柳走到五亭桥，再往二十四桥。\n春天桃花与垂柳最美。\n可乘画舫游湖。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '旺季提前预约。\n湖边风大，备外套。\n扬州早茶值得早起体验。')
WHERE id = 69;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '滕王阁因王勃《滕王阁序》闻名，屡毁屡建，如今的楼阁临赣江而立。登阁可望江天，感受落霞与孤鹜齐飞的意境。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '上午登阁看赣江，再逛阁内展览。\n傍晚可看江边日落。\n可顺路去万寿宫与八一广场。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '登阁需排队，错峰前往。\n南昌夏季炎热，备水。\n夜间灯光秀按季节开放。')
WHERE id = 70;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '橘子洲是湘江中的长岛，青年毛泽东曾在此写下《沁园春·长沙》。洲头的艺术雕塑与江天暮雪，是长沙的城市记忆。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '乘地铁到橘子洲站，步行或坐观光车到洲头。\n傍晚看湘江日落与两岸灯光。\n春季可看梅花与樱花。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '洲上步行距离长，可乘观光车。\n节假日人流大，提前预约。\n江边风大，注意保暖。')
WHERE id = 71;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '岳阳楼临洞庭湖而立，范仲淹《岳阳楼记》让它成为士人精神的象征。楼内楹联与历代重修碑记，记录着这座名楼的兴废。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '上午登楼看洞庭湖，再游汴河街与君山岛。\n雨季湖水浩渺，气势最足。\n可顺路吃洞庭湖鱼。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '登楼需排队，错峰前往。\n湖边风大，备外套。\n君山岛需乘船，预留时间。')
WHERE id = 72;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '陈家祠是广东陈氏宗族合建的祠堂，木雕、砖雕、石雕、灰塑与陶塑遍布梁架屋脊。如今作为广东民间工艺博物馆，展示岭南工艺精华。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '按展厅顺序看建筑装饰与民间工艺。\n建议留两小时，细看屋脊陶塑。\n可顺路去荔湾湖与永庆坊。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '室内禁止触摸展品。\n广州夏季炎热，备水。\n周边老城区适合步行。')
WHERE id = 73;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '晋祠是为纪念晋国开国诸侯唐叔虞而建的宗祠园林，圣母殿、鱼沼飞梁与难老泉并称三绝。宋代彩塑与古柏，让这里成为山西古建的缩影。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '从水镜台进，沿中轴线看圣母殿、鱼沼飞梁，再往难老泉。\n请讲解能理解宋代彩塑与建筑细节。\n可顺路去天龙山石窟。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '古建内禁止触摸。\n太原风大干燥，注意补水。\n景区较大，穿舒适鞋。')
WHERE id = 74;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '赵州桥由隋代工匠李春设计，是世界上现存最早的敞肩石拱桥。桥面车辙与栏板雕刻，记录着千年往来的行人车马。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '看桥体结构与栏板雕刻，再逛桥文化博物馆。\n建议留一小时。\n可顺路去柏林禅寺。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '桥面禁止攀爬护栏。\n石家庄冬季寒冷，注意保暖。\n景区周边餐饮较少，备水。')
WHERE id = 75;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '天一阁是明代范钦所建私家藏书楼，取天一生水之意。月湖周边书院、故居与园林相连，构成宁波城的文化客厅。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '上午看天一阁藏书楼与园林，下午沿月湖散步。\n可顺路去鼓楼与南塘老街。\n雨天园林更有韵味。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '藏书楼内保持安静。\n月湖免费开放，天一阁单独购票。\n宁波夏季湿热，备伞。')
WHERE id = 76;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '鼋头渚伸入太湖，因巨石形似鼋头得名。樱花季的长春桥、太湖仙岛与湖帆，让这里成为无锡的春日名片。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '春天看樱花，乘船去太湖仙岛。\n清晨入园避开人流。\n可顺路去蠡园与拈花湾。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '樱花季需提前预约。\n湖边风大，备外套。\n游船班次固定，留意末班。')
WHERE id = 77;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '大召寺由阿拉坦汗主持修建，是呼和浩特最早的藏传佛教寺院。银佛、龙雕与壁画被称为三绝，寺前塞上老街延续着旧城商业记忆。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '上午参观大召寺，再逛塞上老街与席力图召。\n请讲解能理解藏传佛教造像。\n可顺路去内蒙古博物院。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '寺内尊重宗教礼仪，不喧哗。\n呼和浩特风大干燥，注意补水。\n周边小吃可尝烧麦与奶茶。')
WHERE id = 78;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '中山桥被称为黄河第一桥，1909年建成，是兰州最早的铁桥。白塔山上的白塔与山下的黄河、铁桥构成兰州城市封面。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '傍晚从中山桥步行过黄河，再登白塔山看城市夜景。\n可顺路去黄河母亲雕像与水车博览园。\n夜晚灯光适合拍照。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '桥上人流大，注意随身物品。\n登山台阶多，穿舒适鞋。\n兰州早晚温差大，备外套。')
WHERE id = 79;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '普陀山是观音菩萨道场，普济寺、法雨寺、慧济寺三大寺分布全岛。海天之间香火不断，岛上的渔村与素斋也带着海岛气息。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '乘船到普陀山，先游普济寺，再乘索道上佛顶山慧济寺，最后去法雨寺与南海观音。\n两天游可住岛上。\n清晨听早课氛围最好。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '船票与门票分开，提前购票。\n岛上交通以巴士为主。\n寺院内注意着装与礼仪。')
WHERE id = 80;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '洪崖洞依嘉陵江崖壁而建，吊脚楼层层叠叠，夜晚灯火与江景相映。这里既有巴渝传统建筑，也有重庆码头文化的生活气息。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '傍晚从顶层往下逛，等到灯亮后到江边拍全景。\n千厮门大桥是拍洪崖洞的好位置。\n可顺路去解放碑与朝天门。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '节假日人流极大，注意安全。\n电梯排队久，可走楼梯。\n江边风大，备外套。')
WHERE id = 81;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '武侯祠是君臣合祀的祠庙，刘备殿与诸葛亮殿并列。红墙夹道、竹影婆娑，三国故事与成都的慢生活在这里相遇。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '从大门进，依次看刘备殿、诸葛亮殿、三义庙与红墙竹影。\n可顺路逛锦里。\n上午人少，适合拍照。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '锦里小吃价格偏高。\n祠内禁止触摸文物。\n成都夏季闷热，备水。')
WHERE id = 82;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '成都大熊猫繁育研究基地是迁地保护与科研机构，竹林、产房与活动场还原大熊猫的生活环境。清晨的幼崽活动与饲养员投喂，是最受欢迎的时段。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '早上七点半开园就进，先看月亮产房与太阳产房。\n按园区指示牌步行或乘观光车。\n可顺路去熊猫塔。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '旺季提前预约。\n保持安静，不使用闪光灯。\n不要投喂动物。')
WHERE id = 83;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '石林是喀斯特地貌的代表，石峰如林，撒尼族阿诗玛的传说在这里流传。火把节期间，彝族村寨的歌舞与篝火让石林有了烟火气。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '大石林看核心石峰，小石林看阿诗玛石。\n可乘电瓶车串联景区。\n建议请讲解，听懂石头背后的传说。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '石径狭窄，穿防滑鞋。\n云南紫外线强，备防晒。\n火把节期间人多，提前安排。')
WHERE id = 84;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '崇圣寺三塔建于南诏、大理国时期，主塔千寻塔与两座小塔呈鼎立之势。背靠苍山、面朝洱海，是大理历史的地标。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '上午看三塔与崇圣寺，下午沿洱海骑行。\n三塔倒影公园适合拍全景。\n可顺路去大理古城。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '景区台阶多，穿舒适鞋。\n大理紫外线强，备防晒。\n洱海边风大，注意保暖。')
WHERE id = 85;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '青岩古镇是明代屯堡古镇，石城墙、石巷与状元府保存完整。古镇内的教堂、寺庙与民居并存，记录着黔中多民族交往的历史。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '从南门进，沿主街走到状元府、文昌阁。\n可尝青岩猪脚与玫瑰糖。\n傍晚游客散去后更适合拍照。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '古镇内石板路湿滑，穿防滑鞋。\n贵阳多雨，备伞。\n节假日人多，早到。')
WHERE id = 86;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '梵净山是武陵山脉主峰，红云金顶与蘑菇石立于云海之上。作为弥勒道场，山间寺院与朝山信众延续着佛教传统。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '乘索道上山，再步行登红云金顶，全程约一天。\n清晨云海概率高。\n可顺路去寨沙侗寨。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '金顶台阶陡，量力而行。\n山顶气温低，备外套。\n旺季预约门票与索道。')
WHERE id = 87;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '大昭寺是藏传佛教信仰中心，供奉释迦牟尼十二岁等身像。寺前八廓街转经的人流日夜不息，酥油灯与诵经声构成拉萨的日常。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '上午参观大昭寺，下午沿八廓街转经。\n请讲解能理解壁画与佛像故事。\n可顺路去布达拉宫广场。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '寺内禁止拍照的区域遵守标识。\n高原反应注意休息。\n尊重转经方向与宗教礼仪。')
WHERE id = 88;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '纳木错是西藏三大圣湖之一，念青唐古拉雪山倒映湖中。藏族牧民在湖畔放牧，转湖信众沿湖行走，圣湖承载着信仰与自然敬畏。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '从拉萨出发约四小时车程，可一日往返或住湖边看星空。\n扎西半岛适合看日出日落。\n海拔高，行动放缓。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '海拔约4700米，注意高反。\n湖边昼夜温差极大，备厚衣。\n不要随意进入牧民草场。')
WHERE id = 89;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '镇北堡由明清古堡改建而成，荒凉的土墙与城门成为众多电影的取景地。《大话西游》的城楼与月亮门，让这里成为影迷打卡地。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '先看清城堡，再逛明城堡与老银川一条街。\n可租服装拍照。\n傍晚光线最适合拍土墙。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '西北风沙大，备口罩和墨镜。\n影城内项目另收费，按需选择。\n夏季日照强，注意防晒。')
WHERE id = 90;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '新疆国际大巴扎是乌鲁木齐的中亚风情市集，干果、地毯、乐器与手工艺品汇聚。傍晚的歌舞与烤肉香气，让这里充满市井活力。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '傍晚来逛，先看建筑再进市场。\n可买干果与手工艺品，记得砍价。\n可顺路去二道桥。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '市场人多，注意随身物品。\n购买前确认价格与重量。\n尊重当地民族习俗。')
WHERE id = 91;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '沙坡头位于腾格里沙漠东南缘，黄河穿行而过。羊皮筏子、滑沙与治沙草方格，记录着人与沙漠共处的方式。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '上午玩滑沙与黄河项目，下午看沙漠星空或骑骆驼。\n可乘黄河飞索过河。\n傍晚沙丘光线最美。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '沙漠日晒强，备防晒和足量水。\n项目另收费，注意安全提示。\n风沙大时保护相机。')
WHERE id = 92;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '青秀山是南宁的城市绿肺，苏铁园、兰园与观音禅寺散布山间。清晨市民登山晨练，傍晚可俯瞰邕江与城市天际线。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '乘观光车到山顶，再步行下山看各园。\n春季桃花与兰花盛开。\n可顺路去南湖公园。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '南宁夏季湿热，备水和驱蚊液。\n山路多，穿舒适鞋。\n景区较大，预留半天。')
WHERE id = 93;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '天涯海角是海南岛南端的海岸景区，天涯石、海角石与南天一柱立于海边。古人视此地为天之尽头，如今是三亚的热带海岸名片。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '沿海边步道走到天涯石与海角石，可乘电瓶车节省体力。\n傍晚看日落最美。\n可顺路去南山文化旅游区。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '海边紫外线强，备防晒。\n礁石湿滑，注意脚下。\n旺季人多，早到。')
WHERE id = 94;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '海口骑楼老街是南洋华侨回乡建造的骑楼街区，中山路、得胜沙路一带保留着巴洛克与南洋风格立面。老爸茶、文昌鸡与市井生活，是老街的日常。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '从中山路步行逛骑楼建筑，再找一家老爸茶店坐下。\n傍晚灯亮后适合拍照。\n可顺路去钟楼与海甸岛。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '海口夏季炎热多雨，备伞。\n老街部分建筑年久，注意安全。\n老爸茶店按需点单。')
WHERE id = 95;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '天门山因天门洞得名，盘山公路九十九道弯与高山索道是工程奇观。山间栈道贴崖而行，云雾中可见张家界峰林。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '乘索道上山，走西线玻璃栈道与鬼谷栈道，再下到天门洞。\n全程约一天。\n旺季索道排队久，早出发。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '玻璃栈道需穿鞋套。\n山顶气温低，备外套。\n恐高者量力而行。')
WHERE id = 96;

UPDATE `attraction` SET
  culture_intro = COALESCE(NULLIF(culture_intro, ''), '稻城亚丁被称作蓝色星球最后一片净土，仙乃日、央迈勇、夏诺多吉三座神山环抱湖泊与草甸。藏族牧民与朝山者在此延续着对神山的敬畏。'),
  travel_guide = COALESCE(NULLIF(travel_guide, ''), '长线看牛奶海与五色海，短线看珍珠海。\n建议住亚丁村或香格里拉镇，分两天游览。\n清晨洛绒牛场光线最好。'),
  local_tips = COALESCE(NULLIF(local_tips, ''), '海拔高，注意高反，行动放缓。\n天气多变，备雨衣和保暖衣。\n景区内餐饮少，备干粮和水。')
WHERE id = 97;
