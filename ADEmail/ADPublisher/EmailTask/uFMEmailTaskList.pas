unit uFMEmailTaskList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, VirtualTrees,
  Vcl.StdCtrls, System.Actions, Vcl.ActnList;

type
  TFMEmailTaskList = class(TFrame)
    pnlTaskOperator: TPanel;
    VirtualStringTree1: TVirtualStringTree;
    actlstMain: TActionList;
    actAddTask: TAction;
    btnAddTask: TButton;
    procedure actAddTaskExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  ufrmEmailTask;

{$R *.dfm}

procedure TFMEmailTaskList.actAddTaskExecute(Sender: TObject);
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
