object frmEmailTask: TfrmEmailTask
  Left = 0
  Top = 0
  Caption = #26032#24314#19968#20010#20219#21153
  ClientHeight = 334
  ClientWidth = 643
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
    Width = 643
    Height = 293
    ActivePage = tsBase
    Align = alClient
    Style = tsFlatButtons
    TabOrder = 0
    object tsBase: TTabSheet
      Caption = #20219#21153#24773#20917
      ExplicitLeft = 8
      ExplicitTop = 25
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
    object TabSheet2: TTabSheet
      Caption = #36873#29992#25509#25910#20154
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 25
      object pnlRecvOperator: TPanel
        Left = 0
        Top = 0
        Width = 635
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
    Top = 293
    Width = 643
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitLeft = 288
    ExplicitTop = 232
    ExplicitWidth = 185
  end
  object actlstMain: TActionList
    Left = 516
    Top = 184
  end
end