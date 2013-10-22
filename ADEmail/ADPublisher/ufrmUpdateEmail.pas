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
    FDataKey: String;
    { Private declarations }
  public
    property DataKey: String read FDataKey write FDataKey;
  end;

var
  frmUpdateEmail: TfrmUpdateEmail;

implementation

uses
  udmMain, uCMDConsts;

{$R *.dfm}

procedure TfrmUpdateEmail.actCancelExecute(Sender: TObject);
begin
  ;
end;

procedure TfrmUpdateEmail.actOKExecute(Sender: TObject);
begin
  if edtEmail.Text = '' then
  begin
    raise Exception.Create('Emailµÿ÷∑±ÿ–Î ‰»Î!');
  end;


  dmMain.CMDObject.clear;
  dmMain.CMDObject.CMDIndex := CMD_Publisher_UpdateEmail;
  dmMain.CMDObject.Config.S['data.key'] := FDataKey;
  dmMain.CMDObject.Config.S['data.callname'] := edtCallName.Text;
  dmMain.CMDObject.Config.S['data.name'] := edtName.Text;
  dmMain.CMDObject.Config.S['data.email'] := edtEmail.Text;
  dmMain.CMDObject.Config.S['data.grade'] := cbbGrade.Text;
  dmMain.CMDObject.Config.S['data.catalog'] := cbbCatalog.Text;
  dmMain.CMDObject.Config.S['data.sex'] := cbbSex.Text;
  dmMain.DoAction();
  Close;
end;

end.
