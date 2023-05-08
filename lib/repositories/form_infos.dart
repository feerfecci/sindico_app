class FormInfos {
  final String responsavel;

  FormInfos({this.responsavel = ''});
  FormInfos copyWith({String? responsavel}) {
    return FormInfos(responsavel: responsavel ?? this.responsavel);
  }
}
