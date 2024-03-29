object dmdGerenciadorDownloads: TdmdGerenciadorDownloads
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 235
  Width = 382
  object Connection: TFDConnection
    Params.Strings = (
      'Database=C:\GerenciadorDownloads\GerenciadorDownloads.db'
      'DriverID=SQLite')
    FormatOptions.AssignedValues = [fvMaxBcdPrecision, fvMaxBcdScale, fvDataSnapCompatibility]
    FormatOptions.MaxBcdPrecision = 22
    FormatOptions.MaxBcdScale = 22
    FormatOptions.DataSnapCompatibility = True
    Connected = True
    LoginPrompt = False
    Left = 88
    Top = 24
  end
  object qryCriaTabelaHistoricoDownloads: TFDQuery
    Connection = Connection
    SQL.Strings = (
      'CREATE TABLE IF NOT EXISTS HISTORICODOWNLOADS('
      '  CODIGO NUMBER(22,0) NOT NULL,'
      '  URL VARCHAR2(600) NOT NULL,'
      '  DATAINICIO DATETIME NOT NULL,'
      '  DATAFIM DATETIME,'
      '  CONSTRAINT PK_LOGDOWNLOAD PRIMARY KEY (CODIGO)'
      ')')
    Left = 88
    Top = 96
  end
  object qryHistoricoGrid: TFDQuery
    Connection = Connection
    SQL.Strings = (
      'SELECT '
      '  CODIGO,'
      '  URL,'
      '  DATAINICIO,'
      '  DATAFIM'
      'FROM HISTORICODOWNLOADS'
      'ORDER BY CODIGO DESC')
    Left = 272
    Top = 96
    object qryHistoricoGridCODIGO: TBCDField
      FieldName = 'CODIGO'
      Origin = 'CODIGO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
      Precision = 22
      Size = 0
    end
    object qryHistoricoGridURL: TStringField
      FieldName = 'URL'
      Origin = 'URL'
      Required = True
      Size = 600
    end
    object qryHistoricoGridDATAINICIO: TDateTimeField
      FieldName = 'DATAINICIO'
      Origin = 'DATAINICIO'
      Required = True
    end
    object qryHistoricoGridDATAFIM: TDateTimeField
      FieldName = 'DATAFIM'
      Origin = 'DATAFIM'
    end
  end
  object dsHistoricoGrid: TDataSource
    DataSet = qryHistoricoGrid
    Left = 272
    Top = 152
  end
  object qryHistoricoDownloads: TFDQuery
    CachedUpdates = True
    Connection = Connection
    UpdateOptions.AssignedValues = [uvUpdateMode]
    UpdateOptions.UpdateMode = upWhereAll
    UpdateOptions.KeyFields = 'CODIGO'
    SQL.Strings = (
      'SELECT '
      '  CODIGO,'
      '  URL,'
      '  DATAINICIO,'
      '  DATAFIM'
      'FROM HISTORICODOWNLOADS'
      'WHERE CODIGO = :CODIGOHISTORICO')
    Left = 272
    Top = 24
    ParamData = <
      item
        Name = 'CODIGOHISTORICO'
        DataType = ftLargeint
        ParamType = ptInput
        Value = Null
      end>
    object qryHistoricoDownloadsCODIGO: TBCDField
      FieldName = 'CODIGO'
      Origin = 'CODIGO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
      Precision = 22
      Size = 0
    end
    object qryHistoricoDownloadsURL: TStringField
      FieldName = 'URL'
      Origin = 'URL'
      Required = True
      Size = 600
    end
    object qryHistoricoDownloadsDATAINICIO: TDateTimeField
      FieldName = 'DATAINICIO'
      Origin = 'DATAINICIO'
      Required = True
    end
    object qryHistoricoDownloadsDATAFIM: TDateTimeField
      FieldName = 'DATAFIM'
      Origin = 'DATAFIM'
    end
  end
  object qryProximoCodigoHistorico: TFDQuery
    Connection = Connection
    SQL.Strings = (
      'SELECT COALESCE('
      '  (SELECT MAX(CODIGO) + 1 '
      '   FROM HISTORICODOWNLOADS), 1) AS CODIGO')
    Left = 88
    Top = 152
    object qryProximoCodigoHistoricoCODIGO: TLargeintField
      FieldName = 'CODIGO'
    end
  end
end
