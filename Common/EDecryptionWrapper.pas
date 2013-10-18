unit EDecryptionWrapper;

interface

uses
  ActiveX, Classes;

const
  EDecryptionLib = 'EDecryption.dll';

type
  TEDecryptionWrapper = class(TObject)
  public
    class function AES_EncryptStr(pvSource:AnsiString; pvKey:AnsiString):AnsiString;
    class function AES_DecryptStr(pvEncryptStr:AnsiString; pvKey:AnsiString): AnsiString;

    class function AES_EncryptStream(pvSource:TStream; pvDest:TStream;
        pvKey:AnsiString): Boolean;
    class function AES_DecryptStream(pvSource:TStream; pvDest:TStream;
        pvKey:AnsiString): Boolean;


    class function MD5_Compare(MD5_String: AnsiString; Normal_String: AnsiString): Boolean; stdcall;
    class function MD5_Str(S: AnsiString): AnsiString; stdcall;
    class function MD5_File(pvFile:AnsiString): AnsiString; stdcall;

  end;


function AESEncryptStr(pvSource:PAnsiChar; pvKey:PAnsiChar): PAnsiChar; stdcall;
function AESDecryptStr(pvEncryptStr:PAnsiChar; pvKey:PAnsiChar): PAnsiChar; stdcall;

function AESEncryptStream(pvSource:IStream; pvDest:IStream; pvKey:PAnsiChar): Boolean; stdcall;
function AESDecryptStream(pvSource:IStream; pvDest:IStream; pvKey:PAnsiChar): Boolean; stdcall;

function MD5Compare(MD5_String: PAnsiChar; Normal_String: PAnsiChar): Boolean; stdcall;
function MD5Str(S: PAnsiChar): PAnsiChar; stdcall;
function MD5File(pvFile:PAnsiChar): PAnsiChar; stdcall;



implementation



function AESEncryptStr; external EDecryptionLib name 'AESEncryptStr';
function AESDecryptStr; external EDecryptionLib name 'AESDecryptStr';
function AESEncryptStream; external EDecryptionLib name 'AESEncryptStream';
function AESDecryptStream; external EDecryptionLib name 'AESDecryptStream';


function MD5Compare; external EDecryptionLib name 'MD5Compare';
function MD5Str; external EDecryptionLib name 'MD5Str';
function MD5File; external EDecryptionLib name 'MD5File';
{ TEDecryptionWrapper }

class function TEDecryptionWrapper.AES_DecryptStr(pvEncryptStr,
  pvKey: AnsiString): AnsiString;
begin
  Result := AESDecryptStr(PAnsiChar(pvEncryptStr), PAnsiChar(pvKey));
end;

class function TEDecryptionWrapper.AES_DecryptStream(pvSource:TStream;
    pvDest:TStream; pvKey:AnsiString): Boolean;
begin
  Result := AESDecryptStream(TStreamAdapter.Create(pvSource),
    TStreamAdapter.Create(pvDest), PAnsiChar(pvKey));
end;

class function TEDecryptionWrapper.AES_EncryptStr(pvSource,
  pvKey: AnsiString): AnsiString;
begin
  Result := AESEncryptStr(PAnsiChar(pvSource), PAnsiChar(pvKey));
end;

class function TEDecryptionWrapper.AES_EncryptStream(pvSource:TStream;
    pvDest:TStream; pvKey:AnsiString): Boolean;
begin
  Result := AESEncryptStream(TStreamAdapter.Create(pvSource),
    TStreamAdapter.Create(pvDest), PAnsiChar(pvKey));
end;

class function TEDecryptionWrapper.MD5_Compare(MD5_String,
  Normal_String: AnsiString): Boolean;
begin
  Result := MD5Compare(PAnsiChar(MD5_String), PAnsiChar(Normal_String));
end;

class function TEDecryptionWrapper.MD5_File(pvFile: AnsiString): AnsiString;
begin
  Result := MD5File(PAnsiChar(pvFile));
end;

class function TEDecryptionWrapper.MD5_Str(S: AnsiString): AnsiString;
begin
  Result := MD5Str(PAnsiChar(S));
end;

end.
