use imooc_db
;
USE order_db;

CREATE TABLE order_customer_addr (
	customer_addr_id INT UNSIGNED AUTO_INCREMENT NOT NULL COMMENT '自增主键ID',
	customer_id INT UNSIGNED NOT NULL COMMENT 'customer_login表的自增ID',
	zip INT NOT NULL COMMENT '邮编',
	province INT NOT NULL COMMENT '地区表中省份的id',
	city INT NOT NULL COMMENT '地区表中城市的id',
	district INT NOT NULL COMMENT '地区表中的区id',
	address VARCHAR (200) NOT NULL COMMENT '具体的地址门牌号',
	is_default TINYINT NOT NULL COMMENT '是否默认',
	modified_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
	PRIMARY KEY pk_customeraddid (customer_addr_id)
) ENGINE = INNODB COMMENT '用户地址表';

CREATE TABLE region_info (
	region_id SMALLINT NOT NULL AUTO_INCREMENT COMMENT '主键id',
	parent_id SMALLINT NOT NULL DEFAULT 0 COMMENT '上级地区id',
	region_name VARCHAR (150) NOT NULL COMMENT '城市名称',
	region_level TINYINT (1) NOT NULL COMMENT '级别',
  PRIMARY KEY (region_id)
) ENGINE = INNODB COMMENT '地区信息表';

CREATE TABLE order_master (
	order_id INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '订单ID',
	order_sn BIGINT UNSIGNED NOT NULL COMMENT '订单编号 yyyymmddnnnnnnnn',
	customer_id INT UNSIGNED NOT NULL COMMENT '下单人ID',
	shipping_user VARCHAR (20) NOT NULL COMMENT '收货人姓名',
	province SMALLINT NOT NULL COMMENT '收货人所在省',
	city SMALLINT NOT NULL COMMENT '收货人所在市',
	district SMALLINT NOT NULL COMMENT '收货人所在区',
	address VARCHAR (100) NOT NULL COMMENT '收货人详细地址',
	payment_method TINYINT NOT NULL COMMENT '支付方式:1现金,2余额,3网银,4支付宝,5微信',
	order_money DECIMAL (8, 2) NOT NULL COMMENT '订单金额',
	district_money DECIMAL (8, 2) NOT NULL DEFAULT 0.00 COMMENT '优惠金额',
	shipping_money DECIMAL (8, 2) NOT NULL DEFAULT 0.00 COMMENT '运费金额',
	payment_money DECIMAL (8, 2) NOT NULL DEFAULT 0.00 COMMENT '支付金额',
	shipping_comp_name VARCHAR (10) COMMENT '快递公司名称',
	shipping_sn VARCHAR (50) COMMENT '快递单号',
	create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '下单时间',
	shipping_time datetime COMMENT '发货时间',
	pay_time datetime COMMENT '支付时间',
	receive_time datetime COMMENT '收货时间',
	order_status TINYINT NOT NULL DEFAULT 0 COMMENT '订单状态',
	order_point INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '订单积分',
	invoice_title VARCHAR (100) COMMENT '发票抬头',
	modified_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
	PRIMARY KEY pk_orderid (order_id)
) ENGINE = INNODB COMMENT '订单主表';

/*
insert into order_master(order_sn,customer_id,shipping_user,province,city,district,address,payment_method,order_money)


 */
CREATE TABLE order_detail (
	order_detail_id INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增主键ID,订单详情表ID',
	order_id INT UNSIGNED NOT NULL COMMENT '订单表ID',
	product_id INT UNSIGNED NOT NULL COMMENT '订单商品ID',
	product_name VARCHAR (50) NOT NULL COMMENT '商品名称',
	product_cnt INT NOT NULL DEFAULT 1 COMMENT '购买商品数量',
	product_price DECIMAL (8, 2) NOT NULL COMMENT '购买商品单价',
	average_cost DECIMAL (8, 2) NOT NULL DEFAULT 0.00 COMMENT '平均成本价格',
	weight FLOAT COMMENT '商品重量',
	fee_money DECIMAL (8, 2) NOT NULL DEFAULT 0.00 COMMENT '优惠分摊金额',
	w_id INT UNSIGNED NOT NULL COMMENT '仓库ID',
	modified_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
	PRIMARY KEY pk_orderdetailid (order_detail_id)
) ENGINE = INNODB COMMENT '订单详情表';

/*
insert into order_detail(order_id,product_id,product_name,product_cnt,product_price,w_id)
 */
