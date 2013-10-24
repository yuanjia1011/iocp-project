unit uClientContext;

interface

uses
  Windows, uBuffer, Classes, SysUtils,
  uIOCPCentre, uCMDObject, ComObj;

type
  TClientContext = class(TIOCPClientContext)
  private
    FlastAssignTime: TDateTime;
    FLoginTime: TDateTime;
    FuserKey: String;
    FuserCode: String;
    FuserName: String;
    FSessionID: Integer;
  protected
    procedure DoConnect; override;
    procedure DoDisconnect; override;
    procedure DoOnWriteBack; override;

    //复位<回收时进行复位>
    procedure Reset; override;

    procedure checkLogin;
  private
    //检测创建用户表信息
    procedure checkCreateUserEmailAddrTable(pvUserCode:string);

    //执行SQL语句
    procedure executeScript(pvCMDText:String);

  private
    //更新Email信息
    procedure DoPublisher_UpdateEmail(pvCMDObject:TCMDObject);



  private
    //登陆
    procedure DoLogin(const pvCMDObject:TCMDObject);

    //注册检测
    procedure DoRegisterCheck(const pvCMDObject:TCMDObject);

    //注册
    procedure DoRegister(const pvCMDObject:TCMDObject);

    //获取一个任务
    procedure DoGetATask(const pvCMDObject:TCMDObject);

    //登陆
    procedure DoLogin4Publisher(const pvCMDObject:TCMDObject);

    //更新Email信息
    procedure DoPublisher_UpdateTask(pvCMDObject:TCMDObject);

    //注册
    procedure DoRegister4Publisher(const pvCMDObject:TCMDObject);

    //注册检测
    procedure DoRegisterCheck4Publisher(const pvCMDObject:TCMDObject);



    //获取一个文件数据
    procedure GetFileDATA(const pvCMDObject:TCMDObject);

    //获取一个文件信息
    procedure GetFileINfo(const pvCMDObject:TCMDObject);

  public
    /// <summary>
    ///   数据处理
    /// </summary>
    /// <param name="pvDataObject"> (TObject) </param>
    procedure dataReceived(const pvDataObject:TObject); override;

    //最后一次分配任务时间
    property lastAssignTime: TDateTime read FlastAssignTime write FlastAssignTime;

    property LoginTime: TDateTime read FLoginTime;
    property userCode: String read FuserCode;
    property userName: String read FuserName;

  end;

implementation

uses
  Math, uCMDConsts, uUniPool, UntCobblerUniPool, uUniOperator, DB, uCRCTools,
  uFileHandler, uStringTools, uEmailTaskHandler;





procedure TClientContext.checkCreateUserEmailAddrTable(pvUserCode:string);
var
  lvStrings:TStrings;
  lvFile, lvPath:String;
begin
  lvPath := ExtractFilePath(ParamStr(0)) + '\data\';
  lvStrings := TStringList.Create;
  try
    lvFile := lvPath + 'createClientEmailAddr.sql';
    if FileExists(lvFile) then
    begin
      lvStrings.LoadFromFile(lvFile);
      lvStrings.Text :=  StringReplace(lvStrings.Text, '%userCode%', pvUserCode, [rfReplaceAll, rfIgnoreCase]);
      lvStrings.Text := UTF8Encode(lvStrings.Text);
      executeScript(lvStrings.Text);
    end else
    begin
      raise Exception.Create('缺少创建用户Email地址SQL文件，请通知服务商！');
    end;

  finally
    lvStrings.Free;
  end;
end;

procedure TClientContext.checkLogin;
begin
  if FSessionID = 0 then
    raise Exception.Create('没有进行登陆，请登陆再进行操作!');

  if FuserCode = '' then
    raise Exception.Create('没有进行登陆，请登陆再进行操作!');

end;

procedure TClientContext.dataReceived(const pvDataObject:TObject);
var
  lvCMDObject:TCMDObject;
