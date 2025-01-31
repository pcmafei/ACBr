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

unit ACBrNFSeXLerXml_ABRASFv2;

interface

uses
{$IFDEF FPC}
  LResources, Controls, Graphics, Dialogs,
{$ENDIF}
  SysUtils, Classes, StrUtils,
  ACBrUtil, ACBrConsts,
  ACBrXmlBase, ACBrXmlDocument,
  ACBrNFSeXLerXml, ACBrNFSeXConversao;

type
  { TNFSeR_ABRASFv2 }

  TNFSeR_ABRASFv2 = class(TNFSeRClass)
  private

  protected
    procedure LerInfNfse(const ANode: TACBrXmlNode);

    procedure LerValoresNfse(const ANode: TACBrXmlNode);

    procedure LerPrestadorServico(const ANode: TACBrXmlNode);
    procedure LerEnderecoPrestadorServico(const ANode: TACBrXmlNode; aTag: string);
    procedure LerContatoPrestador(const ANode: TACBrXmlNode);

    procedure LerOrgaoGerador(const ANode: TACBrXmlNode);
    procedure LerDeclaracaoPrestacaoServico(const ANode: TACBrXmlNode);
    procedure LerInfDeclaracaoPrestacaoServico(const ANode: TACBrXmlNode);

    procedure LerRps(const ANode: TACBrXmlNode);
    procedure LerIdentificacaoRps(const ANode: TACBrXmlNode);
    procedure LerRpsSubstituido(const ANode: TACBrXmlNode);

    procedure LerServico(const ANode: TACBrXmlNode);
    procedure LerValores(const ANode: TACBrXmlNode);

    procedure LerPrestador(const ANode: TACBrXmlNode);
    procedure LerIdentificacaoPrestador(const ANode: TACBrXmlNode);

    procedure LerTomadorServico(const ANode: TACBrXmlNode);
    procedure LerIdentificacaoTomador(const ANode: TACBrXmlNode);
    procedure LerEnderecoTomador(const ANode: TACBrXmlNode);
    procedure LerContatoTomador(const ANode: TACBrXmlNode);

    procedure LerIntermediarioServico(const ANode: TACBrXmlNode);

    procedure LerConstrucaoCivil(const ANode: TACBrXmlNode);

    procedure LerNfseCancelamento(const ANode: TACBrXmlNode);
    procedure LerConfirmacao(const ANode: TACBrXmlNode);
    procedure LerPedido(const ANode: TACBrXmlNode);
    procedure LerInfConfirmacaoCancelamento(const ANode: TACBrXmlNode);
    procedure LerInfPedidoCancelamento(const ANode: TACBrXmlNode);
    procedure LerIdentificacaoNfse(const ANode: TACBrXmlNode);

    procedure LerNfseSubstituicao(const ANode: TACBrXmlNode);
    procedure LerSubstituicaoNfse(const ANode: TACBrXmlNode);
  public
    function LerXml: Boolean; override;
    function LerXmlRps(const ANode: TACBrXmlNode): Boolean;
    function LerXmlNfse(const ANode: TACBrXmlNode): Boolean;

  end;

implementation

//==============================================================================
// Essa unit tem por finalidade exclusiva de ler o XML da NFS-e e RPS dos provedores:
//     que seguem a vers�o 2.xx do layout da ABRASF
//==============================================================================

{ TNFSeR_ABRASFv2 }

