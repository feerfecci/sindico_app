import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:sindico_app/widgets/my_box_shadow.dart';
import 'package:sindico_app/widgets/scaffold_all.dart';

import '../../consts/const_widget.dart';
import '../../consts/consts.dart';
import '../../widgets/my_text_form_field.dart';

class InformacoesCond extends StatefulWidget {
  const InformacoesCond({super.key});

  @override
  State<InformacoesCond> createState() => _InformacoesCondState();
}

class _InformacoesCondState extends State<InformacoesCond> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return buildScaffoldAll(context,
        body: MyBoxShadow(
          child: Column(
            children: [
              ConstsWidget.buildPadding001(
                context,
                child: ConstsWidget.buildTextTitle(
                    context, 'Dados ${ResponsalvelInfos.nome_condominio}',
                    size: 20),
              ),
              buildMyTextFormObrigatorio(context, 'Logradouro',
                  initialValue: ResponsalvelInfos.endereco,
                  hintText: 'Rua dos Alfineiros'),
              Row(
                children: [
                  SizedBox(
                    width: size.width * 0.45,
                    child: buildMyTextFormObrigatorio(context, 'Cep',
                        hintText: 'Ex: 01230-000',
                        initialValue: ResponsalvelInfos.cep,
                        mask: '#####-###',
                        keyboardType: TextInputType.number),
                  ),
                  Spacer(),
                  SizedBox(
                    width: size.width * 0.3,
                    child: buildMyTextFormObrigatorio(context, 'Número',
                        initialValue: ResponsalvelInfos.numero,
                        hintText: 'Ex: 04',
                        keyboardType: TextInputType.number),
                  ),
                  Spacer(),
                ],
              ),
              buildMyTextFormObrigatorio(context, 'Bairro',
                  initialValue: ResponsalvelInfos.bairro,
                  hintText: 'Ex: Bairro do Limão'),
              Row(
                children: [
                  SizedBox(
                    width: size.width * 0.3,
                    child: buildMyTextFormObrigatorio(
                      context,
                      'Estado',
                      initialValue: ResponsalvelInfos.estado,
                      hintText: 'Ex: SP, RJ',
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                      width: size.width * 0.5,
                      child: buildMyTextFormObrigatorio(
                        context,
                        'Cidade',
                        initialValue: ResponsalvelInfos.cidade,
                        hintText: 'Ex: São Paulo',
                      )),
                  Spacer(),
                ],
              ),
            ],
          ),
        ),
        title: 'title');
  }
}
