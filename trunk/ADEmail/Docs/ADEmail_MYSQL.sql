-- �����û���
CREATE TABLE IF NOT EXISTS sys_Users (
	FKey  varchar(38) NOT NULL ,
	FCode  varchar(20) CHARACTER SET utf8 NOT NULL,
	FName  varchar(20) CHARACTER SET utf8 NOT NULL,
	FPassword  varchar(30) NOT NULL ,
	FRegTime  datetime NOT NULL COMMENT 'ע��ʱ��' ,
	FLastLoginTime  datetime NOT NULL COMMENT '����½ʱ��' ,
	FMobile varchar(20) CHARACTER SET utf8 NULL COMMENT '�ֻ�', 
	PRIMARY KEY (FKey)
);

-- �ͻ���<�������ڿͻ��ĵ�½>
CREATE TABLE IF NOT EXISTS sys_Client (
  FKey VARCHAR(38) NOT NULL,   
  FCode VARCHAR(20) CHARACTER SET utf8 NOT NULL,
  FName VARCHAR(20) CHARACTER SET utf8 NOT NULL,
  FPassword VARCHAR(30) NOT NULL, 
  FTel VARCHAR(50) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (FKey)  
);


-- EmailSMTP�ʺ��б�
CREATE TABLE IF NOT EXISTS sys_EmailSMTP(
  FKey varchar(38) NOT NULL,  
  FSMTP_Server VARCHAR(20) NOT NULL COMMENT 'SMTP������',
  FSMTP_User VARCHAR(20) NOT NULL,
  FSMTP_Password VARCHAR(20) NOT NULL,
  PRIMARY KEY (FKey)  
);


-- �ͻ���Email��ϵ���б�<ÿ���ͻ�����ʱ����һ���б�eml_EmailAddr_FUserCode>
CREATE TABLE IF NOT EXISTS eml_EmailAddr(
  FKey VARCHAR(38) NOT NULL,
  FClientKey VARCHAR(38) NOT NULL COMMENT '�ͻ�����',
  FDate DATETIME NOT NULL COMMENT '���ʱ��',
  FEmail VARCHAR(50) NOT NULL COMMENT 'Email��ַ',
  FName VARCHAR(20) CHARACTER SET utf8 NOT NULL COMMENT '����',
  FCallName VARCHAR(50) CHARACTER SET utf8 NOT NULL COMMENT '�ƺ�',
  FSex VARCHAR(10) CHARACTER SET utf8 NOT NULL COMMENT '�Ա�<����,����,С��,Ůʿ,��Ů>',  
  PRIMARY KEY (FKey)
);

-- �����б�
CREATE TABLE IF NOT EXISTS eml_Task(
  FKey VARCHAR(38) NOT NULL,
  FClientKey VARCHAR(38) NOT NULL COMMENT '�ͻ�����',  
  FDate DATETIME NOT NULL COMMENT '�������ʱ��', 
  FContentFile VARCHAR(30) CHARACTER SET utf8 NOT NULL COMMENT '���������ļ�',
  PRIMARY KEY (FKey)
);

-- ���������_ÿ���ͻ�����һ����
CREATE TABLE IF NOT EXISTS eml_TaskRecvList_Template(
  FKey VARCHAR(38) NOT NULL,
  FMasterKey VARCHAR(38) NOT NULL COMMENT '��������',    -- eml_Task.FKey
  FEmail VARCHAR(50) NOT NULL COMMENT 'Email��ַ',
  FStartTime DATETIME NULL COMMENT '�����ȡʱ��',
  FDoneDate DATETIME NULL COMMENT '�������ʱ��', 
  FSendUserKey VARCHAR(38) NOT NULL COMMENT '�����û�����',
  PRIMARY KEY (FKey)
);

