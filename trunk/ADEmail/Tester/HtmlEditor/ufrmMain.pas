unit ufrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.OleCtrls, SHDocVw, Vcl.ComCtrls,
  Vcl.ExtCtrls, MSHTML, Vcl.StdCtrls, Vcl.AppEvnts;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    wbContent: TWebBrowser;
    pnlTop: TPanel;
    btnshow: TButton;
    ApplicationEvents1: TApplicationEvents;
    procedure ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);
    procedure btnshowClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure wbContentDocumentComplete(ASender: TObject;
      const pDisp: IDispatch; const URL: OLEVariant);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.ApplicationEvents1Message(var Msg: tagMSG;
  var Handled: Boolean);
const
  _KeyPressMask = $80000000;
begin
//  // ½ûÓÃÓÒ¼ü
//  with Msg do
//  begin
////    if not (wbContent.Handle = hwnd) then exit;
//    if not IsChild(wbContent.Handle, hWnd) then
//      Exit;
//    Handled := (message = WM_RBUTTONDOWN) or (message = WM_RBUTTONUP) or
//      (message = WM_CONTEXTMENU);
//  end;
//  // ½ûÖ¹Ctrl + N
//  // ½ûÖ¹Ctrl + F
//  // ½ûÖ¹Ctrl + A
//  if Msg.message = WM_KEYDOWN then
//  begin
//    if ((Msg.lParam and _KeyPressMask) = 0) and (GetKeyState(VK_Control) < 0)
//      and ((Msg.wParam = Ord('N')) or (Msg.wParam = Ord('F')) or
//      (Msg.wParam = Ord('A'))) then
//    begin
//      Handled := True;
//    end;
//  end;
end;

procedure TForm1.btnshowClick(Sender: TObject);
var
  Document: IHTMLDocument2;
  s: String;
begin
  // Document := wbContent.Document as IHTMLDocument2;
  // if Assigned(Document) then
  // begin
  // ShowMessage(Document.body.outerHTML);
  // end;

  s := wbContent.OleObject.Document.script.editor.html();

  ShowMessage(s);


  // WebBrowser2.OleObject.document.parentWindow.execScript('º¯ÊýÃû').submit()','JavaScript');

end;

procedure TForm1.FormCreate(Sender: TObject);
var
  lvFile: String;
begin
  lvFile := ExtractFilePath(ParamStr(0)) +
    'kindeditor\examples\emailEditor.html';
  wbContent.Navigate(lvFile);

end;

procedure TForm1.wbContentDocumentComplete(ASender: TObject;
  const pDisp: IDispatch; const URL: OLEVariant);
begin
  // WB_Set3DBorderStyle(ASender, false);
end;

end.