procedure TNFSeR_ABRASFv2.LerConfirmacao(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('Confirmacao');

  if AuxNode <> nil then
  begin
    LerPedido(AuxNode);
    LerInfConfirmacaoCancelamento(AuxNode);

    with NFSe.NfseCancelamento do
    begin
      DataHora := LerDatas(ProcessarConteudo(AuxNode.Childrens.FindAnyNs('DataHora'), tcStr));

      if DataHora > 0 then
        NFSe.SituacaoNfse := snCancelado;
    end;
  end;
end;

procedure TNFSeR_ABRASFv2.LerConstrucaoCivil(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('ConstrucaoCivil');

  if AuxNode <> nil then
  begin
    with NFSe.ConstrucaoCivil do
    begin
      CodigoObra := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('CodigoObra'), tcStr);
      Art        := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Art'), tcStr);
    end;
  end;
end;

procedure TNFSeR_ABRASFv2.LerContatoPrestador(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('Contato');

  if AuxNode <> nil then
  begin
    with NFSe.Prestador.Contato do
    begin
      Telefone := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Telefone'), tcStr);
      Email    := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Email'), tcStr);
    end;
  end;
end;

procedure TNFSeR_ABRASFv2.LerContatoTomador(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('Contato');

  if AuxNode <> nil then
  begin
    with NFSe.Tomador.Contato do
    begin
      Telefone := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Telefone'), tcStr);
      Email    := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Email'), tcStr);
    end;
  end;
end;

procedure TNFSeR_ABRASFv2.LerDeclaracaoPrestacaoServico(
  const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('DeclaracaoPrestacaoServico');

  if AuxNode <> nil then
  begin
    LerInfDeclaracaoPrestacaoServico(AuxNode);
  end;
end;

procedure TNFSeR_ABRASFv2.LerEnderecoPrestadorServico(const ANode: TACBrXmlNode;
  aTag: string);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs(aTag);

  if AuxNode <> nil then
  begin
    with NFSe.Prestador.Endereco do
    begin
      Endereco        := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Endereco'), tcStr);
      Numero          := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Numero'), tcStr);
      Complemento     := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Complemento'), tcStr);
      Bairro          := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Bairro'), tcStr);
      CodigoMunicipio := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('CodigoMunicipio'), tcStr);
      UF              := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Uf'), tcStr);
      CodigoPais      := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('CodigoPais'), tcInt);
      CEP             := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Cep'), tcStr);
      xMunicipio      := CodIBGEToCidade(StrToIntDef(CodigoMunicipio, 0));
    end;
  end;
end;

procedure TNFSeR_ABRASFv2.LerEnderecoTomador(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('Endereco');

  if AuxNode <> nil then
  begin
    with NFSe.Tomador.Endereco do
    begin
      Endereco        := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Endereco'), tcStr);
      Numero          := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Numero'), tcStr);
      Complemento     := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Complemento'), tcStr);
      Bairro          := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Bairro'), tcStr);
      CodigoMunicipio := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('CodigoMunicipio'), tcStr);
      UF              := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Uf'), tcStr);
      CEP             := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Cep'), tcStr);
      xMunicipio      := CodIBGEToCidade(StrToIntDef(CodigoMunicipio, 0));
    end;
  end;
end;

procedure TNFSeR_ABRASFv2.LerIdentificacaoNfse(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('IdentificacaoNfse');

  if AuxNode <> nil then
  begin
    with NFSe.NfseCancelamento.Pedido.IdentificacaoNfse do
    begin
      Numero             := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Numero'), tcStr);
      Cnpj               := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Cnpj'), tcStr);
      InscricaoMunicipal := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('InscricaoMunicipal'), tcStr);
      CodigoMunicipio    := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('CodigoMunicipio'), tcStr);
    end;
  end;
end;

procedure TNFSeR_ABRASFv2.LerIdentificacaoPrestador(const ANode: TACBrXmlNode);
var
  AuxNode, AuxNodeCpfCnpj: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('IdentificacaoPrestador');

  if AuxNode <> nil then
  begin
    with NFSe.Prestador.IdentificacaoPrestador do
    begin
      Cnpj := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Cnpj'), tcStr);

      if Cnpj = '' then
      begin
        AuxNodeCpfCnpj := AuxNode.Childrens.FindAnyNs('CpfCnpj');

        with NFSe.Tomador.IdentificacaoTomador do
        begin
          if AuxNodeCpfCnpj <> nil then
          begin
            Cnpj := ProcessarConteudo(AuxNodeCpfCnpj.Childrens.FindAnyNs('Cpf'), tcStr);

            if Cnpj = '' then
              Cnpj := ProcessarConteudo(AuxNodeCpfCnpj.Childrens.FindAnyNs('Cnpj'), tcStr);
          end;
        end;
      end;

      InscricaoMunicipal := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('InscricaoMunicipal'), tcStr);
    end;
  end
  else
  begin
    with NFSe.Prestador.IdentificacaoPrestador do
    begin
      Cnpj := ProcessarConteudo(ANode.Childrens.FindAnyNs('Cnpj'), tcStr);

      if Cnpj = '' then
      begin
        AuxNodeCpfCnpj := ANode.Childrens.FindAnyNs('CpfCnpj');

        with NFSe.Tomador.IdentificacaoTomador do
        begin
          if AuxNodeCpfCnpj <> nil then
          begin
            Cnpj := ProcessarConteudo(AuxNodeCpfCnpj.Childrens.FindAnyNs('Cpf'), tcStr);

            if Cnpj = '' then
              Cnpj := ProcessarConteudo(AuxNodeCpfCnpj.Childrens.FindAnyNs('Cnpj'), tcStr);
          end;
        end;
      end;

      InscricaoMunicipal := ProcessarConteudo(ANode.Childrens.FindAnyNs('InscricaoMunicipal'), tcStr);
    end;
  end;
