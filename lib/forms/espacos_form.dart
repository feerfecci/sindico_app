class FormInfosEspacos {
  final int ativo;
  final int idespaco;
  final String nome_espaco;
  final String descricao;

  FormInfosEspacos(
      {this.ativo = 0,
      this.idespaco = 0,
      this.nome_espaco = '',
      this.descricao = ''});

  FormInfosEspacos copyWith({
    int? ativo,
    int? idespaco,
    String? nome_espaco,
    String? descricao,
  }) {
    return FormInfosEspacos(
        ativo: ativo ?? this.ativo,
        idespaco: idespaco ?? this.idespaco,
        nome_espaco: nome_espaco ?? this.nome_espaco,
        descricao: descricao ?? this.descricao);
  }
}