begin
  lvCMDObject := TCMDObject(pvDataObject);
  try
    if lvCMDObject.CMDIndex = CMD_LOGIN then
    begin
      DoLogin(lvCMDObject);
    end else if lvCMDObject.CMDIndex = CMD_CHECK_USERCode then
    begin
      DoRegisterCheck(lvCMDObject);
    end else if lvCMDObject.CMDIndex = CMD_REGISTER then
    begin
      DoRegister(lvCMDObject);
    end else if lvCMDObject.CMDIndex = CMD_Publisher_Login then
    begin
      DoLogin4Publisher(lvCMDObject);
    end else if lvCMDObject.CMDIndex = CMD_Publicher_CheckRegister then
    begin
      DoRegisterCheck4Publisher(lvCMDObject);
    end else if lvCMDObject.CMDIndex = CMD_Publisher_Regiser then
    begin
      DoRegister4Publisher(lvCMDObject);
    end else if lvCMDObject.CMDIndex = CMD_Publisher_UpdateEmail then
    begin
      checkLogin;
      DoPublisher_UpdateEmail(lvCMDObject);
    end else if lvCMDObject.CMDIndex = CMD_Publisher_UpdateTask then
    begin
      checkLogin;
      DoPublisher_UpdateTask(lvCMDObject);
    end else if lvCMDObject.CMDIndex = CMD_Publisher_MyEmailTaskList then
    begin
      checkLogin;
      TEmailTaskHandler.GetTaskList(FuserKey, lvCMDObject, Self);
    end;

    //直接回传
    writeObject(lvCMDObject);
  except
    on E:Exception do
    begin
      lvCMDObject.clear;
      lvCMDObject.SessionID := FSessionID;
      lvCMDObject.CMDResult := -1;
      lvCMDObject.Config.S['__msg'] := e.Message;
      writeObject(lvCMDObject);
    end;
  end;
end;

procedure TClientContext.DoConnect;
begin
  inherited;
end;

procedure TClientContext.DoDisconnect;
begin
  inherited;
end;



procedure TClientContext.DoGetATask(const pvCMDObject: TCMDObject);
begin
  ;
end;

procedure TClientContext.DoLogin(const pvCMDObject: TCMDObject);
var
  lvDBDataOperator:TUniOperator;
  lvPoolObj:TUniCobbler;
  lvSQL:AnsiString;
  lvDataSet:TDataSet;
