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
    //ע��
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

      lvSQL := 'SELECT * FROM sys_Users WHERE 1=0';

      try
        //��ȡһ����ѯ������
        lvDataSet := lvDBDataOperator.CDSProvider.Query(lvSQL);
        if lvDataSet.RecordCount = 0 then
        begin
          lvDataSet.Append;
          lvDataSet.FieldByName('FKey').AsString := CreateClassID;
          lvDataSet.FieldByName('FCode').AsString := '����';
          lvDataSet.FieldByName('FPassword').AsString := '����';
          lvDataSet.FieldByName('FEmail').AsString := '����';
          lvDataSet.FieldByName('FName').AsString := UTF8Encode('����');
          lvDataSet.FieldByName('FMobile').AsString := '����';
          lvDataSet.FieldByName('FRegTime').AsDateTime := Now();
          lvDataSet.Post;
        end else
        begin
          raise Exception.Create('�û����Ѿ�����!');
        end;
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

procedure TfrmMain.refreshState;
begin
  btnStart.Enabled := not FIOCPRuuner.IOCPConsole.Active;
  btnStop.Enabled := not btnStart.Enabled;
end;

end.
