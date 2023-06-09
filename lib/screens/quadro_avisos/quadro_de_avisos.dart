// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sindico_app/consts/consts.dart';
import 'package:sindico_app/screens/quadro_avisos/modal_avisos.dart';
import 'package:sindico_app/widgets/header.dart';
import 'package:sindico_app/widgets/my_box_shadow.dart';
import 'package:sindico_app/widgets/scaffold_all.dart';
import 'package:http/http.dart' as http;
import '../../consts/const_widget.dart';

class QuadroDeAvisos extends StatefulWidget {
  const QuadroDeAvisos({super.key});

  @override
  State<QuadroDeAvisos> createState() => _QuadroDeAvisosState();
}

apiListarAvisos() async {
  var url = Uri.parse(
      '${Consts.sindicoApi}quadro_avisos/index.php?fn=listarAvisos&idcond=${ResponsalvelInfos.idcondominio}');
  var resposta = await http.get(url);
  if (resposta.statusCode == 200) {
    return json.decode(resposta.body);
  } else {
    return false;
  }
}

class _QuadroDeAvisosState extends State<QuadroDeAvisos> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return buildScaffoldAll(
      context,
      body: buildHeaderPage(
        context,
        titulo: 'Quadro de Avisos',
        subTitulo: 'Avise',
        widget: ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: [
            ConstsWidget.buildCustomButton(
              context,
              'Adicionar Aviso',
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
                      height: size.height * 0.85, child: WidgetModalAvisos()),
                );
              },
            ),
            FutureBuilder<dynamic>(
              future: apiListarAvisos(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError || !snapshot.hasData) {
                  return Text('Algo deu errado');
                } else {
                  if (snapshot.data['erro']) {
                    return Text('Não há nada');
                  }
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

                      return MyBoxShadow(
                          // ListTile(
                          //   title: ConstsWidget.buildTextTitle(context, titulo),
                          //   subtitle: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       ConstsWidget.buildTextTitle(
                          //         context,
                          //         texto,
                          //       ),
                          //       ConstsWidget.buildTextSubTitle(
                          //         context,
                          //         datahora,
                          //       ),
                          //     ],
                          //   ),
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ConstsWidget.buildTextTitle(titulo),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: size.height * 0.01),
                            child: ConstsWidget.buildTextSubTitle(
                              texto,
                            ),
                          ),
                          ConstsWidget.buildTextSubTitle(
                            datahora,
                          ),
                        ],
                      ));
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
