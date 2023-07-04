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
import '../../widgets/page_erro.dart';

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
      '${Consts.sindicoApi}moradores/?fn=listarMoradores&idunidade=$idunidade&idcond=${ResponsalvelInfos.idcondominio}');
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
        context,
        title: 'Moradores',
        body: Column(
          children: [
            ConstsWidget.buildCustomButton(context, 'Adicionar Morador',
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
                } if(snapshot.hasData){
                  
                  if(snapshot.data['erro']){
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
                          ConstsWidget.buildTextTitle(context, nome_condominio),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ConstsWidget.buildTextTitle(
                                  context, nome_morador),
                              Container(
                                child: ConstsWidget.buildAtivoInativo(
                                    context, ativo),
                              ),
                            ],
                          ),
                          ConstsWidget.buildTextSubTitle('Localizado em :'),
                          Row(
                            children: [
                              ConstsWidget.buildTextTitle(
                                  context, '$numero - '),
                              ConstsWidget.buildTextTitle(
                                  context, '$dividido_por '),
                              ConstsWidget.buildTextTitle(
                                  context, nome_divisao),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: size.height * 0.015),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ConstsWidget.buildTextSubTitle(
                                        'Data Nascimento :'),
                                    ConstsWidget.buildTextTitle(
                                        context,
                                        DateFormat('dd/MM/yyy').format(
                                            DateTime.parse(data_nascimento))),
                                  ],
                                ),
                                SizedBox(
                                  width: size.width * 0.1,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ConstsWidget.buildTextSubTitle(
                                        'Documento :'),
                                    ConstsWidget.buildTextTitle(
                                        context, documento),
                                  ],
                                )
                              ],
                            ),
                          ),
                          ConstsWidget.buildTextSubTitle('Contato :'),
                          Row(
                            children: [
                              ConstsWidget.buildTextTitle(context, '($ddd) '),
                              ConstsWidget.buildTextTitle(context, telefone),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  ConstsWidget.buildTextSubTitle('Login :'),
                                  ConstsWidget.buildTextTitle(context, login),
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
                          ConstsWidget.buildCustomButton(
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
              
                  }else {
                    return Column(
                    children: [
                      SizedBox(
                        child: ConstsWidget.buildTextTitle(
                            context, 'Nenhum morador cadastrado!'),
                      ),
                      SizedBox(
                        child: ConstsWidget.buildTextSubTitle(
                            'Adicione um morador para essa Unidade'),
                      ),
                    ],
                  );
                  }
                }else { return PageErro();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
