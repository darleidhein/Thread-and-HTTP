object frmGerenciadorDownloads: TfrmGerenciadorDownloads
  Left = 0
  Top = 0
  Anchors = []
  BorderStyle = bsSingle
  Caption = 'Gerenciador de downlods'
  ClientHeight = 114
  ClientWidth = 394
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblLinkDownload: TLabel
    Left = 8
    Top = 8
    Width = 109
    Height = 13
    Caption = 'Link para download'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object pbProgresso: TProgressBar
    Left = 8
    Top = 84
    Width = 375
    Height = 21
    TabOrder = 0
  end
  object btnDownload: TButton
    Left = 8
    Top = 53
    Width = 121
    Height = 25
    Caption = 'Iniciar download'
    TabOrder = 1
    OnClick = btnDownloadClick
  end
  object btnIniciarDownload: TButton
    Left = 137
    Top = 53
    Width = 121
    Height = 25
    Caption = 'Exibir mensagem'
    TabOrder = 2
    OnClick = btnIniciarDownloadClick
  end
  object edtLinkDownload: TEdit
    Left = 8
    Top = 26
    Width = 377
    Height = 21
    TabOrder = 3
  end
  object btnHistoricoDownloads: TButton
    Left = 264
    Top = 53
    Width = 121
    Height = 25
    Caption = 'Hist'#243'rico de downlods'
    TabOrder = 4
    OnClick = btnHistoricoDownloadsClick
  end
  object sdArquivoDownload: TSaveDialog
    Left = 256
  end
end
