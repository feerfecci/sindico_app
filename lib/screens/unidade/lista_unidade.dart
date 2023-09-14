// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sindico_app/forms/unidades_form.dart';
import 'package:sindico_app/screens/unidade/cadastro_unidade.dart';
import 'package:sindico_app/screens/unidade/card_unidade.dart';
import 'package:sindico_app/screens/unidade/loading_unidade.dart';
import 'package:sindico_app/screens/unidade/search_unidades.dart';
import 'package:sindico_app/widgets/page_vazia.dart';
import 'package:sindico_app/widgets/scaffold_all.dart';
import 'package:http/http.dart' as http;
import '../../consts/consts.dart';
import '../../consts/const_widget.dart';
import '../../consts/consts_future.dart';
import '../../widgets/page_erro.dart';

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
        '${Consts.sindicoApi}unidades/?fn=listarUnidades&idcond=${ResponsalvelInfos.idcondominio}&idfuncionario=${ResponsalvelInfos.idfuncionario}');
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
              GestureDetector(
                onTap: () =>
                    showSearch(context: context, delegate: SearchUnidade()),
                child: ConstsWidget.buildPadding001(
                  context,
                  horizontal: 0.01,
                  child: Container(
                    height: size.height * 0.085,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        border: Border.all(
                            color: Colors.blue, width: size.width * 0.007),
                        borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(flex: 3),
                        ConstsWidget.buildTextTitle(
                            context, 'Localizar Unidade ',
                            textAlign: TextAlign.center),
                        Spacer(),
                        Container(
                          height: size.height * 0.3,
                          width: size.width * 0.1,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                          child: Icon(
                            Icons.search,
                            color: Colors.white,
                            fill: 1,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
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
                          return buildCardUnidade(context,
                              idunidade: idunidade,
                              iddivisao: iddivisao,
                              localizado:
                                  "$dividido_por $nome_divisao - $numero");
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
