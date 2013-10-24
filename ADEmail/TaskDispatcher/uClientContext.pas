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

    //��λ<����ʱ���и�λ>
    procedure Reset; override;

    procedure checkLogin;
  private
    //��ⴴ���û�����Ϣ
    procedure checkCreateUserEmailAddrTable(pvUserCode:string);

    //ִ��SQL���
    procedure executeScript(pvCMDText:String);

  private
    //����Email��Ϣ
    procedure DoPublisher_UpdateEmail(pvCMDObject:TCMDObject);



  private
    //��½
    procedure DoLogin(const pvCMDObject:TCMDObject);

    //ע����
    procedure DoRegisterCheck(const pvCMDObject:TCMDObject);

    //ע��
    procedure DoRegister(const pvCMDObject:TCMDObject);

    //��ȡһ������
    procedure DoGetATask(const pvCMDObject:TCMDObject);

    //��½
    procedure DoLogin4Publisher(const pvCMDObject:TCMDObject);

    //����Email��Ϣ
    procedure DoPublisher_UpdateTask(pvCMDObject:TCMDObject);

    //ע��
    procedure DoRegister4Publisher(const pvCMDObject:TCMDObject);

    //ע����
    procedure DoRegisterCheck4Publisher(const pvCMDObject:TCMDObject);



    //��ȡһ���ļ�����
    procedure GetFileDATA(const pvCMDObject:TCMDObject);

    //��ȡһ���ļ���Ϣ
    procedure GetFileINfo(const pvCMDObject:TCMDObject);

  public
    /// <summary>
    ///   ���ݴ���
    /// </summary>
    /// <param name="pvDataObject"> (TObject) </param>
    procedure dataReceived(const pvDataObject:TObject); override;

    //���һ�η�������ʱ��
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
      raise Exception.Create('ȱ�ٴ����û�Email��ַSQL�ļ�����֪ͨ�����̣�');
    end;

  finally
    lvStrings.Free;
  end;
end;