CREATE TABLE order_cart (
	cart_id INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '购物车ID',
	customer_id INT UNSIGNED NOT NULL COMMENT '用户ID',
	product_id INT UNSIGNED NOT NULL COMMENT '商品ID',
	product_amount INT NOT NULL COMMENT '加入购物车商品数量',
	price DECIMAL (8, 2) NOT NULL COMMENT '商品价格',
	add_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '加入购物车时间',
	modified_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
	PRIMARY KEY pk_cartid (cart_id)
) ENGINE = INNODB COMMENT '购物车表';

CREATE TABLE warehouse_info (
	w_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '仓库ID',
	warehouse_sn CHAR (5) NOT NULL COMMENT '仓库编码',
	warehouse_name VARCHAR (10) NOT NULL COMMENT '仓库名称',
	warehouse_phone VARCHAR (20) NOT NULL COMMENT '仓库电话',
	contact VARCHAR (10) NOT NULL COMMENT '仓库联系人',
	province SMALLINT NOT NULL COMMENT '省',
	city SMALLINT NOT NULL COMMENT '市',
	district SMALLINT NOT NULL COMMENT '区',
	address VARCHAR (100) NOT NULL COMMENT '仓库地址',
	warehouse_status TINYINT NOT NULL DEFAULT 1 COMMENT '仓库状态:0禁用,1启用',
	modified_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
	PRIMARY KEY pk_wid (w_id)
) ENGINE = INNODB COMMENT '仓库信息表';

/*
insert into warehouse_info(warehouse_sn,warehouse_name,warehouse_phone,contact,province,city,district,address)
	values('02001','北京一号货仓','76883333','张飞',2,52,3440,''),
		  ('02002','北京二号货仓','87654444','赵云',2,52,3440,''),
		  ('06001','广州一号货仓','76883333','诸葛',6,86,15986,'');


 */
CREATE TABLE warehouse_proudct (
	wp_id INT UNSIGNED NOT NULL auto_increment COMMENT '商品库存ID',
	product_id INT UNSIGNED NOT NULL COMMENT '商品id',
	w_id SMALLINT UNSIGNED NOT NULL COMMENT '仓库ID',
	currnet_cnt INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '当前商品数量',
	lock_cnt INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '当前占用数据',
	in_transit_cnt INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '在途数据',
	average_cost DECIMAL (8, 2) NOT NULL DEFAULT 0.00 COMMENT '移动加权成本',
	modified_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
	PRIMARY KEY pk_wpid (wp_id)
) ENGINE = INNODB COMMENT '商品库存表';

CREATE TABLE shipping_info (
	ship_id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
	ship_name VARCHAR (20) NOT NULL COMMENT '物流公司名称',
	ship_contact VARCHAR (20) NOT NULL COMMENT '物流公司联系人',
	telphone VARCHAR (20) NOT NULL COMMENT '物流公司联系电话',
	price DECIMAL (8, 2) NOT NULL DEFAULT 0.00 COMMENT '配送价格',
	modified_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
	PRIMARY KEY pk_shipid (ship_id)
) ENGINE = INNODB COMMENT '物流公司信息表';

create table customer_login(
customer_id int unsigned AUTO_INCREMENT NOT NULL comment '用户ID',
login_name varchar(20) not null comment '用户登陆名',
password char(32) not null comment 'md5加密的密码',
user_stats tinyint not null default 1 comment '用户状态',
area_id int not null default 10000 comment '用户所在地区',
modified_time timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP 
ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
primary key pk_customerid (customer_id)
) engine = innodb comment='用户登陆表'
;


create table customer_inf(
customer_inf_id int unsigned AUTO_INCREMENT not null comment '自增主键ID',
customer_id int unsigned not null comment 'customer_login表的自增ID',
customer_name varchar(20) not null comment '用户真实姓名',
identity_card_type tinyint not null default 1 comment '证件类型：1 身份证,2军官证,3护照',
identity_card_no varchar(20) comment '证件号码',
mobile_phone int unsigned comment '手机号',
customer_email varchar(50) comment '邮箱',
gender char(1) comment '性别',
user_point int not null default 0 comment '用户积分',
register_time timestamp not null comment '注册时间',
birthday datetime comment '会员生日',
customer_level tinyint not null default 1 comment '会员级别:1普通会员,2青铜会员,3白银会员,4黄金会员,5钻石会员',
user_money decimal(8,2) not null default 0.00 comment '用户余额',
modified_time timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
primary key pk_custoemrinfid (customer_inf_id)
) engine=innodb comment '用户信息表'
;

