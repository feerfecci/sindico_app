// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sindico_app/consts/consts.dart';
import 'package:sindico_app/consts/consts_future.dart';
import 'package:sindico_app/screens/quadro_avisos/modal_avisos.dart';
import 'package:sindico_app/widgets/header.dart';
import 'package:sindico_app/widgets/my_box_shadow.dart';
import 'package:sindico_app/widgets/page_vazia.dart';
import 'package:sindico_app/widgets/scaffold_all.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../consts/const_widget.dart';
import '../../widgets/page_erro.dart';
import 'loading_avisos.dart';

class QuadroDeAvisos extends StatefulWidget {
  const QuadroDeAvisos({super.key});

  @override
  State<QuadroDeAvisos> createState() => _QuadroDeAvisosState();
}

class _QuadroDeAvisosState extends State<QuadroDeAvisos> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          ConstsFuture.resquestApi(
              '${Consts.sindicoApi}quadro_avisos/index.php?fn=listarAvisos&idcond=${ResponsalvelInfos.idcondominio}');
        });
      },
      child: buildScaffoldAll(
        context,
        title: 'Quadro de Avisos',
        body: ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
              child: ConstsWidget.buildCustomButton(
                context,
                'Adicionar Aviso',
                color: Consts.kColorRed,
                icon: Icons.add,
                onPressed: () {
                  showModalBottomSheet(
                    enableDrag: false,
                    isScrollControlled: true,
                    isDismissible: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    context: context,
                    builder: (context) => SizedBox(
                      height: size.height * 0.85,
                      child: Scaffold(body: WidgetModalAvisos()),
                    ),
                  );
                },
              ),
            ),
            FutureBuilder<dynamic>(
              future: ConstsFuture.resquestApi(
                  '${Consts.sindicoApi}quadro_avisos/index.php?fn=listarAvisos&idcond=${ResponsalvelInfos.idcondominio}'),
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
                        String txt_tipo = apiAvisos['txt_tipo'];
                        String titulo = apiAvisos['titulo'];
                        String texto = apiAvisos['texto'];
                        String datahora = DateFormat('dd/MM/yyyy - HH:mm')
                            .format(DateTime.parse(apiAvisos['datahora']));
                        var arquivo = apiAvisos['arquivo'];

                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.005),
                          child: MyBoxShadow(
                              child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.02,
                                vertical: size.height * 0.01),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ConstsWidget.buildTextTitle(context, titulo,
                                    size: 18),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: size.height * 0.01),
                                  child: ConstsWidget.buildTextSubTitle(texto,
                                      textAlign: TextAlign.center),
                                ),
                                ConstsWidget.buildTextSubTitle(datahora,
                                    textAlign: TextAlign.center),
                                SizedBox(
                                  height: size.height * 0.01,
                                ),
                                if (arquivo != '')
                                  ConstsWidget.buildOutlinedButton(
                                    context,
                                    title: 'Ver Anexo',
                                    onPressed: () {
                                      launchUrl(Uri.parse(arquivo),
                                          mode: LaunchMode
                                              .externalNonBrowserApplication);
                                    },
                                  ),
                              ],
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
