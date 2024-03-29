unit dmGerenciadorDownloads;

interface

uses
  System.SysUtils, vcl.Dialogs, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TdmdGerenciadorDownloads = class(TDataModule)
    Connection: TFDConnection;
    qryCriaTabelaHistoricoDownloads: TFDQuery;
    qryHistoricoGrid: TFDQuery;
    dsHistoricoGrid: TDataSource;
    qryHistoricoGridCODIGO: TBCDField;
    qryHistoricoGridURL: TStringField;
    qryHistoricoDownloads: TFDQuery;
    qryHistoricoDownloadsCODIGO: TBCDField;
    qryHistoricoDownloadsURL: TStringField;
    qryProximoCodigoHistorico: TFDQuery;
    qryProximoCodigoHistoricoCODIGO: TLargeintField;
    qryHistoricoDownloadsDATAINICIO: TDateTimeField;
    qryHistoricoDownloadsDATAFIM: TDateTimeField;
    qryHistoricoGridDATAINICIO: TDateTimeField;
    qryHistoricoGridDATAFIM: TDateTimeField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    procedure CriaTabelaHistoricoDownloads;
    function ProximoCodigoHistorico: Integer;
  public
    { Public declarations }
    procedure AbrirHistoricoDownloadsGrid;
    procedure AbrirHistoricoDownloads;

    function GravarHistoricoInicio(Url: String): Integer;
    procedure GravarHistoricoFim(Codigo: Integer);
    procedure FiltrarHistoricoDownload(Codigo: Integer);
  end;

var
  dmdGerenciadorDownloads: TdmdGerenciadorDownloads;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmdGerenciadorDownloads }

procedure TdmdGerenciadorDownloads.AbrirHistoricoDownloads;
begin
  qryHistoricoDownloads.Close;
  qryHistoricoDownloads.MacroByName('WHERE').AsString := EmptyStr;
  qryHistoricoDownloads.Open;
end;

procedure TdmdGerenciadorDownloads.AbrirHistoricoDownloadsGrid;
begin
  qryHistoricoGrid.Close;
  qryHistoricoGrid.Open;
end;

procedure TdmdGerenciadorDownloads.CriaTabelaHistoricoDownloads;
begin
  qryCriaTabelaHistoricoDownloads.ExecSQL;
end;

procedure TdmdGerenciadorDownloads.DataModuleCreate(Sender: TObject);
begin
  Connection.Params.Database := 'GerenciadorDownloads.db';
  Connection.Open;

  CriaTabelaHistoricoDownloads;
end;

procedure TdmdGerenciadorDownloads.FiltrarHistoricoDownload(Codigo: Integer);
begin
  qryHistoricoDownloads.Close;
  qryHistoricoDownloads.ParamByName('CODIGOHISTORICO').AsInteger := Codigo;
  qryHistoricoDownloads.Open;
end;

procedure TdmdGerenciadorDownloads.GravarHistoricoFim(Codigo: Integer);
begin
  FiltrarHistoricoDownload(Codigo);

  qryHistoricoDownloads.Edit;
  qryHistoricoDownloadsDATAFIM.AsDateTime := Now;
  qryHistoricoDownloads.Post;

  try
    qryHistoricoDownloads.ApplyUpdates(0);
  except
    on e:Exception do
      raise Exception.Create('Erro ao gravar histórico.' + #13#10 + 'Erro original:' + e.Message);
  end;
end;

function TdmdGerenciadorDownloads.GravarHistoricoInicio(Url: String): Integer;
var
  iNovoCodigo: Integer;
begin
  iNovoCodigo := ProximoCodigoHistorico;

  FiltrarHistoricoDownload(iNovoCodigo);

  qryHistoricoDownloads.Insert;
  qryHistoricoDownloadsCODIGO.AsInteger := iNovoCodigo;
  qryHistoricoDownloadsURL.AsString := Url;
  qryHistoricoDownloadsDATAINICIO.AsDateTime := Now;
  qryHistoricoDownloads.Post;

  try
    qryHistoricoDownloads.ApplyUpdates(0);
  except
    on e:Exception do
      ShowMessage('Erro ao gravar histórico.' + #13#10 + 'Erro original:' + e.Message);
  end;

  Result := iNovoCodigo;
end;

function TdmdGerenciadorDownloads.ProximoCodigoHistorico: Integer;
begin
  Result := 1;

  qryProximoCodigoHistorico.Close;
  qryProximoCodigoHistorico.Open;

  if not qryProximoCodigoHistorico.IsEmpty then
    Result := qryProximoCodigoHistoricoCODIGO.AsInteger;
end;

end.
