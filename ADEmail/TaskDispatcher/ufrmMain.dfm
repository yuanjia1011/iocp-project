object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'frmMain'
  ClientHeight = 311
  ClientWidth = 591
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pgcMain: TPageControl
    Left = 0
    Top = 0
    Width = 591
    Height = 311
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
      object btnStart: TButton
        Left = 16
        Top = 24
        Width = 75
        Height = 25
        Caption = 'btnStart'
        TabOrder = 0
        OnClick = btnStartClick
      end
      object btnStop: TButton
        Left = 16
        Top = 64
        Width = 75
        Height = 25
        Caption = 'btnStop'
        TabOrder = 1
        OnClick = btnStopClick
      end
    end
    object tsIOCPINfo: TTabSheet
      Caption = 'tsIOCPINfo'
      ImageIndex = 1
    end
    object tsDebug: TTabSheet
      Caption = 'tsDebug'
      ImageIndex = 2
      object btnAssign: TButton
        Left = 11
        Top = 16
        Width = 105
        Height = 25
        Caption = #20998#37197#19968#27425#20219#21153
        TabOrder = 0
      end
    end
  end
end
