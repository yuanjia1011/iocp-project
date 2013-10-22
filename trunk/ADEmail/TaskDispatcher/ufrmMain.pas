unit ufrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Controls, Forms, Dialogs, ComCtrls,
  uIOCPRunner,
  StdCtrls,


  SQLServerUniProvider, MySQLUniProvider, uCMDObject, ComObj;

type
  TfrmMain = class(TForm)
    pgcMain: TPageControl;
    TabSheet1: TTabSheet;
    tsIOCPINfo: TTabSheet;
    btnStart: TButton;
    btnStop: TButton;
    tsDebug: TTabSheet;
    btnAssign: TButton;
    btnTesterMySQL: TButton;
    btnFileHandler: TButton;
    procedure btnFileHandlerClick(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure btnTesterMySQLClick(Sender: TObject);
  private
    { Private declarations }
    FIOCPRuuner:TIOCPRunner;
    //注册
    procedure DoRegister;
    procedure refreshState;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses uFMIOCPDebugINfo, uUniOperator, UntCobblerUniPool, Db, uUniPool,
  uFileHandler;

{ TfrmMain }

procedure TfrmMain.btnStartClick(Sender: TObject);
begin
  FIOCPRuuner.Execute;
  refreshState;
end;

procedure TfrmMain.btnStopClick(Sender: TObject);
begin
  FIOCPRuuner.Stop;
  refreshState;
end;

constructor TfrmMain.Create(AOwner: TComponent);
begin
  inherited;
  FIOCPRuuner := TIOCPRunner.Create;
  TFMIOCPDebugINfo.createAsChild(tsIOCPINfo, FIOCPRuuner.IOCPConsole);
  refreshState;
end;

destructor TfrmMain.Destroy;
begin
  FIOCPRuuner.Free;
  inherited;
end;

procedure TfrmMain.btnFileHandlerClick(Sender: TObject);
var
  lvCount, lvPosition:Integer;
  lvFileStream:TFileStream;
  lvFileName:String;
  lvBuffer: PAnsiChar;
begin
  TFileHandler.setBasePath('D:\');

  lvFileName :='D:\abc.jpg';
  if FileExists(lvFileName) then
  begin
    lvFileStream := TFileStream.Create(lvFileName, fmOpenRead);
    try
      lvPosition := 0;
      GetMem(lvBuffer, 1024);
      try
        while True do
        begin
          lvCount := lvFileStream.Read(lvBuffer^, 1024);
          lvPosition := lvPosition + TFileHandler.writeFileData('writeabc.jpg', lvBuffer, lvPosition, lvCount);

          if lvCount =0 then
          begin
            Break;
          end;
        end;
      finally
        FreeMem(lvBuffer);
      end;
    finally
      lvFileStream.Free;
    end;
  end;


end;

procedure TfrmMain.btnTesterMySQLClick(Sender: TObject);
begin
  DoRegister();
end;

procedure TfrmMain.DoRegister;
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

      lvSQL := 'SELECT * FROM sys_Users WHERE 1=0';

      try
        //获取一个查询的数据
        lvDataSet := lvDBDataOperator.CDSProvider.Query(lvSQL);
        if lvDataSet.RecordCount = 0 then
        begin
          lvDataSet.Append;
          lvDataSet.FieldByName('FKey').AsString := CreateClassID;
          lvDataSet.FieldByName('FCode').AsString := '汉字';
          lvDataSet.FieldByName('FPassword').AsString := '汉字';
          lvDataSet.FieldByName('FEmail').AsString := '汉字';
          lvDataSet.FieldByName('FName').AsString := UTF8Encode('汉字');
          lvDataSet.FieldByName('FMobile').AsString := '汉字';
          lvDataSet.FieldByName('FRegTime').AsDateTime := Now();
          lvDataSet.Post;
        end else
        begin
          raise Exception.Create('用户名已经存在!');
        end;
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

procedure TfrmMain.refreshState;
begin
  btnStart.Enabled := not FIOCPRuuner.IOCPConsole.Active;
  btnStop.Enabled := not btnStart.Enabled;
end;

end.
