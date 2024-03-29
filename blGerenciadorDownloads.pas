unit blGerenciadorDownloads;

interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections, System.Threading,
  IdHTTP, IdSSLOpenSSL, IdComponent, dmGerenciadorDownloads;

type
  TProgresso = record
    Posicao: Integer;
    Maximo: Integer;
    Concluido: Boolean;
    PararDownload: Boolean;
    Erro: String;
  end;

  IObserver = interface
    procedure Atualizar(Progresso: TProgresso);
  end;

  TDownload = class(TThread)
  private
    FGerenciadorDownloadsDM: TdmdGerenciadorDownloads;
    FProgresso: TProgresso;
    FListaObservers: TList<IObserver>;

    FHttp: TIdHTTP;
    FCodigoDownload: Integer;
    FUrlDownload: String;
    FNomeArquivo: String;

    procedure ConfigurarHTTP;
    procedure InicializarPropriedadesProgresso;
    procedure InicializarPropriedadesDownload;

    procedure InicioDownload(ASender: TObject; AWorkMode: TWorkMode;AWorkCountMax: Int64);
    procedure Progresso(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);

    procedure RealizarDownload;
    procedure FimDownload;
    procedure TratarExcecaoHttp(CodeResponse: Integer; sErro: String);
  protected
    procedure Atualizar;

  public
    constructor Create;
    destructor Destroy; override;
    procedure Execute; override;

    procedure AdicionarObserver(oObserver: IObserver);
    procedure RemoverObserver(oObserver: IObserver);

    procedure PararDownload;

    property CodigoDownload: Integer read FCodigoDownload write FCodigoDownload;
    property UrlDownload: String read FUrlDownload write FUrlDownload;
    property NomeArquivo: String read FNomeArquivo write FNomeArquivo;
  end;

implementation

{ TGerenciadorDownload }

procedure TDownload.AdicionarObserver(oObserver: IObserver);
begin
  if FListaObservers.IndexOf(oObserver) = -1 then
    FListaObservers.Add(oObserver);
end;

procedure TDownload.Atualizar;
var
  Observer: IObserver;
begin
  for Observer in FListaObservers do
    if Assigned(Observer) then
      Observer.Atualizar(FProgresso);
end;

procedure TDownload.ConfigurarHTTP;
var
  oIdSSL: TIdSSLIOHandlerSocketOpenSSL;
begin
  oIdSSL := TIdSSLIOHandlerSocketOpenSSL.Create;
  oIdSSL.SSLOptions.SSLVersions := [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];
  oIdSSL.SSLOptions.Method := sslvSSLv23;
  oIdSSL.SSLOptions.Mode := sslmClient;

  FHttp := TIdHTTP.Create;
  FHttp.IOHandler := oIdSSL;
  FHttp.HandleRedirects := True;
  FHttp.OnWorkBegin := InicioDownload;
  FHttp.OnWork := Progresso;
end;

constructor TDownload.Create;
begin
  inherited Create(True);

  FGerenciadorDownloadsDM := dmdGerenciadorDownloads;
  FListaObservers := TList<IObserver>.Create;
  ConfigurarHTTP;
  InicializarPropriedadesProgresso;
  InicializarPropriedadesDownload;
end;

destructor TDownload.Destroy;
begin
  FHttp.Free;
  inherited;
end;

procedure TDownload.Execute;
begin
  inherited;
  RealizarDownload;
end;

procedure TDownload.FimDownload;
begin
  FGerenciadorDownloadsDM.GravarHistoricoFim(FCodigoDownload);
  FProgresso.Concluido := FProgresso.Erro = EmptyStr;
  Atualizar;
end;

procedure TDownload.RealizarDownload;
var
  oStream: TMemoryStream;

begin
  FCodigoDownload := FGerenciadorDownloadsDM.GravarHistoricoInicio(UrlDownload);

  try
    oStream := TMemoryStream.Create;
    try
      FHttp.Get(UrlDownload, oStream);
      oStream.SaveToFile(NomeArquivo);
    except
      on e:Exception do
        TratarExcecaoHttp(FHttp.ResponseCode, e.Message);
    end;

    FimDownload;
  finally
    oStream.Free;
  end;
end;

procedure TDownload.RemoverObserver(oObserver: IObserver);
begin
  FListaObservers.Remove(oObserver);
end;

procedure TDownload.InicializarPropriedadesDownload;
begin
  FCodigoDownload := 0;
  FUrlDownload := EmptyStr;
  FNomeArquivo := EmptyStr;
end;

procedure TDownload.InicializarPropriedadesProgresso;
begin
  FProgresso.Posicao := 0;
  FProgresso.Maximo := 100;
  FProgresso.Concluido := False;
  FProgresso.Erro := EmptyStr;
  FProgresso.PararDownload := False;
end;

procedure TDownload.InicioDownload(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCountMax: Int64);
begin
  FProgresso.Maximo := AWorkCountMax;
end;

procedure TDownload.PararDownload;
begin
  FProgresso.PararDownload := True
end;

procedure TDownload.Progresso(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
begin
  FProgresso.Posicao:= AWorkCount;

  if FProgresso.PararDownload then
    FHttp.Disconnect;

  Atualizar;
end;

procedure TDownload.TratarExcecaoHttp(CodeResponse: Integer; sErro: String);
begin
  if CodeResponse = 404 then
    FProgresso.Erro := 'Arquivo n�o encontrado.'
  else if Pos('UNKNOWN PROTOCOL', UpperCase(sErro)) > 0 then
    FProgresso.Erro := 'Link inv�lido.'
  else
    FProgresso.Erro := sErro;
end;

end.
