class FormInfosResp {
  final String responsavel;
  final int ativo;
  final String nome_condominio;
  final String login;
  final String nascimento;
  final String? telefone;
  final String? ddd;
  final String? email;
  final String? documento;
  final String senha;
  final String logradouro;
  final String cep;
  final String numero;
  final String bairro;
  final String estado;
  final String cidade;

  FormInfosResp({
    this.responsavel = '',
    this.nome_condominio = '',
    this.login = '',
    this.telefone,
    this.ddd,
    this.email,
    this.nascimento = '',
    this.documento,
    this.ativo = 0,
    this.senha = '',
    this.logradouro = '',
    this.cep = '',
    this.numero = '',
    this.bairro = '',
    this.estado = '',
    this.cidade = '',
  });

  FormInfosResp copyWith({
    int? ativo,
    String? responsavel,
    String? nome_condominio,
    String? login,
    String? senha,
    String? documento,
    String? nascimento,
    String? telefone,
    String? ddd,
    String? email,
    String? logradouro,
    String? cep,
    String? numero,
    String? bairro,
    String? estado,
    String? cidade,
  }) {
    return FormInfosResp(
      ativo: ativo ?? this.ativo,
      responsavel: responsavel ?? this.responsavel,
      nome_condominio: nome_condominio ?? this.nome_condominio,
      login: login ?? this.login,
      senha: senha ?? this.senha,
      documento: documento ?? this.documento,
      nascimento: nascimento ?? this.nascimento,
      telefone: telefone ?? this.telefone,
      ddd: ddd ?? this.ddd,
      email: email ?? this.email,
      logradouro: logradouro ?? this.logradouro,
      cep: cep ?? this.cep,
      numero: numero ?? this.numero,
      bairro: bairro ?? this.bairro,
      estado: estado ?? this.estado,
      cidade: cidade ?? this.cidade,
    );
  }
}