procedure TClientContext.checkLogin;
begin
  if FSessionID = 0 then
    raise Exception.Create('û�н��е�½�����½�ٽ��в���!');

  if FuserCode = '' then
    raise Exception.Create('û�н��е�½�����½�ٽ��в���!');

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

    //ֱ�ӻش�
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
  //ͨ������ID��ȡһ�����ӳض���
  lvPoolObj := TUniPool.getConnObject('main');
  try
    //������
    lvPoolObj.checkConnect;

    //Uni���ݿ��������<���Ը��ö����Ч�ʸ���>
    lvDBDataOperator := TUniOperator.Create;
    try
      //����ʹ�õ����ӳ�
      lvDBDataOperator.Connection := lvPoolObj.ConnObj;

      lvSQL := 'SELECT * FROM sys_Users WHERE FCode = ''' + pvCMDObject.Config.S['user'] + '''';

      self.StateINfo := '������һ��lvDBDataOperator,׼��������!';
      try
        //��ȡһ����ѯ������
        lvDataSet := lvDBDataOperator.CDSProvider.Query(lvSQL);

        if lvDataSet.RecordCount = 0 then
        begin
          raise Exception.Create('�û�������!');
        end else
        begin
          if lvDataSet.FieldByName('FPassword').AsString <> pvCMDObject.Config.S['pass'] then
          begin
            raise Exception.Create('�������!');
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
        self.StateINfo := 'lvDBDataOperator,ִ��SQL������,׼����д����';
      except
        raise;
      end;
      pvCMDObject.clear;
      pvCMDObject.CMDResult := 1;
    finally
      lvDBDataOperator.Free;
    end;
  finally
    //�黹���ӳ�
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
  //ͨ������ID��ȡһ�����ӳض���
  lvPoolObj := TUniPool.getConnObject('main');
  try
    //������
    lvPoolObj.checkConnect;

    //Uni���ݿ��������<���Ը��ö����Ч�ʸ���>
    lvDBDataOperator := TUniOperator.Create;
    try
      //����ʹ�õ����ӳ�
      lvDBDataOperator.Connection := lvPoolObj.ConnObj;

      lvSQL := 'SELECT * FROM sys_Client WHERE FCode = ''' + pvCMDObject.Config.S['user'] + '''';

      self.StateINfo := '������һ��lvDBDataOperator,׼��������!';
      try
        //��ȡһ����ѯ������
        lvDataSet := lvDBDataOperator.CDSProvider.Query(lvSQL);

        if lvDataSet.RecordCount = 0 then
        begin
          raise Exception.Create('�û�������, �����ͻ���������ִ�пͻ��˲�����ͬһ���û���½!');
        end else
        begin
          if lvDataSet.FieldByName('FPassword').AsString <> pvCMDObject.Config.S['pass'] then
          begin
            raise Exception.Create('�������!');
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
        self.StateINfo := 'lvDBDataOperator,ִ��SQL������,׼����д����';
      except
        raise;
      end;
      pvCMDObject.clear;
      pvCMDObject.CMDResult := 1;
    finally
      lvDBDataOperator.Free;
    end;
  finally
    //�黹���ӳ�
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
  //ͨ������ID��ȡһ�����ӳض���
  lvPoolObj := TUniPool.getConnObject('main');
  try
    //������
    lvPoolObj.checkConnect;

    //Uni���ݿ��������<���Ը��ö����Ч�ʸ���>
    lvDBDataOperator := TUniOperator.Create;
    try
      //����ʹ�õ����ӳ�
      lvDBDataOperator.Connection := lvPoolObj.ConnObj;

      lvSQL := 'SELECT * FROM eml_EmailAddr_' + FuserCode
         + ' WHERE FEmail = ''' + pvCMDObject.Config.S['data.email'] + '''';

      self.StateINfo := '������һ��lvDBDataOperator,׼��������!';
      try
        //��ȡһ����ѯ������
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
            raise Exception.Create('Email�Ѿ����ڣ�');
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

        self.StateINfo := 'lvDBDataOperator,����Email�������';
      except
        raise;
      end;
      pvCMDObject.CMDResult := 1;
    finally
      lvDBDataOperator.Free;
    end;
  finally
    //�黹���ӳ�
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
  //ͨ������ID��ȡһ�����ӳض���
  lvPoolObj := TUniPool.getConnObject('main');
  try
    //������
    lvPoolObj.checkConnect;

    //Uni���ݿ��������<���Ը��ö����Ч�ʸ���>
    lvDBDataOperator := TUniOperator.Create;
    try
      //����ʹ�õ����ӳ�
      lvDBDataOperator.Connection := lvPoolObj.ConnObj;

      lvSQL := 'SELECT * FROM eml_task'
         + ' WHERE FKey = ''' + pvCMDObject.Config.S['data.key'] + '''';

      self.StateINfo := '������һ��lvDBDataOperator,׼��������!';
      try
        //��ȡһ����ѯ������
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
            raise Exception.Create('ֻ�вݸ��������ܽ����޸�!');
          end;

        end;
        lvFile := TStringTools.FixValidKeyValue(pvCMDObject.Config.S['data.key']) + '.html';

        lvDataSet.FieldByName('FState').AsInteger := 0; //�ݸ�״̬

        lvDataSet.FieldByName('FSubject').AsString := pvCMDObject.Config.S['data.subject'];
        lvDataSet.FieldByName('FDate').AsDateTime := Now();
        lvDataSet.FieldByName('FContentFile').AsString :=lvFile;

        lvDataSet.Post;




        lvDataStr := pvCMDObject.Config.S['data.content'];
        if Length(lvDataStr) <> 0 then
        begin
          TFileHandler.writeFileData(lvFile, PAnsiChar(lvDataStr),0, Length(lvDataStr));
        end;

        self.StateINfo := 'lvDBDataOperator,����Email�������';
      except
        raise;
      end;
      pvCMDObject.CMDResult := 1;
    finally
      lvDBDataOperator.Free;
    end;
  finally
    //�黹���ӳ�
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
  //ͨ������ID��ȡһ�����ӳض���
  lvPoolObj := TUniPool.getConnObject('main');
  try
    //������
    lvPoolObj.checkConnect;

    //Uni���ݿ��������<���Ը��ö����Ч�ʸ���>
    lvDBDataOperator := TUniOperator.Create;
    try
      //����ʹ�õ����ӳ�
      lvDBDataOperator.Connection := lvPoolObj.ConnObj;

      lvSQL := 'SELECT * FROM sys_Users WHERE FCode = ''' + pvCMDObject.Config.S['user'] + '''';

      self.StateINfo := '������һ��lvDBDataOperator,׼��������!';
      try
        //��ȡһ����ѯ������
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
          raise Exception.Create('�û����Ѿ�����!');
        end;
        self.StateINfo := 'lvDBDataOperator,ִ��SQL������,׼����д����';
      except
        raise;
      end;
      pvCMDObject.clear;

    finally
      lvDBDataOperator.Free;
    end;
  finally
    //�黹���ӳ�
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
  //ͨ������ID��ȡһ�����ӳض���
  lvPoolObj := TUniPool.getConnObject('main');
  try
    //������
    lvPoolObj.checkConnect;

    //Uni���ݿ��������<���Ը��ö����Ч�ʸ���>
    lvDBDataOperator := TUniOperator.Create;
    try
      //����ʹ�õ����ӳ�
      lvDBDataOperator.Connection := lvPoolObj.ConnObj;

      lvSQL := 'SELECT * FROM sys_Client WHERE FCode = ''' + pvCMDObject.Config.S['user'] + '''';

      self.StateINfo := '������һ��lvDBDataOperator,׼��������!';
      try
        //��ȡһ����ѯ������
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
          raise Exception.Create('�û����Ѿ�����!');
        end;
        self.StateINfo := 'lvDBDataOperator,ִ��SQL������,׼����д����';
      except
        raise;
      end;
      pvCMDObject.clear;

    finally
      lvDBDataOperator.Free;
    end;
  finally
    //�黹���ӳ�
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
  //ͨ������ID��ȡһ�����ӳض���
  lvPoolObj := TUniPool.getConnObject('main');
  try
    //������
    lvPoolObj.checkConnect;

    //Uni���ݿ��������<���Ը��ö����Ч�ʸ���>
    lvDBDataOperator := TUniOperator.Create;
    try
      //����ʹ�õ����ӳ�
      lvDBDataOperator.Connection := lvPoolObj.ConnObj;

      lvSQL := 'SELECT * FROM sys_Users WHERE FCode = ''' + pvCMDObject.Config.S['user'] + '''';

      self.StateINfo := '������һ��lvDBDataOperator,׼��������!';
      try
        //��ȡһ����ѯ������
        lvDataSet := lvDBDataOperator.CDSProvider.Query(lvSQL);
        pvCMDObject.clear;
        if lvDataSet.RecordCount = 0 then
        begin
          pvCMDObject.Config.S['__msg'] := '�û�������ʹ��';
          pvCMDObject.CMDResult := 1;
        end else
        begin
          pvCMDObject.Config.S['__msg'] := '�û����Ѿ���ռ��';
          pvCMDObject.CMDResult := 2;
        end;
        self.StateINfo := 'lvDBDataOperator,ִ��SQL������,׼����д����';
      except
        raise;
      end;

    finally
      lvDBDataOperator.Free;
    end;
  finally
    //�黹���ӳ�
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
  //ͨ������ID��ȡһ�����ӳض���
  lvPoolObj := TUniPool.getConnObject('main');
  try
    //������
    lvPoolObj.checkConnect;

    //Uni���ݿ��������<���Ը��ö����Ч�ʸ���>
    lvDBDataOperator := TUniOperator.Create;
    try
      //����ʹ�õ����ӳ�
      lvDBDataOperator.Connection := lvPoolObj.ConnObj;

      lvSQL := 'SELECT * FROM sys_Client WHERE FCode = ''' + pvCMDObject.Config.S['user'] + '''';

      self.StateINfo := '������һ��lvDBDataOperator,׼��������!';
      try
        //��ȡһ����ѯ������
        lvDataSet := lvDBDataOperator.CDSProvider.Query(lvSQL);
        pvCMDObject.clear;
        if lvDataSet.RecordCount = 0 then
        begin
          pvCMDObject.Config.S['__msg'] := '�û�������ʹ��';
          pvCMDObject.CMDResult := 1;
        end else
        begin
          pvCMDObject.Config.S['__msg'] := '�û����Ѿ���ռ��';
          pvCMDObject.CMDResult := 2;
        end;
        self.StateINfo := 'lvDBDataOperator,ִ��SQL������,׼����д����';
      except
        raise;
      end;

    finally
      lvDBDataOperator.Free;
    end;
  finally
    //�黹���ӳ�
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
  //ͨ������ID��ȡһ�����ӳض���
  lvPoolObj := TUniPool.getConnObject('main');
  try
    //������
    lvPoolObj.checkConnect;

    //Uni���ݿ��������<���Ը��ö����Ч�ʸ���>
    lvDBDataOperator := TUniOperator.Create;
    try
      //����ʹ�õ����ӳ�
      lvDBDataOperator.Connection := lvPoolObj.ConnObj;

      lvSQL := pvCMDText;

      self.StateINfo := '������һ��lvDBDataOperator,׼����ִ�нű�!';
      try
        lvDBDataOperator.CDSProvider.ExecuteScript(lvSQL);
        self.StateINfo := 'lvDBDataOperator,ִ��SQL������,׼����д����';
      except
        raise;
      end;
    finally
      lvDBDataOperator.Free;
    end;
  finally
    //�黹���ӳ�
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
