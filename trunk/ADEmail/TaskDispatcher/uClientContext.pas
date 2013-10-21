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
    FuserCode: String;
    FuserName: String;
  protected
    procedure DoConnect; override;
    procedure DoDisconnect; override;
    procedure DoOnWriteBack; override;

  private
    //��½
    procedure DoLogin(const pvCMDObject:TCMDObject);

    //ע����
    procedure DoRegisterCheck(const pvCMDObject:TCMDObject);

    //ע��
    procedure DoRegister(const pvCMDObject:TCMDObject);

    //��ȡһ������
    procedure DoGetATask(const pvCMDObject:TCMDObject);

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
  Math, uCMDConsts, uUniPool, UntCobblerUniPool, uUniOperator, DB, uCRCTools;





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

    end;

    //ֱ�ӻش�
    writeObject(lvCMDObject);
  except
    on E:Exception do
    begin
      lvCMDObject.clear;
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

      self.StateINfo := '������һ��lvADOOpera,׼��������!';
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
          lvDataSet.Edit;
          lvDataSet.FieldByName('FLastLoginTime').AsDateTime := Now();
          lvDataSet.Post;
          pvCMDObject.SessionID := TCRCTools.crc32String(pvCMDObject.Config.S['user'] + DateTimeToStr(Now()));
        end;
        self.StateINfo := 'lvADOOpera,ִ��SQL������,׼����д����';
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

      self.StateINfo := '������һ��lvADOOpera,׼��������!';
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
        self.StateINfo := 'lvADOOpera,ִ��SQL������,׼����д����';
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

      self.StateINfo := '������һ��lvADOOpera,׼��������!';
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
        self.StateINfo := 'lvADOOpera,ִ��SQL������,׼����д����';
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

end.
