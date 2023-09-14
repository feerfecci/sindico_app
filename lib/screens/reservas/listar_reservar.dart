// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sindico_app/consts/consts.dart';
import 'package:sindico_app/consts/consts_future.dart';
import 'package:sindico_app/widgets/my_box_shadow.dart';
import 'package:sindico_app/widgets/scaffold_all.dart';
import 'package:sindico_app/widgets/snackbar/snack.dart';
import '../../screens/splash_screen/splash_screen.dart';
import '../../consts/const_widget.dart';
import '../../widgets/page_erro.dart';
import '../../widgets/page_vazia.dart';
import 'loading_reserva.dart';
import 'package:http/http.dart' as http;

class ListaReservas extends StatefulWidget {
  static List listIdReserva = [];
  const ListaReservas({super.key});

  @override
  State<ListaReservas> createState() => _ListaReservasState();
}

Future apiResevas() async {
  var resposta = await http.get(
    Uri.parse(
        '${Consts.sindicoApi}reserva_espacos/?fn=listarReservas&idcond=${ResponsalvelInfos.idcondominio}&idfuncionario=${ResponsalvelInfos.idfuncionario}&ativo=2'),
  );
  if (resposta.statusCode == 200) {
    var respostaJson = json.decode(resposta.body);
    if (!respostaJson['erro']) {
      for (var i = 0; i <= (respostaJson['reserva_espacos'].length - 1); i++) {
        int idReserva = respostaJson['reserva_espacos'][i]['idreserva'];

        if (!ListaReservas.listIdReserva.contains(idReserva)) {
          ListaReservas.listIdReserva.add(idReserva);
        }
      }
    }
  }
}

