-- DELETE FROM sys_users;

-- 插入测试用户信息
INSERT INTO sys_users(FKey, FCode, FName)
  SELECT UUID(), 'ymofen', '测试用户'
   FROM DUAL 
  WHERE NOT EXISTS(SELECT 1 FROM sys_users WHERE FCode = 'ymofen');

SELECT * FROM sys_users;