insert into customer_inf(customer_id,customer_name,customer_email,register_time)
SELECT 	customer_id,login_name,concat(login_name,'@','imooc.com'),ADDDATE(now(),INTERVAL RAND()*1000000 SECOND)
FROM 	customer_login;

create table customer_level_inf(
customer_level tinyint not null auto_increment comment '会员级别ID',
level_name varchar(10) not null comment '会员级别名称',
min_point int unsigned not null default 0 comment '该级别最低积分',
max_point int unsigned not null default 0 comment '该级别最高积分',
modified_time timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP on UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
primary key pk_levelid (customer_level)
) engine=innodb comment '用户级别信息表'
;

INSERT INTO `customer_level_inf`(`level_name`,`min_point`,`max_point`)
VALUES ('青铜级','0','10000'),('白银级',10001,100000),('黄金级',100001,300000),('神级',300001,999999999);





CREATE TABLE customer_login_log(
login_id int unsigned not null AUTO_INCREMENT comment '登录日志ID',
customer_id int unsigned not null comment '登录用户ID',
login_time timestamp not null comment '用户登录时间',
login_ip int unsigned not null comment '登录IP',
login_type tinyint not null comment '登录类型:0未成功 1成功',
primary key pk_loginid (login_id)
)engine=innodb comment '用户登录日志表'
;

CREATE TABLE customer_point_log(
point_id int unsigned not null AUTO_INCREMENT comment '积分日志ID',
customer_id int unsigned not null comment '用户ID',
source tinyint unsigned not null comment '积分来源:0订单,1登录,2活动',
refer_number int unsigned not null default 0 comment '积分来源相关编号',
change_point SMALLINT not null  default 0 comment '变更积分数',
create_time timestamp not null comment '积分日志生成时间',
primary key pk_pointid (point_id)
)engine=innodb comment '用户积分日志表'
;

CREATE TABLE customer_balance_log(
balance_id int unsigned not null AUTO_INCREMENT comment '余额日志id',
customer_id int unsigned not null comment '用户ID',
source tinyint unsigned not null default 1 comment '记录来源:1订单,2退货单',
source_sn int unsigned not null comment '相关单据ID',
create_time timestamp not null default current_timestamp comment '记录生成时间',
amount decimal(8,2) not null default 0.00 comment '变动金额',
primary key pk_balanceid (balance_id)
)engine=innodb comment '用户余额变动表'
;

CREATE TABLE product_brand_info (
      brand_id SMALLINT UNSIGNED AUTO_INCREMENT NOT NULL COMMENT '品牌ID',
      brand_name VARCHAR (50) NOT NULL COMMENT '品牌名称',
      telephone VARCHAR (50) NOT NULL COMMENT '联系电话',
      brand_web VARCHAR (100) COMMENT '品牌网站',
      brand_logo VARCHAR (100) COMMENT '品牌logo URL',
      brand_desc VARCHAR (150) COMMENT '品牌描述',
      brand_status TINYINT NOT NULL DEFAULT 0 COMMENT '品牌状态,0禁用,1启用',
      brand_order TINYINT NOT NULL DEFAULT 0 COMMENT '排序',
      modified_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
      PRIMARY KEY pk_brandid (brand_id)
) ENGINE = INNODB COMMENT '品牌信息表';

INSERT INTO product_brand_info (
      brand_name,
      telephone,
      brand_status
)
VALUES
      ('探路者', '', 1),
      ('Columbia', '', 1),
      ('骆驼', '', 1),
      ('凯乐石', '', 1),
      ('北极狐', '', 1),
      ('TheNorthFace', '', 1),
      ('SALOMON', '', 1),
      ('LOWA', '', 1),
      ('伯希和', '', 1),
      ('诺诗兰', '', 1),
      ('Jack Wolfskin', '', 1),
      ('金狐狸', '', 1),
      ('JACK&JONES', '', 1),
      ('Lee', '', 1),
      ('太平鸟', '', 1),
      ('李宁', '', 1),
      ('NB', '', 1);

