unit uFMEmailAddrList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions,
  Vcl.ActnList, Vcl.StdCtrls, Vcl.ExtCtrls, VirtualTrees;

type
  TFMEmailAddrList = class(TFrame)
    vlsTask: TVirtualStringTree;
    pnlTaskOperator: TPanel;
    btnAddEmail: TButton;
    actlstMain: TActionList;
    actAddEmail: TAction;
    procedure actAddEmailExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  ufrmUpdateEmail;

{$R *.dfm}

procedure TFMEmailAddrList.actAddEmailExecute(Sender: TObject);
begin
  with TfrmUpdateEmail.Create(Self) do
  try
    ShowModal();
  finally
    Free;
  end;
end;

end.
