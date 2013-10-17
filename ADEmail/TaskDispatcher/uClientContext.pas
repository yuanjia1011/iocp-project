unit uClientContext;

interface

uses
  Windows, uBuffer, Classes, SysUtils,
  uIOCPCentre, uCMDObject;

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
    procedure DoLogin(const pvCMDObject:TCMDObject);
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
  Math, uCMDConsts, uUniPool, UntCobblerUniPool, uUniOperator, DB;





procedure TClientContext.dataReceived(const pvDataObject:TObject);
var
  lvCMDObject:TCMDObject;
begin
  lvCMDObject := TCMDObject(pvDataObject);
  try
    if lvCMDObject.CMDIndex = CMD_LOGIN then
    begin
      DoLogin(lvCMDObject);
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

end.
