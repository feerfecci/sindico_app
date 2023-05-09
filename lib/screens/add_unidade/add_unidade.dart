import 'package:flutter/material.dart';
import 'package:sindico_app/widgets/header.dart';
import 'package:sindico_app/widgets/scaffold_all.dart';

import '../../consts.dart';
import '../../forms/funcionario_form.dart';
import '../../widgets/my_box_shadow.dart';
import '../../widgets/my_text_form_field.dart';

class AddUnidade extends StatefulWidget {
  const AddUnidade({super.key});

  @override
  State<AddUnidade> createState() => _AddUnidadeState();
}

class _AddUnidadeState extends State<AddUnidade> {
  final formKey = GlobalKey<FormState>();
  bool isChecked = false;
  FormInfosFunc formInfos = FormInfosFunc();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Widget buildEditarFunc() {
      return Form(
        key: formKey,
        child: MyBoxShadow(
          child: Column(
            children: [
              buildMyTextFormProibido(context, 'Condomínio'),
              buildMyTextFormProibido(context, 'Unidade'),
              buildMyTextFormProibido(
                context,
                'Nome Resposável',
                onSaved: (text) =>
                    formInfos = formInfos.copyWith(responsavel: text),
              ),
              buildMyTextFormProibido(
                context,
                'Usário de login',
              ),
              buildMyTextFormProibido(
                context,
                'Senha Login',
              ),
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
        body: buildHeaderPage(context,
            titulo: 'Unidade',
            subTitulo: 'Adicione e edite unidade',
            widget: buildEditarFunc()));
  }
}
