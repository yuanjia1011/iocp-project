unit uFileHandler;

interface

uses
  superobject, SysUtils, Classes;

type
  TFileHandler = class(TObject)
  private
    class function getBasePath: String;
    class function loadConfig: ISuperObject;
  public
    class procedure setBasePath(pvPath:string);
    class procedure reload;
    class procedure clearCache;

    /// <summary>TFileHandler.readFileData
    /// </summary>
    /// <returns>
    /// -1:文件不存在
    /// 0:没有可以读取的
    /// >0：读取到的尺寸
    /// </returns>
    /// <param name="pvFile"> (string) </param>
    /// <param name="pvPosition"> (Int64) </param>
    /// <param name="pvCount"> (Int64) </param>
    /// <param name="pvStream"> (TStream) </param>
    class function readFileData(pvFile: string; pvPosition, pvCount: Int64;
        pvStream: TStream): Integer;

    /// <summary>
    ///   写入文件数据
    /// </summary>
    /// <returns>
    ///   返回写入的文件长度
    /// </returns>
    /// <param name="pvFile"> 文件名 </param>
    /// <param name="pvBuffer"> 写入的数据 </param>
    /// <param name="pvPosition"> 开始写入的位置,大于现有文件尺寸或者负数则加入到最后 </param>
    /// <param name="pvCount"> 要写入的长度 </param>
    class function writeFileData(pvFile:string; pvBuffer:Pointer; pvPosition,
        pvCount: Int64): Integer;


    /// <summary>
    ///   获取文件信息
    /// </summary>
    /// <returns> Boolean
    /// </returns>
    /// <param name="pvFile"> (string) </param>
    /// <param name="pvFileINfo">
    ///
    /// </param>
    class function getFileINfo(pvFile: string; const pvFileINfo: ISuperObject):
        Boolean;
  end;

implementation


var
  __cache:ISuperObject;

{ TFileHandler }

class function TFileHandler.readFileData(pvFile: string; pvPosition, pvCount:
    Int64; pvStream: TStream): Integer;
var
  lvFile:String;
  lvFileStream:TFileStream;
begin
  lvFile := getBasePath + '\' + pvFile;
  if not FileExists(lvFile) then
  begin
    Result := -1;
  end else
  begin
    lvFileStream := TFileStream.Create(lvFile, fmOpenRead);
    try
      if pvPosition >= lvFileStream.Size then
      begin
        Result := 0;
      end else
      begin
        lvFileStream.Position := pvPosition;
        if lvFileStream.Size - lvFileStream.Position < pvCount then
        begin
          Result := lvFileStream.Size - lvFileStream.Position;
        end else
        begin
          Result := pvCount;
        end;
        Result := pvStream.CopyFrom(lvFileStream, Result);
      end;
    finally
      lvFileStream.Free;
    end;
  end;



end;

class procedure TFileHandler.reload;
begin
  __cache.O['config'] := loadConfig;
  if __cache.S['config.path'] <> '' then
  begin
    __cache.S['config.path'] := StringReplace(__cache.S['config.path'], '%app%', ExtractFilePath(ParamStr(0)), [rfReplaceAll, rfIgnoreCase]);

  end;
end;

class procedure TFileHandler.setBasePath(pvPath: string);
begin
  __cache.S['config.path'] := pvPath;
end;

class procedure TFileHandler.clearCache;
begin
  __cache.Clear();
end;

class function TFileHandler.getBasePath: String;
begin
  Result := __cache.S['config.path'];
  if Result = '' then
  begin
    Result := ExtractFilePath(ParamStr(0)) + 'files\';
    if not DirectoryExists(Result) then
    begin
      ForceDirectories(Result);
    end;
  end;
end;

class function TFileHandler.getFileINfo(pvFile: string; const pvFileINfo:
    ISuperObject): Boolean;
begin
  Result := ;
end;


class function TFileHandler.loadConfig: ISuperObject;
var
  lvStrings:TStrings;
  lvFile:String;
begin
  lvFile := ExtractFilePath(ParamStr(0)) + 'config\filecentre.config';
  if FileExists(lvFile) then
  begin
    lvStrings := TStringList.Create;
    try
      lvStrings.LoadFromFile(lvFile);
      Result := SO(lvStrings.Text);
      if (Result <> nil) and (Result.DataType <> stObject) then
      begin
        Result := nil;
      end;
    finally
      lvStrings.Free;
    end;
  end else
  begin
    Result := nil;
  end;
end;

class function TFileHandler.writeFileData(pvFile:string; pvBuffer:Pointer;
    pvPosition, pvCount: Int64): Integer;
var
  lvFile:String;
  lvFileStream:TFileStream;
begin
  lvFile := getBasePath + '\' + pvFile;
  if FileExists(lvFile) then
  begin
    lvFileStream := TFileStream.Create(lvFile, fmOpenWrite);
  end else
  begin
    lvFileStream := TFileStream.Create(lvFile, fmCreate);
  end;
  try
    if pvPosition >= lvFileStream.Size then
    begin
      lvFileStream.Position := lvFileStream.Size;
    end else if pvPosition < 0 then
    begin
      lvFileStream.Position := lvFileStream.Size;
    end else
    begin
      lvFileStream.Position := pvPosition;
    end;

    Result := lvFileStream.Write(pvBuffer, pvCount);
  finally
    lvFileStream.Free;
  end;
end;



initialization
  __cache := SO();



finalization
  __cache := nil;


end.
