unit uIdTcpClientCMDObjectCoder;

interface

uses
  Classes, uCMDObject, superobject,
  Windows,
  EDecryptionWrapper,
  IdGlobal,
  IdTCPClient, uZipTools, uIOCPProtocol, Math, SysUtils;


const
  BUF_BLOCK_SIZE = 1024;
  
type
  TIdTcpClienTCMDObjectCoder = class(TObject)
  private
    class function recvBuffer(pvSocket: TIdTCPClient; buf: Pointer; len: Cardinal):
        Integer;
    class function sendBuffer(pvSocket:TIdTCPClient; buf: Pointer; len: Cardinal):
        Integer;
    class function sendStream(pvSocket:TIdTCPClient; pvStream:TStream):Integer;
  public
    /// <summary>
    ///   接收解码
    /// </summary>
    /// <returns> Boolean
    /// </returns>
    /// <param name="pvSocket"> (TClientSocket) </param>
    /// <param name="pvObject"> (TObject) </param>
    class function Decode(pvSocket: TIdTcpClient; pvObject: TObject): Boolean;

    /// <summary>
    ///   编码发送
    /// </summary>
    /// <param name="pvSocket"> (TClientSocket) </param>
    /// <param name="pvObject"> (TObject) </param>
    class function Encode(pvSocket: TIdTcpClient; pvObject: TObject): Integer;

  end;

implementation

uses
  FileLogger;

class function TIdTcpClienTCMDObjectCoder.Decode(pvSocket: TIdTcpClient;
    pvObject: TObject): Boolean;
var
  lvJSonLength, lvStreamLength:Integer;
  lvData, lvTemp:AnsiString;
  lvStream:TStream;

  lvCMDObject:TCMDObject;
  lvBytes:TIOCPBytes;

  l, lvRemain:Integer;
  lvBufBytes:array[0..1023] of byte;
begin
  Result := false;
  lvJSonLength := 0;
  lvStreamLength := 0;
  //TFileLogger.instance.logDebugMessage('1100');
  recvBuffer(pvSocket, @lvJSonLength, SizeOf(Integer));
  recvBuffer(pvSocket, @lvStreamLength, SizeOf(Integer));
  //TFileLogger.instance.logDebugMessage('1101');

  if (lvJSonLength = 0) and (lvStreamLength = 0) then exit;
  




  //TFileLogger.instance.logDebugMessage('1102, ' + InttoStr(lvJSonLength) + ',' + intToStr(lvStreamLength));

  lvCMDObject := TCMDObject(pvObject);
  lvCMDObject.Clear();
  recvBuffer(pvSocket, @lvCMDObject.CMDIndex, SizeOf(Integer));
  recvBuffer(pvSocket, @lvCMDObject.CMDResult, SizeOf(Integer));
  recvBuffer(pvSocket, @lvCMDObject.SessionID, SizeOf(Integer));
  //TFileLogger.instance.logDebugMessage('1103');
  //读取json字符串
  if lvJSonLength > 0 then
  begin
    //TFileLogger.instance.logDebugMessage('1104');

    lvStream:=TMemoryStream.Create();
    try
      lvRemain := lvJSonLength;
      while lvStream.Size < lvJSonLength do
      begin

        l := recvBuffer(pvSocket, @lvBufBytes[0], Min(lvRemain, (SizeOf(lvBufBytes))));
        lvStream.WriteBuffer(lvBufBytes[0], l);
        lvRemain := lvRemain - l;
      end;


      SetLength(lvData, lvStream.Size);
      lvStream.Position := 0;
      lvStream.ReadBuffer(lvData[1], lvStream.Size);

      lvData := TEDecryptionWrapper.AES_DecryptStr2(lvData);

      lvCMDObject.Config := SO(lvData);
      if (lvCMDObject.Config = nil) or (lvCMDObject.Config.DataType <> stObject) then
      begin
        TFileLogger.instance.logMessage('接收JSon' + sLineBreak + lvData);
        TMemoryStream(lvStream).SaveToFile(ExtractFilePath(ParamStr(0)) +
          'DEBUG_' + FormatDateTime('YYYYMMDDHHNNSS', Now()) + '.dat');
        raise Exception.Create('解码JSon对象失败,接收到得JSon字符串为!');
      end;
            
    finally
      lvStream.Free;
    end;
  end;

  //读取流数据 
  if lvStreamLength > 0 then
  begin
    lvStream := lvCMDObject.Stream;
    lvStream.Size := 0;
    lvRemain := lvStreamLength;
    while lvStream.Size < lvStreamLength do
    begin
      recvBuffer(pvSocket, @lvBufBytes[0], Min(lvRemain, (SizeOf(lvBufBytes))));
      lvStream.WriteBuffer(lvBufBytes[0], l);
      lvRemain := lvRemain - l;
    end;

    //解压流
    if (lvCMDObject.Config <> nil) and (lvCMDObject.Config.B['config.stream.zip']) then
    begin
      //解压
      TZipTools.unCompressStreamEX(lvCMDObject.Stream);
    end;
  end;
  Result := true;
