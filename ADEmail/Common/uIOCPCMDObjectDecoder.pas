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
    ///   �����յ�������,����н��յ�����,���ø÷���,���н���
    /// </summary>
    /// <returns>
    ///   ���ؽ���õĶ���
    /// </returns>
    /// <param name="inBuf"> ���յ��������� </param>
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

  //��������е����ݳ��Ȳ�����ͷ���ȣ�����ʧ��<json�ַ�������,������>
  lvValidCount := inBuf.validCount;
  if (lvValidCount < SizeOf(Integer) + SizeOf(Integer) + SizeOf(Integer) + SizeOf(Boolean)) then
  begin
    Exit;
  end;

  //��¼��ȡλ��
  inBuf.markReaderIndex;
  inBuf.readBuffer(@lvJSonLength, SizeOf(Integer));
  inBuf.readBuffer(@lvStreamLength, SizeOf(Integer));


  //��������е����ݲ���json�ĳ��Ⱥ�������<˵�����ݻ�û����ȡ���>����ʧ��
  lvValidCount := inBuf.validCount;

  if lvValidCount < (lvJSonLength + lvStreamLength +
     SizeOf(Integer) + SizeOf(Boolean)) then
  begin
    //����buf�Ķ�ȡλ��
    inBuf.restoreReaderIndex;
    exit;
  end;



  //����ɹ�
  lvCMDObject := TCMDObject.Create;
  Result := lvCMDObject;

  inBuf.readBuffer(@lvCMDObject.CMDIndex, SizeOf(Integer));
  inBuf.readBuffer(@lvCMDObject.CMDResult, SizeOf(Boolean));

  //��ȡjson�ַ���
  if lvJSonLength > 0 then
  begin
    SetLength(lvData, lvJSonLength);
    inBuf.readBuffer(@lvData[1], lvJSonLength);

    //lvData := AES.DecryptString(lvData, FEncryptKey);

    lvCMDObject.Config := SO(lvData);
  end else
  begin
    TFileLogger.instance.logMessage('���յ�һ��JSonΪ�յ�һ����������!', 'IOCP_ALERT_');
  end;


  //��ȡ������ 
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

        //��ʱ������
        lvCMDObject.Stream.CopyFrom(lvStream, lvStream.Size);
        lvCMDObject.Stream.Position := 0;

        //AES.DecryptStream(lvStream, FEncryptKey, lvCMDObject.Stream);
      finally
        lvStream.Free;
      end;

      //��ѹ��
      if lvCMDObject.Config.B['config.stream.zip'] then
      begin
        //��ѹ
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
