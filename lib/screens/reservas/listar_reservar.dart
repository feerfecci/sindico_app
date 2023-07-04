import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sindico_app/consts/consts.dart';
import 'package:sindico_app/consts/consts_future.dart';
import 'package:sindico_app/widgets/header.dart';
import 'package:sindico_app/widgets/my_box_shadow.dart';
import 'package:sindico_app/widgets/scaffold_all.dart';
import 'package:sindico_app/widgets/shimmer_widget.dart';
import 'package:sindico_app/widgets/snackbar/snack.dart';

import '../../consts/const_widget.dart';
import '../../widgets/page_erro.dart';
import '../../widgets/page_vazia.dart';
import 'loading_reserva.dart';

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
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ConstsWidget.buildTextTitle(context, titulo, size: 18),
          ConstsWidget.buildTextSubTitle(texto, size: 16),
        ],
      );
    }

    Widget buildFiltroReserv(String title, int ativo, {Color? color}) {
      return SizedBox(
        width: size.width * 0.31,
        child: ConstsWidget.buildCustomButton(
          context,
          largura: 0,
          title,
          color: color,
          fontSize: 16,
          onPressed: () {
            setState(() {
              statusReserva = ativo;
            });
          },
        ),
      );
    }

    Color verde = Color.fromARGB(255, 44, 201, 104);
    Color amarelo = Color.fromARGB(255, 255, 193, 7);

    var apiListar = ConstsFuture.resquestApi(
        '${Consts.sindicoApi}reserva_espacos/?fn=listarReservas&idcond=${ResponsalvelInfos.idcondominio}&ativo=$statusReserva');
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          apiListar;
        });
      },
      child: buildScaffoldAll(context,
          title: 'Reservas',
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: size.height * 0.015),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildFiltroReserv('Recusadas', 0, color: Colors.grey),
                    buildFiltroReserv('Aprovadas', 1, color: verde),
                    buildFiltroReserv('Pendentes', 2, color: amarelo),
                  ],
                ),
              ),
              FutureBuilder(
                future: apiListar,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoadingReservas();
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
                          String data_reserva = DateFormat('dd/MM/yyyy').format(
                              DateTime.parse(apiReservar['data_reserva']));
                          String datahora = DateFormat('dd/MM/yyyy HH:mm')
                              .format(DateTime.parse(apiReservar['datahora']));

                          Widget buildAtendeReserva(String title, int tipo) {
                            return ConstsWidget.buildCustomButton(
                              context,
                              title,
                              color: title == 'Aprovar' ? verde : Colors.grey,
                              altura: 0.02,
                              largura: 0.07,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(13),
                                      ),
                                      insetPadding: EdgeInsets.symmetric(
                                          horizontal: size.width * 0.05,
                                          vertical: size.height * 0.01),
                                      title: Text(
                                        'Tem certeza?',
                                        textAlign: TextAlign.center,
                                      ),
                                      content: SizedBox(
                                        width: size.width * 0.85,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Você deseja $title essa solicitação?',
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(
                                              height: size.height * 0.025,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                TextButton(
                                                    style: OutlinedButton
                                                        .styleFrom(
                                                      shape: StadiumBorder(
                                                          side: BorderSide(
                                                              color: Consts
                                                                  .kColorAzul)),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Padding(
                                                      padding: EdgeInsets.all(
                                                          size.height * 0.01),
                                                      child: Text(
                                                        'Cancelar',
                                                        style: TextStyle(
                                                            color: Consts
                                                                .kColorAzul),
                                                      ),
                                                    )),
                                                ElevatedButton(
                                                    onPressed: () {},
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            shape:
                                                                StadiumBorder(),
                                                            backgroundColor:
                                                                Consts
                                                                    .kColorAzul),
                                                    child: Padding(
                                                      padding: EdgeInsets.all(
                                                          size.height * 0.019),
                                                      child: Text(
                                                        'Continuar',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    )),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                                // ConstsFuture.resquestApi(
                                //         '${Consts.sindicoApi}reserva_espacos/?fn=atenderReserva&idcond=${ResponsalvelInfos.idcondominio}&idunidade=$idunidade&idmorador=$idmorador&idreserva=$idreserva&ativo=$tipo')
                                //     .then((value) {
                                //   if (!value['erro']) {
                                //     setState(() {
                                //       apiListar;
                                //     });
                                //     buildMinhaSnackBar(context,
                                //         title: 'Muito Obrigado',
                                //         subTitle: value['mensagem']);
                                //   } else {
                                //     buildMinhaSnackBar(context,
                                //         title: 'Algo saiu mal',
                                //         subTitle: value['mensagem']);
                                //   }
                                // });
                              },
                            );
                          }

                          return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: size.height * 0.005),
                            child: MyBoxShadow(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.02,
                                    vertical: size.height * 0.01),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        buildTextReserva(
                                          titulo: 'Nome do Espaço',
                                          texto: nome_espaco.toString(),
                                        ),
                                        Spacer(),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: status == 0
                                                  ? Colors.grey
                                                  : status == 1
                                                      ? verde
                                                      : amarelo,
                                              borderRadius:
                                                  BorderRadius.circular(16)),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: size.height * 0.012,
                                                horizontal: size.width * 0.05),
                                            child: ConstsWidget.buildTextTitle(
                                              context,
                                              texto_status,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: size.height * 0.02),
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        width: double.maxFinite,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            buildTextReserva(
                                              titulo: 'Reservado por',
                                              texto: '$unidade',
                                            ),
                                            ConstsWidget.buildTextSubTitle(
                                                nome_morador.toString())
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Row(
                                    //   children: [
                                    //     Container(
                                    //       alignment: Alignment.centerLeft,
                                    //       width: size.width * 0.5,
                                    //       child: buildTextReserva(
                                    //         titulo: 'Reservado por',
                                    //         texto:
                                    //             '${nome_morador.toString()} - ',
                                    //       ),
                                    //     ),
                                    //     Spacer(),
                                    //     buildTextReserva(
                                    //       titulo: 'Unidade',
                                    //       texto: unidade,
                                    //     ),
                                    //   ],
                                    // ),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        buildTextReserva(
                                          titulo: 'Enviado em',
                                          texto: datahora.toString(),
                                        ),
                                        buildTextReserva(
                                          titulo: 'Data da Reserva',
                                          texto: data_reserva.toString(),
                                        ),
                                      ],
                                    ),
                                    if (status == 2)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * 0.02),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            buildAtendeReserva('Recusar', 0),
                                            SizedBox(
                                              width: size.width * 0.01,
                                            ),
                                            buildAtendeReserva(
                                              'Aprovar',
                                              1,
                                            ),
                                          ],
                                        ),
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
              )
            ],
          )),
    );
  }
}
