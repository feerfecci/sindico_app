import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sindico_app/forms/unidades_form.dart';
import 'package:sindico_app/screens/add_morador/lista_morador.dart';
import 'package:sindico_app/screens/unidade/cadastro_unidade.dart';
import 'package:sindico_app/screens/unidade/teste.dart';
import 'package:sindico_app/widgets/header.dart';
import 'package:sindico_app/widgets/scaffold_all.dart';
import 'package:http/http.dart' as http;

import '../../consts/consts.dart';
import '../../consts/const_widget.dart';
import '../../consts/consts_future.dart';
import '../../forms/funcionario_form.dart';
import '../../widgets/my_box_shadow.dart';
import '../../widgets/my_text_form_field.dart';

class ListaUnidades extends StatefulWidget {
  const ListaUnidades({super.key});

  @override
  State<ListaUnidades> createState() => _ListaUnidadeStates();
}

class _ListaUnidadeStates extends State<ListaUnidades> {
  bool isChecked = false;
  FormInfosUnidade formInfosUnidade = FormInfosUnidade();

  listarUnidades() async {
    var url = Uri.parse(
        'https://a.portariaapp.com/sindico/api/unidades/?fn=listarUnidades&idcond=${ResponsalvelInfos.idcondominio}');
    var resposta = await http.get(url);

    if (resposta.statusCode == 200) {
      return json.decode(resposta.body);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          listarUnidades();
        });
      },
      child: buildScaffoldAll(
          body: buildHeaderPage(context,
              titulo: 'Unidade',
              subTitulo: 'Adicione e edite unidade',
              widget: ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: [
                  ConstWidget.buildCustomButton(context, 'Adicionar Unidade',
                      onPressed: () => ConstsFuture.navigatorPagePush(
                          context, CadastroUnidades()),
                      icon: Icons.add),
                  FutureBuilder<dynamic>(
                    future: listarUnidades(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Container(
                          color: Colors.red,
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: snapshot.data['unidades'].length,
                        itemBuilder: (context, index) {
                          var itensUnidade = snapshot.data['unidades'][index];
                          var idunidade = itensUnidade['idunidade'];
                          var iddivisao = itensUnidade['iddivisao'];
                          var nome_responsavel =
                              itensUnidade['nome_responsavel'];
                          var nome_condominio = itensUnidade['nome_condominio'];
                          var nome_divisao = itensUnidade['nome_divisao'];
                          var dividido_por = itensUnidade['dividido_por'];
                          var numero = itensUnidade['numero'];
                          var login = itensUnidade['login'];

                          bool ativoUnidade = itensUnidade['ativo'];
                          return MyBoxShadow(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ConstWidget.buildTextTitle(
                                  nome_condominio.toString(),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ConstWidget.buildTextSubTitle(
                                            'Nome do Responsável'),
                                        ConstWidget.buildTextTitle(
                                            nome_responsavel),
                                      ],
                                    ),
                                    ConstWidget.buildAtivoInativo(ativoUnidade),
                                  ],
                                ),
                                SizedBox(
                                  height: size.height * 0.01,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ConstWidget.buildTextSubTitle(
                                            'Localiza do em'),
                                        Row(
                                          children: [
                                            ConstWidget.buildTextTitle(
                                                '$numero - $dividido_por $nome_divisao'),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ConstWidget.buildTextSubTitle('Login:'),
                                        ConstWidget.buildTextTitle(login),
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                ConstWidget.buildCustomButton(
                                  context,
                                  'Acessar Moradores',
                                  onPressed: () =>
                                      ConstsFuture.navigatorPagePush(
                                          context,
                                          ListaMorador(
                                            idunidade: idunidade,
                                            numero: numero,
                                            idvisisao: iddivisao,
                                          )),
                                ),
                                ConstWidget.buildCustomButton(
                                  context,
                                  'Editar Unidades',
                                  onPressed: () {
                                    ConstsFuture.navigatorPagePush(
                                        context,
                                        CadastroUnidades(
                                            idunidade: idunidade,
                                            iddivisao: iddivisao,
                                            nome_responsavel: nome_responsavel,
                                            login: login,
                                            numero: numero,
                                            ativo: ativoUnidade));
                                  },
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ))),
    );
  }
}