CREATE TABLE product_category (
      category_id SMALLINT UNSIGNED AUTO_INCREMENT NOT NULL COMMENT '分类ID',
      category_name VARCHAR (10) NOT NULL COMMENT '分类名称',
      category_code VARCHAR (10) NOT NULL COMMENT '分类编码',
      parent_id SMALLINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '父分类ID',
      category_level TINYINT NOT NULL DEFAULT 1 COMMENT '分类层级',
      category_status TINYINT NOT NULL DEFAULT 1 COMMENT '分类状态',
      modified_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
      PRIMARY KEY pk_categoryid (category_id)
) ENGINE = INNODB COMMENT '商品分类表';

-- 一级分类
INSERT INTO product_category (
      category_name,
      category_code,
      parent_id,
      category_level
)
VALUES
      ('女装', '01', 0, 1),
      ('男装', '02', 0, 1),
      ('内衣', '03', 0, 1),
      ('女鞋', '04', 0, 1),
      ('男鞋', '05', 0, 1),
      ('户外', '06', 0, 1),
      ('运动', '07', 0, 1),
      ('童装', '08', 0, 1);

-- 二级分类
INSERT INTO product_category (
      category_name,
      category_code,
      parent_id,
      category_level
)
VALUES
      ('女士裙装', '0101', 1, 2),
      ('女士上装', '0102', 1, 2),
      ('女士下装', '0103', 1, 2);

INSERT INTO product_category (
      category_name,
      category_code,
      parent_id,
      category_level
)
VALUES
      ('男士上装', '0201', 2, 2),
      ('男士下装', '0202', 2, 2);

INSERT INTO product_category (
      category_name,
      category_code,
      parent_id,
      category_level
)
VALUES
      ('户外鞋服', '0601', 6, 2),
      ('户外装备', '0602', 6, 2),
      ('垂钓用品', '0603', 6, 2);

-- 三级分类
INSERT INTO product_category (
      category_name,
      category_code,
      parent_id,
      category_level
)
VALUES
      ('连衣裙', '010101', 9, 3),
      ('蕾丝裙', '010102', 9, 3),
      ('套装裙', '010103', 9, 3),
      (
            '棉麻连衣裙',
            '010104',
            9,
            3
      ),
      ('针织裙', '010105', 9, 3),
      ('a字裙', '010106', 9, 3),
      ('长裙', '010107', 9, 3);

INSERT INTO product_category (
      category_name,
      category_code,
      parent_id,
      category_level
)
VALUES
      ('针织衫', '010201', 10, 3),
      ('衬衫', '010202', 10, 3),
      ('T恤', '010203', 10, 3),
      ('雪纺衫', '010204', 10, 3),
      ('外套', '010205', 10, 3),
      ('小西装', '010206', 10, 3),
      ('风衣', '010207', 10, 3);

INSERT INTO product_category (
      category_name,
      category_code,
      parent_id,
      category_level
)
VALUES
      ('休闲裤', '010301', 11, 3),
      ('牛仔裤', '010302', 11, 3),
      ('连体裤', '010303', 11, 3),
      ('哈伦裤', '010304', 11, 3),
      ('九分裤', '010305', 11, 3),
      ('小脚裤', '010306', 11, 3),
      ('打底裤', '010307', 11, 3);

INSERT INTO product_category (
      category_name,
      category_code,
      parent_id,
      category_level
)
VALUES
      ('夹克', '020101', 19, 3),
      ('衬衫', '020102', 19, 3),
      ('卫衣', '020103', 19, 3),
      ('风衣', '020104', 19, 3),
      ('皮衣', '020105', 19, 3),
      (
            '西服套装',
            '020106',
            19,
            3
      ),
      ('毛衣', '020107', 19, 3);

INSERT INTO product_category (
      category_name,
      category_code,
      parent_id,
      category_level
)
VALUES
      (
            '冲锋衣裤',
            '060101',
            49,
            3
      ),
      (
            '速干衣裤',
            '060102',
            49,
            3
      ),
      ('滑雪服', '060103', 49, 3),
      (
            '户外风衣',
            '060104',
            49,
            3
      ),
      ('雪地靴', '060105', 49, 3),
      ('溯溪鞋', '060106', 49, 3),
      ('徒步鞋', '060107', 49, 3);

INSERT INTO product_category (
      category_name,
      category_code,
      parent_id,
      category_level
)
VALUES
      ('帐篷', '060201', 50, 3),
      ('睡袋', '060202', 50, 3),
      (
            '野餐烧烤',
            '060203',
            50,
            3
      ),
      (
            '登山攀岩',
            '060204',
            50,
            3
      ),
      ('背包', '060205', 50, 3),
      (
            '户外照明',
            '060206',
            50,
            3
      ),
      (
            '极限户外',
            '060207',
            50,
            3
      );

