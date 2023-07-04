import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sindico_app/widgets/header.dart';
import 'package:sindico_app/widgets/scaffold_all.dart';
import 'package:sindico_app/widgets/snackbar/snack.dart';
import 'package:http/http.dart' as http;

import '../../consts/consts.dart';
import '../../consts/const_widget.dart';
import '../../consts/consts_future.dart';
import '../../forms/funcionario_form.dart';
import '../../widgets/my_box_shadow.dart';
import '../../widgets/my_text_form_field.dart';

class CadastroColaborador extends StatefulWidget {
  final int? idfuncionario;
  final Object? idfuncao;
  final String nomeFuncionario;
  final String funcao;
  final String login;
  final bool avisa_corresp;
  final bool avisa_visita;
  final bool avisa_delivery;
  final bool avisa_encomendas;

  const CadastroColaborador({
    this.idfuncao,
    this.idfuncionario,
    this.nomeFuncionario = '',
    this.funcao = '',
    this.login = '',
    this.avisa_corresp = false,
    this.avisa_visita = false,
    this.avisa_delivery = false,
    this.avisa_encomendas = false,
    super.key,
  });

  @override
  State<CadastroColaborador> createState() => _CadastroColaboradorState();
}

class _CadastroColaboradorState extends State<CadastroColaborador> {
  final _formkeyFuncionario = GlobalKey<FormState>();
  FormInfosFunc formInfosFunc = FormInfosFunc();
  @override
  void initState() {
    super.initState();
    apiListarFuncoes();
    salvarFuncaoForm();
  }

  salvarFuncaoForm() {
    formInfosFunc = formInfosFunc.copyWith(idfuncao: widget.idfuncao);
    formInfosFunc = formInfosFunc.copyWith(
        avisa_corresp: widget.avisa_corresp == true
            ? widget.avisa_corresp == true
                ? 1
                : 0
            : 0);
    formInfosFunc = formInfosFunc.copyWith(
        avisa_delivery: widget.avisa_delivery == true
            ? widget.avisa_delivery == true
                ? 1
                : 0
            : 0);
    formInfosFunc = formInfosFunc.copyWith(
        avisa_visita: widget.avisa_visita == true
            ? widget.avisa_visita == true
                ? 1
                : 0
            : 0);
    formInfosFunc = formInfosFunc.copyWith(
        avisa_encomendas: widget.avisa_encomendas == true
            ? widget.avisa_encomendas == true
                ? 1
                : 0
            : 0);
  }

