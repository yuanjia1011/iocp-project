object frmEmailTask: TfrmEmailTask
  Left = 0
  Top = 0
  Caption = #26032#24314#19968#20010#20219#21153
  ClientHeight = 467
  ClientWidth = 744
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
    Width = 744
    Height = 426
    ActivePage = tsBase
    Align = alClient
    Style = tsFlatButtons
    TabOrder = 0
    ExplicitWidth = 862
    ExplicitHeight = 385
    object tsBase: TTabSheet
      Caption = #20219#21153#24773#20917
      ExplicitLeft = 0
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
    object tsEmail: TTabSheet
      Caption = 'Email'#20869#23481
      ImageIndex = 2
      ExplicitWidth = 854
      ExplicitHeight = 354
      object wbContent: TWebBrowser
        Left = 0
        Top = 0
        Width = 736
        Height = 395
        Align = alClient
        TabOrder = 0
        ExplicitLeft = 176
        ExplicitTop = 48
        ExplicitWidth = 300
        ExplicitHeight = 150
        ControlData = {
          4C000000114C0000D32800000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E126208000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
    end
    object TabSheet2: TTabSheet
      Caption = #36873#29992#25509#25910#20154
      ImageIndex = 1
      ExplicitWidth = 854
      ExplicitHeight = 354
      object pnlRecvOperator: TPanel
        Left = 0
        Top = 0
        Width = 736
        Height = 57
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitWidth = 854
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
    Top = 426
    Width = 744
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 385
    ExplicitWidth = 862
    DesignSize = (
      744
      41)
    object btnOK: TButton
      Left = 448
      Top = 6
      Width = 75
      Height = 25
      Action = actOK
      Anchors = [akTop, akRight]
      TabOrder = 0
      ExplicitLeft = 520
    end
    object btnCancel: TButton
      Left = 636
      Top = 6
      Width = 75
      Height = 25
      Action = actCancel
      Anchors = [akTop, akRight]
      TabOrder = 1
      ExplicitLeft = 708
    end
    object btnSubmit: TButton
      Left = 542
      Top = 6
      Width = 75
      Height = 25
      Action = actSubmit
      Anchors = [akTop, akRight]
      TabOrder = 2
      ExplicitLeft = 614
    end
  end
  object actlstMain: TActionList
    Left = 460
    Top = 296
    object actOK: TAction
      Caption = #20445#23384#33609#31295
      OnExecute = actOKExecute
    end
    object actSubmit: TAction
      Caption = #30830#35748#25552#20132
    end
    object actCancel: TAction
      Caption = #21462#28040
    end
  end
end
