unit ufrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.OleCtrls, SHDocVw, Vcl.ComCtrls,
  Vcl.ExtCtrls, MSHTML, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    wbContent: TWebBrowser;
    pnlTop: TPanel;
    btnshow: TButton;
    procedure btnshowClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure wbContentDocumentComplete(ASender: TObject; const pDisp: IDispatch;
        const URL: OLEVariant);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}



procedure TForm1.btnshowClick(Sender: TObject);
var
  Document: IHTMLDocument2;
begin
    Document := wbContent.Document as IHTMLDocument2;
    if Assigned(Document) then
    begin
      ShowMessage(Document.Body.OuterHtml);

    end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  lvFile:String;
begin
  lvFile:= ExtractFilePath(ParamStr(0)) + 'kindeditor\examples\emailEditor.html';
  wbContent.Navigate(lvFile);
end;

procedure TForm1.wbContentDocumentComplete(ASender: TObject; const pDisp:
    IDispatch; const URL: OLEVariant);
begin
  //  WB_Set3DBorderStyle(ASender, false);
end;

end.
