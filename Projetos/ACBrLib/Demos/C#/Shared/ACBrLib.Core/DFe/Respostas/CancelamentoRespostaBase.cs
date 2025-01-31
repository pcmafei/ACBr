﻿namespace ACBrLib.Core.DFe
{
    public abstract class CancelamentoRespostaBase<TClass> : DFeRespostaBase where TClass : CancelamentoRespostaBase<TClass>, new()
    {
        #region Properties

        public string nProt { get; set; }

        public TipoEvento tpEvento { get; set; }

        public string xEvento { get; set; }

        public int nSeqEvento { get; set; }

        public string CNPJDest { get; set; }

        public string emailDest { get; set; }

        public string XML { get; set; }

        public string Arquivo { get; set; }

        #endregion Properties

        #region Methods

        public static TClass LerResposta(string resposta)
        {
            var iniresposta = ACBrIniFile.Parse(resposta);
            var ret = iniresposta.ReadFromIni<TClass>("Cancelamento");
            ret.Resposta = resposta;
            return ret;
        }

        #endregion Methods
    }
}