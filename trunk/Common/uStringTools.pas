unit uStringTools;

interface

type
  TAnsiCharSet = set of AnsiChar;
  TStringTools = class(TObject)
  public
    class function DeleteChars(const s: string; pvCharSets: TAnsiCharSet): string;
    class function FixValidKeyValue(pvKeyValue: string): string;

  end;

implementation

//   字符长度:3.8M 15ns
//   字符长度:38.15 M  391ns
//   DeleteChars(pvGUIDKey, ['-', '{','}']);

class function TStringTools.DeleteChars(const s: string; pvCharSets:
    TAnsiCharSet): string;
var
  i, l, times: Integer;
  lvStr: string;
begin
  l := Length(s);
  SetLength(lvStr, l);
  times := 0;
  for i := 1 to l do
  begin
    if not (s[i] in pvCharSets) then
    begin
      inc(times);
      lvStr[times] := s[i];
    end;
  end;
  SetLength(lvStr, times);
  Result := lvStr;
end;

class function TStringTools.FixValidKeyValue(pvKeyValue: string): string;
begin
  //   /\:*?<>"[]|
  Result := DeleteChars(pvKeyValue, ['-', ',', '.',
    '{', '}', '(', ')', '\', '/', '"', '[', ']', '|', '?', '<', '>', ' ']);
end;

end.
