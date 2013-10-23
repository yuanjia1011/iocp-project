object FMEmailAddrList: TFMEmailAddrList
  Left = 0
  Top = 0
  Width = 614
  Height = 384
  TabOrder = 0
  object vlsTask: TVirtualStringTree
    Left = 0
    Top = 41
    Width = 614
    Height = 343
    Align = alClient
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
    TabOrder = 0
    ExplicitLeft = -45
    ExplicitTop = -3
    ExplicitWidth = 659
    ExplicitHeight = 387
    Columns = <
      item
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment]
        Position = 0
        Width = 120
        WideText = 'Email'
      end
      item
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment]
        Position = 1
        Width = 150
        WideText = #31216#21628
      end
      item
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment]
        Position = 2
        Width = 100
        WideText = #24615#21035
      end
      item
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment]
        Position = 3
        Width = 100
        WideText = #20998#31867
      end
      item
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment]
        Position = 4
        Width = 100
        WideText = #32423#21035
      end>
  end
  object pnlTaskOperator: TPanel
    Left = 0
    Top = 0
    Width = 614
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitLeft = -45
    ExplicitWidth = 659
    object btnAddEmail: TButton
      Left = 11
      Top = 10
      Width = 102
      Height = 25
      Action = actAddEmail
      TabOrder = 0
    end
  end
  object actlstMain: TActionList
    Left = 64
    Top = 176
    object actAddEmail: TAction
      Caption = #28155#21152'Email'
      OnExecute = actAddEmailExecute
    end
  end
end
