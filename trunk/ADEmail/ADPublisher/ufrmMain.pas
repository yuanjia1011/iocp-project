unit ufrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  System.Actions, Vcl.ActnList;

type
  TfrmMain = class(TForm)
    pgcMain: TPageControl;
    tsOperator: TTabSheet;
    tsLog: TTabSheet;
    actlstMain: TActionList;
    actAddEmail: TAction;
    mmoLog: TMemo;
    btnAddEmail: TButton;
    procedure actAddEmailExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  ufrmUpdateEmail;

{$R *.dfm}

procedure TfrmMain.actAddEmailExecute(Sender: TObject);
begin
  with TfrmUpdateEmail.Create(Self) do
  try
    ShowModal();
  finally
    Free;
  end;
end;

end.
