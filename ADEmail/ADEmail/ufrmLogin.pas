unit ufrmLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Actions,
  Vcl.ActnList, EDecryptionWrapper, Vcl.Buttons;

type
  TfrmLogin = class(TForm)
    edtUser: TEdit;
    edtPassword: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    actlstMain: TActionList;
    actOK: TAction;
    actCancel: TAction;
    btnOK: TButton;
    btnCancel: TButton;
    actRegister: TAction;
    btnRegister: TSpeedButton;
    procedure actOKExecute(Sender: TObject);
    procedure actRegisterExecute(Sender: TObject);
  private
    { Private declarations }
  public
    class function ExecuteLogin: Boolean;
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.dfm}

uses udmMain, uCMDObject, uIdTcpClientCMDObjectCoder, uCMDConsts, ufrmRegister;

procedure TfrmLogin.actOKExecute(Sender: TObject);
var
  lvCMDObject, lvRecvCMDObject:TCMDObject;
  lvData, lvData2:AnsiString;
begin


  lvCMDObject := TCMDObject.Create;
  try
    lvCMDObject.CMDIndex := CMD_LOGIN;
    lvCMDObject.Config.S['user'] := edtUser.Text;
    lvCMDObject.Config.S['pass'] := edtPassword.Text;
    dmMain.DoAction(lvCMDObject);
    Close;
    ModalResult := mrOK;
  finally
    lvCMDObject.Free;
  end;
end;

procedure TfrmLogin.actRegisterExecute(Sender: TObject);
var
  lvForm:TfrmRegister;
begin
  lvForm := TfrmRegister.Create(Self);
  try
    if lvForm.ShowModal() = mrOK then
    begin
      edtUser.Text := lvForm.edtUser.Text;
      edtPassword.Text := '';
    end;
  finally
    lvForm.Free;
  end;
end;

class function TfrmLogin.ExecuteLogin: Boolean;
var
  lvLogin:TfrmLogin;
begin
  lvLogin := TfrmLogin.Create(nil);
  try
    result := lvLogin.ShowModal()=mrOk;

  finally
    lvLogin.Free;
  end;

end;

end.
