unit ufrmLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Actions,
  Vcl.ActnList;

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
    procedure actOKExecute(Sender: TObject);
  private
    { Private declarations }
  public
    class function ExecuteLogin: Boolean;
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.dfm}

uses udmMain, uCMDObject, uIdTcpClientCMDObjectCoder, AES, uCMDConsts;

procedure TfrmLogin.actOKExecute(Sender: TObject);
var
  lvCMDObject, lvRecvCMDObject:TCMDObject;
  lvData, lvData2:AnsiString;
begin
  dmMain.IdTCPClient.Disconnect;
  dmMain.IdTCPClient.Host := '127.0.0.1';
  dmMain.IdTCPClient.Port := 9903;
  dmMain.IdTCPClient.Connect;

  lvCMDObject := TCMDObject.Create;
  lvRecvCMDObject := TCMDObject.Create;
  try
    lvCMDObject.CMDIndex := CMD_LOGIN;
    lvCMDObject.Config.S['user'] := edtUser.Text;
    lvCMDObject.Config.S['pass'] := edtPassword.Text;

    lvData := 'abcdÖÐ¹ú';
    lvCMDObject.Stream.Write(lvData[1], Length(lvData));

//    lvData := lvCMDObject.Config.AsJSon(True, False);
//    ShowMessage(lvData);
//
//    lvData2 := AES.EncryptString(lvData, 'ADEmailCode');
//    ShowMessage(lvData2);
//
//    lvData := AES.DecryptString(lvData2, 'ADEmailCode');
//    ShowMessage(lvData);


    TIdTcpClienTCMDObjectCoder.Encode(dmMain.IdTCPClient, lvCMDObject, 'ADEmailCode');

    TIdTcpClienTCMDObjectCoder.Decode(dmMain.IdTCPClient, lvRecvCMDObject, 'ADEmailCode');

    if lvRecvCMDObject.CMDResult = -1 then
      raise Exception.Create(lvRecvCMDObject.Config.S['__msg']);

    Close;
    ModalResult := mrOK;
  finally
    lvCMDObject.Free;
    lvRecvCMDObject.Free;
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
