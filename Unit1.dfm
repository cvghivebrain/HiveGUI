object Form1: TForm1
  Left = 540
  Top = 256
  BorderStyle = bsDialog
  Caption = 'HiveGUI'
  ClientHeight = 622
  ClientWidth = 1088
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblCom: TLabel
    Left = 248
    Top = 147
    Width = 72
    Height = 19
    Caption = 'Command:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
  end
  object lstCom: TListBox
    Left = 8
    Top = 41
    Width = 234
    Height = 573
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Consolas'
    Font.Style = []
    ItemHeight = 19
    ParentFont = False
    TabOrder = 0
    OnClick = lstComClick
  end
  object editInput: TEdit
    Left = 248
    Top = 41
    Width = 657
    Height = 27
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object editOutput: TEdit
    Left = 248
    Top = 74
    Width = 657
    Height = 27
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object btnInput: TButton
    Left = 911
    Top = 41
    Width = 76
    Height = 27
    Caption = 'Select Input'
    TabOrder = 3
    OnClick = btnInputClick
  end
  object btnOutput: TButton
    Left = 911
    Top = 74
    Width = 76
    Height = 27
    Caption = 'Select Output'
    TabOrder = 4
    OnClick = btnOutputClick
  end
  object memoEvents: TMemo
    Left = 248
    Top = 172
    Width = 832
    Height = 442
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
  end
  object btnRun: TButton
    Left = 911
    Top = 107
    Width = 169
    Height = 34
    Caption = 'Run'
    TabOrder = 6
    OnClick = btnRunClick
  end
  object boxTabs: TComboBox
    Left = 8
    Top = 8
    Width = 234
    Height = 27
    Style = csDropDownList
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    OnChange = boxTabsChange
  end
  object btnFile: TRadioButton
    Left = 247
    Top = 18
    Width = 54
    Height = 17
    Caption = 'File'
    Checked = True
    TabOrder = 8
    TabStop = True
    OnClick = btnFileClick
  end
  object btnFolder: TRadioButton
    Left = 307
    Top = 18
    Width = 113
    Height = 17
    Caption = 'Folder'
    TabOrder = 9
    OnClick = btnFolderClick
  end
  object editMask: TEdit
    Left = 993
    Top = 41
    Width = 87
    Height = 27
    Hint = 'Input file mask'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    TabOrder = 10
    Text = '*.*'
    Visible = False
  end
  object editExt: TEdit
    Left = 993
    Top = 74
    Width = 87
    Height = 27
    Hint = 'Output extension (leave blank to keep original)'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    TabOrder = 11
    Visible = False
  end
  object chkOverwrite: TCheckBox
    Left = 248
    Top = 107
    Width = 97
    Height = 17
    Caption = 'Overwrite Files'
    Checked = True
    State = cbChecked
    TabOrder = 12
  end
  object dlgOpen: TOpenDialog
    Left = 719
    Top = 563
  end
  object dlgSave: TSaveDialog
    Left = 758
    Top = 563
  end
end
