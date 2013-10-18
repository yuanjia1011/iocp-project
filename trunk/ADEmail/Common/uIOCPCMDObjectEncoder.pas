unit uIOCPCMDObjectEncoder;

interface

uses
  uIOCPCentre, uBuffer, uCMDObject, Classes,
  uZipTools, SysUtils, uIOCPProtocol, EDecryptionWrapper;

type
  TIOCPCMDObjectEncoder = class(TIOCPEncoder)
  private
    FEncryptKey:AnsiString;
  public
    constructor Create();
    /// <summary>
    ///   编码要发生的对象
    /// </summary>
    /// <param name="pvDataObject"> 要进行编码的对象 </param>
    /// <param name="ouBuf"> 编码好的数据 </param>
    procedure Encode(pvDataObject:TObject; const ouBuf: TBufferLink); override;

    procedure setEncryptKey(pvKeyCode:AnsiString);
  end;



implementation


constructor TIOCPCMDObjectEncoder.Create;
begin
  FEncryptKey := 'ADEmailCode';
end;

procedure TIOCPCMDObjectEncoder.Encode(pvDataObject:TObject; const ouBuf:
    TBufferLink);
var
  lvCMDObject:TCMDObject;
  lvJSonLength:Integer;
  lvStreamLength:Integer;
  sData:AnsiString;
  lvStream:TStream;
  lvTempBuf:PAnsiChar;
  lvBytes, lvTempBytes:TIOCPBytes;
begin
  if pvDataObject = nil then exit;
  lvCMDObject := TCMDObject(pvDataObject);

  //是否压缩流
  if (lvCMDObject.Stream <> nil) then
  begin
    if lvCMDObject.Config.O['config.stream.zip'] <> nil then
    begin
      if lvCMDObject.Config.B['config.stream.zip'] then
      begin
        //压缩流
        TZipTools.compressStreamEx(lvCMDObject.Stream);
      end;
    end else if lvCMDObject.Stream.Size > 0 then
    begin
      //压缩流
      TZipTools.compressStreamEx(lvCMDObject.Stream);
      lvCMDObject.Config.B['config.stream.zip'] := true;
    end;
  end;


  sData := lvCMDObject.Config.AsJSon(True, False);
  sData := TEDecryptionWrapper.AES_EncryptStr2(sData);

  lvJSonLength := Length(sData);
  lvStream := TMemoryStream.Create;
  try
    lvCMDObject.Stream.Position := 0;
    lvStream.Position := 0;

    lvStream.CopyFrom(lvCMDObject.Stream, lvCMDObject.Stream.Size);

    //AES.EncryptStream(lvCMDObject.Stream, FEncryptKey, lvStream);

    ouBuf.AddBuffer(@lvJSonLength, SizeOf(lvJSonLength));


    if lvStream <> nil then
    begin
      lvStreamLength := lvStream.Size;
    end else
    begin
      lvStreamLength := 0;
    end;

    ouBuf.AddBuffer(@lvStreamLength, SizeOf(lvStreamLength));


    ouBuf.AddBuffer(@lvCMDObject.CMDIndex, SizeOf(Integer));
    ouBuf.AddBuffer(@lvCMDObject.CMDResult, SizeOf(Integer));
    ouBuf.AddBuffer(@lvCMDObject.SessionID, SizeOf(Integer));

    //json bytes
    ouBuf.AddBuffer(PAnsiChar(sData), lvJSonLength);


    if lvStream.Size > 0 then
    begin
      //stream bytes
      GetMem(lvTempBuf, lvStream.Size);
      try
        lvStream.Position := 0;
        lvStream.ReadBuffer(lvTempBuf^, lvStream.Size);
        ouBuf.AddBuffer(lvTempBuf, lvStream.Size);
      finally
        FreeMem(lvTempBuf, lvStream.Size);
      end;
    end;
  finally
    lvStream.Free;
  end;

end;

procedure TIOCPCMDObjectEncoder.setEncryptKey(pvKeyCode: AnsiString);
begin
  FEncryptKey := pvKeyCode;
end;

end.
