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

class CadastroUnidades extends StatefulWidget {
  const CadastroUnidades({super.key});

  @override
  State<CadastroUnidades> createState() => _CadastroUnidadesState();
}

class _CadastroUnidadesState extends State<CadastroUnidades> {
  final _formKey = GlobalKey<FormState>();
  FormInfosUnidade formInfosUnidade = FormInfosUnidade();

  List categoryItemList = [];
  Object? dropdownValue;
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
            shape: Border.all(color: Colors.black26),
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
                  dropdownValue = value;
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
          titulo: 'Nova Unidade',
          subTitulo: 'Cadastre uma nova unidade',
          widget: Form(
            key: _formKey,
            child: MyBoxShadow(
              child: Column(
                children: [
                  buildMyTextFormObrigatorio(
                    context,
                    'Nome Resposável',
                    onSaved: (text) => formInfosUnidade =
                        formInfosUnidade.copyWith(responsavel: text),
                  ),
                  buildMyTextFormObrigatorio(
                    context,
                    'Usário de login',
                  ),
                  buildMyTextFormObrigatorio(
                    context,
                    'Senha Login',
                  ),
                  buildMyTextFormObrigatorio(context, 'Condomínio'),
                  buildDropButton(),
                  buildMyTextFormObrigatorio(
                    context,
                    'Número',
                  ),
                  ConstWidget.buildCustomButton(
                    context,
                    'Salvar',
                    onPressed: () {
                      var formValid =
                          _formKey.currentState?.validate() ?? false;
                      if (formValid) {
                        print(formValid.toString());
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
