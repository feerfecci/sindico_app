import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sindico_app/forms/funcionario_form.dart';
import 'package:sindico_app/forms/unidades_form.dart';
import 'package:sindico_app/widgets/header.dart';
import 'package:sindico_app/widgets/scaffold_all.dart';
import '../../consts/consts.dart';
import '../../consts/const_widget.dart';
import '../../consts/consts_future.dart';
import '../../widgets/my_box_shadow.dart';
import '../../widgets/my_text_form_field.dart';
import '../funcionarios/cadastro_func.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class CadastroUnidades extends StatefulWidget {
  final int idunidade;
  final String? numero;
  final String? nome_responsavel;
  final String? login;
  final Object? iddivisao;
  final bool? ativo;
  const CadastroUnidades({
    this.idunidade = 0,
    super.key,
    this.numero,
    this.nome_responsavel,
    this.login,
    this.iddivisao,
    this.ativo,
  });

  @override
  State<CadastroUnidades> createState() => _CadastroUnidadesState();
}

class _CadastroUnidadesState extends State<CadastroUnidades> {
  final _formkeyUnidade = GlobalKey<FormState>();
  FormInfosUnidade formInfosUnidade = FormInfosUnidade();

  @override
  void initState() {
    super.initState();
    apiListarDivisoes();
    colocarIdDivisao();
  }

  colocarIdDivisao() {
    formInfosUnidade = formInfosUnidade.copyWith(iddivisao: widget.iddivisao);
  }

  List categoryItemListDivisoes = [];
  // Object? dropdownValueDivisioes;
  Future apiListarDivisoes() async {
    var uri =
        'https://a.portariaapp.com/sindico/api/divisoes/?fn=listarDivisoes&idcond=${ResponsalvelInfos.idcondominio}';

    final response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      final jsonresponse = json.decode(response.body);
      var divisoes = jsonresponse['divisoes'];
      setState(() {
        categoryItemListDivisoes = divisoes;
      });
    } else {
      throw response.statusCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget buildDropButton() {
      return Container(
        width: double.infinity,
        alignment: Alignment.center,
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
              hint: Text('Selecione uma Divisão'),
              icon: Icon(Icons.arrow_drop_down_sharp),
              borderRadius: BorderRadius.circular(16),
              style: TextStyle(
                  // fontWeight: FontWeight.bold,
                  fontSize: Consts.fontTitulo,
                  color: Colors.black),
              items: categoryItemListDivisoes.map((e) {
                return DropdownMenuItem(
                  value: e['iddivisao'],
                  child: Text(
                    e['nome_divisao'],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  // dropdownValueDivisioes = value;
                  formInfosUnidade =
                      formInfosUnidade.copyWith(iddivisao: value);
                });
              },
              value: formInfosUnidade.iddivisao,
            ),
          ),
        ),
      );
    }

    var size = MediaQuery.of(context).size;

    List<String> listAtivo = <String>['Ativo', 'Inativo'];
    var seAtivo = widget.ativo == true ? 'Ativo' : 'Inativo';
    var dropdownValueAtivo = listAtivo.first;

    return buildScaffoldAll(
      body: buildHeaderPage(context,
          titulo: widget.idunidade == 0 ? 'Nova Unidade' : 'Editar Unidade',
          subTitulo: widget.idunidade == 0
              ? 'Cadastre uma nova unidade'
              : 'Edite uma unidade',
          widget: Form(
            key: _formkeyUnidade,
            child: MyBoxShadow(
              child: Column(
                children: [
                  ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButtonFormField<String>(
                      value:
                          widget.idunidade == 0 ? dropdownValueAtivo : seAtivo,

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
                        contentPadding:
                            EdgeInsets.only(left: size.width * 0.00),
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
                      items: listAtivo
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          dropdownValueAtivo = value!;
                          if (dropdownValueAtivo == 'Ativo') {
                            formInfosUnidade =
                                formInfosUnidade.copyWith(ativo: 1);
                          } else if (dropdownValueAtivo == 'Inativo') {
                            formInfosUnidade =
                                formInfosUnidade.copyWith(ativo: 0);
                          }
                        });
                      },
                    ),
                  ),
                  buildMyTextFormObrigatorio(
                    context,
                    'Nome Resposável',
                    initialValue: widget.nome_responsavel,
                    onSaved: (text) => formInfosUnidade =
                        formInfosUnidade.copyWith(responsavel: text),
                  ),
                  buildMyTextFormObrigatorio(
                    context,
                    'Usário de login',
                    initialValue: widget.login,
                    onSaved: (text) => formInfosUnidade =
                        formInfosUnidade.copyWith(login: text),
                  ),
                  widget.idunidade != 0
                      ? SizedBox()
                      : buildMyTextFormObrigatorio(
                          context,
                          'Senha Login',
                          onSaved: (text) => formInfosUnidade =
                              formInfosUnidade.copyWith(senha: text),
                        ),
                  buildDropButton(),
                  buildMyTextFormObrigatorio(
                    context,
                    'Número',
                    initialValue: widget.numero,
                    onSaved: (text) => formInfosUnidade =
                        formInfosUnidade.copyWith(numero: text),
                  ),
                  ConstWidget.buildCustomButton(
                    context,
                    'Salvar',
                    onPressed: () {
                      var formValid =
                          _formkeyUnidade.currentState?.validate() ?? false;
                      if (formValid) {
                        _formkeyUnidade.currentState!.save();
                        String incluindoEditando = widget.idunidade == null
                            ? "incluirUnidade&"
                            : 'editarUnidade&id=${widget.idunidade}&';
                        ConstsFuture.changeApi(
                            'https://a.portariaapp.com/sindico/api/unidades/?fn=${incluindoEditando}idcond=${ResponsalvelInfos.idcondominio}&iddivisao=${formInfosUnidade.iddivisao}&ativo=${formInfosUnidade.ativo}&responsavel=${formInfosUnidade.responsavel}&login=${formInfosUnidade.login}&senha=${formInfosUnidade.senha}&iddivisao=${formInfosUnidade.iddivisao}&numero=${formInfosUnidade.numero}');
                        Navigator.pop(context);
                      } else if (widget.idunidade == 0) {
                      } else {
                        print(formValid.toString());
                      }
                    },
                  )
                ],
              ),
            ),
          )),
    );
  }
}
