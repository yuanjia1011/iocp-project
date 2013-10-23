unit ufrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  System.Actions, Vcl.ActnList, VirtualTrees, Vcl.ExtCtrls, uFMEmailTaskList,
  uFMEmailAddrList;

type
  TfrmMain = class(TForm)
    pgcMain: TPageControl;
    tsOperator: TTabSheet;
    tsLog: TTabSheet;
    actlstMain: TActionList;
    actAddEmail: TAction;
    mmoLog: TMemo;
    btnAddEmail: TButton;
    actAddTask: TAction;
    btnAddTask: TButton;
    tsMyTask: TTabSheet;
    tsMyEmail: TTabSheet;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FFMTaskList:TFMEmailTaskList;
    FFMEmailList:TFMEmailAddrList;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  ufrmUpdateEmail, ufrmEmailTask;

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FFMTaskList := TFMEmailTaskList.Create(self);
  FFMTaskList.Parent := tsMyTask;
  FFMTaskList.Align := alClient;

  FFMEmailList := TFMEmailAddrList.Create(self);
  FFMEmailList.Parent := tsMyEmail;
  FFMEmailList.Align := alClient;
end;

end.
