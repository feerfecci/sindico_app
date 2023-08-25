import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sindico_app/consts/const_widget.dart';
import 'package:sindico_app/consts/consts_future.dart';
import 'package:sindico_app/widgets/my_box_shadow.dart';
import 'package:http/http.dart' as http;
import 'package:sindico_app/widgets/page_erro.dart';
import '../../consts/consts.dart';
import '../../widgets/header.dart';

class DivisoesScreen extends StatefulWidget {
  const DivisoesScreen({super.key});

  @override
  State<DivisoesScreen> createState() => _DivisoesScreenState();
}

Future apiListarDivisoes() async {
  var uri = Uri.parse(
      '${Consts.sindicoApi}divisoes/?fn=listarDivisoes&idcond=${ResponsalvelInfos.idcondominio}&idfuncionario=${ResponsalvelInfos.idfuncionario}');

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw response.statusCode;
  }
}

class _DivisoesScreenState extends State<DivisoesScreen> {
  @override
  Widget build(BuildContext context) {
    return buildHeaderPage(
      context,
      titulo: 'Divisões',
      subTitulo: 'Vejas as Divisões Listadas',
      widget: ListView(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        children: [
          FutureBuilder(
            future: apiListarDivisoes(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasData) {
                if (!snapshot.data['erro']) {
                  return ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data['divisoes'].length,
                    itemBuilder: (context, index) {
                      return MyBoxShadow(
                          child: Column(
                        children: [
                          ConstsWidget.buildTextTitle(context,
                              snapshot.data['divisoes'][index]['nome_divisao']),
                        ],
                      ));
                    },
                  );
                } else {
                  return PageErro();
                }
              }
              return PageErro();
            },
          )
        ],
      ),
    );
  }
}
