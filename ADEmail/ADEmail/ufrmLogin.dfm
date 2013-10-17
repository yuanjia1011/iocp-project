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
  object edtUser: TEdit
    Left = 88
    Top = 57
    Width = 196
    Height = 21
    TabOrder = 0
    Text = 'edtUser'
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
    Left = 96
    Top = 152
    Width = 75
    Height = 25
    Action = actOK
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
    Left = 344
    Top = 16
    object actOK: TAction
      Caption = #30331#38470
      OnExecute = actOKExecute
    end
    object actCancel: TAction
      Caption = #21462#28040
    end
  end
end
