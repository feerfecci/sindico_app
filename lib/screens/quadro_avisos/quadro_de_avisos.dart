// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:sindico_app/consts/consts.dart';
import 'package:sindico_app/consts/consts_future.dart';
import 'package:sindico_app/screens/quadro_avisos/add_avisos_screen.dart';
import 'package:sindico_app/widgets/my_box_shadow.dart';
import 'package:sindico_app/widgets/page_vazia.dart';
import 'package:sindico_app/widgets/scaffold_all.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../consts/const_widget.dart';
import '../../repositories/shared_preferences.dart';
import '../../widgets/page_erro.dart';
import 'loading_avisos.dart';

class QuadroDeAvisos extends StatefulWidget {
  static List qntAvisos = [];
  static List<String> idAcessados = [];
  const QuadroDeAvisos({super.key});

  @override
  State<QuadroDeAvisos> createState() => _QuadroDeAvisosState();
}

Future apiQuadroAvisos() async {
  //print('listarAvisos');
  var url = Uri.parse(
      '${Consts.sindicoApi}quadro_avisos/index.php?fn=listarAvisos&idcond=${ResponsalvelInfos.idcondominio}&idfuncionario=${ResponsalvelInfos.idfuncionario}');
  var resposta = await get(url);

  if (resposta.statusCode == 200) {
    var jsonResposta = json.decode(resposta.body);
    if (!jsonResposta['erro']) {
      comparaAvisos(jsonResposta).whenComplete(() => LocalInfos.setLoginDate());
    }

    return json.decode(resposta.body);
  } else {
    return false;
  }
}

Future comparaAvisos(jsonResposta) async {
  QuadroDeAvisos.qntAvisos.clear();
  List apiAvisos = jsonResposta['avisos'];
  LocalInfos.getLoginDate().then((dateValue) {
    for (var i = 0; i <= apiAvisos.length - 1; i++) {
      if (dateValue != null) {
        if (DateTime.parse(apiAvisos[i]['datahora'])
                    .compareTo(DateTime.parse(dateValue)) >
                0 &&
            DateTime.parse(apiAvisos[i]['datahora']).compareTo(DateTime.now()) <
                0) {
          if (!QuadroDeAvisos.qntAvisos.contains(apiAvisos[i]['idaviso'])) {
            QuadroDeAvisos.qntAvisos.add(apiAvisos[i]['idaviso']);
          }
        }
      } else {
        if (!QuadroDeAvisos.idAcessados
            .contains(ResponsalvelInfos.idfuncionario.toString())) {
          QuadroDeAvisos.idAcessados
              .add(ResponsalvelInfos.idfuncionario.toString());
        }
        QuadroDeAvisos.qntAvisos.add(apiAvisos[i]['idaviso']);
      }
    }
  });
}

class _QuadroDeAvisosState extends State<QuadroDeAvisos> {
  @override
  void initState() {
    apiQuadroAvisos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ConstsWidget.buildRefreshIndicator(
      context,
      onRefresh: () async {
        setState(() {
          // apiQuadroAvisos();
        });
      },
      child: buildScaffoldAll(
        context,
        title: 'Quadro de Avisos',
        body: ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: [
            ConstsWidget.buildPadding001(
              context,
              child: ConstsWidget.buildCustomButton(
                context,
                'Enviar Aviso',
                color: Consts.kColorRed,
                onPressed: () {
                  ConstsFuture.navigatorPagePush(context, AddAvisosScreen());
                  // showModalBottomSheet(
                  //   enableDrag: false,
                  //   isScrollControlled: true,
                  //   isDismissible: false,
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.vertical(
                  //       top: Radius.circular(20),
                  //     ),
                  //   ),
                  //   context: context,
                  //   useSafeArea: true,
                  //   builder:
                  //       (context) => /*SizedBox(
                  //     height: size.height * 0.9,
                  //     child: */
                  //           Scaffold(body: AddAvisosScreen()
                  //               /* ),*/
                  //               ),
                  // );
                },
              ),
            ),
            FutureBuilder<dynamic>(
              future: apiQuadroAvisos(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingAvisos();
                } else if (snapshot.hasData) {
                  if (!snapshot.data['erro']) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: snapshot.data['avisos'].length,
                      itemBuilder: (context, index) {
                        var apiAvisos = snapshot.data['avisos'][index];
                        var idaviso = apiAvisos['idaviso'];
                        String txt_tipo = apiAvisos['txt_tipo'];
                        String titulo = apiAvisos['titulo'];
                        String texto = apiAvisos['texto'];
                        String datahora = DateFormat('dd/MM/yyyy - HH:mm')
                            .format(DateTime.parse(apiAvisos['datahora']));
                        var arquivo = apiAvisos['arquivo'];
                        bool showBolinha = false;

                        if (QuadroDeAvisos.qntAvisos.contains(idaviso)) {
                          showBolinha = true;
                        }

                        return ConstsWidget.buildPadding001(
                          context,
                          vertical: 0.005,
                          child: MyBoxShadow(
                              child: ConstsWidget.buildPadding001(
                            context,
                            horizontal: 0.02,
                            child: ConstsWidget.buildBadge(
                              context,
                              showBadge: showBolinha,
                              position: BadgePosition.topEnd(
                                  top: size.height * 0.018,
                                  end: size.width * 0.0025),
                              child: Theme(
                                data: Theme.of(context)
                                    .copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  collapsedIconColor: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color,
                                  onExpansionChanged: (value) {
                                    if (QuadroDeAvisos.qntAvisos
                                        .contains(idaviso)) {
                                      QuadroDeAvisos.qntAvisos.remove(idaviso);
                                      showBolinha = false;
                                    }
                                  },
                                  // trailing: Icon(Icons.arrow_drop_down),
                                  title: Column(
                                    children: [
                                      ConstsWidget.buildTextTitle(
                                          context, titulo,
                                          width: 0.65,
                                          maxLines: 5,
                                          textAlign: TextAlign.center,
                                          fontSize: 18),
                                      SizedBox(
                                        height: size.height * 0.005,
                                      ),
                                      ConstsWidget.buildTextSubTitle(
                                          context, datahora,
                                          textAlign: TextAlign.center),
                                    ],
                                  ),

                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: size.width * 0.06),
                                      child: Column(
                                        children: [
                                          ConstsWidget.buildPadding001(
                                            context,
                                            child:
                                                ConstsWidget.buildTextSubTitle(
                                              context,
                                              texto,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          SizedBox(
                                            height: size.height * 0.0075,
                                          ),
                                          if (arquivo != '')
                                            ConstsWidget.buildOutlinedButton(
                                              context,
                                              title: 'Ver Anexo',
                                              onPressed: () {
                                                launchUrl(Uri.parse(arquivo),
                                                    mode: LaunchMode
                                                        .inAppWebView);
                                              },
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
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
        ),
      ),
    );
  }
}
