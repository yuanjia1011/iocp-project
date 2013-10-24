unit uUniOperatorPool;

interface

uses
  uUniOperator;

type
  TUniOperatorPool = class(TObject)
  public
    //后期改成对象池
    class function getUniOperator:TUniOperator;

    //后期改成对象池
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