end;

procedure TNFSeR_ABRASFv2.LerIdentificacaoRps(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  Ok: Boolean;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('IdentificacaoRps');

  if AuxNode <> nil then
  begin
    with NFSe.IdentificacaoRps do
    begin
      Numero := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Numero'), tcStr);
      Serie  := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Serie'), tcStr);
      Tipo   := StrToTipoRPS(Ok, ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Tipo'), tcStr));
    end;
  end;
end;

procedure TNFSeR_ABRASFv2.LerIdentificacaoTomador(const ANode: TACBrXmlNode);
var
  AuxNode, AuxNodeCpfCnpj: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('IdentificacaoTomador');

  if AuxNode <> nil then
  begin
    AuxNodeCpfCnpj := AuxNode.Childrens.FindAnyNs('CpfCnpj');

    with NFSe.Tomador.IdentificacaoTomador do
    begin
      if AuxNodeCpfCnpj <> nil then
      begin
        CpfCnpj := ProcessarConteudo(AuxNodeCpfCnpj.Childrens.FindAnyNs('Cpf'), tcStr);

        if CpfCnpj = '' then
          CpfCnpj := ProcessarConteudo(AuxNodeCpfCnpj.Childrens.FindAnyNs('Cnpj'), tcStr);
      end;

      InscricaoMunicipal := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('InscricaoMunicipal'), tcStr);
    end;

    if NFSe.Tomador.RazaoSocial = '' then
      NFSe.Tomador.RazaoSocial := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('RazaoSocial'), tcStr);

    LerEnderecoTomador(AuxNode);
    LerContatoTomador(AuxNode);
  end;
end;

procedure TNFSeR_ABRASFv2.LerInfConfirmacaoCancelamento(
  const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('InfConfirmacaoCancelamento');

  NFSe.SituacaoNfse := snNormal;

  if AuxNode <> nil then
  begin
    with NFSe.NfseCancelamento do
    begin
      Sucesso  := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Sucesso'), tcBool);
      DataHora := LerDatas(ProcessarConteudo(AuxNode.Childrens.FindAnyNs('DataHora'), tcStr));
    end;

    if NFSe.NfseCancelamento.DataHora > 0 then
      NFSe.SituacaoNfse := snCancelado;
  end;
end;

procedure TNFSeR_ABRASFv2.LerInfDeclaracaoPrestacaoServico(
  const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  Ok: Boolean;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('InfDeclaracaoPrestacaoServico');

  if AuxNode <> nil then
  begin
    LerRps(AuxNode);

    NFSe.Competencia := LerDatas(ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Competencia'), tcStr));

    LerServico(AuxNode);
    LerPrestador(AuxNode);
    LerTomadorServico(AuxNode);
    LerIntermediarioServico(AuxNode);
    LerConstrucaoCivil(AuxNode);

    NFSe.RegimeEspecialTributacao := StrToRegimeEspecialTributacao(Ok, ProcessarConteudo(AuxNode.Childrens.FindAnyNs('RegimeEspecialTributacao'), tcStr));
    NFSe.OptanteSimplesNacional   := StrToSimNao(Ok, ProcessarConteudo(AuxNode.Childrens.FindAnyNs('OptanteSimplesNacional'), tcStr));
    NFSe.IncentivadorCultural     := StrToSimNao(Ok, ProcessarConteudo(AuxNode.Childrens.FindAnyNs('IncentivoFiscal'), tcStr));
  end;
end;

procedure TNFSeR_ABRASFv2.LerInfNfse(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('InfNfse');

  if AuxNode <> nil then
  begin
    NFSe.Numero            := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Numero'), tcStr);
    NFSe.CodigoVerificacao := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('CodigoVerificacao'), tcStr);
    NFSe.DataEmissao       := LerDatas(ProcessarConteudo(AuxNode.Childrens.FindAnyNs('DataEmissao'), tcStr));
    NFSe.NfseSubstituida   := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('NfseSubstituida'), tcStr);

    NFSe.OutrasInformacoes := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('OutrasInformacoes'), tcStr);
    NFSe.InformacoesComplementares := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('InformacoesComplementares'), tcStr);
    NFSe.Link := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('UrlNfse'), tcStr);

    if NFSe.Link = '' then
      NFSe.Link := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('LinkNota'), tcStr);

    LerValoresNfse(AuxNode);

    NFSe.ValorCredito := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('ValorCredito'), tcDe2);

    LerPrestadorServico(AuxNode);
    LerEnderecoPrestadorServico(AuxNode, 'EnderecoPrestadorServico');
    LerOrgaoGerador(AuxNode);
    LerDeclaracaoPrestacaoServico(AuxNode);

    NFSe.ChaveAcesso := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('ChaveAcesso'), tcStr);
  end;
