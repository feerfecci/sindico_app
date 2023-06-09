import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sindico_app/consts/const_widget.dart';
import 'package:sindico_app/widgets/my_box_shadow.dart';
import 'package:http/http.dart' as http;
import '../../consts/consts.dart';
import '../../widgets/header.dart';

class FuncoesScreen extends StatefulWidget {
  const FuncoesScreen({super.key});

  @override
  State<FuncoesScreen> createState() => _FuncoesScreenState();
}

Future apiListarDivisoes() async {
  var uri = Uri.parse(
      '${Consts.sindicoApi}funcoes/?fn=listarFuncoes&idcond=${ResponsalvelInfos.idcondominio}');

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw response.statusCode;
  }
}

class _FuncoesScreenState extends State<FuncoesScreen> {
  @override
  Widget build(BuildContext context) {
    return buildHeaderPage(
      context,
      titulo: 'Funções',
      subTitulo: 'Vejas as Funções Listadas',
      widget: ListView(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        children: [
          FutureBuilder(
            future: apiListarDivisoes(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError ||
                  snapshot.data['mensagem'] != '' ||
                  snapshot.data['erro'] == true) {
                return Text('Deu erro');
              }
              return ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data['funcao'].length,
                itemBuilder: (context, index) {
                  return MyBoxShadow(
                      child: Column(
                    children: [
                      ConstsWidget.buildTextTitle(
                          snapshot.data['funcao'][index]['funcao']),
                    ],
                  ));
                },
              );
            },
          )
        ],
      ),
    );
  }
}
