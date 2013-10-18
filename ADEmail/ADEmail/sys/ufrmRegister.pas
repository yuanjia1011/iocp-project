unit ufrmRegister;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList,
  Vcl.StdCtrls;

type
  TfrmRegister = class(TForm)
    actlstMain: TActionList;
    edtUser: TEdit;
    edtPW: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    edtMobile: TEdit;
    Label3: TLabel;
    actOK: TAction;
    actCancel: TAction;
    btnOK: TButton;
    btnCancel: TButton;
    edtPW2: TEdit;
    Label4: TLabel;
    edtName: TEdit;
    Label5: TLabel;
    edtEmail: TEdit;
    Label6: TLabel;
    lblCodeHint: TLabel;
    procedure actOKExecute(Sender: TObject);
    procedure edtUserChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmRegister: TfrmRegister;

implementation

{$R *.dfm}

uses udmMain, uCMDConsts, EDecryptionWrapper;

procedure TfrmRegister.actOKExecute(Sender: TObject);
var
  lvUser, lvPass:String;
begin
  lvUser := Trim(edtUser.Text);
  lvPass := Trim(edtPW.Text);
  if lvUser = '' then
    raise Exception.Create('用户名不能为空!');
  if lvPass = '' then
    raise Exception.Create('密码不能为空！');
  if lvPass <> trim(edtPW2.Text) then
  begin
    raise Exception.Create('两次密码不相同!');
  end;

  dmMain.CMDObject.Clear;
  dmMain.CMDObject.CMDIndex := CMD_REGISTER;
  dmMain.CMDObject.Config.S['user'] := lvUser;
  dmMain.CMDObject.Config.S['name'] := Trim(edtName.Text);
  dmMain.CMDObject.Config.S['pass'] := TEDecryptionWrapper.MD5_Str(LowerCase(lvUser) + lvPass);
  dmMain.CMDObject.Config.S['email'] := Trim(edtEmail.Text);
  dmMain.CMDObject.Config.S['mobile'] := Trim(edtMobile.Text);

  dmMain.DoAction();
  close;
  ModalResult := mrOk;
end;

procedure TfrmRegister.edtUserChange(Sender: TObject);
begin
  if Length(edtUser.Text) = 0 then
  begin
    lblCodeHint.Caption := '请输入用户名!';
  end
  else if Length(edtUser.Text) < 3 then
  begin
    lblCodeHint.Caption := '用户名必须大于3位';
  end else
  begin
    dmMain.CMDObject.clear;
    dmMain.CMDObject.CMDIndex := CMD_CHECK_USERCode;
    dmMain.CMDObject.Config.S['user'] := trim(edtUser.Text);
    dmMain.DoAction();
    lblCodeHint.Caption := dmMain.CMDObject.Config.S['__msg'];
  end;
end;

end.