  List categoryItemListFuncoes = [];
  Future apiListarFuncoes() async {
    var uri = Uri.parse(
        '${Consts.sindicoApi}funcoes/?fn=listarFuncoes&idcond=${ResponsalvelInfos.idcondominio}');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      setState(() {
        categoryItemListFuncoes = jsonResponse['funcao'];
      });
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Widget buildDropdownButtonFuncoes() {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            shape: Border.all(color: Colors.black),
            child: DropdownButton(
              elevation: 24,
              isExpanded: true,
              icon: Icon(
                Icons.arrow_downward,
                color: Theme.of(context).iconTheme.color,
              ),
              borderRadius: BorderRadius.circular(16),
              hint: Text('Selecione Uma Função'),
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w400,
                  fontSize: 18),
              items: categoryItemListFuncoes.map((e) {
                return DropdownMenuItem(
                  value: e['idfuncao'],
                  child: Text(e['funcao']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  formInfosFunc = formInfosFunc.copyWith(idfuncao: value);
                });
              },
              value: formInfosFunc.idfuncao,
            ),
          ),
        ),
      );
    }

    Widget buildTilePermissao(BuildContext context, String title,
        {required int nomeCampo, bool isChecked = false}) {
      return StatefulBuilder(builder: (context, setState) {
        return ConstsWidget.buildCheckBox(context,
            isChecked: isChecked,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            onChanged: (bool? value) {
          setState(() {
            isChecked = value!;
            int isCheckedApi = isChecked ? 1 : 0;
            switch (nomeCampo) {
              case 0:
                formInfosFunc =
                    formInfosFunc.copyWith(avisa_corresp: isCheckedApi);
                break;
              case 1:
                formInfosFunc =
                    formInfosFunc.copyWith(avisa_visita: isCheckedApi);
                break;
              case 2:
                formInfosFunc =
                    formInfosFunc.copyWith(avisa_delivery: isCheckedApi);

                break;
              case 3:
                formInfosFunc =
                    formInfosFunc.copyWith(avisa_encomendas: isCheckedApi);

                break;
              default:
            }
            // if (nomeCampo == 0) {
            //   formInfosFunc = formInfosFunc.copyWith(
            //       avisa_corresp: isCheckedApi);
            // } else if (nomeCampo == 1) {
            //   formInfosFunc = formInfosFunc.copyWith(
            //       avisa_visita: isCheckedApi);
            // } else if (nomeCampo == 2) {
            //   formInfosFunc = formInfosFunc.copyWith(
            //       avisa_delivery: isCheckedApi);
            // } else if (nomeCampo == 3) {
            //   formInfosFunc = formInfosFunc.copyWith(
            //       avisa_encomendas: isCheckedApi);
            // }
          });
        }, title: title);
      });

      ListTile(
        title: ConstsWidget.buildTextTitle(context, title),
        trailing: StatefulBuilder(builder: (context, setState) {
          return SizedBox(
              width: size.width * 0.125,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Checkbox(
                    value: isChecked,
                    activeColor: Consts.kColorApp,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value!;
                        int isCheckedApi = isChecked ? 1 : 0;
                        switch (nomeCampo) {
                          case 0:
                            formInfosFunc = formInfosFunc.copyWith(
                                avisa_corresp: isCheckedApi);
                            break;
                          case 1:
                            formInfosFunc = formInfosFunc.copyWith(
                                avisa_visita: isCheckedApi);
                            break;
                          case 2:
                            formInfosFunc = formInfosFunc.copyWith(
                                avisa_delivery: isCheckedApi);

                            break;
                          case 3:
                            formInfosFunc = formInfosFunc.copyWith(
                                avisa_encomendas: isCheckedApi);

                            break;
                          default:
                        }
                        // if (nomeCampo == 0) {
                        //   formInfosFunc = formInfosFunc.copyWith(
                        //       avisa_corresp: isCheckedApi);
                        // } else if (nomeCampo == 1) {
                        //   formInfosFunc = formInfosFunc.copyWith(
                        //       avisa_visita: isCheckedApi);
                        // } else if (nomeCampo == 2) {
                        //   formInfosFunc = formInfosFunc.copyWith(
                        //       avisa_delivery: isCheckedApi);
                        // } else if (nomeCampo == 3) {
                        //   formInfosFunc = formInfosFunc.copyWith(
                        //       avisa_encomendas: isCheckedApi);
                        // }
                      });
                    },
                  ),
                ],
              ));
        }),
      );
    }

    return buildScaffoldAll(
      context,
      title:
          widget.idfuncionario != null ? 'Editar Cadastro' : 'Novo Funcionário',
      body: Form(
        key: _formkeyFuncionario,
        child: MyBoxShadow(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.015),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildMyTextFormObrigatorio(
                  context,
                  initialValue: widget.nomeFuncionario,
                  'Nome Completo',
                  onSaved: (text) => formInfosFunc =
                      formInfosFunc.copyWith(nome_funcionario: text),
                ),
                buildMyTextFormObrigatorio(
                  context,
                  'Usário de login',
                  initialValue: widget.login,
                  onSaved: (text) =>
                      formInfosFunc = formInfosFunc.copyWith(login: text),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                  child: buildDropdownButtonFuncoes(),
                ),
                widget.idfuncionario != null
                    ? SizedBox()
                    : buildMyTextFormObrigatorio(
                        context,
                        'Senha Login',
                        onSaved: (text) =>
                            formInfosFunc = formInfosFunc.copyWith(senha: text),
                      ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                  child: Column(
                    children: [
                      buildTilePermissao(context, 'Avisos de Cartas',
                          nomeCampo: 0, isChecked: widget.avisa_corresp),
                      buildTilePermissao(context, 'Avisos de Visitas',
                          nomeCampo: 1, isChecked: widget.avisa_visita),
                      buildTilePermissao(context, 'Avisos de Delivery',
                          nomeCampo: 2, isChecked: widget.avisa_delivery),
                      buildTilePermissao(context, 'Avisos de Caixas',
                          nomeCampo: 3, isChecked: widget.avisa_encomendas),
                    ],
                  ),
                ),
                ConstsWidget.buildCustomButton(
                  context,
                  'Salvar',
                  color: Consts.kColorRed,
                  onPressed: () {
                    if (_formkeyFuncionario.currentState!.validate() &&
                        formInfosFunc.idfuncao != null) {
                      _formkeyFuncionario.currentState!.save();

                      var apiEditarIncluir = widget.idfuncionario != null
                          ? 'editarFuncionario&idfuncionario=${widget.idfuncionario}&'
                          : 'incluirFuncionario&senha=${formInfosFunc.senha}&';

                      ConstsFuture.resquestApi(
                              '${Consts.sindicoApi}funcionarios/?fn=$apiEditarIncluir&idcond=${ResponsalvelInfos.idcondominio}&nomeFuncionario=${formInfosFunc.nome_funcionario}&idfuncao=${formInfosFunc.idfuncao}&login=${formInfosFunc.login}&avisa_corresp=${formInfosFunc.avisa_corresp}&avisa_visita=${formInfosFunc.avisa_visita}&avisa_delivery=${formInfosFunc.avisa_delivery}&avisa_encomendas=${formInfosFunc.avisa_encomendas}')
                          .then((value) {
                        if (!value['erro']) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          setState(() {});

                          return buildMinhaSnackBar(context,
                              title: 'Parabéns', subTitle: value['mensagem']);
                        }
                        return buildMinhaSnackBar(context,
                            title: 'Algo deu errado!',
                            subTitle: value['mensagem']);
                      });
                    } else {
                      buildMinhaSnackBar(context,
                          subTitle: 'Selecione uma Função');
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
