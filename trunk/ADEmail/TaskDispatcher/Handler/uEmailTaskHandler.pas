unit uEmailTaskHandler;

interface

uses
  Windows, uBuffer, Classes, SysUtils,
  uIOCPCentre, uCMDObject, ComObj, uClientContext, superobject;


type
  TEmailTaskHandler = class(TObject)
  private
  public
    //��ȡ�ҵ������б�
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
  //ͨ������ID��ȡһ�����ӳض���
  lvPoolObj := TUniPool.getConnObject('main');
  try
    //������
    lvPoolObj.checkConnect;

    //Uni���ݿ��������
    lvDBDataOperator := TUniOperatorPool.getUniOperator;
    try
      //����ʹ�õ����ӳ�
      lvDBDataOperator.Connection := lvPoolObj.ConnObj;

      lvSQL := 'SELECT top 200 * FROM eml_task'
         + ' WHERE FUserKey = ''' + pvUserKey + ''' ORDER BY FDate DESC';

      pvContent.StateINfo := '������һ��lvDBDataOperator,׼��������!';
      try
        //��ȡһ����ѯ������
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


        pvContent.StateINfo := '��ȡ�ҵ������б����';
      except
        raise;
      end;
      pvCMDObject.CMDResult := 1;
    finally
      TUniOperatorPool.giveBackUniOperator(lvDBDataOperator);
    end;
  finally
    //�黹���ӳ�
    TUniPool.releaseConnObject(lvPoolObj);
  end;
end;



end.
