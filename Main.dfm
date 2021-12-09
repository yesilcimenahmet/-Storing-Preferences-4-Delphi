object FormMain: TFormMain
  Left = 0
  Top = 0
  ClientHeight = 321
  ClientWidth = 376
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
  object Button1: TButton
    Left = 255
    Top = 8
    Width = 82
    Height = 25
    Caption = 'Read'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 249
    Height = 321
    Align = alLeft
    TabOrder = 1
    ExplicitHeight = 299
  end
  object Button2: TButton
    Left = 255
    Top = 39
    Width = 82
    Height = 25
    Caption = 'Change & Save'
    TabOrder = 2
    OnClick = Button2Click
  end
end
