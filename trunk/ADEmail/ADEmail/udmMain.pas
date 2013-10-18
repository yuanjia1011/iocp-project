unit udmMain;

interface

uses
  System.SysUtils, System.Classes, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, uCMDObject;

type
  TdmMain = class(TDataModule)
    IdTCPClient: TIdTCPClient;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure DoAction(pvCMDObject:TCMDObject);
  end;

var
  dmMain: TdmMain;

implementation

uses
  uIdTcpClientCMDObjectCoder;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TdmMain.DoAction(pvCMDObject:TCMDObject);
begin
  TIdTcpClienTCMDObjectCoder.Encode(dmMain.IdTCPClient, pvCMDObject);

  pvCMDObject.clear;

  TIdTcpClienTCMDObjectCoder.Decode(dmMain.IdTCPClient, pvCMDObject);

  if pvCMDObject.CMDResult = -1 then
    raise Exception.Create(pvCMDObject.Config.S['__msg']);
end;

end.
