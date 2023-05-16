class FormInfosUnidade {
  final String responsavel;
  final String login;
  final String senha;
  final String numero;
  var iddivisao;
  final int ativo;
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
    this.ativo = 0,
  });

  FormInfosUnidade copyWith({
    String? responsavel,
    String? login,
    String? senha,
    String? numero,
    iddivisao,
    int? ativo,
  }) {
    return FormInfosUnidade(
      responsavel: responsavel ?? this.responsavel,
      login: login ?? this.login,
      senha: senha ?? this.senha,
      numero: numero ?? this.numero,
      iddivisao: iddivisao ?? this.iddivisao,
      ativo: ativo ?? this.ativo,
    );
  }
}
