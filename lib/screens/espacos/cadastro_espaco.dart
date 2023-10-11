// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:sindico_app/consts/const_widget.dart';
import 'package:sindico_app/consts/consts.dart';
import 'package:sindico_app/consts/consts_future.dart';
import 'package:sindico_app/forms/espacos_form.dart';
import 'package:sindico_app/screens/espacos/lista_espacos.dart';
import 'package:sindico_app/widgets/my_box_shadow.dart';
import 'package:sindico_app/widgets/my_text_form_field.dart';
import 'package:sindico_app/widgets/scaffold_all.dart';
import 'package:sindico_app/widgets/snack.dart';

class CadastroEspacos extends StatefulWidget {
  bool ativo;
  int? idespaco;
  String? nome_espaco;
  String? descricao;
  CadastroEspacos(
      {this.descricao,
      this.nome_espaco,
      this.idespaco,
      this.ativo = true,
      super.key});

  @override
  State<CadastroEspacos> createState() => _CadastroEspacosState();
}

class _CadastroEspacosState extends State<CadastroEspacos> {
  final formKey = GlobalKey<FormState>();
  FormInfosEspacos _formInfosEspacos = FormInfosEspacos();
  Object? dropdownValueAtivo;
  @override
  void initState() {
    _formInfosEspacos = _formInfosEspacos.copyWith(ativo: widget.ativo ? 1 : 0);
    _formInfosEspacos = _formInfosEspacos.copyWith(idespaco: widget.idespaco);
    _formInfosEspacos =
        _formInfosEspacos.copyWith(nome_espaco: widget.nome_espaco);
    _formInfosEspacos = _formInfosEspacos.copyWith(descricao: widget.descricao);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // Widget buildDropAtivoInativo(
    //   BuildContext context, {
    //   int seEditando = 0,
    // }) {
    //   return ConstsWidget.buildPadding001(
    //     context,
    //     child: StatefulBuilder(builder: (context, setState) {
    //       return ConstsWidget.buildDecorationDrop(
    //         context,
    //         child: DropdownButton(
    //           value: dropdownValueAtivo = _formInfosEspacos.ativo,
    //           icon: Padding(
    //             padding: EdgeInsets.only(right: size.height * 0.03),
    //             child: Icon(
    //               Icons.arrow_downward,
    //               color: Theme.of(context).iconTheme.color,
    //             ),
    //           ),
    //           elevation: 24,
    //           style: TextStyle(
    //               color: Theme.of(context).textTheme.bodyLarge!.color,
    //               fontWeight: FontWeight.w400,
    //               fontSize: 18),
    //           borderRadius: BorderRadius.circular(16),
    //           onChanged: (value) {
    //             setState(() {
    //               dropdownValueAtivo = value!;
    //               _formInfosEspacos = _formInfosEspacos.copyWith(ativo: value);
    //             });
    //           },
    //           items: listAtivo.map<DropdownMenuItem>((value) {
    //             return DropdownMenuItem(
    //               value: value,
    //               child: value == 0 ? Text('Inativo') : Text('Ativo'),
    //             );
    //           }).toList(),
    //         ),
    //       );
    //     }),
    //   );
    // }

    return buildScaffoldAll(context,
        title: widget.idespaco == null ? 'Adicionar Espaço' : 'Editar Espaço',
        body: ListView(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          children: [
            MyBoxShadow(
              child: Form(
                key: formKey,
                child: ConstsWidget.buildPadding001(
                  context,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ConstsWidget.buildCamposObrigatorios(context),
                      ConstsWidget.buildDropAtivoInativo(
                        context,
                        dropdownValue: dropdownValueAtivo =
                            _formInfosEspacos.ativo,
                        onChanged: (value) {
                          setState(() {
                            dropdownValueAtivo = value!;
                            _formInfosEspacos =
                                _formInfosEspacos.copyWith(ativo: value);
                          });
                        },
                      ),
                      buildMyTextFormObrigatorio(
                        context,
                        'Nome Espaço',
                        hintText: 'Exemplo: Churrasqueira Bloco B',
                        textCapitalization: TextCapitalization.words,
                        initialValue: widget.nome_espaco,
                        onSaved: (text) => _formInfosEspacos =
                            _formInfosEspacos.copyWith(nome_espaco: text),
                      ),
                      buildTextFormLinhas(
                        context,
                        label: 'Observações',
                        hintText:
                            'Exemplo: Salão de festas localizado no andar térreo entre as torres A e B. Capacidade máxima 150 pessoas',
                        initialValue: widget.descricao,
                        onSaved: (newValue) => _formInfosEspacos =
                            _formInfosEspacos.copyWith(descricao: newValue),
                      ),
                      ConstsWidget.buildCustomButton(
                        context,
                        'Salvar',
                        color: Consts.kColorRed,
                        onPressed: () {
                          var keyForm =
                              formKey.currentState?.validate() ?? false;
                          FocusManager.instance.primaryFocus!.unfocus();

                          FocusManager.instance.primaryFocus!.unfocus();
                          if (keyForm) {
                            formKey.currentState?.save();
                            String editaInlui = widget.idespaco == null
                                ? 'fn=incluirEspacos'
                                : 'fn=editarEspacos&idespaco=${widget.idespaco}';

                            ConstsFuture.resquestApi(
                                    '${Consts.sindicoApi}espacos/index.php?$editaInlui&idcond=${ResponsalvelInfos.idcondominio}&idfuncionario=${ResponsalvelInfos.idfuncionario}&ativo=${_formInfosEspacos.ativo}&nome_espaco=${_formInfosEspacos.nome_espaco}&descricao=${_formInfosEspacos.descricao}')
                                .then((value) {
                              if (!value['erro']) {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                ConstsFuture.navigatorPagePush(
                                    context, ListaEspacos());

                                buildMinhaSnackBar(context,
                                    title: 'Muito Obrigado',
                                    hasError: value['erro'],
                                    subTitle: value['mensagem']);
                              } else {
                                buildMinhaSnackBar(context,
                                    title: 'algo saiu mal',
                                    hasError: value['erro'],
                                    subTitle: value['mensagem']);
                              }
                            });
                          }
                        },
                      ),
                      SizedBox(
                        height: size.height * 0.005,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