end;

procedure TNFSeR_ABRASFv2.LerNfseCancelamento(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('NfseCancelamento');

  LerConfirmacao(AuxNode);
end;

procedure TNFSeR_ABRASFv2.LerNfseSubstituicao(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('NfseSubstituicao');

  LerSubstituicaoNfse(AuxNode);
end;

procedure TNFSeR_ABRASFv2.LerInfPedidoCancelamento(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('InfPedidoCancelamento');

  if AuxNode <> nil then
  begin
    LerIdentificacaoNfse(AuxNode);

    with NFSe.NfseCancelamento.Pedido do
      CodigoCancelamento := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('CodigoCancelamento'), tcStr);
  end;
end;

procedure TNFSeR_ABRASFv2.LerIntermediarioServico(const ANode: TACBrXmlNode);
var
  AuxNode, AuxNodeCpfCnpj: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('Intermediario');

  if AuxNode <> nil then
  begin
    NFSe.IntermediarioServico.RazaoSocial := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('RazaoSocial'), tcStr);

    AuxNodeCpfCnpj := AuxNode.Childrens.FindAnyNs('CpfCnpj');

    with NFSe.IntermediarioServico do
    begin
      if AuxNodeCpfCnpj <> nil then
      begin
        CpfCnpj := ProcessarConteudo(AuxNodeCpfCnpj.Childrens.FindAnyNs('Cpf'), tcStr);

        if CpfCnpj = '' then
          CpfCnpj := ProcessarConteudo(AuxNodeCpfCnpj.Childrens.FindAnyNs('Cnpj'), tcStr);
      end;

      InscricaoMunicipal := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('InscricaoMunicipal'), tcStr);
    end;
  end;
end;

procedure TNFSeR_ABRASFv2.LerOrgaoGerador(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('OrgaoGerador');

  if AuxNode <> nil then
  begin
    with NFSe.OrgaoGerador do
    begin
      CodigoMunicipio := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('CodigoMunicipio'), tcStr);
      Uf              := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Uf'), tcStr);
    end;
  end;
end;

