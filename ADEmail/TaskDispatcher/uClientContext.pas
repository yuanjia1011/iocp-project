unit uClientContext;

interface

uses
  Windows, uBuffer, Classes, SysUtils,
  uIOCPCentre, uCMDObject;

type
  TClientContext = class(TIOCPClientContext)
  private
    FlastAssignTime: TDateTime;
    FLoginTime: TDateTime;
    FuserCode: String;
    FuserName: String;
  protected
    procedure DoConnect; override;
    procedure DoDisconnect; override;
    procedure DoOnWriteBack; override;

  public
    /// <summary>
    ///   ���ݴ���
    /// </summary>
    /// <param name="pvDataObject"> (TObject) </param>
    procedure dataReceived(const pvDataObject:TObject); override;

    //���һ�η�������ʱ��
    property lastAssignTime: TDateTime read FlastAssignTime write FlastAssignTime;

    property LoginTime: TDateTime read FLoginTime;
    property userCode: String read FuserCode;
    property userName: String read FuserName;

  end;

implementation

uses
  Math;





procedure TClientContext.dataReceived(const pvDataObject:TObject);
var
  lvCMDObject:TCMDObject;
begin
  lvCMDObject := TCMDObject(pvDataObject);
  try
    //ֱ�ӻش�
    writeObject(lvCMDObject);
  except
    on E:Exception do
    begin
      lvCMDObject.clear;
      lvCMDObject.CMDResult := -1;
      lvCMDObject.Config.S['__msg'] := e.Message;
      writeObject(lvCMDObject);
    end;
  end;
end;

procedure TClientContext.DoConnect;
begin
  inherited;
end;

procedure TClientContext.DoDisconnect;
begin
  inherited;
end;



procedure TClientContext.DoOnWriteBack;
begin
  inherited;
end;

end.
