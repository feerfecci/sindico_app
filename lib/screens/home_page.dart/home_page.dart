import 'package:flutter/material.dart';
import 'package:sindico_app/screens/home_page.dart/card_home.dart';
import 'package:sindico_app/widgets/my_box_shadow.dart';
import 'package:sindico_app/widgets/scaffold_all.dart';

import '../add_funcionario/add_funcionario.dart';
import '../../widgets/header.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return buildHeaderPage(
      context,
      titulo: 'Fernando',
      subTitulo: 'Síndico',
      widget: Column(
        children: [
          GridView.count(
            physics: ClampingScrollPhysics(),
            crossAxisCount: 2,
            shrinkWrap: true,
            childAspectRatio: 1.6,
            crossAxisSpacing: 1,
            mainAxisSpacing: 0.5,
            children: [
              buildCardHome(
                context,
                title: 'Funcionários',
                iconApi: 'perfil.png',
                pageRoute: AddFuncionario(),
              ),
            ],
          )
        ],
      ),
    );
  }
}
