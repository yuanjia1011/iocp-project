object frmLogin: TfrmLogin
  Left = 0
  Top = 0
  Caption = #30331#38470
  ClientHeight = 208
  ClientWidth = 411
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 32
    Top = 60
    Width = 36
    Height = 13
    Caption = #29992#25143#21517
  end
  object Label2: TLabel
    Left = 32
    Top = 100
    Width = 24
    Height = 13
    Caption = #23494#30721
  end
  object btnRegister: TSpeedButton
    Left = 8
    Top = 8
    Width = 51
    Height = 22
    Action = actRegister
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object edtUser: TEdit
    Left = 88
    Top = 57
    Width = 196
    Height = 21
    TabOrder = 0
    Text = 'ymofen'
  end
  object edtPassword: TEdit
    Left = 88
    Top = 97
    Width = 196
    Height = 21
    TabOrder = 1
    Text = 'edtPassword'
  end
  object btnOK: TButton
    Left = 120
    Top = 152
    Width = 75
    Height = 25
    Action = actOK
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 224
    Top = 152
    Width = 75
    Height = 25
    Action = actCancel
    TabOrder = 3
  end
  object actlstMain: TActionList
    Left = 328
    Top = 96
    object actOK: TAction
      Caption = #30331#38470
      OnExecute = actOKExecute
    end
    object actCancel: TAction
      Caption = #21462#28040
    end
    object actRegister: TAction
      Caption = #27880#20876
      OnExecute = actRegisterExecute
    end
  end
end
