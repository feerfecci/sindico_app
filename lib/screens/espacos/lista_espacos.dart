// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:sindico_app/consts/const_widget.dart';
import 'package:sindico_app/consts/consts.dart';
import 'package:sindico_app/consts/consts_future.dart';
import 'package:sindico_app/screens/espacos/cadastro_espaco.dart';
import 'package:sindico_app/widgets/my_box_shadow.dart';
import 'package:sindico_app/widgets/page_vazia.dart';
import 'package:sindico_app/widgets/scaffold_all.dart';

import '../../widgets/page_erro.dart';
import 'loading_espacos.dart';

class ListaEspacos extends StatefulWidget {
  const ListaEspacos({super.key});

  @override
  State<ListaEspacos> createState() => _ListaEspacosState();
}

class _ListaEspacosState extends State<ListaEspacos> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ConstsWidget.buildRefreshIndicator(
      context,
      onRefresh: () async {
        setState(
          () {
            ConstsFuture.resquestApi(
                '${Consts.sindicoApi}espacos/index.php?fn=listarEspacos&idcond=${ResponsalvelInfos.idcondominio}&idfuncionario=${ResponsalvelInfos.idfuncionario}');
          },
        );
      },
      child: buildScaffoldAll(
        context,
        title: 'Espaços',
        body: StatefulBuilder(builder: (context, setState) {
          return Column(
            children: [
              ConstsWidget.buildPadding001(
                context,
                child: ConstsWidget.buildCustomButton(
                  context,
                  'Adicionar Espaço',
                  color: Consts.kColorRed,
                  onPressed: () {
                    ConstsFuture.navigatorPagePush(context, CadastroEspacos());
                  },
                ),
              ),
              FutureBuilder(
                future: ConstsFuture.resquestApi(
                    '${Consts.sindicoApi}espacos/index.php?fn=listarEspacos&idcond=${ResponsalvelInfos.idcondominio}&idfuncionario=${ResponsalvelInfos.idfuncionario}'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoadingEspacos();
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (!snapshot.data['erro']) {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: snapshot.data['espacos'].length,
                          itemBuilder: (context, index) {
                            var apiEspacos = snapshot.data['espacos'][index];
                            var ativo = apiEspacos['ativo'];
                            var idespaco = apiEspacos['idespaco'];
                            var nome_espaco = apiEspacos['nome_espaco'];
                            var idcondominio = apiEspacos['idcondominio'];
                            var descricao = apiEspacos['descricao'];
                            return ConstsWidget.buildPadding001(
                              context,
                              vertical: 0.005,
                              child: MyBoxShadow(
                                  child: ConstsWidget.buildPadding001(
                                context,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Stack(
                                      // mainAxisAlignment:
                                      //     MainAxisAlignment.spaceBetween,
                                      alignment: Alignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            ConstsWidget.buildAtivoInativo(
                                              context,
                                              ativo,
                                            ),
                                          ],
                                        ),
                                        ConstsWidget.buildTextTitle(
                                            context, nome_espaco,
                                            textAlign: TextAlign.center,
                                            width: ativo ? 0.58 : 0.5,
                                            maxLines: 6,
                                            fontSize: 18),
                                      ],
                                    ),
                                    ConstsWidget.buildPadding001(
                                      context,
                                      vertical: 0.015,
                                      child: ConstsWidget.buildTextSubTitle(
                                          context, descricao,
                                          textAlign: TextAlign.center),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: size.height * 0.01),
                                      child: ConstsWidget.buildCustomButton(
                                        context,
                                        'Editar Espaço',
                                        onPressed: () {
                                          ConstsFuture.navigatorPagePush(
                                              context,
                                              CadastroEspacos(
                                                ativo: ativo,
                                                idespaco: idespaco,
                                                nome_espaco: nome_espaco,
                                                descricao: descricao,
                                              ));
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              )),
                            );
                          });
                    } else {
                      return PageVazia(title: snapshot.data['mensagem']);
                    }
                  } else {
                    return PageErro();
                  }
                },
              ),
            ],
          );
        }),
      ),
    );
  }
}
