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
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pgcMain: TPageControl
    Left = 0
    Top = 0
    Width = 627
    Height = 312
    ActivePage = tsMyEmail
    Align = alClient
    TabOrder = 0
    object tsOperator: TTabSheet
      Caption = #22522#26412#25805#20316
      object btnAddEmail: TButton
        Left = 27
        Top = 27
        Width = 75
        Height = 25
        Action = actAddEmail
        TabOrder = 0
      end
      object btnAddTask: TButton
        Left = 27
        Top = 80
        Width = 102
        Height = 25
        Action = actAddTask
        TabOrder = 1
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
      end
    end
    object tsMyTask: TTabSheet
      Caption = #25105#30340#20219#21153
      ImageIndex = 2
    end
    object tsMyEmail: TTabSheet
      Caption = #25105#30340#32852#31995#20154
      ImageIndex = 3
    end
  end
  object actlstMain: TActionList
    Left = 192
    Top = 48
    object actAddEmail: TAction
      Caption = #28155#21152'Email'
    end
    object actAddTask: TAction
      Caption = #28155#21152#19968#20010#20219#21153
    end
  end
end