INSERT INTO product_category (
      category_name,
      category_code,
      parent_id,
      category_level
)
VALUES
      ('钓竿', '060301', 51, 3),
      ('鱼线', '060302', 51, 3),
      ('浮漂', '060303', 51, 3),
      ('鱼饵', '060304', 51, 3),
      ('鱼包', '060305', 51, 3),
      ('钓箱', '060306', 51, 3),
      ('鱼线轮', '060307', 51, 3);

-- 数据检查
SELECT
      a.category_name AS one_category,
      a.category_code AS one_category_code,
      b.category_name AS two_category,
      b.category_code AS two_category_code,
      c.category_name AS three_category,
      c.category_code AS three_category_code
FROM
      product_category a
LEFT JOIN product_category b ON b.parent_id = a.category_id
AND b.category_level = 2
LEFT JOIN product_category c ON c.parent_id = b.category_id
AND c.category_level = 3
WHERE
      a.category_level = 1;

CREATE TABLE product_supplier_info (
      supplier_id INT UNSIGNED AUTO_INCREMENT NOT NULL COMMENT '供应商ID',
      supplier_code CHAR (8) NOT NULL COMMENT '供应商编码',
      supplier_name CHAR (50) NOT NULL COMMENT '供应商名称',
      supplier_type TINYINT NOT NULL COMMENT '供应商类型:1.自营,2.平台',
      link_man VARCHAR (10) NOT NULL COMMENT '供应商联系人',
      phone_number VARCHAR (50) NOT NULL COMMENT '联系电话',
      bank_name VARCHAR (50) NOT NULL COMMENT '供应商开户银行名称',
      bank_account VARCHAR (50) NOT NULL COMMENT '银行账号',
      province INT NOT NULL COMMENT '地区表中省份的id',
      city INT NOT NULL COMMENT '地区表中城市的id',
      district INT NOT NULL COMMENT '地区表中的区id',
      address VARCHAR (200) NOT NULL COMMENT '供应商地址',
      supplier_status TINYINT NOT NULL DEFAULT '0' COMMENT '状态:0禁用,1启用',
      modified_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
      PRIMARY KEY pk_supplierid (supplier_id)
) ENGINE = INNODB COMMENT '供应商信息表';

INSERT INTO product_supplier_info (
      supplier_code,
      supplier_name,
      supplier_type,
      link_man,
      supplier_status,
      phone_number,
      bank_name,
      bank_account,
      province,
      city,
      district,
      address
)
VALUES
      (
            '10001',
            '供应商-1',
            1,
            '张三',
            1,
            '13800138001',
            '工商银行',
            '62988776444333',
            25,
            321,
            2706,
            '上海'
      ),
      (
            '10002',
            '供应商-2',
            1,
            '李四',
            1,
            '13800138002',
            '招行银行',
            '629809988765533',
            27,
            343,
            2914,
            '天津'
      ),
      (
            '20001',
            '供应商-3',
            1,
            '王五',
            1,
            '13800138003',
            '中国银行',
            '12345656785443',
            2,
            52,
            503,
            '北京'
      );

CREATE TABLE product_info (
      product_id INT UNSIGNED AUTO_INCREMENT NOT NULL COMMENT '商品ID',
      product_code CHAR (16) NOT NULL COMMENT '商品编码',
      product_name VARCHAR (50) NOT NULL COMMENT '商品名称',
      bar_code VARCHAR (50) NOT NULL COMMENT '国条码',
      brand_id INT UNSIGNED NOT NULL COMMENT '品牌表的ID',
      one_category_id SMALLINT UNSIGNED NOT NULL COMMENT '一级分类ID',
      two_category_id SMALLINT UNSIGNED NOT NULL COMMENT '二级分类ID',
      three_category_id SMALLINT UNSIGNED NOT NULL COMMENT '三级分类ID',
      supplier_id INT UNSIGNED NOT NULL COMMENT '商品的供应商id',
      price DECIMAL (8, 2) NOT NULL COMMENT '商品销售价格',
      average_cost DECIMAL (18, 2) NOT NULL COMMENT '商品加权平均成本',
      publish_status TINYINT NOT NULL DEFAULT 0 COMMENT '上下架状态:0下架1上架',
      audit_status TINYINT NOT NULL DEFAULT 0 COMMENT '审核状态:0未审核,1已审核',
      weight FLOAT COMMENT '商品重量',
      length FLOAT COMMENT '商品长度',
      heigh FLOAT COMMENT '商品高度',
      width FLOAT COMMENT '商品宽度',
      color_type enum ('红', '黄', '蓝', '黒'),
      production_date datetime NOT NULL COMMENT '生产日期',
      shelf_life INT NOT NULL COMMENT '商品有效期',
      descript text NOT NULL COMMENT '商品描述',
      indate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '商品录入时间',
      modified_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
      PRIMARY KEY pk_productid (product_id)
) ENGINE = INNODB COMMENT '商品信息表';

