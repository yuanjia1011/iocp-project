unit ufrmEmailTask;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  System.Actions, Vcl.ActnList, Vcl.OleCtrls, SHDocVw;

type
  TfrmEmailTask = class(TForm)
    PageControl1: TPageControl;
    tsBase: TTabSheet;
    TabSheet2: TTabSheet;
    pnlOperator: TPanel;
    edtName: TEdit;
    Label1: TLabel;
    mmoRemark: TMemo;
    lblRemark: TLabel;
    actlstMain: TActionList;
    pnlRecvOperator: TPanel;
    rgRevcType: TRadioGroup;
    tsEmail: TTabSheet;
    wbContent: TWebBrowser;
    actOK: TAction;
    actSubmit: TAction;
    actCancel: TAction;
    btnOK: TButton;
    btnCancel: TButton;
    btnSubmit: TButton;
    procedure actOKExecute(Sender: TObject);
  private
    FDataKey: string;
    { Private declarations }
    function getEmailContent():String;
    procedure ExecuteApplyUpdate;
  public
    { Public declarations }
    procedure PrepareForCreate;
    property DataKey: string read FDataKey write FDataKey;

  end;

var
  frmEmailTask: TfrmEmailTask;

implementation

uses
  udmMain, uCMDConsts;

{$R *.dfm}

procedure TfrmEmailTask.actOKExecute(Sender: TObject);
begin
  ExecuteApplyUpdate;
end;

{ TfrmEmailTask }

procedure TfrmEmailTask.ExecuteApplyUpdate;
begin
  dmMain.CMDObject.clear;
  dmMain.CMDObject.CMDIndex := CMD_Publisher_UpdateTask;
  dmMain.CMDObject.Config.S['data.key'] := FDataKey;
  dmMain.CMDObject.Config.S['data.name'] := edtName.Text;
  dmMain.CMDObject.Config.S['data.remark'] := mmoRemark.Lines.Text;
  dmMain.CMDObject.Config.S['data.content'] := getEmailContent;
  dmMain.DoAction();
end;

function TfrmEmailTask.getEmailContent: String;
begin
  Result := wbContent.OleObject.Document.script.editor.html();
end;

procedure TfrmEmailTask.PrepareForCreate;
var
  lvFile: String;
begin
  lvFile := ExtractFilePath(ParamStr(0)) +
    'emailEditor.html';
  wbContent.Navigate(lvFile);
end;

end.
