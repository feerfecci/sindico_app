import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sindico_app/consts/consts.dart';
import 'package:sindico_app/consts/consts_future.dart';
import 'package:sindico_app/screens/moradores/cadastro_morador.dart';
import 'package:sindico_app/widgets/header.dart';
import 'package:sindico_app/widgets/my_box_shadow.dart';
import 'package:sindico_app/widgets/scaffold_all.dart';
import 'package:http/http.dart' as http;
import '../../consts/const_widget.dart';

class ListaMorador extends StatefulWidget {
  final int? idunidade;
  final String? numero;
  final int? idvisisao;
  const ListaMorador({this.idvisisao, this.idunidade, this.numero, super.key});

  @override
  State<ListaMorador> createState() => _ListaMoradorState();
}

Future apiListarMoradores(idunidade) async {
  var uri = Uri.parse(
      'https://a.portariaapp.com/sindico/api/moradores/?fn=listarMoradores&idunidade=$idunidade&idcond=${ResponsalvelInfos.idcondominio}');
  var resposta = await http.get(uri);
  if (resposta.statusCode == 200) {
    return json.decode(resposta.body);

    // return jsonDecode(utf8.decode(resposta.bodyBytes));
  } else {
    return false;
  }
}

class _ListaMoradorState extends State<ListaMorador> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          apiListarMoradores(widget.idunidade);
        });
      },
      child: buildScaffoldAll(
          body: buildHeaderPage(context,
              titulo: 'Moradores',
              subTitulo: 'Adicione ou edite moradores',
              widget: ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: [
                  ConstWidget.buildCustomButton(context, 'Adicionar Morador',
                      onPressed: () {
                    ConstsFuture.navigatorPagePush(
                        context,
                        CadastroMorador(
                          numero: widget.numero,
                          iddivisao: widget.idvisisao,
                          idunidade: widget.idunidade,
                        ));
                  }),
                  FutureBuilder<dynamic>(
                    future: apiListarMoradores(widget.idunidade),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Container(
                          color: Colors.red,
                        );
                      } else if ((snapshot.hasData == false ||
                          snapshot.data['mensagem'] ==
                              "Não foi possível exibir a lista de moradores!")) {
                        return Column(
                          children: [
                            SizedBox(
                              child: ConstWidget.buildTextTitle(
                                  'Nenhum morador cadastrado!'),
                            ),
                            SizedBox(
                              child: ConstWidget.buildTextSubTitle(
                                  'Adicione um morador para essa Unidade'),
                            ),
                          ],
                        );
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: snapshot.data['morador'].length,
                          itemBuilder: (context, index) {
                            var apiMorador = snapshot.data['morador'][index];
                            var idmorador = apiMorador['idmorador'];
                            var idunidade = apiMorador['idunidade'];
                            var iddivisao = apiMorador['iddivisao'];
                            var ativo = apiMorador['ativo'];
                            var nome_condominio = apiMorador['nome_condominio'];
                            var nome_divisao = apiMorador['nome_divisao'];
                            var dividido_por = apiMorador['dividido_por'];
                            var numero = apiMorador['numero'];
                            var nome_morador = apiMorador['nome_morador'];
                            var login = apiMorador['login'];
                            var documento = apiMorador['documento'];
                            var data_nascimento = apiMorador['data_nascimento'];
                            // var data_nascimento = DateFormat('dd/MM/yyy').format(
                            //     DateTime.parse(apiMorador['data_nascimento']));
                            var ddd = apiMorador['ddd'];
                            var telefone = apiMorador['telefone'];
                            var acessa_sistema = apiMorador['acessa_sistema'];

                            int acesso = acessa_sistema == true ? 1 : 0;
                            return MyBoxShadow(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ConstWidget.buildTextTitle(nome_condominio),
                                SizedBox(
                                  height: size.height * 0.01,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ConstWidget.buildTextTitle(nome_morador),
                                    Container(
                                      child:
                                          ConstWidget.buildAtivoInativo(ativo),
                                    ),
                                  ],
                                ),
                                ConstWidget.buildTextSubTitle(
                                    'Localizado em :'),
                                Row(
                                  children: [
                                    ConstWidget.buildTextTitle('$numero - '),
                                    ConstWidget.buildTextTitle(
                                        '$dividido_por '),
                                    ConstWidget.buildTextTitle(nome_divisao),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: size.height * 0.015),
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ConstWidget.buildTextSubTitle(
                                              'Data Nascimento :'),
                                          ConstWidget.buildTextTitle(
                                              DateFormat('dd/MM/yyy').format(
                                                  DateTime.parse(
                                                      data_nascimento))),
                                        ],
                                      ),
                                      SizedBox(
                                        width: size.width * 0.1,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ConstWidget.buildTextSubTitle(
                                              'Documento :'),
                                          ConstWidget.buildTextTitle(documento),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                ConstWidget.buildTextSubTitle('Contato :'),
                                Row(
                                  children: [
                                    ConstWidget.buildTextTitle('($ddd) '),
                                    ConstWidget.buildTextTitle(telefone),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        ConstWidget.buildTextSubTitle(
                                            'Login :'),
                                        ConstWidget.buildTextTitle(login),
                                      ],
                                    ),
                                    SizedBox(
                                      width: size.width * 0.6,
                                      child: CheckboxListTile(
                                        title: Text('Acesso ao sistema'),
                                        value: acessa_sistema,
                                        onChanged: (value) {},
                                      ),
                                    )
                                  ],
                                ),
                                ConstWidget.buildCustomButton(
                                    context, 'Editar Morador', onPressed: () {
                                  ConstsFuture.navigatorPagePush(
                                    context,
                                    CadastroMorador(
                                      idmorador: idmorador,
                                      iddivisao: iddivisao,
                                      idunidade: idunidade,
                                      numero: numero,
                                      nome_morador: nome_morador,
                                      login: login,
                                      documento: documento,
                                      nascimento: data_nascimento,
                                      telefone: telefone,
                                      ddd: ddd,
                                      acesso: acesso,
                                      ativo: ativo,
                                    ),
                                  );
                                })
                              ],
                            ));
                          },
                        );
                      }
                    },
                  )
                ],
              ))),
    );
  }
}
