// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sindico_app/forms/unidades_form.dart';
import 'package:sindico_app/screens/moradores/lista_morador.dart';
import 'package:sindico_app/screens/unidade/cadastro_unidade.dart';
import 'package:sindico_app/screens/unidade/loading_unidade.dart';
import 'package:sindico_app/screens/unidade/teste.dart';
import 'package:sindico_app/widgets/header.dart';
import 'package:sindico_app/widgets/page_vazia.dart';
import 'package:sindico_app/widgets/scaffold_all.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../consts/consts.dart';
import '../../consts/const_widget.dart';
import '../../consts/consts_future.dart';
import '../../widgets/my_box_shadow.dart';
import '../../widgets/page_erro.dart';
import '../../widgets/shimmer_widget.dart';

class ListaUnidades extends StatefulWidget {
  const ListaUnidades({super.key});

  @override
  State<ListaUnidades> createState() => _ListaUnidadeStates();
}

class _ListaUnidadeStates extends State<ListaUnidades> {
  bool isChecked = false;
  FormInfosUnidade formInfosUnidade = FormInfosUnidade();

  listarUnidades() async {
    var url = Uri.parse(
        '${Consts.sindicoApi}unidades/?fn=listarUnidades&idcond=${ResponsalvelInfos.idcondominio}');
    var resposta = await http.get(url);

    if (resposta.statusCode == 200) {
      return json.decode(resposta.body);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    buildRowUnidade(
        {required String title1,
        required String subTitle1,
        required String title2,
        required String subTitle2}) {
      return ConstsWidget.buildPadding001(
        context,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstsWidget.buildTextSubTitle(title1),
                Row(
                  children: [
                    ConstsWidget.buildTextTitle(context, subTitle1),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstsWidget.buildTextSubTitle(title2),
                ConstsWidget.buildTextTitle(context, subTitle2),
              ],
            )
          ],
        ),
      );
    }

    return ConstsWidget.buildRefreshIndicator(
      context,
      onRefresh: () async {
        setState(() {
          listarUnidades();
        });
      },
      child: buildScaffoldAll(context,
          title: ResponsalvelInfos.nome_condominio,
          body: Column(
            children: [
              ConstsWidget.buildPadding001(
                context,
                child: ConstsWidget.buildCustomButton(
                    context, 'Adicionar Unidade',
                    color: Consts.kColorRed,
                    onPressed: () => ConstsFuture.navigatorPagePush(
                        context, CadastroUnidades()),
                    icon: Icons.add),
              ),
              FutureBuilder<dynamic>(
                future: listarUnidades(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoadingUnidades();
                  } else if (!snapshot.hasError) {
                    if (!snapshot.data['erro']) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: snapshot.data['unidades'].length,
                        itemBuilder: (context, index) {
                          var itensUnidade = snapshot.data['unidades'][index];
                          var idunidade = itensUnidade['idunidade'];
                          var iddivisao = itensUnidade['iddivisao'];
                          var nome_condominio = itensUnidade['nome_condominio'];
                          var nome_divisao = itensUnidade['nome_divisao'];
                          var dividido_por = itensUnidade['dividido_por'];
                          var numero = itensUnidade['numero'];

                          bool ativoUnidade = itensUnidade['ativo'];
                          return ConstsWidget.buildPadding001(
                            context,
                            vertical: 0.005,
                            child: MyBoxShadow(
                              child: ConstsWidget.buildPadding001(
                                context,
                                vertical: 0.005,
                                horizontal: 0.02,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ConstsWidget.buildTextTitle(context,
                                        "$dividido_por $nome_divisao - $numero"),
                                    SizedBox(
                                      height: size.height * 0.01,
                                    ),
                                    ConstsWidget.buildCustomButton(
                                      context,
                                      'Listar Moradores',
                                      onPressed: () {
                                        ConstsFuture.navigatorPagePush(
                                            context,
                                            ListaMorador(
                                              idunidade: idunidade,
                                              idvisisao: iddivisao,
                                              localizado:
                                                  "$dividido_por $nome_divisao - $numero",
                                            ));
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return PageVazia(title: snapshot.data['mensagem']);
                    }
                  } else {
                    return PageErro();
                  }
                },
              ),
            ],
          )),
    );
  }
}
