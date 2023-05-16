import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sindico_app/screens/funcionarios/lista_funcionario.dart';
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

class CadastroFuncionario extends StatefulWidget {
  final int? idfuncionario;
  final Object? idfuncao;
  final String nomeFuncionario;
  final String funcao;
  final String login;
  final bool avisa_corresp;
  final bool avisa_visita;
  final bool avisa_delivery;
  final bool avisa_encomendas;

  const CadastroFuncionario({
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
  State<CadastroFuncionario> createState() => _CadastroFuncionarioState();
}

class _CadastroFuncionarioState extends State<CadastroFuncionario> {
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
    /* formInfosFunc = formInfosFunc.copyWith(avisa_corresp: widget.avisa_corresp == null? false : );
    formInfosFunc = formInfosFunc.copyWith(avisa_delivery: widget.avisa_delivery);
    formInfosFunc = formInfosFunc.copyWith(avisa_visita: widget.avisa_encomendas);
    formInfosFunc = formInfosFunc.copyWith(avisa_encomendas: widget.avisa_visita);*/
  }

  List categoryItemListFuncoes = [];
  Future apiListarFuncoes() async {
    var uri = Uri.parse(
        'https://a.portariaapp.com/sindico/api/funcoes/?fn=listarFuncoes&idcond=${ResponsalvelInfos.idcondominio}');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      var funcoes = jsonResponse['funcao'];
      setState(() {
        categoryItemListFuncoes = funcoes;
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
        {required int nomeCampo, bool? isChecked}) {
      return ListTile(
        title: ConstWidget.buildTextTitle(title),
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
                        int isCheckedApi = isChecked! ? 1 : 0;
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

    return Form(
      key: _formkeyFuncionario,
      child: buildScaffoldAll(
        body: buildHeaderPage(
          context,
          titulo: widget.idfuncionario != null
              ? 'Editar Cadastro'
              : 'Novo Funcionário',
          subTitulo: widget.idfuncionario != null
              ? 'Edite o cadastro'
              : 'Adicione colaboradores',
          widget: MyBoxShadow(
            child: Column(
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
                buildDropdownButtonFuncoes(),
                widget.idfuncionario != null
                    ? SizedBox()
                    : buildMyTextFormObrigatorio(
                        context,
                        'Senha Login',
                        onSaved: (text) =>
                            formInfosFunc = formInfosFunc.copyWith(senha: text),
                      ),
                buildTilePermissao(context, 'Avisos de Correspondências',
                    nomeCampo: 0, isChecked: widget.avisa_corresp),
                buildTilePermissao(context, 'Avisos de Visitas',
                    nomeCampo: 1, isChecked: widget.avisa_visita),
                buildTilePermissao(context, 'Avisos de Delivery',
                    nomeCampo: 2, isChecked: widget.avisa_delivery),
                buildTilePermissao(context, 'Avisos de Encomendas',
                    nomeCampo: 3, isChecked: widget.avisa_encomendas),
                ConstWidget.buildCustomButton(
                  context,
                  'Salvar',
                  onPressed: () {
                    if (_formkeyFuncionario.currentState!.validate() &&
                        formInfosFunc.idfuncao != null) {
                      _formkeyFuncionario.currentState!.save();

                      var apiEditarIncluir = widget.idfuncionario != null
                          ? 'editarFuncionario&idfuncionario=${widget.idfuncionario}&'
                          : 'incluirFuncionario&senha=${formInfosFunc.senha}&';

                      ConstsFuture.changeApi(
                          'https://a.portariaapp.com/sindico/api/funcionarios/?fn=$apiEditarIncluir&idcond=${ResponsalvelInfos.idcondominio}&nomeFuncionario=${formInfosFunc.nome_funcionario}&idfuncao=${formInfosFunc.idfuncao}&login=${formInfosFunc.login}&avisa_corresp=${formInfosFunc.avisa_corresp}&avisa_visita=${formInfosFunc.avisa_visita}&avisa_delivery=${formInfosFunc.avisa_delivery}&avisa_encomendas=${formInfosFunc.avisa_encomendas}');
                      ConstsFuture.navigatorPopPush(
                          context, '/listaFuncionario');

                      buildMinhaSnackBar(context,
                          title: 'Parabéns',
                          subTitle: widget.idfuncionario != null
                              ? 'Funcionário Editado!!'
                              : 'Funcionário Adicionado!!');
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