procedure TNFSeR_ABRASFv2.LerPedido(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('Pedido');

  if AuxNode <> nil then
  begin
    LerInfPedidoCancelamento(AuxNode);
  end;
end;

procedure TNFSeR_ABRASFv2.LerPrestador(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('Prestador');

  if AuxNode <> nil then
  begin
    LerIdentificacaoPrestador(AuxNode);
  end;
end;

procedure TNFSeR_ABRASFv2.LerPrestadorServico(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('PrestadorServico');

  if AuxNode = nil then
    AuxNode := ANode.Childrens.FindAnyNs('Prestador');


  if AuxNode <> nil then
  begin
    LerIdentificacaoPrestador(AuxNode);

    with NFSe.Prestador do
    begin
      RazaoSocial  := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('RazaoSocial'), tcStr);
      NomeFantasia := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('NomeFantasia'), tcStr);
    end;

    LerEnderecoPrestadorServico(AuxNode, 'Endereco');
    LerContatoPrestador(AuxNode);
  end;
end;

procedure TNFSeR_ABRASFv2.LerRps(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  Ok: Boolean;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('Rps');

  if AuxNode <> nil then
  begin
    LerIdentificacaoRps(AuxNode);

    if NFSe.DataEmissao = 0 then
      NFSe.DataEmissao := LerDatas(ProcessarConteudo(AuxNode.Childrens.FindAnyNs('DataEmissao'), tcStr));

    NFSe.Status := StrToStatusRPS(Ok, ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Status'), tcStr));

    LerRpsSubstituido(AuxNode);
  end;
end;

procedure TNFSeR_ABRASFv2.LerRpsSubstituido(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  Ok: Boolean;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('RpsSubstituido');

  if AuxNode <> nil then
  begin
    with NFSe.RpsSubstituido do
    begin
      Numero := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Numero'), tcStr);
      Serie  := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Serie'), tcStr);
      Tipo   := StrToTipoRPS(Ok, ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Tipo'), tcStr));
    end;
  end;
end;

procedure TNFSeR_ABRASFv2.LerServico(const ANode: TACBrXmlNode);
var
  AuxNode, AuxNode2: TACBrXmlNode;
  Ok: Boolean;
  CodigoItemServico: string;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('Servico');

  if AuxNode <> nil then
  begin
    AuxNode2 := AuxNode.Childrens.FindAnyNs('tcDadosServico');

    if AuxNode2 <> nil then
      AuxNode := AuxNode2;

    LerValores(AuxNode);

    CodigoItemServico := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('ItemListaServico'), tcStr);

    // Provedor MegaSoft
    if CodigoItemServico = '' then
      CodigoItemServico := OnlyNumber(ProcessarConteudo(AuxNode.Childrens.FindAnyNs('CodigoTributacaoMunicipio'), tcStr));

    with NFSe.Servico do
    begin
      ItemListaServico          := NormatizaItemListaServico(CodigoItemServico);
      xItemListaServico         := ItemListaServicoDescricao(ItemListaServico);
      CodigoCnae                := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('CodigoCnae'), tcStr);
      CodigoTributacaoMunicipio := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('CodigoTributacaoMunicipio'), tcStr);
      Discriminacao             := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Discriminacao'), tcStr);
      CodigoMunicipio           := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('CodigoMunicipio'), tcStr);

      CodigoPais          := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('CodigoPais'), tcInt);
      ExigibilidadeISS    := StrToExigibilidadeISS(Ok, ProcessarConteudo(AuxNode.Childrens.FindAnyNs('ExigibilidadeISS'), tcStr));
      MunicipioIncidencia := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('MunicipioIncidencia'), tcInt);
      NumeroProcesso      := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('NumeroProcesso'), tcStr);

      Valores.IssRetido := StrToSituacaoTributaria(Ok, ProcessarConteudo(AuxNode.Childrens.FindAnyNs('IssRetido'), tcStr));

      if Valores.IssRetido = stRetencao then
        Valores.ValorIssRetido := Valores.ValorInss
      else
        Valores.ValorIssRetido := 0;
    end;
  end;
end;

procedure TNFSeR_ABRASFv2.LerSubstituicaoNfse(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('SubstituicaoNfse');

  if AuxNode <> nil then
  begin
    NFSe.NfseSubstituidora := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('NfseSubstituidora'), tcStr);
  end;
end;

procedure TNFSeR_ABRASFv2.LerTomadorServico(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('TomadorServico');

  if AuxNode = nil then
    AuxNode := ANode.Childrens.FindAnyNs('Tomador');

  if AuxNode <> nil then
  begin
    NFSe.Tomador.RazaoSocial := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('RazaoSocial'), tcStr);

    LerIdentificacaoTomador(AuxNode);

    LerEnderecoTomador(AuxNode);
    LerContatoTomador(AuxNode);
  end;
end;

