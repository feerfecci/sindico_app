import 'package:flutter/material.dart';
import 'package:sindico_app/repositories/notification_widget.dart';
import 'package:sindico_app/screens/add_morador/add_morador.dart';
import 'package:sindico_app/screens/add_unidade/add_unidade.dart';
import 'package:sindico_app/screens/home_page.dart/card_home.dart';
import 'package:sindico_app/widgets/my_box_shadow.dart';
import 'package:sindico_app/widgets/scaffold_all.dart';

import '../../consts.dart';
import '../funcionarios/lista_funcionario.dart';
import '../../widgets/header.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // NotificationWidget.init();
  }

  @override
  Widget build(BuildContext context) {
    return buildHeaderPage(
      context,
      titulo: ResponsalvelInfos.nome_responsavel,
      subTitulo: 'Resposável por ${ResponsalvelInfos.nome_condominio}',
      widget: GridView.count(
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
            pageRoute: ListaFuncionarios(),
          ),
          buildCardHome(context,
              title: 'Moradores',
              pageRoute: AddMorador(),
              iconApi: 'perfil.png'),
          buildCardHome(context,
              title: 'Unidades',
              pageRoute: AddUnidade(),
              iconApi: 'perfil.png'),
        ],
      ),
    );
  }
}
