object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 398
  ClientWidth = 798
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 798
    Height = 398
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
      object wbContent: TWebBrowser
        Left = 0
        Top = 41
        Width = 790
        Height = 329
        Align = alClient
        TabOrder = 0
        OnDocumentComplete = wbContentDocumentComplete
        ExplicitWidth = 300
        ExplicitHeight = 150
        ControlData = {
          4C000000A6510000012200000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E126208000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
      object pnlTop: TPanel
        Left = 0
        Top = 0
        Width = 790
        Height = 41
        Align = alTop
        Caption = 'pnlTop'
        TabOrder = 1
        object btnshow: TButton
          Left = 0
          Top = 10
          Width = 75
          Height = 25
          Caption = 'btnshow'
          TabOrder = 0
          OnClick = btnshowClick
        end
      end
    end
  end
end
