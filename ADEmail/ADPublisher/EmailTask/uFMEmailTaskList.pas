unit uFMEmailTaskList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, VirtualTrees,
  Vcl.StdCtrls, System.Actions, Vcl.ActnList;

type
  TFMEmailTaskList = class(TFrame)
    pnlTaskOperator: TPanel;
    vlsTask: TVirtualStringTree;
    actlstMain: TActionList;
    actAddTask: TAction;
    btnAddTask: TButton;
    procedure actAddTaskExecute(Sender: TObject);
    procedure vlsTaskGetText(Sender: TBaseVirtualTree; Node:
        PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText:
        string);
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

procedure TFMEmailTaskList.vlsTaskGetText(Sender: TBaseVirtualTree;
    Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var
    CellText: string);
begin
  CellText := '≤‚ ‘';
end;

end.
