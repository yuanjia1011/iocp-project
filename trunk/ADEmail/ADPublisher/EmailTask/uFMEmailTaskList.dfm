object FMEmailTaskList: TFMEmailTaskList
  Left = 0
  Top = 0
  Width = 659
  Height = 428
  TabOrder = 0
  object pnlTaskOperator: TPanel
    Left = 0
    Top = 0
    Width = 659
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object btnAddTask: TButton
      Left = 11
      Top = 10
      Width = 102
      Height = 25
      Action = actAddTask
      TabOrder = 0
    end
  end
  object vlsTask: TVirtualStringTree
    Left = 0
    Top = 41
    Width = 659
    Height = 387
    Align = alClient
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
    TabOrder = 1
    OnGetText = vlsTaskGetText
    Columns = <
      item
        Position = 0
        Width = 120
        WideText = #26102#38388
      end
      item
        Position = 1
        Width = 150
        WideText = #21517#31216
      end>
  end
  object actlstMain: TActionList
    Left = 40
    Top = 200
    object actAddTask: TAction
      Caption = #28155#21152#19968#20010#20219#21153
      OnExecute = actAddTaskExecute
    end
  end
end
