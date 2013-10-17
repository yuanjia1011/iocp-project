unit ufrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Controls, Forms, Dialogs, ComCtrls,
  uIOCPRunner,
  StdCtrls,


  SQLServerUniProvider, MySQLUniProvider;

type
  TfrmMain = class(TForm)
    pgcMain: TPageControl;
    TabSheet1: TTabSheet;
    tsIOCPINfo: TTabSheet;
    btnStart: TButton;
    btnStop: TButton;
    tsDebug: TTabSheet;
    btnAssign: TButton;
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
  private
    { Private declarations }
    FIOCPRuuner:TIOCPRunner;
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

uses uFMIOCPDebugINfo;

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

procedure TfrmMain.refreshState;
begin
  btnStart.Enabled := not FIOCPRuuner.IOCPConsole.Active;
  btnStop.Enabled := not btnStart.Enabled;
end;

end.
