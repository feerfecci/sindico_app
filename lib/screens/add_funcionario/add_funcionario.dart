import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sindico_app/main.dart';
import 'package:sindico_app/widgets/header.dart';
import 'package:sindico_app/widgets/my_box_shadow.dart';
import 'package:sindico_app/widgets/my_text_form_field.dart';
import 'package:sindico_app/widgets/scaffold_all.dart';
import 'package:validatorless/validatorless.dart';

import '../../consts.dart';
import 'package:crypto/crypto.dart';

class AddFuncionario extends StatefulWidget {
  const AddFuncionario({super.key});

  @override
  State<AddFuncionario> createState() => _AddFuncionarioState();
}

class _AddFuncionarioState extends State<AddFuncionario> {
  static final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Widget buildTilePermicao(String title, {bool isChecked = false}) {
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
                      });
                    },
                  ),
                ],
              ));
        }),
      );
    }

    Widget buildEditarFunc() {
      return Form(
        key: formKey,
        child: MyBoxShadow(
          child: Column(
            children: [
              buildMyTextFormProibido(
                context,
                'Nome Completo',
              ),
              buildMyTextFormProibido(
                context,
                'Usário de login',
              ),
              buildMyTextFormProibido(
                context,
                'Senha Login',
              ),
              buildMyTextFormProibido(context, 'Função/Cargo',
                  hintText: 'Porteiro, Zelador, Administradora, Síndico'),
              buildTilePermicao('Avisos de Correspondências'),
              buildTilePermicao('Avisos de Visitas'),
              buildTilePermicao('Avisos de Delivery'),
              buildTilePermicao('Avisos de Encomendas'),
              Consts.buildCustomButton(
                context,
                'Salvar',
                onPressed: () {
                  var formValid = formKey.currentState?.validate() ?? false;
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
      );
    }

    return buildScaffoldAll(
      body: buildHeaderPage(
        context,
        titulo: 'Funcionários',
        subTitulo: 'Adicione e edite colaboradores',
        widget: ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: [
            buildEditarFunc(),
            MyBoxShadow(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Consts.buildTextSubTitle('Nome'),
                          Consts.buildTextTitle('Fernando Amorim'),
                          SizedBox(
                            height: 10,
                          ),
                          Consts.buildTextSubTitle('Usuário'),
                          Consts.buildTextTitle('feeh_fecci'),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Consts.buildTextSubTitle('Cargo'),
                          Consts.buildTextTitle('Zelador'),
                        ],
                      ),
                      SizedBox(
                        width: 30,
                      )
                    ],
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        title: Text('Permições'),
                        children: [
                          buildTilePermicao('Avisos de Correspondências'),
                          buildTilePermicao('Avisos de Visitas',
                              isChecked: true),
                          buildTilePermicao('Avisos de Delivery'),
                          buildTilePermicao('Avisos de Encomendas',
                              isChecked: true),
                        ],
                      ),
                    ),
                  ),
                  Consts.buildCustomButton(
                    context,
                    'Editar',
                    onPressed: () {},
                  )
                ],
              ),
            ),
            MyBoxShadow(
              child: Column(
                children: [
                  Consts.buildTextTitle('Cesar Reballo'),
                  Consts.buildTextTitle('sezi_nha'),
                  Consts.buildTextTitle('********'),
                  Consts.buildTextTitle(
                    'Zelador',
                  ),
                  buildTilePermicao('Avisos de Correspondências',
                      isChecked: true),
                  buildTilePermicao('Avisos de Visitas'),
                  buildTilePermicao('Avisos de Delivery', isChecked: true),
                  buildTilePermicao('Avisos de Encomendas'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
