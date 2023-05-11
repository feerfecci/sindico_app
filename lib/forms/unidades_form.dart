class FormInfosUnidade {
  final String responsavel;
  // final String nome_funcionario;
  // final String nome_condominio;
  // final int funcao;
  // final String login;
  // final String senha;
  // final int avisa_corresp;
  // final int avisa_visita;
  // final int avisa_delivery;
  // final int avisa_encomendas;

  FormInfosUnidade({
    this.responsavel = '',
    // this.nome_funcionario = '',
    // this.nome_condominio = '',
    // this.funcao = 0,
    // this.login = '',
    // this.senha = '',
    // this.avisa_corresp = 0,
    // this.avisa_visita = 0,
    // this.avisa_delivery = 0,
    // this.avisa_encomendas = 0,
  });

  FormInfosUnidade copyWith({
    String? responsavel,
    // String? nome_funcionario,
    // String? nome_condominio,
    // int? funcao,
    // String? login,
    // String? senha,
    // int? avisa_corresp,
    // int? avisa_visita,
    // int? avisa_delivery,
    // int? avisa_encomendas,
  }) {
    return FormInfosUnidade(
      responsavel: responsavel ?? this.responsavel,
      // nome_funcionario: nome_funcionario ?? this.nome_funcionario,
      // nome_condominio: nome_condominio ?? this.nome_condominio,
      // funcao: funcao ?? this.funcao,
      // login: login ?? this.login,
      // senha: senha ?? this.senha,
      // avisa_corresp: avisa_corresp ?? this.avisa_corresp,
      // avisa_visita: avisa_visita ?? this.avisa_visita,
      // avisa_delivery: avisa_delivery ?? this.avisa_delivery,
      // avisa_encomendas: avisa_encomendas ?? this.avisa_encomendas,
    );
  }
}
