object frmUpdateEmail: TfrmUpdateEmail
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = #25105#30340'Email'#32852#31995#20154#20449#24687
  ClientHeight = 279
  ClientWidth = 658
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 48
    Top = 32
    Width = 24
    Height = 13
    Caption = 'Email'
  end
  object Label2: TLabel
    Left = 48
    Top = 68
    Width = 24
    Height = 13
    Caption = #31216#21628
  end
  object Label3: TLabel
    Left = 368
    Top = 101
    Width = 24
    Height = 13
    Caption = #24615#21035
  end
  object Label4: TLabel
    Left = 48
    Top = 101
    Width = 24
    Height = 13
    Caption = #22995#21517
  end
  object Label5: TLabel
    Left = 368
    Top = 68
    Width = 24
    Height = 13
    Caption = #32423#21035
  end
  object Label6: TLabel
    Left = 48
    Top = 128
    Width = 24
    Height = 13
    Caption = #20998#31867
  end
  object edtEmail: TEdit
    Left = 88
    Top = 28
    Width = 281
    Height = 21
    TabOrder = 0
  end
  object edtCallName: TEdit
    Left = 88
    Top = 64
    Width = 177
    Height = 21
    TabOrder = 1
  end
  object cbbSex: TComboBox
    Left = 408
    Top = 97
    Width = 177
    Height = 21
    TabOrder = 2
    Items.Strings = (
      #20808#29983
      #22899#22763)
  end
  object edtName: TEdit
    Left = 88
    Top = 97
    Width = 177
    Height = 21
    TabOrder = 3
  end
  object cbbGrade: TComboBox
    Left = 408
    Top = 64
    Width = 177
    Height = 21
    Style = csDropDownList
    ItemIndex = 2
    TabOrder = 4
    Text = #20108#32423
    Items.Strings = (
      #29305#32423
      #19968#32423
      #20108#32423
      #19977#32423
      #22235#32423
      #20116#32423)
  end
  object cbbCatalog: TComboBox
    Left = 88
    Top = 124
    Width = 177
    Height = 21
    TabOrder = 5
  end
  object btnOK: TButton
    Left = 438
    Top = 224
    Width = 75
    Height = 25
    Action = actOK
    TabOrder = 6
  end
  object btnCancel: TButton
    Left = 544
    Top = 224
    Width = 75
    Height = 25
    Action = actCancel
    TabOrder = 7
  end
  object actlstMain: TActionList
    Left = 344
    Top = 184
    object actOK: TAction
      Caption = #30830#23450'(&O)'
      OnExecute = actOKExecute
    end
    object actCancel: TAction
      Caption = #21462#28040'(&C)'
      OnExecute = actCancelExecute
    end
  end
end
