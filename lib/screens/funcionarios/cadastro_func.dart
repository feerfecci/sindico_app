import 'package:flutter/material.dart';
import 'package:sindico_app/screens/funcionarios/lista_funcionario.dart';
import 'package:sindico_app/widgets/header.dart';
import 'package:sindico_app/widgets/scaffold_all.dart';
import 'package:sindico_app/widgets/snackbar/snack.dart';

import '../../consts.dart';
import '../../forms/funcionario_form.dart';
import '../../widgets/my_box_shadow.dart';
import '../../widgets/my_text_form_field.dart';

const List<String> list = <String>[
  'Função',
  'Porteiro',
  'Síndico',
  'Zelador',
  'Administrador'
];

class CadastroFuncionario extends StatefulWidget {
  final int? idfuncionario;
  final String nomeFuncionario;
  final String funcao;
  final String login;
  final bool avisa_corresp;
  final bool avisa_visita;
  final bool avisa_delivery;
  final bool avisa_encomendas;

  const CadastroFuncionario({
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

FormInfosFunc formInfos = FormInfosFunc();
String dropdownValue = list.first;

Widget buildDropdownButton(
  BuildContext context, {
  bool editando = false,
  String? funcao,
}) {
  return StatefulBuilder(builder: (context, setState) {
    var size = MediaQuery.of(context).size;
    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownButtonFormField<String>(
        value: editando ? funcao : dropdownValue,

        icon: Padding(
          padding: EdgeInsets.only(right: size.height * 0.03),
          child: Icon(
            Icons.arrow_downward,
            color: Theme.of(context).iconTheme.color,
          ),
        ),

        elevation: 90,
        style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w400,
            fontSize: 18),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: size.width * 0.00),
          filled: true,
          fillColor: Theme.of(context).canvasColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        // underline: Container(
        //   height: 1,
        //   color: Consts.kColorApp,
        // ),
        borderRadius: BorderRadius.circular(16),
        onChanged: (String? value) {
          setState(() {
            funcao = value!;
            if (funcao == 'Porteiro') {
              formInfos = formInfos.copyWith(funcao: 1);
            } else if (funcao == 'Síndico') {
              formInfos = formInfos.copyWith(funcao: 2);
            } else if (funcao == 'Zelador') {
              formInfos = formInfos.copyWith(funcao: 3);
            } else if (funcao == 'Administrador(a)') {
              formInfos = formInfos.copyWith(funcao: 4);
            } else {
              formInfos = formInfos.copyWith(funcao: 0);
            }
          });
        },
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  });
}

Widget buildTilePermissao(BuildContext context, String title,
    {required int nomeCampo, bool isChecked = false}) {
  var size = MediaQuery.of(context).size;
  return ListTile(
    title: Consts.buildTextTitle(title),
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
                    if (nomeCampo == 0) {
                      formInfos =
                          formInfos.copyWith(avisa_corresp: isCheckedApi);
                    } else if (nomeCampo == 1) {
                      formInfos =
                          formInfos.copyWith(avisa_visita: isCheckedApi);
                    } else if (nomeCampo == 2) {
                      formInfos =
                          formInfos.copyWith(avisa_delivery: isCheckedApi);
                    } else if (nomeCampo == 3) {
                      formInfos =
                          formInfos.copyWith(avisa_encomendas: isCheckedApi);
                    }
                  });
                },
              ),
            ],
          ));
    }),
  );
}

class _CadastroFuncionarioState extends State<CadastroFuncionario> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
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
                buildMyTextFormProibido(
                  context,
                  initialValue: widget.nomeFuncionario,
                  'Nome Completo',
                  onSaved: (text) =>
                      formInfos = formInfos.copyWith(nome_funcionario: text),
                ),
                buildMyTextFormProibido(
                  context,
                  'Usário de login',
                  initialValue: widget.login,
                  onSaved: (text) =>
                      formInfos = formInfos.copyWith(login: text),
                ),
                buildDropdownButton(context,
                    editando: widget.idfuncionario != null ? true : false,
                    funcao: widget.idfuncionario != null
                        ? widget.funcao
                        : 'Função'),
                widget.idfuncionario != null
                    ? SizedBox()
                    : buildMyTextFormProibido(
                        context,
                        'Senha Login',
                        onSaved: (text) =>
                            formInfos = formInfos.copyWith(senha: text),
                      ),
                buildTilePermissao(context, 'Avisos de Correspondências',
                    nomeCampo: 0, isChecked: widget.avisa_corresp),
                buildTilePermissao(context, 'Avisos de Visitas',
                    nomeCampo: 1, isChecked: widget.avisa_visita),
                buildTilePermissao(context, 'Avisos de Delivery',
                    nomeCampo: 2, isChecked: widget.avisa_delivery),
                buildTilePermissao(context, 'Avisos de Encomendas',
                    nomeCampo: 3, isChecked: widget.avisa_encomendas),
                Consts.buildCustomButton(
                  context,
                  'Salvar',
                  onPressed: () {
                    if (formKey.currentState!.validate() &&
                        formInfos.funcao != 0) {
                      formKey.currentState!.save();
                      var apiEditar =
                          'https://a.portariaapp.com/sindico/api/funcionarios/?fn=editarFuncionario&idfuncionario=${widget.idfuncionario}&idcond=${ResponsalvelInfos.idcondominio}&nomeFuncionario=${formInfos.nome_funcionario}&funcao=${formInfos.funcao}&login=${formInfos.login}&avisa_corresp=${formInfos.avisa_corresp}&avisa_visita=${formInfos.avisa_visita}&avisa_delivery=${formInfos.avisa_delivery}&avisa_encomendas=${formInfos.avisa_encomendas}';

                      var apiNovo =
                          'https://a.portariaapp.com/sindico/api/funcionarios/?fn=incluirFuncionario&idcond=${ResponsalvelInfos.idcondominio}&nomeFuncionario=${formInfos.nome_funcionario}&funcao=${formInfos.funcao}&login=${formInfos.login}&senha=${formInfos.senha}&avisa_corresp=${formInfos.avisa_corresp}&avisa_visita=${formInfos.avisa_visita}&avisa_delivery=${formInfos.avisa_delivery}&avisa_encomendas=${formInfos.avisa_encomendas}';
                      widget.idfuncionario != null
                          ? Consts.changeApi(apiEditar)
                          : Consts.changeApi(apiNovo);
                      Consts.navigatorPageRoute(context, ListaFuncionarios());

                      buildMinhaSnackBar(context,
                          title: 'Parabéns',
                          subTitle: 'Funcionário Adicionado!!');
                    } else {
                      buildMinhaSnackBar(context,
                          subTitle: 'Selecione uma Função');
                    }
                  },
                )
              ],
            ),
          ),
        )));
  }
}
