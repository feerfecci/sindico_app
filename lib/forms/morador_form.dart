class FormInfosMorador {
  final int ativo;
  final String? nome_morador;
  final String? login;
  final String? senha;
  final String? nascimento;
  final String? documento;
  final String? telefone;
  final String? ddd;
  final int? acesso;
  int? iddivisao;
  FormInfosMorador({
    this.ativo = 0,
    this.nome_morador = '',
    this.login = '',
    this.senha = '',
    this.documento = '',
    this.nascimento = '',
    this.telefone = '',
    this.ddd = '',
    this.acesso = 0,
    this.iddivisao = 0,
  });
  FormInfosMorador copyWith(
      {int? ativo,
      String? nome_morador,
      String? login,
      String? senha,
      String? documento,
      String? nascimento,
      String? telefone,
      String? ddd,
      int? acesso,
      int? iddivisao}) {
    return FormInfosMorador(
        ativo: ativo ?? this.ativo,
        nome_morador: nome_morador ?? this.nome_morador,
        login: login ?? this.login,
        senha: senha ?? this.senha,
        documento: documento ?? this.documento,
        nascimento: nascimento ?? this.nascimento,
        telefone: telefone ?? this.telefone,
        ddd: ddd ?? this.ddd,
        acesso: acesso ?? this.acesso,
        iddivisao: iddivisao ?? this.iddivisao);
  }
}
