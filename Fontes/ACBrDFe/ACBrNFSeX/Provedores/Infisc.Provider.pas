{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Giurizzato Junior                         }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }
{                                                                              }
{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Sim�es de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatu� - SP - 18270-170         }
{******************************************************************************}

{$I ACBr.inc}

unit Infisc.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase, ACBrXmlDocument, ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderProprio, ACBrNFSeXProviderABRASFv2,
  ACBrNFSeXWebserviceBase, ACBrNFSeXWebservicesResponse;

type

  TACBrNFSeXWebserviceInfisc = class(TACBrNFSeXWebserviceSoap11)
  public
    function Recepcionar(ACabecalho, AMSG: String): string; override;
    function ConsultarLote(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorFaixa(ACabecalho, AMSG: String): string; override;
    function Cancelar(ACabecalho, AMSG: String): string; override;

  end;

  TACBrNFSeProviderInfisc = class (TACBrNFSeProviderProprio)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

    function PrepararRpsParaLote(const aXml: string): string; override;

    procedure GerarMsgDadosEmitir(Response: TNFSeEmiteResponse;
      Params: TNFSeParamsResponse); override;
    procedure TratarRetornoEmitir(Response: TNFSeEmiteResponse); override;

    procedure PrepararConsultaLoteRps(Response: TNFSeConsultaLoteRpsResponse); override;
    procedure TratarRetornoConsultaLoteRps(Response: TNFSeConsultaLoteRpsResponse); override;

    procedure PrepararConsultaNFSe(Response: TNFSeConsultaNFSeResponse); override;
    procedure TratarRetornoConsultaNFSe(Response: TNFSeConsultaNFSeResponse); override;

    procedure PrepararCancelaNFSe(Response: TNFSeCancelaNFSeResponse); override;
    procedure TratarRetornoCancelaNFSe(Response: TNFSeCancelaNFSeResponse); override;

    procedure ProcessarMensagemErros(const RootNode: TACBrXmlNode;
                                     const Response: TNFSeWebserviceResponse;
                                     AListTag: string = '';
                                     AMessageTag: string = 'Erro'); override;
  end;

  TACBrNFSeProviderInfisc101 = class (TACBrNFSeProviderInfisc)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
  end;

  TACBrNFSeXWebserviceInfisc201 = class(TACBrNFSeXWebserviceSoap11)
  public
    function Recepcionar(ACabecalho, AMSG: String): string; override;
    function RecepcionarSincrono(ACabecalho, AMSG: String): string; override;
    function GerarNFSe(ACabecalho, AMSG: String): string; override;
    function ConsultarLote(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorFaixa(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSeServicoPrestado(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSeServicoTomado(ACabecalho, AMSG: String): string; override;
    function Cancelar(ACabecalho, AMSG: String): string; override;
    function SubstituirNFSe(ACabecalho, AMSG: String): string; override;

  end;

  TACBrNFSeProviderInfisc201 = class (TACBrNFSeProviderABRASFv2)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

    procedure ValidarSchema(Response: TNFSeWebserviceResponse; aMetodo: TMetodo); override;
  end;

implementation

uses
  ACBrUtil, ACBrDFeException,
  ACBrNFSeX, ACBrNFSeXConfiguracoes, ACBrNFSeXConsts,
  ACBrNFSeXNotasFiscais, Infisc.GravarXml, Infisc.LerXml;

{ TACBrNFSeProviderInfisc }

procedure TACBrNFSeProviderInfisc.Configuracao;
begin
  inherited Configuracao;

  with ConfigGeral do
  begin
    Identificador := '';
    ModoEnvio := meLoteAssincrono;
  end;

  with ConfigWebServices do
  begin
    VersaoDados := '1.00';
    VersaoAtrib := '1.0';
    AtribVerLote := 'versao';
  end;

  ConfigMsgDados.UsarNumLoteConsLote := True;

  SetXmlNameSpace('http://ws.pc.gif.com.br/');
end;

function TACBrNFSeProviderInfisc.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_Infisc.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderInfisc.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_Infisc.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderInfisc.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceInfisc.Create(FAOwner, AMetodo, URL)
  else
    raise EACBrDFeException.Create(ERR_SEM_URL);
end;

function TACBrNFSeProviderInfisc.PrepararRpsParaLote(
  const aXml: string): string;
begin
  Result := '<NFS-e>' + SeparaDados(aXml, 'NFS-e') + '</NFS-e>';
end;

procedure TACBrNFSeProviderInfisc.GerarMsgDadosEmitir(
  Response: TNFSeEmiteResponse; Params: TNFSeParamsResponse);
var
  Emitente: TEmitenteConfNFSe;
begin
  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  with Params do
  begin
    Versao := ' ' + ConfigWebServices.AtribVerLote + '="' +
              ConfigWebServices.VersaoAtrib + '"';

    Response.XmlEnvio := '<envioLote' + Versao + '>' +
                           '<CNPJ>' +
                              OnlyNumber(Emitente.CNPJ) +
                           '</CNPJ>' +
                           '<dhTrans>' +
                              FormatDateTime('yyyy-mm-dd hh:mm:ss', Now) +
                           '</dhTrans>' +
                            Xml +
                         '</envioLote>';
  end;
end;

procedure TACBrNFSeProviderInfisc.TratarRetornoEmitir(
  Response: TNFSeEmiteResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
//  ANode: TACBrXmlNode;
//  AuxNode, AuxNodeCPFCNPJ, AuxNodeChave: TACBrXmlNode;
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      if Response.XmlRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod201;
        AErro.Descricao := Desc201;
        Exit
      end;

      Document.LoadFromXml(Response.XmlRetorno);

      ProcessarMensagemErros(Document.Root, Response, '', 'mot');

      Response.Sucesso := (Response.Erros.Count = 0);

      {
      ANode := Document.Root;

      AuxNode := ANode.Childrens.FindAnyNs('Cabecalho');

      if AuxNode <> nil then
      begin
        with Response do
        begin
          Sucesso := ProcessarConteudoXml(AuxNode.Childrens.FindAnyNs('Sucesso'), tcStr);

          AuxNode := AuxNode.Childrens.FindAnyNs('InformacoesLote');

          if AuxNode <> nil then
          begin
            with InformacoesLote do
            begin
              NumeroLote := ProcessarConteudoXml(AuxNode.Childrens.FindAnyNs('NumeroLote'), tcStr);
              InscricaoPrestador := ProcessarConteudoXml(AuxNode.Childrens.FindAnyNs('InscricaoPrestador'), tcStr);

              AuxNodeCPFCNPJ := AuxNode.Childrens.FindAnyNs('CPFCNPJRemetente');

              if AuxNodeCPFCNPJ <> nil then
              begin
                CPFCNPJRemetente := ProcessarConteudoXml(AuxNodeCPFCNPJ.Childrens.FindAnyNs('CNPJ'), tcStr);

                if CPFCNPJRemetente = '' then
                  CPFCNPJRemetente := ProcessarConteudoXml(AuxNodeCPFCNPJ.Childrens.FindAnyNs('CPF'), tcStr);
              end;

              DataEnvioLote := ProcessarConteudoXml(AuxNode.Childrens.FindAnyNs('DataEnvioLote'), tcDatHor);
              QtdNotasProcessadas := ProcessarConteudoXml(AuxNode.Childrens.FindAnyNs('QtdNotasProcessadas'), tcInt);
              TempoProcessamento := ProcessarConteudoXml(AuxNode.Childrens.FindAnyNs('TempoProcessamento'), tcInt);
              ValorTotalServico := ProcessarConteudoXml(AuxNode.Childrens.FindAnyNs('ValorTotalServico'), tcDe2);
            end;
          end;
        end;
      end;

      AuxNode := ANode.Childrens.FindAnyNs('ChaveNFeRPS');

      if AuxNode <> nil then
      begin
        AuxNodeChave := AuxNode.Childrens.FindAnyNs('ChaveRPS');

        if (AuxNodeChave <> nil) then
        begin
          with Response do
          begin
            InscricaoPrestador := ProcessarConteudoXml(AuxNodeChave.Childrens.FindAnyNs('InscricaoPrestador'), tcStr);
            SerieRPS := ProcessarConteudoXml(AuxNodeChave.Childrens.FindAnyNs('SerieRPS'), tcStr);
            NumeroRPS := ProcessarConteudoXml(AuxNodeChave.Childrens.FindAnyNs('NumeroRPS'), tcStr);
          end;
        end;

        AuxNodeChave := AuxNode.Childrens.FindAnyNs('ChaveNFe');

        if (AuxNodeChave <> nil) then
        begin
          with Response do
          begin
            InscricaoPrestador := ProcessarConteudoXml(AuxNodeChave.Childrens.FindAnyNs('InscricaoPrestador'), tcStr);
            Numero := ProcessarConteudoXml(AuxNodeChave.Childrens.FindAnyNs('NumeroNFe'), tcStr);
            CodigoVerificacao := ProcessarConteudoXml(AuxNodeChave.Childrens.FindAnyNs('CodigoVerificacao'), tcStr);
          end;
        end;
      end;
      }
    except
      on E:Exception do
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod999;
        AErro.Descricao := E.Message;
      end;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

procedure TACBrNFSeProviderInfisc.PrepararConsultaLoteRps(
  Response: TNFSeConsultaLoteRpsResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Emitente: TEmitenteConfNFSe;
  Versao: string;
begin
  if EstaVazio(Response.Lote) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod111;
    AErro.Descricao := Desc111;
    Exit;
  end;

  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  Versao := ' ' + ConfigWebServices.AtribVerLote + '="' +
            ConfigWebServices.VersaoAtrib + '"';

  Response.XmlEnvio := '<pedidoStatusLote' + Versao + '>' +
                         '<CNPJ>' +
                            OnlyNumber(Emitente.CNPJ) +
                         '</CNPJ>' +
                         '<cLote>' +
                            Response.Lote +
                         '</cLote>' +
                       '</pedidoStatusLote>';
end;

procedure TACBrNFSeProviderInfisc.TratarRetornoConsultaLoteRps(
  Response: TNFSeConsultaLoteRpsResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  {
  ANode, AuxNode: TACBrXmlNode;
  ANodeArray: TACBrXmlNodeArray;
  i: Integer;
  NumRps: String;
  ANota: NotaFiscal;
  }
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      if Response.XmlRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod201;
        AErro.Descricao := Desc201;
        Exit
      end;

      Document.LoadFromXml(Response.XmlRetorno);

      ProcessarMensagemErros(Document.Root, Response, '', 'mot');

      Response.Sucesso := (Response.Erros.Count = 0);
      {
      ANode := Document.Root;

      AuxNode := ANode.Childrens.FindAnyNs('Cabecalho');

      if AuxNode <> nil then
      begin
        with Response do
        begin
          Sucesso := ProcessarConteudoXml(AuxNode.Childrens.FindAnyNs('Sucesso'), tcStr);
        end;
      end;

      ANodeArray := ANode.Childrens.FindAllAnyNs('NFe');
      if not Assigned(ANodeArray) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod203;
        AErro.Descricao := Desc203;
        Exit;
      end;

      for i := Low(ANodeArray) to High(ANodeArray) do
      begin
        ANode := ANodeArray[i];
        AuxNode := ANode.Childrens.FindAnyNs('ChaveNFe');
        NumRps := AuxNode.AsString;

        ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByRps(NumRps);

        if Assigned(ANota) then
          ANota.XML := ANode.OuterXml
        else
        begin
          TACBrNFSeX(FAOwner).NotasFiscais.LoadFromString(ANode.OuterXml, False);
          ANota := TACBrNFSeX(FAOwner).NotasFiscais.Items[TACBrNFSeX(FAOwner).NotasFiscais.Count-1];
        end;

        SalvarXmlNfse(ANota);
      end;
      }
    except
      on E:Exception do
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod999;
        AErro.Descricao := E.Message;
      end;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

procedure TACBrNFSeProviderInfisc.PrepararConsultaNFSe(
  Response: TNFSeConsultaNFSeResponse);
var
  Emitente: TEmitenteConfNFSe;
  Versao: string;
  xConsulta: string;
begin
  if (Response.InfConsultaNFSe.NumeroIniNFSe <> '') and
     (Response.InfConsultaNFSe.NumeroFinNFSe <> '') then
  begin
    xConsulta := '<notaInicial>' +
                   Response.InfConsultaNFSe.NumeroIniNFSe +
                 '</notaInicial>' +
                 '<notaFinal>' +
                   Response.InfConsultaNFSe.NumeroFinNFSe +
                 '</notaFinal>';

    if Response.InfConsultaNFSe.SerieNFSe <> '' then
      xConsulta := xConsulta + '<serieNotaFiscal>' +
                                 Response.InfConsultaNFSe.SerieNFSe +
                               '</serieNotaFiscal>';

  end
  else
  begin
    xConsulta := '<emissaoInicial>' +
                   FormatDateTime('YYYY-MM-DD', Response.InfConsultaNFSe.DataInicial) +
                 '</emissaoInicial>' +
                 '<emissaoFinal>' +
                   FormatDateTime('YYYY-MM-DD', Response.InfConsultaNFSe.DataFinal) +
                 '</emissaoFinal>';
  end;

  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  Response.Metodo := tmConsultarNFSePorFaixa;

  Versao := ' ' + ConfigWebServices.AtribVerLote + '="' +
            ConfigWebServices.VersaoAtrib + '"';

  Response.XmlEnvio := '<pedidoLoteNFSe' + Versao + '>' +
                         '<CNPJ>' +
                            OnlyNumber(Emitente.CNPJ) +
                         '</CNPJ>' +
                         xConsulta +
                       '</pedidoLoteNFSe>';
end;

procedure TACBrNFSeProviderInfisc.TratarRetornoConsultaNFSe(
  Response: TNFSeConsultaNFSeResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  {
  ANode, AuxNode: TACBrXmlNode;
  ANodeArray: TACBrXmlNodeArray;
  i: Integer;
  NumRps: String;
  ANota: NotaFiscal;
  }
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      if Response.XmlRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod201;
        AErro.Descricao := Desc201;
        Exit
      end;

      Document.LoadFromXml(Response.XmlRetorno);

      ProcessarMensagemErros(Document.Root, Response, '', 'mot');

      Response.Sucesso := (Response.Erros.Count = 0);
      {
      ANode := Document.Root;

      AuxNode := ANode.Childrens.FindAnyNs('Cabecalho');

      if AuxNode <> nil then
      begin
        with Response do
        begin
          Sucesso := ProcessarConteudoXml(AuxNode.Childrens.FindAnyNs('Sucesso'), tcStr);
        end;
      end;

      ANodeArray := ANode.Childrens.FindAllAnyNs('NFe');
      if not Assigned(ANodeArray) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod203;
        AErro.Descricao := Desc203;
        Exit;
      end;

      for i := Low(ANodeArray) to High(ANodeArray) do
      begin
        ANode := ANodeArray[i];
        AuxNode := ANode.Childrens.FindAnyNs('ChaveNFe');
        NumRps := AuxNode.AsString;

        ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByRps(NumRps);

        if Assigned(ANota) then
          ANota.XML := ANode.OuterXml
        else
        begin
          TACBrNFSeX(FAOwner).NotasFiscais.LoadFromString(ANode.OuterXml, False);
          ANota := TACBrNFSeX(FAOwner).NotasFiscais.Items[TACBrNFSeX(FAOwner).NotasFiscais.Count-1];
        end;

        SalvarXmlNfse(ANota);
      end;
      }
    except
      on E:Exception do
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod999;
        AErro.Descricao := E.Message;
      end;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

procedure TACBrNFSeProviderInfisc.PrepararCancelaNFSe(
  Response: TNFSeCancelaNFSeResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Emitente: TEmitenteConfNFSe;
  Versao: string;
begin
  if EstaVazio(Response.InfCancelamento.ChaveNFSe) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod118;
    AErro.Descricao := Desc118;
    Exit;
  end;

  if EstaVazio(Response.InfCancelamento.CodCancelamento) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod109;
    AErro.Descricao := Desc109;
    Exit;
  end;

  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  Versao := ' ' + ConfigWebServices.AtribVerLote + '="' +
            ConfigWebServices.VersaoAtrib + '"';

  Response.XmlEnvio := '<pedCancelaNFSe' + Versao + '>' +
                         '<CNPJ>' +
                            OnlyNumber(Emitente.CNPJ) +
                         '</CNPJ>' +
                         '<chvAcessoNFS-e>' +
                            Response.InfCancelamento.ChaveNFSe +
                         '</chvAcessoNFS-e>' +
                         '<motivo>' +
                            Response.InfCancelamento.CodCancelamento +
                         '</motivo>' +
                       '</pedCancelaNFSe>';
end;

procedure TACBrNFSeProviderInfisc.TratarRetornoCancelaNFSe(
  Response: TNFSeCancelaNFSeResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
//  ANode, AuxNode: TACBrXmlNode;
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      if Response.XmlRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod201;
        AErro.Descricao := Desc201;
        Exit
      end;

      Document.LoadFromXml(Response.XmlRetorno);

      ProcessarMensagemErros(Document.Root, Response, '', 'mot');

      Response.Sucesso := (Response.Erros.Count = 0);
      {
      ANode := Document.Root;

      AuxNode := ANode.Childrens.FindAnyNs('Cabecalho');

      if AuxNode <> nil then
      begin
        with Response do
        begin
          Sucesso := ProcessarConteudoXml(AuxNode.Childrens.FindAnyNs('Sucesso'), tcStr);
        end;
      end;
      }
    except
      on E:Exception do
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod999;
        AErro.Descricao := E.Message;
      end;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

procedure TACBrNFSeProviderInfisc.ProcessarMensagemErros(
  const RootNode: TACBrXmlNode; const Response: TNFSeWebserviceResponse;
  AListTag, AMessageTag: string);
var
  I: Integer;
  ANode: TACBrXmlNode;
  ANodeArray: TACBrXmlNodeArray;
  AErro: TNFSeEventoCollectionItem;
begin
  ANode := RootNode.Childrens.FindAnyNs(AListTag);

  if (ANode = nil) then
    ANode := RootNode;

  ANodeArray := ANode.Childrens.FindAllAnyNs(AMessageTag);

  if not Assigned(ANodeArray) then Exit;

  for I := Low(ANodeArray) to High(ANodeArray) do
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := '';
    AErro.Descricao := ProcessarConteudoXml(ANodeArray[I].Childrens.FindAnyNs('mot'), tcStr);

    if AErro.Descricao = '' then
      AErro.Descricao := ANodeArray[I].AsString;

    AErro.Correcao := '';
  end;
end;

{ TACBrNFSeProviderInfisc101 }

procedure TACBrNFSeProviderInfisc101.Configuracao;
begin
  inherited Configuracao;

  with ConfigAssinar do
  begin
    LoteRps := True;
    ConsultarSituacao := True;
    ConsultarNFSe := True;
    CancelarNFSe := True;

    IncluirURI := False;
  end;

  with ConfigWebServices do
  begin
    VersaoDados := '1.10';
    VersaoAtrib := '1.0';
    AtribVerLote := 'versao';
  end;

  with ConfigMsgDados do
  begin
    with LoteRps do
    begin
      InfElemento := 'envioLote';
      DocElemento := 'envioLote';
    end;
  end;
end;

function TACBrNFSeProviderInfisc101.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_Infisc101.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderInfisc101.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_Infisc.Create(Self);
  Result.NFSe := ANFSe;
end;

{ TACBrNFSeProviderInfisc201 }

procedure TACBrNFSeProviderInfisc201.Configuracao;
begin
  inherited Configuracao;

  with ConfigAssinar do
  begin
    Rps := True;
    LoteRps := True;
    ConsultarLote := True;
    ConsultarNFSeRps := True;
    ConsultarNFSePorFaixa := True;
    ConsultarNFSeServicoPrestado := True;
    ConsultarNFSeServicoTomado := True;
    CancelarNFSe := True;
  end;

  with ConfigWebServices do
  begin
    VersaoDados := '2.01';
    VersaoAtrib := '2.01';
  end;

  with ConfigMsgDados do
  begin
    DadosCabecalho := '<cabecalho versao="2.01">' +
                        '<versaoDados>2.01</versaoDados>' +
                      '</cabecalho>';
  end;
end;

function TACBrNFSeProviderInfisc201.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_Infisc201.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderInfisc201.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_Infisc201.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderInfisc201.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceInfisc201.Create(FAOwner, AMetodo, URL)
  else
    raise EACBrDFeException.Create(ERR_SEM_URL);
end;

procedure TACBrNFSeProviderInfisc201.ValidarSchema(
  Response: TNFSeWebserviceResponse; aMetodo: TMetodo);
begin
  inherited ValidarSchema(Response, aMetodo);

  Response.XmlEnvio := StringReplace(Response.XmlEnvio,
         ' xmlns="http://www.abrasf.org.br/nfse.xsd"', '', [rfReplaceAll]);
end;

{ TACBrNFSeXWebserviceInfisc }

function TACBrNFSeXWebserviceInfisc.Recepcionar(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<enviarLoteNotasRequest>';
  Request := Request + AMSG;
  Request := Request + '</enviarLoteNotasRequest>';

  Result := Executar('', Request, ['confirmaLote'],
                     ['xmlns="http://ws.pc.gif.com.br/"']);
end;

function TACBrNFSeXWebserviceInfisc.ConsultarLote(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<obterCriticaLoteRequest>';
  Request := Request + AMSG;
  Request := Request + '</obterCriticaLoteRequest>';

  Result := Executar('', Request, ['resultadoLote'],
                     ['xmlns="http://ws.pc.gif.com.br/"']);
end;

function TACBrNFSeXWebserviceInfisc.ConsultarNFSePorFaixa(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<obterLoteNotaFiscalRequest>';
  Request := Request + AMSG;
  Request := Request + '</obterLoteNotaFiscalRequest>';

  Result := Executar('', Request, ['resPedidoLoteNFSe'],
                     ['xmlns="http://ws.pc.gif.com.br/"']);
end;

function TACBrNFSeXWebserviceInfisc.Cancelar(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<cancelarNotaFiscalRequest>';
  Request := Request + AMSG;
  Request := Request + '</cancelarNotaFiscalRequest>';

  Result := Executar('', Request, ['resCancelaNFSe'],
                     ['xmlns="http://ws.pc.gif.com.br/"']);
end;

{ TACBrNFSeXWebserviceInfisc201 }

function TACBrNFSeXWebserviceInfisc201.Recepcionar(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<RecepcionarLoteRps>';
  Request := Request + '<nfseCabecMsg>' + ACabecalho + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + AMSG + '</nfseDadosMsg>';
  Request := Request + '</RecepcionarLoteRps>';

  Result := Executar('', Request, [''], ['xmlns="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceInfisc201.RecepcionarSincrono(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<RecepcionarLoteRpsSincrono>';
  Request := Request + '<nfseCabecMsg>' + ACabecalho + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + AMSG + '</nfseDadosMsg>';
  Request := Request + '</RecepcionarLoteRpsSincrono>';

  Result := Executar('', Request, ['EnviarLoteRpsSincronoResposta'],
                     ['xmlns="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceInfisc201.GerarNFSe(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<GerarNfse>';
  Request := Request + '<nfseCabecMsg>' + ACabecalho + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + AMSG + '</nfseDadosMsg>';
  Request := Request + '</GerarNfse>';

  Result := Executar('', Request, ['GerarNfseResposta'],
                     ['xmlns="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceInfisc201.ConsultarLote(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ConsultarLoteRps>';
  Request := Request + '<nfseCabecMsg>' + ACabecalho + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + AMSG + '</nfseDadosMsg>';
  Request := Request + '</ConsultarLoteRps>';

  Result := Executar('', Request, ['ConsultarLoteRpsResposta'],
                     ['xmlns="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceInfisc201.ConsultarNFSePorFaixa(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  {
    O WebService esta retornando a tag de fechamento da Resposta sem o caracter "/"
  }
  FPMsgOrig := AMSG;

  Request := '<ConsultarNfseFaixa>';
  Request := Request + '<nfseCabecMsg>' + ACabecalho + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + AMSG + '</nfseDadosMsg>';
  Request := Request + '</ConsultarNfseFaixa>';

  Result := Executar('', Request, ['ConsultarNfseFaixaResposta'],
                     ['xmlns="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceInfisc201.ConsultarNFSePorRps(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ConsultarNfsePorRps>';
  Request := Request + '<nfseCabecMsg>' + ACabecalho + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + AMSG + '</nfseDadosMsg>';
  Request := Request + '</ConsultarNfsePorRps>';

  Result := Executar('', Request, ['ConsultarNfseRpsResposta'],
                     ['xmlns="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceInfisc201.ConsultarNFSeServicoPrestado(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  {
    O WebService esta retornando a tag de fechamento da Resposta sem o caracter "/"
  }
  FPMsgOrig := AMSG;

  Request := '<ConsultarNfseServicoPrestado>';
  Request := Request + '<nfseCabecMsg>' + ACabecalho + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + AMSG + '</nfseDadosMsg>';
  Request := Request + '</ConsultarNfseServicoPrestado>';

  Result := Executar('', Request, ['ConsultarNfseServicoPrestadoResposta'],
                     ['xmlns="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceInfisc201.ConsultarNFSeServicoTomado(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  {
    O WebService esta retornando a tag de fechamento da Resposta sem o caracter "/"
  }
  FPMsgOrig := AMSG;

  Request := '<ConsultarNfseServicoTomado>';
  Request := Request + '<nfseCabecMsg>' + ACabecalho + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + AMSG + '</nfseDadosMsg>';
  Request := Request + '</ConsultarNfseServicoTomado>';

  Result := Executar('', Request, ['ConsultarNfseServicoTomadoResposta'],
                     ['xmlns="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceInfisc201.Cancelar(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<CancelarNfse>';
  Request := Request + '<nfseCabecMsg>' + ACabecalho + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + AMSG + '</nfseDadosMsg>';
  Request := Request + '</CancelarNfse>';

  Result := Executar('', Request, ['CancelarNfseResposta'],
                     ['xmlns="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceInfisc201.SubstituirNFSe(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<SubstituirNfse>';
  Request := Request + '<nfseCabecMsg>' + ACabecalho + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + AMSG + '</nfseDadosMsg>';
  Request := Request + '</SubstituirNfse>';

  Result := Executar('', Request, ['SubstituirNfseResposta'],
                     ['xmlns="http://nfse.abrasf.org.br"']);
end;

end.
