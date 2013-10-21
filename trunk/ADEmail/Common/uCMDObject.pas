unit uCMDObject;

interface

uses
  SysUtils, Classes, Windows, superobject;

type
  TCMDObject = class(TObject)
  private
    FCMDIndex: Integer;
    FStream: TStream;
    FCMDResult: Integer;
    FConfig: ISuperObject;
    FSessionID: Integer;
  public
    constructor Create();
    destructor Destroy; override;
    procedure clear;
    property CMDIndex:Integer read FCMDIndex write FCMDIndex;
    property CMDResult:Integer read FCMDResult write FCMDResult;
    property Config:ISuperObject read FConfig write FConfig;
    property SessionID:Integer read FSessionID write FSessionID;
    property Stream:TStream read FStream;
  end;

implementation

{ TCMDObject }

procedure TCMDObject.clear;
begin
  FStream.Size := 0;
  FConfig.Clear();
  FCMDResult := 0;
end;

constructor TCMDObject.Create;
begin
  FStream := TMemoryStream.Create;
  FConfig := SO();
  FSessionID := 0;
  FCMDIndex := 0;
  CMDResult := 0;
end;

destructor TCMDObject.Destroy;
begin
  FConfig := nil;
  FStream.Free;
  FStream := nil;
  inherited;
end;

end.
