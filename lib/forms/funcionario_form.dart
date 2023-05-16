class FormInfosFunc {
  final String responsavel;
  final String nome_funcionario;
  final String nome_condominio;
  final Object? idfuncao;
  final String funcao;
  final String login;
  final String senha;
  final int avisa_corresp;
  final int avisa_visita;
  final int avisa_delivery;
  final int avisa_encomendas;

  FormInfosFunc({
    this.responsavel = '',
    this.nome_funcionario = '',
    this.nome_condominio = '',
    this.idfuncao,
    this.funcao = '',
    this.login = '',
    this.senha = '',
    this.avisa_corresp = 0,
    this.avisa_visita = 0,
    this.avisa_delivery = 0,
    this.avisa_encomendas = 0,
  });

  FormInfosFunc copyWith({
    String? responsavel,
    String? nome_funcionario,
    String? nome_condominio,
    Object? idfuncao,
    String? funcao,
    String? login,
    String? senha,
    int? avisa_corresp,
    int? avisa_visita,
    int? avisa_delivery,
    int? avisa_encomendas,
  }) {
    return FormInfosFunc(
      responsavel: responsavel ?? this.responsavel,
      nome_funcionario: nome_funcionario ?? this.nome_funcionario,
      nome_condominio: nome_condominio ?? this.nome_condominio,
      idfuncao: idfuncao ?? this.idfuncao,
      funcao: funcao ?? this.funcao,
      login: login ?? this.login,
      senha: senha ?? this.senha,
      avisa_corresp: avisa_corresp ?? this.avisa_corresp,
      avisa_visita: avisa_visita ?? this.avisa_visita,
      avisa_delivery: avisa_delivery ?? this.avisa_delivery,
      avisa_encomendas: avisa_encomendas ?? this.avisa_encomendas,
    );
  }
}
