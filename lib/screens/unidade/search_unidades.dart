// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../consts/const_widget.dart';
import '../../consts/consts.dart';
import '../../widgets/page_erro.dart';
import '../../widgets/page_vazia.dart';
import 'card_unidade.dart';

class SearchUnidade extends SearchDelegate<String> {
  @override
  String get searchFieldLabel => 'ex: AP23, Sala 12, João Silva';
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.close),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, 'result');
        },
        icon: Icon(Icons.arrow_back_ios_new_sharp));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Widget buildNoQuerySearch(BuildContext context, {required String mesagem}) {
      return ConstsWidget.buildPadding001(
        context,
        vertical: 0.02,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: size.width * 0.9,
              child: Text(
                mesagem,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                    height: 1.5,
                    fontSize: 18),
              ),
            ),
          ],
        ),
      );
    }

    if (query.isEmpty) {
      return buildNoQuerySearch(context,
          mesagem: 'Procure por: uma unidade e acesse os moradores');
    } else {
      return FutureBuilder<dynamic>(
        future: sugestoesUnidades(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasData) {
            if (!snapshot.data['erro']) {
              return ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data['unidades'] != null
                    ? snapshot.data['unidades'].length
                    : 0,
                itemBuilder: (context, index) {
                  var apiUnidade = snapshot.data['unidades'][index];
                  var idunidade = apiUnidade['idunidade'];
                  var ativo = apiUnidade['ativo'];
                  var idcondominio = apiUnidade['idcondominio'];
                  var nome_condominio = apiUnidade['nome_condominio'];
                  var iddivisao = apiUnidade['iddivisao'];
                  var nome_divisao = apiUnidade['nome_divisao'];
                  var dividido_por = apiUnidade['dividido_por'];
                  var numero = apiUnidade['numero'];
                  var nome_responsavel = apiUnidade['nome_responsavel'];
                  var nome_moradores = apiUnidade['nome_moradores'];
                  var login = apiUnidade['login'];

                  return buildCardUnidade(context,
                      idunidade: idunidade,
                      iddivisao: iddivisao,
                      localizado: "$dividido_por $nome_divisao - $numero");
                },
              );
            } else {
              return PageVazia(title: snapshot.data['mensagem']);
            }
          } else {
            return PageErro();
          }
        },
      );
    }
  }

  Future<dynamic> sugestoesUnidades() async {
    var url = Uri.parse(
        'https://a.portariaapp.com/sindico/api/unidades/index.php?fn=pesquisarUnidades&idcond=${ResponsalvelInfos.idcondominio}&idfuncionario=${ResponsalvelInfos.idfuncionario}&palavra=$query');
    var resposta = await http.get(url);
    if (resposta.statusCode == 200) {
      return json.decode(resposta.body);
    } else {
      return {'erro': true, 'mesagem': 'Algo Saiu Mal!'};
    }
  }
}
