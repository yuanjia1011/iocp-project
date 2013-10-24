unit uEmailTaskHandler;

interface

uses
  Windows, uBuffer, Classes, SysUtils,
  uIOCPCentre, uCMDObject, ComObj, uClientContext, superobject;


type
  TEmailTaskHandler = class(TObject)
  private
  public
    //获取我的任务列表
    class procedure GetTaskList(const pvUserKey: string; const pvCMDObject:
        TCMDObject; pvContent: TClientContext);
  end;



implementation

uses
  Math, uCMDConsts, uUniPool, UntCobblerUniPool, uUniOperator, DB, uCRCTools,
  uFileHandler, uStringTools, uUniOperatorPool;

class procedure TEmailTaskHandler.GetTaskList(const pvUserKey: string; const
    pvCMDObject: TCMDObject; pvContent: TClientContext);
var
  lvDBDataOperator:TUniOperator;
  lvPoolObj:TUniCobbler;
  lvSQL:AnsiString;
  lvDataSet:TDataSet;
  lvItem:ISuperObject;
begin
  //通过帐套ID获取一个连接池对象
  lvPoolObj := TUniPool.getConnObject('main');
  try
    //打开连接
    lvPoolObj.checkConnect;

    //Uni数据库操作对象
    lvDBDataOperator := TUniOperatorPool.getUniOperator;
    try
      //设置使用的连接池
      lvDBDataOperator.Connection := lvPoolObj.ConnObj;

      lvSQL := 'SELECT top 200 * FROM eml_task'
         + ' WHERE FUserKey = ''' + pvUserKey + ''' ORDER BY FDate DESC';

      pvContent.StateINfo := '借用了一个lvDBDataOperator,准备打开连接!';
      try
        //获取一个查询的数据
        lvDataSet := lvDBDataOperator.CDSProvider.Query(lvSQL);
        lvDataSet.First;
        while not lvDataSet.Eof do
        begin
          lvItem := SO();
          lvItem.S['key'] := lvDataSet.FieldByName('FKey').AsString;
          lvItem.S['subject'] := lvDataSet.FieldByName('FSubject').AsString;
          lvItem.S['date'] := FormatDateTime('yyyy-MM-dd hh:nn:ss', lvDataSet.FieldByName('FDate').AsDateTime);
          lvItem.S['contentfile'] := lvDataSet.FieldByName('FContentFile').AsString;
          lvItem.I['state'] := lvDataSet.FieldByName('FState').AsInteger;

          pvCMDObject.Config.O['data.list[]'] := lvItem;
          lvDataSet.Next;
        end;


        pvContent.StateINfo := '获取我的任务列表完成';
      except
        raise;
      end;
      pvCMDObject.CMDResult := 1;
    finally
      TUniOperatorPool.giveBackUniOperator(lvDBDataOperator);
    end;
  finally
    //归还连接池
    TUniPool.releaseConnObject(lvPoolObj);
  end;
end;



end.
