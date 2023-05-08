import 'package:flutter/material.dart';
import 'package:sindico_app/widgets/header.dart';
import 'package:sindico_app/widgets/scaffold_all.dart';

import '../../consts.dart';
import '../../widgets/my_box_shadow.dart';
import '../../widgets/my_text_form_field.dart';

class AddMorador extends StatefulWidget {
  const AddMorador({super.key});

  @override
  State<AddMorador> createState() => _AddMoradorState();
}

class _AddMoradorState extends State<AddMorador> {
  final formKey = GlobalKey<FormState>();
  bool isChecked = false;

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
              buildMyTextFormField(context,
                  title: 'Data de Nascimento',
                  keyboardType: TextInputType.number,
                  mask: '##/##/####',
                  hintText: '##/##/####'),
              buildMyTextFormField(context,
                  title: 'Documento',
                  keyboardType: TextInputType.number,
                  hintText: 'RG, CPF'),
              buildMyTextFormField(context,
                  title: 'Telefone',
                  keyboardType: TextInputType.number,
                  mask: '(##) ##### - ####',
                  hintText: '(##) #####-####'),
              ListTile(
                title: Consts.buildTextTitle('Permitir acesso ao sistema'),
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
            titulo: 'Moradores',
            subTitulo: 'Adicione ou edite moradores',
            widget: Column(
              children: [buildEditarFunc()],
            )));
  }
}
