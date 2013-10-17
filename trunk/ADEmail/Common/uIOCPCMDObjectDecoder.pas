unit uIOCPCMDObjectDecoder;

interface

uses
  uIOCPCentre, uBuffer, Classes, uCMDObject, uIOCPFileLogger, SysUtils, AES;

type
  TIOCPCMDObjectDecoder = class(TIOCPDecoder)
  private
    FEncryptKey:AnsiString;
  protected
    constructor Create();
    /// <summary>
    ///   解码收到的数据,如果有接收到数据,调用该方法,进行解码
    /// </summary>
    /// <returns>
    ///   返回解码好的对象
    /// </returns>
    /// <param name="inBuf"> 接收到的流数据 </param>
    function Decode(const inBuf: TBufferLink): TObject; override;

    procedure setEncryptKey(pvKeyCode:AnsiString);
  end;


implementation

uses
  Windows, superobject, uZipTools, FileLogger, uIOCPProtocol;

constructor TIOCPCMDObjectDecoder.Create;
begin
  FEncryptKey := 'ADEmailCode';
end;

function TIOCPCMDObjectDecoder.Decode(const inBuf: TBufferLink): TObject;
var
  lvJSonLength, lvStreamLength:Integer;
  lvData:AnsiString;
  lvBuffer:array of Char;
  lvBufData:PAnsiChar;
  lvCMDObject:TCMDObject;
  lvStream:TMemoryStream;
  lvBytes:TIOCPBytes;
  lvValidCount:Integer;
begin
  Result := nil;

  //如果缓存中的数据长度不够包头长度，解码失败<json字符串长度,流长度>
  lvValidCount := inBuf.validCount;
  if (lvValidCount < SizeOf(Integer) + SizeOf(Integer) + SizeOf(Integer) + SizeOf(Boolean)) then
  begin
    Exit;
  end;

  //记录读取位置
  inBuf.markReaderIndex;
  inBuf.readBuffer(@lvJSonLength, SizeOf(Integer));
  inBuf.readBuffer(@lvStreamLength, SizeOf(Integer));


  //如果缓存中的数据不够json的长度和流长度<说明数据还没有收取完毕>解码失败
  lvValidCount := inBuf.validCount;

  if lvValidCount < (lvJSonLength + lvStreamLength +
     SizeOf(Integer) + SizeOf(Boolean)) then
  begin
    //返回buf的读取位置
    inBuf.restoreReaderIndex;
    exit;
  end;



  //解码成功
  lvCMDObject := TCMDObject.Create;
  Result := lvCMDObject;

  inBuf.readBuffer(@lvCMDObject.CMDIndex, SizeOf(Integer));
  inBuf.readBuffer(@lvCMDObject.CMDResult, SizeOf(Boolean));

  //读取json字符串
  if lvJSonLength > 0 then
  begin
    SetLength(lvData, lvJSonLength);
    inBuf.readBuffer(@lvData[1], lvJSonLength);

    //lvData := AES.DecryptString(lvData, FEncryptKey);

    lvCMDObject.Config := SO(lvData);
  end else
  begin
    TFileLogger.instance.logMessage('接收到一次JSon为空的一次数据请求!', 'IOCP_ALERT_');
  end;


  //读取流数据 
  if lvStreamLength > 0 then
  begin
    GetMem(lvBufData, lvStreamLength);
    try
      inBuf.readBuffer(lvBufData, lvStreamLength);
      lvStream := TMemoryStream.Create;
      try
        lvStream.WriteBuffer(lvBufData^, lvStreamLength);
        lvStream.Position := 0;
        lvCMDObject.Stream.Size := 0;

        //暂时不加密
        lvCMDObject.Stream.CopyFrom(lvStream, lvStream.Size);
        lvCMDObject.Stream.Position := 0;

        //AES.DecryptStream(lvStream, FEncryptKey, lvCMDObject.Stream);
      finally
        lvStream.Free;
      end;

      //解压流
      if lvCMDObject.Config.B['config.stream.zip'] then
      begin
        //解压
        TZipTools.unCompressStreamEX(lvCMDObject.Stream);
      end;
    finally
      FreeMem(lvBufData, lvStreamLength);
    end;
  end;
end;

procedure TIOCPCMDObjectDecoder.setEncryptKey(pvKeyCode: AnsiString);
begin
  FEncryptKey := pvKeyCode;
end;

end.
