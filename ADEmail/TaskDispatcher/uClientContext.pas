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

    //直接回传
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

      self.StateINfo := '借用了一个lvADOOpera,准备打开连接!';
      try
        //获取一个查询的数据
        lvDataSet := lvDBDataOperator.CDSProvider.Query(lvSQL);

        if lvDataSet.RecordCount = 0 then
        begin
          raise Exception.Create('用户不存在!');
        end;
        self.StateINfo := 'lvADOOpera,执行SQL语句完成,准备回写数据';
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

end.
