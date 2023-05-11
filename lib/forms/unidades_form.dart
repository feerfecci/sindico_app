class FormInfosUnidade {
  final String responsavel;
  final String login;
  final String senha;
  final String numero;
  var iddivisao;
  // final String senha;
  // final int avisa_corresp;
  // final int avisa_visita;
  // final int avisa_delivery;
  // final int avisa_encomendas;

  FormInfosUnidade({
    this.responsavel = '',
    this.login = '',
    this.senha = '',
    this.numero = '',
    this.iddivisao,
  });

  FormInfosUnidade copyWith({
    String? responsavel,
    String? login,
    String? senha,
    String? numero,
    iddivisao,
  }) {
    return FormInfosUnidade(
        responsavel: responsavel ?? this.responsavel,
        login: login ?? this.login,
        senha: senha ?? this.senha,
        numero: numero ?? this.numero,
        iddivisao: iddivisao ?? this.iddivisao);
  }
}
