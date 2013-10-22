object frmEmailTask: TfrmEmailTask
  Left = 0
  Top = 0
  Caption = #26032#24314#19968#20010#20219#21153
  ClientHeight = 426
  ClientWidth = 862
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 862
    Height = 385
    ActivePage = tsBase
    Align = alClient
    Style = tsFlatButtons
    TabOrder = 0
    object tsBase: TTabSheet
      Caption = #20219#21153#24773#20917
      object Label1: TLabel
        Left = 16
        Top = 20
        Width = 48
        Height = 13
        Caption = #20219#21153#21517#31216
      end
      object lblRemark: TLabel
        Left = 18
        Top = 59
        Width = 24
        Height = 13
        Caption = #22791#27880
      end
      object edtName: TEdit
        Left = 70
        Top = 17
        Width = 339
        Height = 21
        TabOrder = 0
      end
      object mmoRemark: TMemo
        Left = 70
        Top = 56
        Width = 339
        Height = 81
        TabOrder = 1
      end
    end
    object tsEmail: TTabSheet
      Caption = 'Email'#20869#23481
      ImageIndex = 2
      object mmoContent: TMemo
        Left = 0
        Top = 0
        Width = 854
        Height = 354
        Align = alClient
        TabOrder = 0
        ExplicitLeft = 176
        ExplicitTop = 56
        ExplicitWidth = 185
        ExplicitHeight = 89
      end
    end
    object TabSheet2: TTabSheet
      Caption = #36873#29992#25509#25910#20154
      ImageIndex = 1
      object pnlRecvOperator: TPanel
        Left = 0
        Top = 0
        Width = 854
        Height = 57
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object rgRevcType: TRadioGroup
          Left = 0
          Top = 0
          Width = 481
          Height = 49
          Columns = 3
          Items.Strings = (
            #25353#32423#21035#36873#21462#25509#25910#20154
            #25353#20998#31867#36873#21462#25509#25910#20154
            #33258#23450#20041#36873#21462)
          TabOrder = 0
        end
      end
    end
  end
  object pnlOperator: TPanel
    Left = 0
    Top = 385
    Width = 862
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
  end
  object actlstMain: TActionList
    Left = 460
    Top = 296
  end
end
