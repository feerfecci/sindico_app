// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sindico_app/consts/consts.dart';
import 'package:sindico_app/consts/consts_future.dart';
import 'package:sindico_app/widgets/my_box_shadow.dart';
import 'package:sindico_app/widgets/scaffold_all.dart';
import 'package:sindico_app/widgets/snack.dart';
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
  ListaReservas.listIdReserva.clear();
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
              'Atenção',
              textAlign: TextAlign.center,
            ),
            content: SizedBox(
              width: size.width * 0.85,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Text(
                  //   'Você deseja $title essa solicitação?',
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(height: 1.5),
                  // ),
                  RichText(
                      text: TextSpan(
                          text: 'Deseja ',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                            overflow: TextOverflow.ellipsis,
                            fontSize: SplashScreen.isSmall ? 14 : 16,
                          ),
                          children: [
                        ConstsWidget.builRichTextTitle(context,
                            textBold: title,
                            color: tipo == 0
                                ? Consts.kColorRed
                                : Consts.kColorVerde),
                        ConstsWidget.builRichTextSubTitle(context,
                            subTitle: ' essa solicitação?')
                      ])),
                  SizedBox(
                    height: size.height * 0.025,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ConstsWidget.buildOutlinedButton(
                        context,
                        title: 'Cancelar',
                        rowSpacing: SplashScreen.isSmall ? 0.05 : 0.06,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      ConstsWidget.buildCustomButton(
                        context,
                        'Continuar',
                        rowSpacing: SplashScreen.isSmall ? 0.03 : 0.05,
                        color: Consts.kColorRed,
                        onPressed: () {
                          FocusManager.instance.primaryFocus!.unfocus();
                          ConstsFuture.resquestApi(
                                  '${Consts.sindicoApi}reserva_espacos/?fn=atenderReserva&idcond=${ResponsalvelInfos.idcondominio}&idfuncionario=${ResponsalvelInfos.idfuncionario}&idunidade=$idunidade&idmorador=$idmorador&idespaco=$idespaco&data_reserva=$data&idreserva=$idreserva&ativo=$tipo')
                              .then((value) {
                            if (!value['erro']) {
                              Navigator.pop(context);

                              setState(() {
                                ListaReservas.listIdReserva.remove(idreserva);
                                ListaReservas.listIdReserva.length;
                              });
                              buildMinhaSnackBar(context,
                                  title: 'Muito Obrigado',
                                  hasError: value['erro'],
                                  subTitle: value['mensagem']);
                            } else {
                              buildMinhaSnackBar(context,
                                  hasError: value['erro'],
                                  title: 'Algo saiu mal',
                                  subTitle: value['mensagem']);
                            }
                          });
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      );
    }

    Widget buildTextReserva({required titulo, required texto, double? width}) {
      return SizedBox(
        width: width != null ? size.width * width : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ConstsWidget.buildTextSubTitle(context, titulo,
                size: SplashScreen.isSmall ? 14 : 16),
            ConstsWidget.buildTextTitle(context, texto,
                fontSize: SplashScreen.isSmall ? 16 : 18),
          ],
        ),
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
                      width: SplashScreen.isSmall
                          ? size.width * 0.32
                          : size.width * 0.32,
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
                      width: SplashScreen.isSmall
                          ? size.width * 0.32
                          : size.width * 0.315,
                      child: statusReserva == 1
                          ? ConstsWidget.buildCustomButton(
                              context,
                              color: statusReserva == 1
                                  ? Consts.kColorVerde
                                  : null,
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
                              color: statusReserva == 1
                                  ? Consts.kColorVerde
                                  : null,
                              onPressed: () {
                                setState(() {
                                  statusReserva = 1;
                                });
                              },
                            ),
                    ),
                    SizedBox(
                      width: SplashScreen.isSmall
                          ? size.width * 0.32
                          : size.width * 0.315,
                      child: statusReserva == 2
                          ? ConstsWidget.buildCustomButton(
                              context,
                              color: statusReserva == 2
                                  ? Consts.kColorAmarelo
                                  : null,
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
                              color: statusReserva == 2
                                  ? Consts.kColorAmarelo
                                  : null,
                              onPressed: () {
                                setState(() {
                                  statusReserva = 2;
                                });
                              },
                            ),
                    ),
                    // // buildFiltroReserv('Recusadas', 0, color: Colors.grey),
                    // buildFiltroReserv('Aprovadas', 1, color: Consts.kColorVerde),
                    // buildFiltroReserv('Pendentes', 2, color: Consts.kColorAmarelo),
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
                          bool temadm = apiReservar['temadm'];
                          String nome_condominio =
                              apiReservar['nome_condominio'];
                          int idmorador = apiReservar['idmorador'];
                          String nome_morador = apiReservar['nome_morador'];
                          int idunidade = apiReservar['idunidade'];
                          String unidade = apiReservar['unidade'];
                          String data_reserva = DateFormat('dd/MM/yyyy • HH:mm')
                              .format(
                                  DateTime.parse(apiReservar['data_reserva']));
                          String datahora = DateFormat('dd/MM/yyyy • HH:mm')
                              .format(DateTime.parse(apiReservar['datahora']));

                          Widget buildStatusTarefa(
                              {required int status, required String title}) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ConstsWidget.buildTextTitle(context, title),
                                SizedBox(
                                  height: size.height * 0.005,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: !temadm && title != 'Síndico'
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                            : status == 0
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                : status == 1
                                                    ? Consts.kColorVerde
                                                    : Consts.kColorAmarelo,
                                      ),
                                      borderRadius: BorderRadius.circular(16)),
                                  child: ConstsWidget.buildPadding001(
                                    context,
                                    vertical: 0.012,
                                    horizontal: 0.05,
                                    child: ConstsWidget.buildTextTitle(
                                      context,
                                      !temadm && title != 'Síndico'
                                          ? 'Desativado'
                                          : status == 0
                                              ? 'Recusado'
                                              : status == 1
                                                  ? 'Aprovada'
                                                  : 'Pendente',
                                      color: !temadm && title != 'Síndico'
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : status == 0
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : status == 1
                                                  ? Consts.kColorVerde
                                                  : Consts.kColorAmarelo,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }

                          Widget buildAtendeReserva(String title, int tipo) {
                            return tipo == 0
                                ? ConstsWidget.buildOutlinedButton(
                                    context,
                                    title: title,
                                    rowSpacing: 0.09,
                                    onPressed: () {
                                      alertAtender(
                                          idespaco: idespaco,
                                          idmorador: idmorador,
                                          idreserva: idreserva,
                                          idunidade: idunidade,
                                          tipo: tipo,
                                          title: title,
                                          data: apiReservar['data_reserva']);
                                    },
                                  )
                                : ConstsWidget.buildCustomButton(
                                    context,
                                    title,
                                    color: Consts.kColorRed,
                                    altura: 0.02,
                                    rowSpacing: 0.09,
                                    onPressed: () {
                                      alertAtender(
                                          idespaco: idespaco,
                                          idmorador: idmorador,
                                          idreserva: idreserva,
                                          idunidade: idunidade,
                                          tipo: tipo,
                                          title: title,
                                          data: apiReservar['data_reserva']);
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
                                        // buildTextReserva(
                                        //   titulo: 'Nome do Espaço',
                                        //   width: 0.6,
                                        //   texto: nome_espaco.toString(),
                                        // ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ConstsWidget.buildTextTitle(
                                                context, nome_espaco.toString(),
                                                fontSize: 18, width: 0.6),
                                            ConstsWidget.buildPadding001(
                                              context,
                                              vertical: 0.005,
                                              child:
                                                  ConstsWidget.buildTextTitle(
                                                      context, unidade),
                                            ),
                                            ConstsWidget.buildTextSubTitle(
                                                context,
                                                nome_morador.toString())
                                          ],
                                        ),
                                        Spacer(),
                                        // if (temadm)
                                        buildStatusTarefa(
                                            status: status, title: 'Síndico'),
                                      ],
                                    ),
                                    ConstsWidget.buildPadding001(
                                      context,
                                      vertical: 0.02,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            width: size.width * 0.55,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                buildTextReserva(
                                                  titulo: 'Data da Reserva',
                                                  texto:
                                                      data_reserva.toString(),
                                                ),
                                                // buildTextReserva(
                                                //   titulo: 'Reservado por',
                                                //   texto: unidade,
                                                // ),
                                                // ConstsWidget.buildTextTitle(
                                                //     context, unidade),
                                                // ConstsWidget.buildTextSubTitle(
                                                //     context,
                                                //     nome_morador.toString())
                                              ],
                                            ),
                                          ),
                                          buildStatusTarefa(
                                              status: status_adm,
                                              title: 'Administradora'),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        buildTextReserva(
                                          titulo: 'Enviado em',
                                          texto: datahora.toString(),
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
