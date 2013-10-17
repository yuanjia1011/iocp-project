unit uClientSessions;

interface

uses
  uClientContext, superobject, SyncObjs;

type
  TClientSessions = class(TObject)
  private
    FCS:TCriticalSection;
    FSessions: ISuperObject;
  public
    class function Instance:TClientSessions;
    constructor Create();
    destructor Destroy; override;
    procedure checkClientContext(pvClient:TClientContext);
  end;

implementation

var
  __instance:TClientSessions;

procedure TClientSessions.checkClientContext(pvClient: TClientContext);
begin
  ;
end;

constructor TClientSessions.Create;
begin
  inherited Create;
  FSessions := SO();
  FCS := TCriticalSection.Create;
end;

destructor TClientSessions.Destroy;
begin
  FSessions := nil;
  FCS.Free;
  inherited;
end;

class function TClientSessions.Instance: TClientSessions;
begin
  result := __instance;
end;

initialization
  __instance:=TClientSessions.Create;

finalization
  __instance.Free;

end.