CREATE TABLE serial (
      id INT NOT NULL auto_increment,
      PRIMARY KEY pk_id (id)
);

INSERT INTO serial
VALUES
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      (),
      ();

INSERT INTO product_info (
      product_code,
      product_name,
      bar_code,
      brand_id,
      one_category_id,
      two_category_id,
      three_category_id,
      supplier_id,
      price,
      average_cost,
      production_date,
      shelf_life,
      descript
) SELECT
      concat(
            a.three_category_id,
            '0000000000',
            RIGHT (concat('0000', b.id), 4)
      ) AS product_code,
      concat(
            three_category,
            '示例商品-',
            b.id
      ) AS product_name,
      ceil(rand() * 10000000000) AS bar_code,
      (
            SELECT
                  brand_id
            FROM
                  product_brand_info
            ORDER BY
                  rand()
            LIMIT 1
      ) AS brand_id,
      a.one_category_id,
      a.two_category_id,
      a.three_category_id,
      (
            SELECT
                  brand_id
            FROM
                  product_supplier_info
            ORDER BY
                  rand()
            LIMIT 1
      ) AS supplier_id,
      round(rand() * 1000, 2) AS price,
      0.00 AS average_cost,
      ADDDATE(
            now(),
            INTERVAL RAND() * 10000000 SECOND
      ),
      180 AS shelf_life,
      '' AS descript
FROM
      (
            SELECT
                  a.category_name AS one_category,
                  a.category_id AS one_category_id,
                  b.category_name AS two_category,
                  b.category_id AS two_category_id,
                  c.category_name AS three_category,
                  c.category_id AS three_category_id
            FROM
                  product_category a
            JOIN product_category b ON b.parent_id = a.category_id
            AND b.category_level = 2
            JOIN product_category c ON c.parent_id = b.category_id
            AND c.category_level = 3
            WHERE
                  a.category_level = 1
      ) a
CROSS JOIN serial b;

UPDATE product_info a
JOIN product_brand_info b ON a.brand_id = b.brand_id
SET a.product_name = concat(
      '[',
      b.brand_name,
      ']',
      a.product_name
);

UPDATE product_info
SET average_cost = price;

CREATE TABLE product_pic_info (
      product_pic_id INT UNSIGNED AUTO_INCREMENT NOT NULL COMMENT '商品图片ID',
      product_id INT UNSIGNED NOT NULL COMMENT '商品ID',
      pic_desc VARCHAR (50) COMMENT '图片描述',
      pic_url VARCHAR (200) NOT NULL COMMENT '图片URL',
      is_master TINYINT NOT NULL DEFAULT 0 COMMENT '是否主图:0.非主图1.主图',
      pic_order TINYINT NOT NULL DEFAULT 0 COMMENT '图片排序',
      pic_status TINYINT NOT NULL DEFAULT 1 COMMENT '图片是否有效:0无效 1有效',
      modified_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
      PRIMARY KEY pk_picid (product_pic_id)
) ENGINE = INNODB COMMENT '商品图片信息表';

CREATE TABLE product_comment (
      comment_id INT UNSIGNED AUTO_INCREMENT NOT NULL COMMENT '评论ID',
      product_id INT UNSIGNED NOT NULL COMMENT '商品ID',
      order_id BIGINT UNSIGNED NOT NULL COMMENT '订单ID',
      customer_id INT UNSIGNED NOT NULL COMMENT '用户ID',
      title VARCHAR (50) NOT NULL COMMENT '评论标题',
      content VARCHAR (300) NOT NULL COMMENT '评论内容',
      audit_status TINYINT NOT NULL COMMENT '审核状态:0未审核1已审核',
      audit_time TIMESTAMP NOT NULL COMMENT '评论时间',
      modified_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
      PRIMARY KEY pk_commentid (comment_id)
) ENGINE = INNODB COMMENT '商品评论表';