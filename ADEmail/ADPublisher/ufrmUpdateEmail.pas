unit ufrmUpdateEmail;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Actions,
  Vcl.ActnList;

type
  TfrmUpdateEmail = class(TForm)
    Label1: TLabel;
    edtEmail: TEdit;
    edtCallName: TEdit;
    Label2: TLabel;
    cbbSex: TComboBox;
    Label3: TLabel;
    edtName: TEdit;
    Label4: TLabel;
    cbbGrade: TComboBox;
    Label5: TLabel;
    cbbCatalog: TComboBox;
    Label6: TLabel;
    btnOK: TButton;
    actlstMain: TActionList;
    actOK: TAction;
    actCancel: TAction;
    btnCancel: TButton;
    procedure actCancelExecute(Sender: TObject);
    procedure actOKExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmUpdateEmail: TfrmUpdateEmail;

implementation

{$R *.dfm}

procedure TfrmUpdateEmail.actCancelExecute(Sender: TObject);
begin
  ;
end;

procedure TfrmUpdateEmail.actOKExecute(Sender: TObject);
begin
  ;

end;

end.
