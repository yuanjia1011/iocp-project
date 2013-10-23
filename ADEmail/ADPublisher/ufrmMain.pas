unit ufrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  System.Actions, Vcl.ActnList, VirtualTrees, Vcl.ExtCtrls, uFMEmailTaskList;

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
    procedure FormCreate(Sender: TObject);
    procedure actAddEmailExecute(Sender: TObject);
    procedure actAddTaskExecute(Sender: TObject);
  private
    { Private declarations }
    FFMTaskList:TFMEmailTaskList;
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
end;

procedure TfrmMain.actAddEmailExecute(Sender: TObject);
begin
  with TfrmUpdateEmail.Create(Self) do
  try
    ShowModal();
  finally
    Free;
  end;
end;

procedure TfrmMain.actAddTaskExecute(Sender: TObject);
begin
  with TfrmEmailTask.Create(Self) do
  try
    PrepareForCreate;
    ShowModal();
  finally
    Free;
  end;
end;

end.
