SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for building
-- ----------------------------
DROP TABLE IF EXISTS `building`;
CREATE TABLE `building`  (
  `building_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '宿舍楼ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '宿舍楼名称',
  `sort` int NOT NULL COMMENT '排序',
  PRIMARY KEY (`building_id`) USING BTREE,
  UNIQUE INDEX `building_id`(`building_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '宿舍楼' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of building
-- ----------------------------
INSERT INTO `building` VALUES ('a293479e-8966-480b-b1e2-f80a04f12763', '研究所公寓', 3);
INSERT INTO `building` VALUES ('bc8646eb-e06d-41cb-b2b8-4128676cfb0d', '宿舍2号楼', 2);
INSERT INTO `building` VALUES ('be391c0d-a5e0-499e-8c23-59f1564a398e', '宿舍1号楼', 1);

-- ----------------------------
-- Table structure for menu
-- ----------------------------
DROP TABLE IF EXISTS `menu`;
CREATE TABLE `menu`  (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '菜单名称',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '组件路径',
  `menu_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '菜单类型（M目录 C菜单）',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '#' COMMENT '菜单图标',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '菜单权限表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of menu
-- ----------------------------
INSERT INTO `menu` VALUES (1, '系统管理', 0, 99, 'system', NULL, 'M', '系统管理', '2025-12-24 18:07:06');
INSERT INTO `menu` VALUES (2, '用户管理', 1, 1, 'user', 'system/user/index', 'C', '用户管理', '2025-12-24 18:07:05');
INSERT INTO `menu` VALUES (3, '角色管理', 1, 2, 'role', 'system/role/index', 'C', '角色管理', '2025-12-24 18:07:04');
INSERT INTO `menu` VALUES (4, '菜单管理', 1, 3, 'menu', 'system/menu/index', 'C', '菜单管理', '2025-12-24 18:07:03');
INSERT INTO `menu` VALUES (5, '快递站点管理', 0, 1, 'station', 'take/station/index', 'C', '快递站点管理', '2025-12-29 12:12:18');
INSERT INTO `menu` VALUES (6, '宿舍楼管理', 0, 2, 'building', 'take/building/index', 'C', '宿舍楼管理', '2025-12-30 14:19:34');
INSERT INTO `menu` VALUES (7, '包裹规格管理', 0, 3, 'size', 'take/size/index', 'C', '包裹规格管理', '2025-12-30 15:04:17');
INSERT INTO `menu` VALUES (8, '配送员管理/审核', 0, 4, 'rider', 'take/rider/index', 'C', '配送员管理和审核', '2025-12-31 10:57:40');
INSERT INTO `menu` VALUES (9, '订单管理', 0, 5, 'order', 'take/order/index', 'C', '订单管理', '2026-01-02 13:28:03');
INSERT INTO `menu` VALUES (10, '通知公告管理', 0, 6, 'notice', 'take/notice/index', 'C', '通知公告管理', '2026-01-06 11:04:47');

-- ----------------------------
-- Table structure for notice
-- ----------------------------
DROP TABLE IF EXISTS `notice`;
CREATE TABLE `notice`  (
  `notice_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '通知公告ID',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '标题',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '内容',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发布时间',
  PRIMARY KEY (`notice_id`) USING BTREE,
  UNIQUE INDEX `notice_id`(`notice_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '通知公告' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of notice
-- ----------------------------
INSERT INTO `notice` VALUES ('0c92821f-75bb-41bc-a1ad-ebd911036512', '新增“近邻宝”快递柜代取服务', '<p><span style=\"color: rgb(68, 68, 68); font-size: 14px;\">好消息！即日起平台正式开通南校区近邻宝快递柜代取服务。</span></p>', '2025-12-27 22:13:19');
INSERT INTO `notice` VALUES ('5149aa1f-a961-475b-8453-70758bc1e8f0', '关于规范快递代取下单地址填写的说明', '<p><span style=\"color: rgb(68, 68, 68); background-color: rgb(255, 255, 255); font-size: 14px;\">为了确保快递准确送达，请同学们在下单时务必填写详细的楼栋和寝室号。对于地址模糊的订单，骑手有权拒绝接单。</span></p>', '2025-12-27 22:13:09');
INSERT INTO `notice` VALUES ('b000c549-40ca-41a8-ab04-544bd18b18a1', '关于系统服务器升级维护的通知', '<p><span style=\"color: rgb(68, 68, 68); background-color: rgb(255, 255, 255); font-size: 14px;\">尊敬的用户：<br><br>为了提供更优质的服务，我们将于 </span><span style=\"color: rgb(68, 68, 68); background-color: rgb(255, 255, 255); font-size: 14px;\"><strong>2025年12月28日 02:00 - 06:00</strong></span><span style=\"color: rgb(68, 68, 68); background-color: rgb(255, 255, 255); font-size: 14px;\"> 进行系统升级。<br>届时快递代取下单、充值等功能将暂停使用。<br><br>给您带来的不便敬请谅解！</span></p>', '2025-12-27 22:09:59');
INSERT INTO `notice` VALUES ('db05466e-25aa-4597-bb28-cb77e86243a5', '近期校园电信诈骗高发，请注意防范', '<p><span style=\"color: rgb(68, 68, 68); background-color: rgb(255, 255, 255); font-size: 14px;\">近期接到多起同学反馈遇到冒充快递客服理赔的诈骗电话。<br>骗子通常声称快递丢失，需要进行双倍赔付，诱导同学扫描二维码或点击链接。<br><br></span><span style=\"color: rgb(68, 68, 68); background-color: rgb(255, 255, 255); font-size: 14px;\"><strong>郑重提醒：</strong></span><span style=\"color: rgb(68, 68, 68); background-color: rgb(255, 255, 255); font-size: 14px;\">凡是要求转账、提供验证码的均为诈骗！</span></p>', '2025-12-27 22:11:04');

-- ----------------------------
-- Table structure for order
-- ----------------------------
DROP TABLE IF EXISTS `order`;
CREATE TABLE `order`  (
  `order_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '订单ID',
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '取件码',
  `size_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '包裹规格ID',
  `building_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '宿舍楼ID',
  `station_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '快递站点ID',
  `room` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '寝室号/联系人',
  `total_price` decimal(10, 2) NOT NULL COMMENT '总价',
  `status` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '待接单' COMMENT '状态',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '备注',
  `user_id` int NULL DEFAULT NULL COMMENT '下单用户ID',
  `rider_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '配送员ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '提交时间',
  PRIMARY KEY (`order_id`) USING BTREE,
  UNIQUE INDEX `order_id`(`order_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '订单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order
-- ----------------------------
INSERT INTO `order` VALUES ('OR202601041458253', '3-963', '0d6c8a8e-a933-4f9c-a45b-700703d8a0c8', 'be391c0d-a5e0-499e-8c23-59f1564a398e', '4a025617-60a8-4578-ab4d-d630cf5a109c', '307', 13.00, '已取消', '放在门口就行', 3, NULL, '2026-01-04 14:58:25');
INSERT INTO `order` VALUES ('OR202601051058543', '3-963', '07bcd673-d05c-4e8d-95fb-373fc39e067f', 'be391c0d-a5e0-499e-8c23-59f1564a398e', '4a025617-60a8-4578-ab4d-d630cf5a109c', '李四', 8.00, '已完成', '放在门口就行', 3, 'b88122f3-0b16-4da2-ada0-5e944efcfb0a', '2026-01-05 10:58:54');
INSERT INTO `order` VALUES ('OR202601051100473', '632456', '0d6c8a8e-a933-4f9c-a45b-700703d8a0c8', 'bc8646eb-e06d-41cb-b2b8-4128676cfb0d', 'b4f0c397-76de-44ee-b4c6-54728f2fd4f5', '李四', 13.00, '待接单', '不要敲门', 3, NULL, '2026-01-05 11:00:48');

-- ----------------------------
-- Table structure for rider
-- ----------------------------
DROP TABLE IF EXISTS `rider`;
CREATE TABLE `rider`  (
  `rider_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '配送员ID',
  `real_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '真实姓名',
  `id_card` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '身份证号',
  `phone` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '手机号码',
  `student_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '学号',
  `student_card_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '学生证',
  `id_card_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '身份证',
  `status` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '审核中' COMMENT '认证状态',
  `user_id` int NOT NULL COMMENT '用户ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '认证提交时间',
  PRIMARY KEY (`rider_id`) USING BTREE,
  UNIQUE INDEX `rider_id`(`rider_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '配送员' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of rider
-- ----------------------------
INSERT INTO `rider` VALUES ('b88122f3-0b16-4da2-ada0-5e944efcfb0a', '张三', '452123198106211095', '13699998888', '169863', '/profile/upload/学生证.png_19e64f2e585b4c789b4bcd11fd3e7855.png', '/profile/upload/身份证.png_e7ef941c2f0c4bbcb760d0241fe87e44.png', '已通过', 2, '2025-12-31 16:44:19');

-- ----------------------------
-- Table structure for role
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role`  (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '角色名称',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '角色信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of role
-- ----------------------------
INSERT INTO `role` VALUES (1, 'admin', 1, '1', '2025-12-24 18:06:43');
INSERT INTO `role` VALUES (2, 'user', 2, '1', '2025-12-24 18:06:45');
INSERT INTO `role` VALUES (3, 'rider', 3, '1', '2025-12-31 16:40:15');

-- ----------------------------
-- Table structure for role_menu
-- ----------------------------
DROP TABLE IF EXISTS `role_menu`;
CREATE TABLE `role_menu`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '角色和菜单关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of role_menu
-- ----------------------------

-- ----------------------------
-- Table structure for size
-- ----------------------------
DROP TABLE IF EXISTS `size`;
CREATE TABLE `size`  (
  `size_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '包裹规格ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '规格名称',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '描述',
  `price` decimal(10, 2) NOT NULL COMMENT '加价',
  PRIMARY KEY (`size_id`) USING BTREE,
  UNIQUE INDEX `size_id`(`size_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '包裹规格' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of size
-- ----------------------------
INSERT INTO `size` VALUES ('07bcd673-d05c-4e8d-95fb-373fc39e067f', '中件', '微波炉大小以内', 3.00);
INSERT INTO `size` VALUES ('0d6c8a8e-a933-4f9c-a45b-700703d8a0c8', '大件', '重量>5kg或超大', 8.00);
INSERT INTO `size` VALUES ('cedd9d9f-4772-40bb-8105-255f6927a7ca', '小件', '鞋盒大小以内', 0.00);

-- ----------------------------
-- Table structure for station
-- ----------------------------
DROP TABLE IF EXISTS `station`;
CREATE TABLE `station`  (
  `station_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '站点ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '站点名称',
  `sort` int NOT NULL COMMENT '排序',
  PRIMARY KEY (`station_id`) USING BTREE,
  UNIQUE INDEX `station_id`(`station_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '快递站点' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of station
-- ----------------------------
INSERT INTO `station` VALUES ('4a025617-60a8-4578-ab4d-d630cf5a109c', '菜鸟驿站', 1);
INSERT INTO `station` VALUES ('5451c98f-238b-449d-b157-2612d40d22a8', '城市住行', 5);
INSERT INTO `station` VALUES ('a4af5149-3781-45fe-a14d-4fa065491ab4', '近邻宝', 4);
INSERT INTO `station` VALUES ('b39ad45b-3769-44e6-a26d-fff5f3678f32', '顺丰直营点', 2);
INSERT INTO `station` VALUES ('b4f0c397-76de-44ee-b4c6-54728f2fd4f5', '丰巢柜', 3);

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '用户昵称',
  `sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '用户性别（0男 1女）',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '头像',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '密码',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `balance` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '账户余额',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '用户信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'admin', '系统管理员', '1', '', 'admin123', '2025-12-15 00:05:41', 0.00);
INSERT INTO `user` VALUES (2, '张三', '张三', '0', '', '123456', '2025-12-28 15:47:25', 115.60);
INSERT INTO `user` VALUES (3, '李四', '李四', NULL, '', '123456', '2026-01-04 13:14:06', 9.00);

-- ----------------------------
-- Table structure for user_role
-- ----------------------------
DROP TABLE IF EXISTS `user_role`;
CREATE TABLE `user_role`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '用户和角色关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_role
-- ----------------------------
INSERT INTO `user_role` VALUES (1, 1);
INSERT INTO `user_role` VALUES (2, 3);
INSERT INTO `user_role` VALUES (3, 2);

SET FOREIGN_KEY_CHECKS = 1;