class _ListaReservasState extends State<ListaReservas> {
  int statusReserva = 2;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    alertAtender(
        {required String title,
        required int idunidade,
        required int idmorador,
        required int idespaco,
        required String data,
        required int idreserva,
        required int tipo}) {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
            insetPadding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05, vertical: size.height * 0.01),
            title: Text(
              'Tem certeza?',
              textAlign: TextAlign.center,
            ),
            content: SizedBox(
              width: size.width * 0.85,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Você deseja $title essa solicitação?',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: size.height * 0.025,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          style: OutlinedButton.styleFrom(
                            shape: StadiumBorder(
                                side: BorderSide(color: Consts.kColorAzul)),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: EdgeInsets.all(size.height * 0.01),
                            child: Text(
                              'Cancelar',
                              style: TextStyle(color: Consts.kColorAzul),
                            ),
                          )),
                      ElevatedButton(
                          onPressed: () {
                            ConstsFuture.resquestApi(
                                    '${Consts.sindicoApi}reserva_espacos/?fn=atenderReserva&idcond=${ResponsalvelInfos.idcondominio}&idfuncionario=${ResponsalvelInfos.idfuncionario}&idunidade=$idunidade&idmorador=$idmorador&idespaco=$idespaco&data_reserva=$data&idreserva=$idreserva&ativo=$tipo')
                                .then((value) {
                              if (!value['erro']) {
                                Navigator.pop(context);
                                ListaReservas.listIdReserva.remove(idreserva);

                                setState(() {});
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
                          style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(),
                            backgroundColor: Consts.kColorRed,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(size.height * 0.019),
                            child: Text(
                              'Continuar',
                              style: TextStyle(color: Colors.white),
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
    }

    Widget buildTextReserva({required titulo, required texto}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ConstsWidget.buildTextTitle(context, titulo,
              fontSize: SplashScreen.isSmall ? 16 : 18),
          ConstsWidget.buildTextSubTitle(texto,
              size: SplashScreen.isSmall ? 14 : 16),
        ],
      );
    }

    // Widget buildFiltroReserv(String title, int ativo, {Color? color}) {
    //   return SizedBox(
    //     width: size.width * 0.315,
    //     child: ConstsWidget.buildCustomButton(
    //       context,
    //       title,
    //       fontSize: SplashScreen.isSmall ? 18 : 16,
    //       color: color,
    //       onPressed: () {
    //         setState(() {
    //           statusReserva = ativo;
    //         });
    //       },
    //     ),
    //   );
    // }

    Color verde = Color.fromARGB(255, 44, 201, 104);
    Color amarelo = Color.fromARGB(255, 255, 193, 7);

    var apiListar = ConstsFuture.resquestApi(
        '${Consts.sindicoApi}reserva_espacos/?fn=listarReservas&idcond=${ResponsalvelInfos.idcondominio}&idfuncionario=${ResponsalvelInfos.idfuncionario}&ativo=$statusReserva');

    return ConstsWidget.buildRefreshIndicator(
      context,
      onRefresh: () async {
        setState(() {
          apiListar;
        });
      },
      child: buildScaffoldAll(context,
          title: 'Reservas',
          body: Column(
            children: [
              ConstsWidget.buildPadding001(
                context,
                vertical: 0.015,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: size.width * 0.315,
                      child: statusReserva == 0
                          ? ConstsWidget.buildCustomButton(
                              context,
                              color: statusReserva == 0 ? Colors.grey : null,
                              'Recusadas',
                              onPressed: () {
                                setState(() {
                                  statusReserva = 0;
                                });
                              },
                            )
                          : ConstsWidget.buildOutlinedButton(
                              context, title: 'Recusadas',
                              // fontSize: SplashScreen.isSmall ? 18 : 16,
                              // color: statusReserva == 0 ? Colors.grey : null,
                              onPressed: () {
                                setState(() {
                                  statusReserva = 0;
                                });
                              },
                            ),
                    ),
                    SizedBox(
                      width: size.width * 0.315,
                      child: statusReserva == 1
                          ? ConstsWidget.buildCustomButton(
                              context,
                              color: statusReserva == 1 ? verde : null,
                              'Aprovadas',
                              onPressed: () {
                                setState(() {
                                  statusReserva = 1;
                                });
                              },
                            )
                          : ConstsWidget.buildOutlinedButton(
                              context, title: 'Aprovadas',
                              // fontSize: SplashScreen.isSmall ? 18 : 16,
                              color: statusReserva == 1 ? verde : null,
                              onPressed: () {
                                setState(() {
                                  statusReserva = 1;
                                });
                              },
                            ),
                    ),
                    SizedBox(
                      width: size.width * 0.315,
                      child: statusReserva == 2
                          ? ConstsWidget.buildCustomButton(
                              context,
                              color: statusReserva == 2 ? amarelo : null,
                              'Pendentes',
                              onPressed: () {
                                setState(() {
                                  statusReserva = 2;
                                });
                              },
                            )
                          : ConstsWidget.buildOutlinedButton(
                              context, title: 'Pendentes',
                              // fontSize: SplashScreen.isSmall ? 18 : 16,
                              color: statusReserva == 2 ? amarelo : null,
                              onPressed: () {
                                setState(() {
                                  statusReserva = 2;
                                });
                              },
                            ),
                    ),
                    // // buildFiltroReserv('Recusadas', 0, color: Colors.grey),
                    // buildFiltroReserv('Aprovadas', 1, color: verde),
                    // buildFiltroReserv('Pendentes', 2, color: amarelo),
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
                          int status_adm = apiReservar['status_adm'];
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
                              color:
                                  title == '  Aprovar  ' ? verde : Colors.grey,
                              altura: 0.02,
                              largura: 0.07,
                              onPressed: () {
                                alertAtender(
                                    idespaco: idespaco,
                                    idmorador: idmorador,
                                    idreserva: idreserva,
                                    idunidade: idunidade,
                                    tipo: tipo,
                                    title: title,
                                    data: apiReservar['data_reserva']);

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

                          return ConstsWidget.buildPadding001(
                            context,
                            vertical: 0.005,
                            child: MyBoxShadow(
                              child: ConstsWidget.buildPadding001(
                                context,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        buildTextReserva(
                                          titulo: 'Nome do Espaço',
                                          texto: nome_espaco.toString(),
                                        ),
                                        // Spacer(),
                                        // Container(
                                        //   decoration: BoxDecoration(
                                        //       border: Border.all(
                                        //         color: status == 0
                                        //             ? Colors.grey
                                        //             : status == 1
                                        //                 ? verde
                                        //                 : amarelo,
                                        //       ),
                                        //       borderRadius:
                                        //           BorderRadius.circular(16)),
                                        //   child: ConstsWidget.buildPadding001(
                                        //     context,
                                        //     vertical: 0.012,
                                        //     horizontal: 0.05,
                                        //     child: ConstsWidget.buildTextTitle(
                                        //       context,
                                        //       texto_status,
                                        //       color: status == 0
                                        //           ? Colors.grey
                                        //           : status == 1
                                        //               ? verde
                                        //               : amarelo,
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                    ConstsWidget.buildPadding001(
                                      context,
                                      vertical: 0.02,
                                      child: Row(
                                        children: [
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            width: size.width * 0.6,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                buildTextReserva(
                                                  titulo: 'Reservado por',
                                                  texto: unidade,
                                                ),
                                                ConstsWidget.buildTextSubTitle(
                                                    nome_morador.toString())
                                              ],
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              ConstsWidget.buildTextTitle(
                                                  context, 'Administradora'),
                                              SizedBox(
                                                height: size.height * 0.005,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: status_adm == 0
                                                          ? Colors.grey
                                                          : status_adm == 1
                                                              ? verde
                                                              : amarelo,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16)),
                                                child: ConstsWidget
                                                    .buildPadding001(
                                                  context,
                                                  vertical: 0.012,
                                                  horizontal: 0.05,
                                                  child: ConstsWidget
                                                      .buildTextTitle(
                                                    context,
                                                    status_adm == 0
                                                        ? 'Recusado'
                                                        : status_adm == 1
                                                            ? 'Aprovada'
                                                            : 'Pendente',
                                                    color: status_adm == 0
                                                        ? Colors.grey
                                                        : status_adm == 1
                                                            ? verde
                                                            : amarelo,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
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
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            buildAtendeReserva(
                                                '  Recusar  ', 0),
                                            SizedBox(
                                              width: size.width * 0.01,
                                            ),
                                            buildAtendeReserva(
                                              '  Aprovar  ',
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
