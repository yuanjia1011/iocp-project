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
    mmoContent: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEmailTask: TfrmEmailTask;

implementation

{$R *.dfm}

end.
