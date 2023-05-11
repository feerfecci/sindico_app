// ignore_for_file: non_constant_identifier_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sindico_app/main.dart';
import 'package:sindico_app/screens/funcionarios/cadastro_func.dart';
import 'package:sindico_app/widgets/header.dart';
import 'package:sindico_app/widgets/my_box_shadow.dart';
import 'package:sindico_app/widgets/my_text_form_field.dart';
import 'package:sindico_app/widgets/scaffold_all.dart';
import 'package:validatorless/validatorless.dart';
import 'package:http/http.dart' as http;
import '../../consts/consts.dart';
import 'package:crypto/crypto.dart';

import '../../consts/const_widget.dart';

class ListaFuncionarios extends StatefulWidget {
  const ListaFuncionarios({super.key});

  @override
  State<ListaFuncionarios> createState() => _ListaFuncionariosState();
}

listarFuncionario() async {
  var url = Uri.parse(
      'https://a.portariaapp.com/sindico/api/funcionarios/?fn=listarFuncionarios&idcond=${ResponsalvelInfos.idcondominio}');
  var resposta = await http.get(url);

  if (resposta.statusCode == 200) {
    return json.decode(resposta.body);
  } else {
    return null;
  }
}

class _ListaFuncionariosState extends State<ListaFuncionarios> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Widget buildTilePermissaoSalvo(String title, {bool isChecked = false}) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.005),
        child: Container(
          height: size.height * 0.05,
          width: size.width * 0.43,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            color: isChecked ? Colors.green : Colors.grey,
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        setState(
          () {
            listarFuncionario();
          },
        );
      },
      child: buildScaffoldAll(
        body: buildHeaderPage(context,
            titulo: 'Funcionários',
            subTitulo: 'Adicione e edite colaboradores',
            widget: ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: [
                // EditarFuncionario(),
                ConstWidget.buildCustomButton(
                  context,
                  'Adicionar Funcionário',
                  onPressed: () {
                    Consts.navigatorPageRoute(context, CadastroFuncionario());
                  },
                ),
                FutureBuilder<dynamic>(
                    future: listarFuncionario(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Container(
                          height: 30,
                          width: 30,
                          color: Colors.red,
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: snapshot.data['funcionarios'].length,
                        itemBuilder: (context, index) {
                          var api = snapshot.data['funcionarios'][index];
                          var idfuncionario = api['idfuncionario'];
                          var ativo = api['ativo'];
                          var nome_funcionario = api['nome_funcionario'];
                          var login_funcionario = api['login'];
                          var funcao = api['funcao'];
                          bool avisa_corresp = api['avisa_corresp'];
                          bool avisa_visita = api['avisa_visita'];
                          bool avisa_delivery = api['avisa_delivery'];
                          bool avisa_encomendas = api['avisa_encomendas'];

                          return MyBoxShadow(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ConstWidget.buildTextSubTitle('Nome'),
                                        SizedBox(
                                            width: size.width * 0.7,
                                            child: ConstWidget.buildTextTitle(
                                                '$nome_funcionario')),
                                      ],
                                    ),
                                    SizedBox(
                                      width: size.width * 0.02,
                                    ),
                                    ConstWidget.buildAtivoInativo(ativo),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        ConstWidget.buildTextSubTitle(
                                            'Usuário'),
                                        ConstWidget.buildTextTitle(
                                            '$login_funcionario'),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        ConstWidget.buildTextSubTitle('Cargo'),
                                        ConstWidget.buildTextTitle('$funcao'),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 30,
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: size.height * 0.01),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        children: [
                                          buildTilePermissaoSalvo(
                                              'Correspondências',
                                              isChecked: avisa_corresp),
                                          buildTilePermissaoSalvo('Delivery',
                                              isChecked: avisa_delivery),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          buildTilePermissaoSalvo('Visitas',
                                              isChecked: avisa_visita),
                                          buildTilePermissaoSalvo('Encomendas',
                                              isChecked: avisa_encomendas),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                ConstWidget.buildCustomButton(
                                  context,
                                  'Editar',
                                  onPressed: () {
                                    Consts.navigatorPageRoute(
                                        context,
                                        CadastroFuncionario(
                                          idfuncionario: idfuncionario,
                                          nomeFuncionario: nome_funcionario,
                                          funcao: funcao,
                                          login: login_funcionario,
                                          avisa_corresp: avisa_corresp,
                                          avisa_visita: avisa_visita,
                                          avisa_delivery: avisa_delivery,
                                          avisa_encomendas: avisa_encomendas,
                                        ));
                                  },
                                )
                              ],
                            ),
                          );
                        },
                      );
                    }),
              ],
            )),
      ),
    );
  }
}
