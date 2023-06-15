import 'package:flutter/material.dart';
import 'package:sindico_app/consts/const_widget.dart';
import 'package:sindico_app/consts/consts.dart';
import 'package:sindico_app/consts/consts_future.dart';
import 'package:sindico_app/screens/espacos/cadastro_espaco.dart';
import 'package:sindico_app/widgets/header.dart';
import 'package:sindico_app/widgets/my_box_shadow.dart';
import 'package:sindico_app/widgets/scaffold_all.dart';

class ListaEspacos extends StatelessWidget {
  const ListaEspacos({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return buildScaffoldAll(
      context,
      body: StatefulBuilder(builder: (context, setState) {
        return RefreshIndicator(
          onRefresh: () async {
            setState(
              () {
                ConstsFuture.resquestApi(
                    '${Consts.sindicoApi}espacos/index.php?fn=listarEspacos&idcond=16');
              },
            );
          },
          child: buildHeaderPage(context,
              titulo: 'Espaços',
              subTitulo: ResponsalvelInfos.nome_condominio,
              widget: Column(
                children: [
                  ConstsWidget.buildCustomButton(
                    context,
                    'Adicionar Espaço',
                    icon: Icons.add,
                    onPressed: () {
                      ConstsFuture.navigatorPagePush(
                          context, CadastroEspacos());
                    },
                  ),
                  FutureBuilder(
                    future: ConstsFuture.resquestApi(
                        '${Consts.sindicoApi}espacos/index.php?fn=listarEspacos&idcond=16'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        if (!snapshot.data['erro']) {
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount: snapshot.data['espacos'].length,
                              itemBuilder: (context, index) {
                                var apiEspacos =
                                    snapshot.data['espacos'][index];
                                var ativo = apiEspacos['ativo'];
                                var idespaco = apiEspacos['idespaco'];
                                var nome_espaco = apiEspacos['nome_espaco'];
                                var idcondominio = apiEspacos['idcondominio'];
                                var descricao = apiEspacos['descricao'];
                                return MyBoxShadow(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ConstsWidget.buildTextTitle(
                                            nome_espaco),
                                        ConstsWidget.buildAtivoInativo(ativo),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: size.height * 0.015),
                                      child: ConstsWidget.buildTextSubTitle(
                                          descricao),
                                    ),
                                    ConstsWidget.buildCustomButton(
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
                                    )
                                  ],
                                ));
                              });
                        } else {
                          return Text('Tente novamente mais Tarde');
                        }
                      } else {
                        return Text('Erro no Srevidor');
                      }
                    },
                  )
                ],
              )),
        );
      }),
    );
  }
}
