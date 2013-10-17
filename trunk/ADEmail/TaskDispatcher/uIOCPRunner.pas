unit uIOCPRunner;

interface

uses
  uIOCPProtocol, uIOCPCentre, uIOCPConsole, uIOCPCMDObjectDecoder,
  uIOCPCMDObjectEncoder, uClientContext;

type
  TIOCPRunner = class(TObject)
  private
    FIOCPConsole:TIOCPConsole;
    FDecoder:TIOCPCMDObjectDecoder;
    FEncoder:TIOCPCMDObjectEncoder;
  public
    constructor Create();
    procedure Execute;
    procedure Stop;
    destructor Destroy; override;

    property IOCPConsole:TIOCPConsole  read FIOCPConsole;





  end;

implementation

{ TIOCPRunner }

constructor TIOCPRunner.Create;
begin
  FIOCPConsole := TIOCPConsole.Create;
  FDecoder := TIOCPCMDObjectDecoder.Create;
  FEncoder := TIOCPCMDObjectEncoder.Create;
  TIOCPContextFactory.instance.registerClientContextClass(TClientContext);
  TIOCPContextFactory.instance.registerDecoder(FDecoder);
  TIOCPContextFactory.instance.registerEncoder(FEncoder);
end;

destructor TIOCPRunner.Destroy;
begin
  FIOCPConsole.Free;
  FEncoder.Free;
  FDecoder.Free;
  inherited;
end;

procedure TIOCPRunner.Execute;
begin
  FIOCPConsole.Port := 9903;
  FIOCPConsole.open;
end;

procedure TIOCPRunner.Stop;
begin
  FIOCPConsole.close;
end;

end.
