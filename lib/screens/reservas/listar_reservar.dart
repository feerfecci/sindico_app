import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sindico_app/consts/consts.dart';
import 'package:sindico_app/consts/consts_future.dart';
import 'package:sindico_app/widgets/header.dart';
import 'package:sindico_app/widgets/my_box_shadow.dart';
import 'package:sindico_app/widgets/scaffold_all.dart';
import 'package:sindico_app/widgets/snackbar/snack.dart';

import '../../consts/const_widget.dart';
import '../../widgets/page_vazia.dart';

class ListaReservas extends StatefulWidget {
  const ListaReservas({super.key});

  @override
  State<ListaReservas> createState() => _ListaReservasState();
}

class _ListaReservasState extends State<ListaReservas> {
  int statusReserva = 2;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Widget buildTextReserva({required titulo, required texto}) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstsWidget.buildTextSubTitle(titulo),
            ConstsWidget.buildTextTitle(texto),
          ],
        ),
      );
    }

    Widget buildFiltroReserv(String title, int ativo) {
      return SizedBox(
        width: size.width * 0.315,
        child: ConstsWidget.buildCustomButton(
          context,
          title,
          fontSize: 17,
          onPressed: () {
            setState(() {
              statusReserva = ativo;
            });
          },
        ),
      );
    }

    var apiListar = ConstsFuture.resquestApi(
        '${Consts.sindicoApi}reserva_espacos/?fn=listarReservas&idcond=${ResponsalvelInfos.idcondominio}&ativo=$statusReserva');
    return buildScaffoldAll(context,
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              apiListar;
            });
          },
          child: buildHeaderPage(context,
              titulo: 'Reservas',
              subTitulo: 'Aprove ou desaprova',
              widget: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildFiltroReserv('Pendentes', 2),
                      buildFiltroReserv('Aprovadas', 1),
                      buildFiltroReserv('Recusadas', 0),
                    ],
                  ),
                  FutureBuilder(
                    future: apiListar,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasData) {
                        if (!snapshot.data['erro'] &&
                            snapshot.data['reserva_espacos'] != null) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: snapshot.data['reserva_espacos'].length,
                            itemBuilder: (context, index) {
                              var apiReservar =
                                  snapshot.data['reserva_espacos'][index];
                              int idreserva = apiReservar['idreserva'];
                              int status = apiReservar['status'];
                              String texto_status = apiReservar['texto_status'];
                              int idespaco = apiReservar['idespaco'];
                              String nome_espaco = apiReservar['nome_espaco'];
                              int idcondominio = apiReservar['idcondominio'];
                              String nome_condominio =
                                  apiReservar['nome_condominio'];
                              int idmorador = apiReservar['idmorador'];
                              String nome_morador = apiReservar['nome_morador'];
                              int idunidade = apiReservar['idunidade'];
                              String unidade = apiReservar['unidade'];
                              String data_reserva = DateFormat('dd/MM/yyyy')
                                  .format(DateTime.parse(
                                      apiReservar['data_reserva']));
                              String datahora = apiReservar['datahora'];

                              Widget buildAtendeReserva(
                                  String title, int tipo) {
                                return ConstsWidget.buildCustomButton(
                                  context,
                                  title,
                                  color: title == 'Aceitar'
                                      ? Colors.green
                                      : Colors.red,
                                  altura: 0.015,
                                  onPressed: () {
                                    ConstsFuture.resquestApi(
                                            '${Consts.sindicoApi}reserva_espacos/?fn=atenderReserva&idcond=${ResponsalvelInfos.idcondominio}&idunidade=$idunidade&idmorador=$idmorador&idreserva=$idreserva&ativo=$tipo')
                                        .then((value) {
                                      if (!value['erro']) {
                                        setState(() {
                                          apiListar;
                                        });
                                        buildMinhaSnackBar(context,
                                            title: 'Muito Obrigado',
                                            subTitle: value['mensagem']);
                                      } else {
                                        buildMinhaSnackBar(context,
                                            title: 'Algo saiu mal',
                                            subTitle: value['mensagem']);
                                      }
                                    });
                                  },
                                );
                              }

                              return MyBoxShadow(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        buildTextReserva(
                                          titulo: 'Nome do Espaço:',
                                          texto: nome_espaco.toString(),
                                        ),
                                        Spacer(),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: status == 0
                                                  ? Colors.red
                                                  : status == 1
                                                      ? Colors.green
                                                      : Color.fromARGB(
                                                          255, 244, 177, 54),
                                              borderRadius:
                                                  BorderRadius.circular(16)),
                                          child: Padding(
                                            padding: EdgeInsets.all(
                                                size.height * 0.01),
                                            child: ConstsWidget.buildTextTitle(
                                              texto_status,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          width: size.width * 0.5,
                                          child: buildTextReserva(
                                            titulo: 'Reservado por:',
                                            texto: nome_morador.toString(),
                                          ),
                                        ),
                                        Spacer(),
                                        buildTextReserva(
                                          titulo: 'Localizado:',
                                          texto: unidade,
                                        ),
                                      ],
                                    ),
                                    buildTextReserva(
                                      titulo: 'Data:',
                                      texto: data_reserva.toString(),
                                    ),
                                    if (status == 2)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          buildAtendeReserva(
                                            'Aceitar',
                                            1,
                                          ),
                                          SizedBox(
                                            width: size.width * 0.02,
                                          ),
                                          buildAtendeReserva('Recusar', 0),
                                        ],
                                      )
                                  ],
                                ),
                              );
                            },
                          );
                        } else {
                          return PageVazia(title: snapshot.data['mensagem']);
                        }
                      } else {
                        return Text('Algo Deu errado');
                      }
                    },
                  )
                ],
              )),
        ));
  }
}