procedure TNFSeR_ABRASFv2.LerValores(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('Valores');

  if AuxNode <> nil then
  begin
    with NFSe.Servico.Valores do
    begin
      ValorServicos   := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('ValorServicos'), tcDe2);
      ValorDeducoes   := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('ValorDeducoes'), tcDe2);
      ValorPis        := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('ValorPis'), tcDe2);
      ValorCofins     := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('ValorCofins'), tcDe2);
      ValorInss       := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('ValorInss'), tcDe2);
      ValorIr         := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('ValorIr'), tcDe2);
      ValorCsll       := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('ValorCsll'), tcDe2);
      ValorIss        := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('ValorIss'), tcDe2);
      OutrasRetencoes := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('OutrasRetencoes'), tcDe2);

      if NFSe.ValoresNfse.BaseCalculo = 0 then
      begin
        BaseCalculo := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('BaseCalculo'), tcDe2);
        NFSe.ValoresNfse.BaseCalculo := BaseCalculo;
      end;

      Aliquota := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Aliquota'), tcDe4);

      if NFSe.ValoresNfse.ValorLiquidoNfse = 0 then
      begin
        ValorLiquidoNfse := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('ValorLiquidoNfse'), tcDe2);
        NFSe.ValoresNfse.ValorLiquidoNfse := ValorLiquidoNfse;
      end;

      DescontoCondicionado   := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('DescontoCondicionado'), tcDe2);
      DescontoIncondicionado := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('DescontoIncondicionado'), tcDe2);

      if ValorLiquidoNfse = 0 then
        ValorLiquidoNfse := ValorServicos - ValorPis - ValorCofins - ValorInss -
          ValorIr - ValorCsll - OutrasRetencoes - ValorIssRetido -
          DescontoIncondicionado - DescontoCondicionado;
    end;
  end;
end;

procedure TNFSeR_ABRASFv2.LerValoresNfse(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('ValoresNfse');

  if AuxNode <> nil then
  begin
    with NFSe.ValoresNfse do
    begin
      BaseCalculo      := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('BaseCalculo'), tcDe2);
      Aliquota         := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Aliquota'), tcDe4);
      ValorIss         := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('ValorIss'), tcDe2);
      ValorLiquidoNfse := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('ValorLiquidoNfse'), tcDe2);
    end;

    with NFSe.Servico.Valores do
    begin
      BaseCalculo := NFSe.ValoresNfse.BaseCalculo;
      ValorLiquidoNfse := NFSe.ValoresNfse.ValorLiquidoNfse;
    end;
  end;
end;

function TNFSeR_ABRASFv2.LerXml: Boolean;
var
  XmlNode: TACBrXmlNode;
  xRetorno: string;
begin
  xRetorno := Arquivo;

  // Se o XML n�o tiver a codifica��o incluir ela.
  if ObtemDeclaracaoXML(xRetorno) = '' then
    xRetorno := CUTF8DeclaracaoXML + xRetorno;

  // Alguns provedores n�o retornam o XML em UTF-8
  xRetorno := ConverteXMLtoUTF8(xRetorno);

  xRetorno := TratarXmlRetorno(xRetorno);
  xRetorno := TiraAcentos(xRetorno);

  if EstaVazio(xRetorno) then
    raise Exception.Create('Arquivo xml n�o carregado.');

  tpXML := TipodeXMLLeitura(xRetorno);

  if FDocument = nil then
    FDocument := TACBrXmlDocument.Create();

  Document.Clear();
  Document.LoadFromXml(xRetorno);

  XmlNode := Document.Root;

  if XmlNode = nil then
    raise Exception.Create('Arquivo xml vazio.');

  NFSe.Clear;

  if tpXML = txmlNFSe then
    Result := LerXmlNfse(XmlNode)
  else
    Result := LerXmlRps(XmlNode);

  FreeAndNil(FDocument);
end;

function TNFSeR_ABRASFv2.LerXmlNfse(const ANode: TACBrXmlNode): Boolean;
var
  AuxNode: TACBrXmlNode;
begin
  Result := True;

  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('Nfse');

  LerInfNfse(AuxNode);

  LerNfseCancelamento(ANode);
  LerNfseSubstituicao(ANode);
end;

function TNFSeR_ABRASFv2.LerXmlRps(const ANode: TACBrXmlNode): Boolean;
begin
  Result := True;

  if not Assigned(ANode) or (ANode = nil) then Exit;

  LerInfDeclaracaoPrestacaoServico(ANode);
end;

end.
