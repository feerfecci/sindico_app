class FormInfosMorador {
  final int ativo;
  final String? nome_morador;
  final String? login;
  final String? senhaLogin;
  final String? senhaRetirada;
  final String? nascimento;
  final String? documento;
  final String? telefone;
  final String? ddd;
  final String? email;
  final int? acesso;
  final int? resposavel;
  int? iddivisao;
  FormInfosMorador({
    this.ativo = 0,
    this.nome_morador = '',
    this.login = '',
    this.senhaLogin = '',
    this.senhaRetirada = '',
    this.documento = '',
    this.nascimento = '',
    this.telefone = '',
    this.ddd = '',
    this.email = '',
    this.acesso = 1,
    this.iddivisao = 0,
    this.resposavel = 0,
  });
  FormInfosMorador copyWith(
      {int? ativo,
      String? nome_morador,
      String? login,
      String? senhaLogin,
      String? senhaRetirada,
      String? documento,
      String? nascimento,
      String? telefone,
      String? ddd,
      String? email,
      int? acesso,
      int? iddivisao,
      int? resposavel}) {
    return FormInfosMorador(
        ativo: ativo ?? this.ativo,
        nome_morador: nome_morador ?? this.nome_morador,
        login: login ?? this.login,
        senhaLogin: senhaLogin ?? this.senhaLogin,
        senhaRetirada: senhaRetirada ?? this.senhaRetirada,
        documento: documento ?? this.documento,
        nascimento: nascimento ?? this.nascimento,
        telefone: telefone ?? this.telefone,
        ddd: ddd ?? this.ddd,
        email: email ?? this.email,
        acesso: acesso ?? this.acesso,
        iddivisao: iddivisao ?? this.iddivisao,
        resposavel: resposavel ?? this.resposavel);
  }
}
