object frmHistoricoDownloads: TfrmHistoricoDownloads
  Left = 0
  Top = 0
  Caption = 'Hist'#243'rico de downloads'
  ClientHeight = 388
  ClientWidth = 974
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object dbgHistoricoDownloads: TDBGrid
    Left = 0
    Top = 0
    Width = 974
    Height = 388
    Align = alClient
    DataSource = dmdGerenciadorDownloads.dsHistoricoGrid
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgTitleClick, dgTitleHotTrack]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'URL'
        Title.Caption = 'Url'
        Width = 701
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DATAINICIO'
        Title.Caption = 'Data inicio'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DATAFIM'
        Title.Caption = 'Data fim'
        Visible = True
      end>
  end
end
