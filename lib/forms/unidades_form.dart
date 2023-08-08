class FormInfosUnidade {
  final String responsavel;
  final String login;
  final String senha;
  final String numero;
  final String email;
  final String nascimento;
  final String documento;
  final String ddd;
  final String telefone;
  final Object? iddivisao;
  final Object? id_divisao_unidade;
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
    this.id_divisao_unidade,
    this.ativo = 0,
    this.email = '',
    this.nascimento = '',
    this.documento = '',
    this.ddd = '',
    this.telefone = '',
  });

  FormInfosUnidade copyWith({
    String? responsavel,
    String? login,
    String? senha,
    String? numero,
    iddivisao,
    id_divisao_unidade,
    int? ativo,
    String? email,
    String? nascimento,
    String? documento,
    String? ddd,
    String? telefone,
  }) {
    return FormInfosUnidade(
        responsavel: responsavel ?? this.responsavel,
        login: login ?? this.login,
        senha: senha ?? this.senha,
        numero: numero ?? this.numero,
        iddivisao: iddivisao ?? this.iddivisao,
        id_divisao_unidade: id_divisao_unidade ?? this.id_divisao_unidade,
        ativo: ativo ?? this.ativo,
        email: email ?? this.email,
        nascimento: nascimento ?? this.nascimento,
        documento: documento ?? this.documento,
        ddd: ddd ?? this.ddd,
        telefone: telefone ?? this.telefone);
  }
}
