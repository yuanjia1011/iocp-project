unit uCMDConsts;

interface

const
  CMD_LOGIN = 1001;      //登陆
  CMD_REGISTER = 1002;   //注册
  CMD_CHECK_USERCode = 1003;  //注册检测

  CMD_Publisher_Login = 2001;  //发布者登陆
  CMD_Publisher_Regiser = 2002;  //发布者注册
  CMD_Publicher_CheckRegister = 2003;  //发布者注册检测

  CMD_Publisher_UpdateEmail = 2004;     //发布者更新添加Email信息
  CMD_Publisher_DeleteEmail = 2005;     //发布者删除Email信息

  CMD_Publisher_AddTask = 2006;         //发布者添加一个任务

implementation

end.