end;

class function TIdTcpClienTCMDObjectCoder.Encode(pvSocket: TIdTcpClient;
    pvObject: TObject): Integer;
var
  lvCMDObject:TCMDObject;
  lvJSonLength:Integer;
  lvStreamLength:Integer;
  sData, lvTemp:AnsiString;
  lvStream, lvSendStream:TStream;
  lvTempBuf:PAnsiChar;

  lvBytes, lvTempBytes:TIOCPBytes;
  
  l:Integer;
  lvBufBytes:array[0..1023] of byte;
begin
  if pvObject = nil then exit;
  lvCMDObject := TCMDObject(pvObject);
  
  //是否压缩流
  if (lvCMDObject.Stream <> nil) and (lvCMDObject.Stream.Size > 0) then
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

  if lvCMDObject.Config <> nil then
  begin
    sData := lvCMDObject.Config.AsJSon(True, false);
    sData := TEDecryptionWrapper.AES_EncryptStr2(sData);
  end else
  begin
    sData := '';
  end;

  lvJSonLength := Length(sData);

  lvStream := TMemoryStream.Create;
  try
    //加密流
    if (lvCMDObject.Stream <> nil) and (lvCMDObject.Stream.Size > 0) then
    begin
      lvCMDObject.Stream.Position := 0;

      lvStream.CopyFrom(lvCMDObject.Stream, lvCMDObject.Stream.Size);
      //AES.EncryptStream(lvCMDObject.Stream, pvEncryptKey, lvStream);
      lvStream.Position :=0;
    end;
    lvStreamLength := lvStream.Size;


    lvSendStream := TMemoryStream.Create;
    try
      lvSendStream.Write(lvJSonLength, SizeOf(lvJSonLength));
      lvSendStream.Write(lvStreamLength, SizeOf(lvStreamLength));

      lvSendStream.Write(lvCMDObject.CMDIndex, SizeOf(Integer));
      lvSendStream.Write(lvCMDObject.CMDResult, SizeOf(Integer));
      lvSendStream.Write(lvCMDObject.SessionID, SizeOf(Integer));
      if lvJSonLength > 0 then
      begin
        lvSendStream.Write(sData[1], lvJSonLength);
      end;

      if (lvStream <> nil) and (lvStream.Size > 0) then
      begin
        lvStream.Position := 0;
        lvSendStream.CopyFrom(lvStream, lvStream.Size);
      end;

    
      //头信息和JSon数据
      l := sendStream(pvSocket, lvSendStream);
      Result := l;
    finally
      lvSendStream.Free;
    end;
  finally
    lvStream.Free;
  end;
end;

class function TIdTcpClienTCMDObjectCoder.recvBuffer(pvSocket: TIdTCPClient;
    buf: Pointer; len: Cardinal): Integer;
var
  lvBuf: TIdBytes;
begin
  pvSocket.Socket.ReadBytes(lvBuf, len);
  Result := IndyLength(lvBuf);
  CopyMemory(buf, @lvBuf[0], Result);
  SetLength(lvBuf, 0);
end;

class function TIdTcpClienTCMDObjectCoder.sendBuffer(pvSocket: TIdTCPClient;
  buf: Pointer; len: Cardinal): Integer;
var
  lvBytes:TIdBytes;
begin
  SetLength(lvBytes, len);
  CopyMemory(@lvBytes[0], buf, len);
  pvSocket.Socket.Write(lvBytes, len);
  SetLength(lvBytes, 0);
  Result := len;
end;

class function TIdTcpClienTCMDObjectCoder.sendStream(pvSocket: TIdTCPClient;
  pvStream: TStream): Integer;
var
  lvBufBytes:array[0..BUF_BLOCK_SIZE-1] of byte;
  l, j, lvTotal:Integer;
begin
  Result := 0;
  if pvStream = nil then Exit;
  if pvStream.Size = 0 then Exit;

  lvTotal :=0;
  
  pvStream.Position := 0;
  repeat
    FillMemory(@lvBufBytes[0], SizeOf(lvBufBytes), 0);
    l := pvStream.Read(lvBufBytes[0], SizeOf(lvBufBytes));
    if (l > 0) and pvSocket.Connected then
    begin
      j:=sendBuffer(pvSocket, @lvBufBytes[0], l);
      if j <> l then
      begin
        raise Exception.CreateFmt('发送Buffer错误指定发送%d,实际发送:%d', [j, l]);
      end else
      begin
        lvTotal := lvTotal + j;
      end;
    end else Break;
  until (l = 0);
  Result := lvTotal;
end;

end.
