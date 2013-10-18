unit udmMain;

interface

uses
  System.SysUtils, System.Classes, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, uCMDObject;

type
  TdmMain = class(TDataModule)
    IdTCPClient: TIdTCPClient;
  private
    FCMDObject: TCMDObject;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    { Public declarations }
    procedure DoAction(pvCMDObject: TCMDObject = nil);
    property CMDObject: TCMDObject read FCMDObject;
    procedure checkConnect();
  end;

var
  dmMain: TdmMain;

implementation

uses
  uIdTcpClientCMDObjectCoder;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TdmMain.checkConnect;
begin
  if not IdTCPClient.Connected then
  begin
    IdTCPClient.Host := '127.0.0.1';
    IdTCPClient.Port := 9903;
    IdTCPClient.Connect;
  end;
end;

constructor TdmMain.Create(AOwner: TComponent);
begin
  inherited;
  FCMDObject := TCMDObject.Create();
end;

destructor TdmMain.Destroy;
begin
  FCMDObject.Free;
  FCMDObject := nil;
  inherited Destroy;
end;

procedure TdmMain.DoAction(pvCMDObject: TCMDObject = nil);
var
  lvCMDObject:TCMDObject;
begin
  checkConnect;
  lvCMDObject := pvCMDObject;
  if pvCMDObject = nil then
  begin
    lvCMDObject := FCMDObject;
  end;
  TIdTcpClienTCMDObjectCoder.Encode(IdTCPClient, lvCMDObject);

  lvCMDObject.clear;

  TIdTcpClienTCMDObjectCoder.Decode(IdTCPClient, lvCMDObject);

  if lvCMDObject.CMDResult = -1 then
    raise Exception.Create(lvCMDObject.Config.S['__msg']);
end;

end.
