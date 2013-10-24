unit uUniOperatorPool;

interface

uses
  uUniOperator;

type
  TUniOperatorPool = class(TObject)
  public
    //���ڸĳɶ����
    class function getUniOperator:TUniOperator;

    //���ڸĳɶ����
    class procedure giveBackUniOperator(pvOperator:TUniOperator);
  end;

implementation

{ TUniOperatorPool }

class function TUniOperatorPool.getUniOperator: TUniOperator;
begin
  Result := TUniOperator.Create;
end;

class procedure TUniOperatorPool.giveBackUniOperator(pvOperator: TUniOperator);
begin
  pvOperator.Free;
end;

end.