begin
  //通过帐套ID获取一个连接池对象
  lvPoolObj := TUniPool.getConnObject('main');
  try
    //打开连接
    lvPoolObj.checkConnect;

    //Uni数据库操作对象<可以改用对象池效率更好>
    lvDBDataOperator := TUniOperator.Create;
    try
      //设置使用的连接池
      lvDBDataOperator.Connection := lvPoolObj.ConnObj;

      lvSQL := 'SELECT * FROM sys_Users WHERE FCode = ''' + pvCMDObject.Config.S['user'] + '''';

      self.StateINfo := '借用了一个lvDBDataOperator,准备打开连接!';
      try
        //获取一个查询的数据
        lvDataSet := lvDBDataOperator.CDSProvider.Query(lvSQL);

        if lvDataSet.RecordCount = 0 then
        begin
          raise Exception.Create('用户不存在!');
        end else
        begin
          if lvDataSet.FieldByName('FPassword').AsString <> pvCMDObject.Config.S['pass'] then
          begin
            raise Exception.Create('密码错误!');
          end;

          FSessionID := TCRCTools.crc32String(pvCMDObject.Config.S['user'] + 'task' + DateTimeToStr(Now()));
          FuserKey := lvDataSet.FieldByName('FKey').AsString;
          FuserCode := lvDataSet.FieldByName('FCode').AsString;
          FuserName := lvDataSet.FieldByName('FName').AsString;

          lvDataSet.Edit;
          lvDataSet.FieldByName('FLastLoginTime').AsDateTime := Now();
          lvDataSet.Post;
          pvCMDObject.SessionID := FSessionID;

        end;
        self.StateINfo := 'lvDBDataOperator,执行SQL语句完成,准备回写数据';
      except
        raise;
      end;
      pvCMDObject.clear;
      pvCMDObject.CMDResult := 1;
    finally
      lvDBDataOperator.Free;
    end;
  finally
    //归还连接池
    TUniPool.releaseConnObject(lvPoolObj);
  end;
end;

procedure TClientContext.DoLogin4Publisher(const pvCMDObject:TCMDObject);
var
  lvDBDataOperator:TUniOperator;
  lvPoolObj:TUniCobbler;
  lvSQL:AnsiString;
  lvDataSet:TDataSet;
begin
  //通过帐套ID获取一个连接池对象
  lvPoolObj := TUniPool.getConnObject('main');
  try
    //打开连接
    lvPoolObj.checkConnect;

    //Uni数据库操作对象<可以改用对象池效率更好>
    lvDBDataOperator := TUniOperator.Create;
    try
      //设置使用的连接池
      lvDBDataOperator.Connection := lvPoolObj.ConnObj;

      lvSQL := 'SELECT * FROM sys_Client WHERE FCode = ''' + pvCMDObject.Config.S['user'] + '''';

      self.StateINfo := '借用了一个lvDBDataOperator,准备打开连接!';
      try
        //获取一个查询的数据
        lvDataSet := lvDBDataOperator.CDSProvider.Query(lvSQL);

        if lvDataSet.RecordCount = 0 then
        begin
          raise Exception.Create('用户不存在, 发布客户端与任务执行客户端不能用同一个用户登陆!');
        end else
        begin
          if lvDataSet.FieldByName('FPassword').AsString <> pvCMDObject.Config.S['pass'] then
          begin
            raise Exception.Create('密码错误!');
          end;

          FSessionID := TCRCTools.crc32String(pvCMDObject.Config.S['user'] + 'publisher' + DateTimeToStr(Now()));
          FuserKey := lvDataSet.FieldByName('FKey').AsString;
          FuserCode := lvDataSet.FieldByName('FCode').AsString;
          FuserName := lvDataSet.FieldByName('FName').AsString;
          lvDataSet.Edit;
          lvDataSet.FieldByName('FLastLoginTime').AsDateTime := Now();
          lvDataSet.Post;
          pvCMDObject.SessionID := FSessionID;
        end;
        self.StateINfo := 'lvDBDataOperator,执行SQL语句完成,准备回写数据';
      except
        raise;
      end;
      pvCMDObject.clear;
      pvCMDObject.CMDResult := 1;
    finally
      lvDBDataOperator.Free;
    end;
  finally
    //归还连接池
    TUniPool.releaseConnObject(lvPoolObj);
  end;
end;

procedure TClientContext.DoOnWriteBack;
begin
  inherited;
end;

procedure TClientContext.DoPublisher_UpdateEmail(pvCMDObject: TCMDObject);
var
  lvDBDataOperator:TUniOperator;
  lvPoolObj:TUniCobbler;
  lvSQL:AnsiString;
  lvDataSet:TDataSet;
begin
  checkCreateUserEmailAddrTable(FuserCode);
  //通过帐套ID获取一个连接池对象
  lvPoolObj := TUniPool.getConnObject('main');
  try
    //打开连接
    lvPoolObj.checkConnect;

    //Uni数据库操作对象<可以改用对象池效率更好>
    lvDBDataOperator := TUniOperator.Create;
    try
      //设置使用的连接池
      lvDBDataOperator.Connection := lvPoolObj.ConnObj;

      lvSQL := 'SELECT * FROM eml_EmailAddr_' + FuserCode
         + ' WHERE FEmail = ''' + pvCMDObject.Config.S['data.email'] + '''';

      self.StateINfo := '借用了一个lvDBDataOperator,准备打开连接!';
      try
        //获取一个查询的数据
        lvDataSet := lvDBDataOperator.CDSProvider.Query(lvSQL);

        if lvDataSet.RecordCount = 0 then
        begin
          lvDataSet.Append;
          lvDataSet.FieldByName('FKey').AsString := pvCMDObject.Config.S['data.key'];
          if lvDataSet.FieldByName('FKey').AsString = '' then
          begin
            lvDataSet.FieldByName('FKey').AsString := CreateClassID;
            pvCMDObject.Config.S['data.key'] :=lvDataSet.FieldByName('FKey').AsString;
          end;
          lvDataSet.FieldByName('FClientKey').AsString := FuserKey;
        end else
        begin
          if lvDataSet.FieldByName('FKey').AsString = pvCMDObject.Config.S['data.key'] then
          begin
            raise Exception.Create('Email已经存在！');
          end;
          lvDataSet.Edit;

        end;

        lvDataSet.FieldByName('FDate').AsDateTime := Now();
        lvDataSet.FieldByName('FEmail').AsString := pvCMDObject.Config.S['data.email'];
        lvDataSet.FieldByName('FName').AsString := pvCMDObject.Config.S['data.name'];
        lvDataSet.FieldByName('FCallName').AsString := pvCMDObject.Config.S['data.callname'];
        lvDataSet.FieldByName('FSex').AsString := pvCMDObject.Config.S['data.sex'];
        lvDataSet.FieldByName('FGrade').AsString := pvCMDObject.Config.S['data.grade'];
        lvDataSet.FieldByName('FCatalog').AsString := pvCMDObject.Config.S['data.catalog'];
        lvDataSet.Post;

        self.StateINfo := 'lvDBDataOperator,更新Email数据完成';
      except
        raise;
      end;
      pvCMDObject.CMDResult := 1;
    finally
      lvDBDataOperator.Free;
    end;
  finally
    //归还连接池
    TUniPool.releaseConnObject(lvPoolObj);
  end;
end;

procedure TClientContext.DoPublisher_UpdateTask(pvCMDObject:TCMDObject);
var
  lvDBDataOperator:TUniOperator;
  lvPoolObj:TUniCobbler;
  lvSQL, lvDataStr:AnsiString;
  lvDataSet:TDataSet;
  lvStream:TStream;
  lvFile:String;
begin
  //通过帐套ID获取一个连接池对象
  lvPoolObj := TUniPool.getConnObject('main');
  try
    //打开连接
    lvPoolObj.checkConnect;

    //Uni数据库操作对象<可以改用对象池效率更好>
    lvDBDataOperator := TUniOperator.Create;
    try
      //设置使用的连接池
      lvDBDataOperator.Connection := lvPoolObj.ConnObj;

      lvSQL := 'SELECT * FROM eml_task'
         + ' WHERE FKey = ''' + pvCMDObject.Config.S['data.key'] + '''';

      self.StateINfo := '借用了一个lvDBDataOperator,准备打开连接!';
      try
        //获取一个查询的数据
        lvDataSet := lvDBDataOperator.CDSProvider.Query(lvSQL);

        if lvDataSet.RecordCount = 0 then
        begin
          lvDataSet.Append;
          lvDataSet.FieldByName('FKey').AsString := pvCMDObject.Config.S['data.key'];
          if lvDataSet.FieldByName('FKey').AsString = '' then
          begin
            lvDataSet.FieldByName('FKey').AsString := CreateClassID;
            pvCMDObject.Config.S['data.key'] :=lvDataSet.FieldByName('FKey').AsString;
          end;
          lvDataSet.FieldByName('FClientKey').AsString := FuserKey;
        end else
        begin
          lvDataSet.Edit;

          if lvDataSet.FieldByName('FState').AsInteger <> 0 then
          begin
            raise Exception.Create('只有草稿的任务才能进行修改!');
          end;

        end;
        lvFile := TStringTools.FixValidKeyValue(pvCMDObject.Config.S['data.key']) + '.html';

        lvDataSet.FieldByName('FState').AsInteger := 0; //草稿状态

        lvDataSet.FieldByName('FSubject').AsString := pvCMDObject.Config.S['data.subject'];
        lvDataSet.FieldByName('FDate').AsDateTime := Now();
        lvDataSet.FieldByName('FContentFile').AsString :=lvFile;

        lvDataSet.Post;




        lvDataStr := pvCMDObject.Config.S['data.content'];
        if Length(lvDataStr) <> 0 then
        begin
          TFileHandler.writeFileData(lvFile, PAnsiChar(lvDataStr),0, Length(lvDataStr));
        end;

        self.StateINfo := 'lvDBDataOperator,更新Email数据完成';
      except
        raise;
      end;
      pvCMDObject.CMDResult := 1;
    finally
      lvDBDataOperator.Free;
    end;
  finally
    //归还连接池
    TUniPool.releaseConnObject(lvPoolObj);
  end;
end;

procedure TClientContext.DoRegister(const pvCMDObject: TCMDObject);
var
  lvDBDataOperator:TUniOperator;
  lvPoolObj:TUniCobbler;
  lvSQL:AnsiString;
  lvDataSet:TDataSet;
begin
  //通过帐套ID获取一个连接池对象
  lvPoolObj := TUniPool.getConnObject('main');
  try
    //打开连接
    lvPoolObj.checkConnect;

    //Uni数据库操作对象<可以改用对象池效率更好>
    lvDBDataOperator := TUniOperator.Create;
    try
      //设置使用的连接池
      lvDBDataOperator.Connection := lvPoolObj.ConnObj;

      lvSQL := 'SELECT * FROM sys_Users WHERE FCode = ''' + pvCMDObject.Config.S['user'] + '''';

      self.StateINfo := '借用了一个lvDBDataOperator,准备打开连接!';
      try
        //获取一个查询的数据
        lvDataSet := lvDBDataOperator.CDSProvider.Query(lvSQL);
        if lvDataSet.RecordCount = 0 then
        begin
          lvDataSet.Append;
          lvDataSet.FieldByName('FKey').AsString := CreateClassID;
          lvDataSet.FieldByName('FCode').AsString := pvCMDObject.Config.S['user'];
          lvDataSet.FieldByName('FPassword').AsString := pvCMDObject.Config.S['pass'];
          lvDataSet.FieldByName('FEmail').AsString := pvCMDObject.Config.S['email'];
          lvDataSet.FieldByName('FName').AsString := pvCMDObject.Config.S['name'];
          lvDataSet.FieldByName('FMobile').AsString := pvCMDObject.Config.S['mobile'];
          lvDataSet.FieldByName('FRegTime').AsDateTime := Now();
          lvDataSet.Post;

          pvCMDObject.clear;
          pvCMDObject.CMDResult := 1;
        end else
        begin
          raise Exception.Create('用户名已经存在!');
        end;
        self.StateINfo := 'lvDBDataOperator,执行SQL语句完成,准备回写数据';
      except
        raise;
      end;
      pvCMDObject.clear;

    finally
      lvDBDataOperator.Free;
    end;
  finally
    //归还连接池
    TUniPool.releaseConnObject(lvPoolObj);
  end;

end;

procedure TClientContext.DoRegister4Publisher(const pvCMDObject:TCMDObject);
var
  lvDBDataOperator:TUniOperator;
  lvPoolObj:TUniCobbler;
  lvSQL:AnsiString;
  lvDataSet:TDataSet;
begin
  //通过帐套ID获取一个连接池对象
  lvPoolObj := TUniPool.getConnObject('main');
  try
    //打开连接
    lvPoolObj.checkConnect;

    //Uni数据库操作对象<可以改用对象池效率更好>
    lvDBDataOperator := TUniOperator.Create;
    try
      //设置使用的连接池
      lvDBDataOperator.Connection := lvPoolObj.ConnObj;

      lvSQL := 'SELECT * FROM sys_Client WHERE FCode = ''' + pvCMDObject.Config.S['user'] + '''';

      self.StateINfo := '借用了一个lvDBDataOperator,准备打开连接!';
      try
        //获取一个查询的数据
        lvDataSet := lvDBDataOperator.CDSProvider.Query(lvSQL);
        if lvDataSet.RecordCount = 0 then
        begin
          lvDataSet.Append;
          lvDataSet.FieldByName('FKey').AsString := CreateClassID;
          lvDataSet.FieldByName('FCode').AsString := pvCMDObject.Config.S['user'];
          lvDataSet.FieldByName('FPassword').AsString := pvCMDObject.Config.S['pass'];
          lvDataSet.FieldByName('FEmail').AsString := pvCMDObject.Config.S['email'];
          lvDataSet.FieldByName('FName').AsString := pvCMDObject.Config.S['name'];
          lvDataSet.FieldByName('FMobile').AsString := pvCMDObject.Config.S['mobile'];
          lvDataSet.FieldByName('FRegTime').AsDateTime := Now();
          lvDataSet.Post;

          pvCMDObject.clear;
          pvCMDObject.CMDResult := 1;
        end else
        begin
          raise Exception.Create('用户名已经存在!');
        end;
        self.StateINfo := 'lvDBDataOperator,执行SQL语句完成,准备回写数据';
      except
        raise;
      end;
      pvCMDObject.clear;

    finally
      lvDBDataOperator.Free;
    end;
  finally
    //归还连接池
    TUniPool.releaseConnObject(lvPoolObj);
  end;

end;

procedure TClientContext.DoRegisterCheck(const pvCMDObject: TCMDObject);
var
  lvDBDataOperator:TUniOperator;
  lvPoolObj:TUniCobbler;
  lvSQL:AnsiString;
  lvDataSet:TDataSet;
begin
  //通过帐套ID获取一个连接池对象
  lvPoolObj := TUniPool.getConnObject('main');
  try
    //打开连接
    lvPoolObj.checkConnect;

    //Uni数据库操作对象<可以改用对象池效率更好>
    lvDBDataOperator := TUniOperator.Create;
    try
      //设置使用的连接池
      lvDBDataOperator.Connection := lvPoolObj.ConnObj;

      lvSQL := 'SELECT * FROM sys_Users WHERE FCode = ''' + pvCMDObject.Config.S['user'] + '''';

      self.StateINfo := '借用了一个lvDBDataOperator,准备打开连接!';
      try
        //获取一个查询的数据
        lvDataSet := lvDBDataOperator.CDSProvider.Query(lvSQL);
        pvCMDObject.clear;
        if lvDataSet.RecordCount = 0 then
        begin
          pvCMDObject.Config.S['__msg'] := '用户名可以使用';
          pvCMDObject.CMDResult := 1;
        end else
        begin
          pvCMDObject.Config.S['__msg'] := '用户名已经被占用';
          pvCMDObject.CMDResult := 2;
        end;
        self.StateINfo := 'lvDBDataOperator,执行SQL语句完成,准备回写数据';
      except
        raise;
      end;

    finally
      lvDBDataOperator.Free;
    end;
  finally
    //归还连接池
    TUniPool.releaseConnObject(lvPoolObj);
  end;
end;

procedure TClientContext.DoRegisterCheck4Publisher(const
    pvCMDObject:TCMDObject);
var
  lvDBDataOperator:TUniOperator;
  lvPoolObj:TUniCobbler;
  lvSQL:AnsiString;
  lvDataSet:TDataSet;
begin
  //通过帐套ID获取一个连接池对象
  lvPoolObj := TUniPool.getConnObject('main');
  try
    //打开连接
    lvPoolObj.checkConnect;

    //Uni数据库操作对象<可以改用对象池效率更好>
    lvDBDataOperator := TUniOperator.Create;
    try
      //设置使用的连接池
      lvDBDataOperator.Connection := lvPoolObj.ConnObj;

      lvSQL := 'SELECT * FROM sys_Client WHERE FCode = ''' + pvCMDObject.Config.S['user'] + '''';

      self.StateINfo := '借用了一个lvDBDataOperator,准备打开连接!';
      try
        //获取一个查询的数据
        lvDataSet := lvDBDataOperator.CDSProvider.Query(lvSQL);
        pvCMDObject.clear;
        if lvDataSet.RecordCount = 0 then
        begin
          pvCMDObject.Config.S['__msg'] := '用户名可以使用';
          pvCMDObject.CMDResult := 1;
        end else
        begin
          pvCMDObject.Config.S['__msg'] := '用户名已经被占用';
          pvCMDObject.CMDResult := 2;
        end;
        self.StateINfo := 'lvDBDataOperator,执行SQL语句完成,准备回写数据';
      except
        raise;
      end;

    finally
      lvDBDataOperator.Free;
    end;
  finally
    //归还连接池
    TUniPool.releaseConnObject(lvPoolObj);
  end;
end;

procedure TClientContext.executeScript(pvCMDText: String);
var
  lvDBDataOperator:TUniOperator;
  lvPoolObj:TUniCobbler;
  lvSQL:AnsiString;
  lvDataSet:TDataSet;
begin
  //通过帐套ID获取一个连接池对象
  lvPoolObj := TUniPool.getConnObject('main');
  try
    //打开连接
    lvPoolObj.checkConnect;

    //Uni数据库操作对象<可以改用对象池效率更好>
    lvDBDataOperator := TUniOperator.Create;
    try
      //设置使用的连接池
      lvDBDataOperator.Connection := lvPoolObj.ConnObj;

      lvSQL := pvCMDText;

      self.StateINfo := '借用了一个lvDBDataOperator,准备打开执行脚本!';
      try
        lvDBDataOperator.CDSProvider.ExecuteScript(lvSQL);
        self.StateINfo := 'lvDBDataOperator,执行SQL语句完成,准备回写数据';
      except
        raise;
      end;
    finally
      lvDBDataOperator.Free;
    end;
  finally
    //归还连接池
    TUniPool.releaseConnObject(lvPoolObj);
  end;
end;

procedure TClientContext.GetFileDATA(const pvCMDObject: TCMDObject);
begin
  pvCMDObject.Config.S['fileName'];
end;

procedure TClientContext.GetFileINfo(const pvCMDObject: TCMDObject);
var
  lvFile: string;
begin
  //lvFile :=;
end;

procedure TClientContext.Reset;
begin
  inherited;
  FSessionID := 0;
  FuserCode := '';
  FuserName := '';
end;

end.
