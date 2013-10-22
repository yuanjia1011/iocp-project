object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'frmMain'
  ClientHeight = 312
  ClientWidth = 627
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
    Width = 627
    Height = 312
    ActivePage = tsOperator
    Align = alClient
    TabOrder = 0
    object tsOperator: TTabSheet
      Caption = #22522#26412#25805#20316
      ExplicitLeft = 0
      ExplicitTop = 28
      object btnAddEmail: TButton
        Left = 27
        Top = 27
        Width = 75
        Height = 25
        Action = actAddEmail
        TabOrder = 0
      end
    end
    object tsLog: TTabSheet
      Caption = #26085#24535
      ImageIndex = 1
      object mmoLog: TMemo
        Left = 0
        Top = 0
        Width = 619
        Height = 284
        Align = alClient
        TabOrder = 0
        ExplicitLeft = 48
        ExplicitTop = 40
        ExplicitWidth = 185
        ExplicitHeight = 89
      end
    end
  end
  object actlstMain: TActionList
    Left = 288
    Top = 104
    object actAddEmail: TAction
      Caption = #28155#21152'Email'
      OnExecute = actAddEmailExecute
    end
  end
end
