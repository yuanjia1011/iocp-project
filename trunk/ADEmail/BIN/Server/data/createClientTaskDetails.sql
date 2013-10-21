-- 任务接收人_每个客户创建一个表
CREATE TABLE IF NOT EXISTS eml_TaskRecvList_%userCode%(
  FKey VARCHAR(38) NOT NULL,
  FMasterKey VARCHAR(38) NOT NULL COMMENT '任务主键',    -- eml_Task.FKey
  FEmail VARCHAR(50) NOT NULL COMMENT 'Email地址',
  FStartTime DATETIME NULL COMMENT '任务获取时间',
  FDoneDate DATETIME NULL COMMENT '任务完成时间', 
  FSendUserKey VARCHAR(38) NOT NULL COMMENT '发送用户主键',
  PRIMARY KEY (FKey)
);