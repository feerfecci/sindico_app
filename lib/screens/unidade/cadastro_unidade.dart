import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sindico_app/forms/funcionario_form.dart';
import 'package:sindico_app/forms/unidades_form.dart';
import 'package:sindico_app/widgets/header.dart';
import 'package:sindico_app/widgets/scaffold_all.dart';
import '../../consts/consts.dart';
import '../../consts/const_widget.dart';
import '../../widgets/my_box_shadow.dart';
import '../../widgets/my_text_form_field.dart';
import '../funcionarios/cadastro_func.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class CadastroUnidades extends StatefulWidget {
  final int? idunidade;
  final String? numero;
  final String? nome_responsavel;
  final String? login;
  final int? iddivisao;

  const CadastroUnidades(
      {this.idunidade,
      super.key,
      this.numero,
      this.nome_responsavel,
      this.login,
      this.iddivisao});

  @override
  State<CadastroUnidades> createState() => _CadastroUnidadesState();
}

class _CadastroUnidadesState extends State<CadastroUnidades> {
  final _formKey = GlobalKey<FormState>();
  FormInfosUnidade formInfosUnidade = FormInfosUnidade();

  List categoryItemList = [];
  Object? dropdownValue;
  var iddivisao;
  @override
  void initState() {
    super.initState();
    apiListarDivisoes();
  }

  Future apiListarDivisoes() async {
    var uri =
        'https://a.portariaapp.com/sindico/api/divisoes/?fn=listarDivisoes&idcond=13';

    final response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      final jsonresponse = json.decode(response.body);
      var divisoes = jsonresponse['divisoes'];
      setState(() {
        categoryItemList = divisoes;
      });
    } else {
      throw response.statusCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

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
              items: categoryItemList.map((e) {
                return DropdownMenuItem(
                  value: e['iddivisao'],
                  child: Text(
                    e['nome_divisao'].toString(),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  dropdownValue =
                      widget.idunidade == null ? value : widget.iddivisao;
                  formInfosUnidade =
                      formInfosUnidade.copyWith(iddivisao: dropdownValue);
                });
              },
              value: dropdownValue,
            ),
          ),
        ),
      );
    }

    return buildScaffoldAll(
      body: buildHeaderPage(context,
          titulo: widget.idunidade == null ? 'Nova Unidade' : 'Editar Unidade',
          subTitulo: widget.idunidade == null
              ? 'Cadastre uma nova unidade'
              : 'Edite uma unidade',
          widget: Form(
            key: _formKey,
            child: MyBoxShadow(
              child: Column(
                children: [
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
                  widget.idunidade != null
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
                          _formKey.currentState?.validate() ?? false;
                      if (formValid) {
                        _formKey.currentState!.save();
                        Consts.changeApi(
                            'https://a.portariaapp.com/sindico/api/unidades/?fn=incluirUnidade&idcond=${ResponsalvelInfos.idcondominio}&ativo=0&responsavel=${formInfosUnidade.responsavel}&login=${formInfosUnidade.login}&senha=${formInfosUnidade.senha}&iddivisao=${formInfosUnidade.iddivisao}&numero=${formInfosUnidade.numero}');
                        print(
                            'https://a.portariaapp.com/sindico/api/unidades/?fn=incluirUnidade&idcond=${ResponsalvelInfos.idcondominio}&ativo=0&responsavel=${formInfosUnidade.responsavel}&login=${formInfosUnidade.login}&senha=${formInfosUnidade.senha}&iddivisao=${formInfosUnidade.iddivisao}&numero=${formInfosUnidade.numero}');
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
