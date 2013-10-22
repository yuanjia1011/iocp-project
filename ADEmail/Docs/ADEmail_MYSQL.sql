-- 创建用户表
CREATE TABLE IF NOT EXISTS sys_Users (
	FKey  varchar(38) NOT NULL ,
	FCode  varchar(20) CHARACTER SET utf8 NOT NULL,
	FName  varchar(20) CHARACTER SET utf8 NOT NULL,
	FPassword  varchar(30) NOT NULL ,
	FRegTime  datetime NOT NULL COMMENT '注册时间' ,
	FLastLoginTime  datetime NULL COMMENT '最后登陆时间' ,
	FMobile varchar(20) CHARACTER SET utf8 NULL COMMENT '手机',
   FEmail varchar(30) CHARACTER SET utf8 NULL COMMENT 'Email',	
	PRIMARY KEY (FKey)
) DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci;

-- 客户表<可以用于客户的登陆>
CREATE TABLE IF NOT EXISTS sys_Client (
  FKey VARCHAR(38) NOT NULL,   
  FCode VARCHAR(20) CHARACTER SET utf8 NOT NULL,
  FName VARCHAR(20) CHARACTER SET utf8 NOT NULL,
  FPassword VARCHAR(30) NOT NULL, 
  FRegTime  datetime NOT NULL COMMENT '注册时间' ,
  FLastLoginTime  datetime NULL COMMENT '最后登陆时间' ,
  FMobile varchar(20) CHARACTER SET utf8 NULL COMMENT '手机',
  FEmail varchar(30) CHARACTER SET utf8 NULL COMMENT 'Email',	
  PRIMARY KEY (FKey)  
);


-- EmailSMTP帐号列表
CREATE TABLE IF NOT EXISTS sys_EmailSMTP(
  FKey varchar(38) NOT NULL,  
  FSMTP_Server VARCHAR(20) NOT NULL COMMENT 'SMTP服务器',
  FSMTP_User VARCHAR(20) NOT NULL,
  FSMTP_Password VARCHAR(20) NOT NULL,
  PRIMARY KEY (FKey)  
);


-- 客户的Email联系人列表<每个客户导入时创建一个列表eml_EmailAddr_FUserCode>
CREATE TABLE IF NOT EXISTS eml_EmailAddr(
  FKey VARCHAR(38) NOT NULL,
  FClientKey VARCHAR(38) NOT NULL COMMENT '客户主键',
  FDate DATETIME NOT NULL COMMENT '添加时间',
  FEmail VARCHAR(50) NOT NULL COMMENT 'Email地址',
  FName VARCHAR(20) CHARACTER SET utf8 NOT NULL COMMENT '姓名',
  FCallName VARCHAR(50) CHARACTER SET utf8 NOT NULL COMMENT '称呼',
  FSex VARCHAR(10) CHARACTER SET utf8 NOT NULL COMMENT '性别<先生,靓仔,小姐,女士,美女>',  
  PRIMARY KEY (FKey)
);


-- 客户的Email联系人列表<每个客户导入时创建一个列表eml_EmailAddr_FUserCode>
CREATE TABLE IF NOT EXISTS com_MyFiles(
  FKey VARCHAR(38) NOT NULL,
  FClientKey VARCHAR(38) NOT NULL COMMENT '客户主键',
  FDate DATETIME NOT NULL COMMENT '添加时间',
  FEmail VARCHAR(50) NOT NULL COMMENT 'Email地址',
  FName VARCHAR(20) CHARACTER SET utf8 NOT NULL COMMENT '姓名',
  FCallName VARCHAR(50) CHARACTER SET utf8 NOT NULL COMMENT '称呼',
  FSex VARCHAR(10) CHARACTER SET utf8 NOT NULL COMMENT '性别<先生,靓仔,小姐,女士,美女>',  
  PRIMARY KEY (FKey)
);

-- 任务列表
CREATE TABLE IF NOT EXISTS eml_Task(
  FKey VARCHAR(38) NOT NULL,
  FClientKey VARCHAR(38) NOT NULL COMMENT '客户主键',  
  FDate DATETIME NOT NULL COMMENT '任务添加时间', 
  FContentFile VARCHAR(30) CHARACTER SET utf8 NOT NULL COMMENT '发送内容文件',
  PRIMARY KEY (FKey)
);

-- 任务接收人_每个客户创建一个表
CREATE TABLE IF NOT EXISTS eml_TaskRecvList_Template(
  FKey VARCHAR(38) NOT NULL,
  FMasterKey VARCHAR(38) NOT NULL COMMENT '任务主键',    -- eml_Task.FKey
  FEmail VARCHAR(50) NOT NULL COMMENT 'Email地址',
  FStartTime DATETIME NULL COMMENT '任务获取时间',
  FDoneDate DATETIME NULL COMMENT '任务完成时间', 
  FSendUserKey VARCHAR(38) NOT NULL COMMENT '发送用户主键',
  PRIMARY KEY (FKey)
);

