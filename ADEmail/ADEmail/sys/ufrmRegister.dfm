object frmRegister: TfrmRegister
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = #29992#25143#27880#20876
  ClientHeight = 259
  ClientWidth = 404
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
    Left = 8
    Top = 28
    Width = 36
    Height = 13
    Caption = #29992#25143#21517
  end
  object Label2: TLabel
    Left = 8
    Top = 56
    Width = 24
    Height = 13
    Caption = #23494#30721
  end
  object Label3: TLabel
    Left = 8
    Top = 140
    Width = 24
    Height = 13
    Caption = #25163#26426
  end
  object Label4: TLabel
    Left = 8
    Top = 84
    Width = 48
    Height = 13
    Caption = #30830#35748#23494#30721
  end
  object Label5: TLabel
    Left = 8
    Top = 112
    Width = 24
    Height = 13
    Caption = #22995#21517
  end
  object Label6: TLabel
    Left = 8
    Top = 168
    Width = 24
    Height = 13
    Caption = #37038#31665
  end
  object lblCodeHint: TLabel
    Left = 257
    Top = 27
    Width = 72
    Height = 13
    Caption = #35831#36755#20837#29992#25143#21517
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object edtUser: TEdit
    Left = 64
    Top = 24
    Width = 180
    Height = 21
    TabOrder = 0
    OnChange = edtUserChange
  end
  object edtPW: TEdit
    Left = 64
    Top = 52
    Width = 180
    Height = 21
    PasswordChar = '*'
    TabOrder = 1
  end
  object edtMobile: TEdit
    Left = 64
    Top = 136
    Width = 180
    Height = 21
    TabOrder = 4
  end
  object btnOK: TButton
    Left = 137
    Top = 216
    Width = 75
    Height = 25
    Action = actOK
    TabOrder = 6
  end
  object btnCancel: TButton
    Left = 257
    Top = 216
    Width = 75
    Height = 25
    Action = actCancel
    TabOrder = 7
  end
  object edtPW2: TEdit
    Left = 64
    Top = 80
    Width = 180
    Height = 21
    PasswordChar = '*'
    TabOrder = 2
  end
  object edtName: TEdit
    Left = 64
    Top = 108
    Width = 180
    Height = 21
    TabOrder = 3
  end
  object edtEmail: TEdit
    Left = 64
    Top = 164
    Width = 180
    Height = 21
    TabOrder = 5
  end
  object actlstMain: TActionList
    Left = 32
    Top = 192
    object actOK: TAction
      Caption = #30830#23450'(&O)'
      OnExecute = actOKExecute
    end
    object actCancel: TAction
      Caption = #21462#28040'(&C)'
    end
  end
end
