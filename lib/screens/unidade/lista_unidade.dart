import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sindico_app/forms/morador_form.dart';
import 'package:sindico_app/forms/unidades_form.dart';
import 'package:sindico_app/screens/moradores/lista_morador.dart';
import 'package:sindico_app/screens/unidade/cadastro_unidade.dart';
import 'package:sindico_app/screens/unidade/teste.dart';
import 'package:sindico_app/widgets/header.dart';
import 'package:sindico_app/widgets/scaffold_all.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
        '${Consts.sindicoApi}unidades/?fn=listarUnidades&idcond=${ResponsalvelInfos.idcondominio}');
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
    buildRowUnidade(
        {required String title1,
        required String subTitle1,
        required String title2,
        required String subTitle2}) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstsWidget.buildTextSubTitle(title1),
                Row(
                  children: [
                    ConstsWidget.buildTextTitle(subTitle1),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstsWidget.buildTextSubTitle(title2),
                ConstsWidget.buildTextTitle(subTitle2),
              ],
            )
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          listarUnidades();
        });
      },
      child: buildScaffoldAll(context,
          body: buildHeaderPage(context,
              titulo: ResponsalvelInfos.nome_condominio,
              subTitulo: 'Adicione e edite unidade',
              widget: ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: [
                  ConstsWidget.buildCustomButton(context, 'Adicionar Unidade',
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
                          var data_nascimento = DateFormat('dd/MM/yyyy').format(
                              DateTime.parse(itensUnidade['data_nascimento']));
                          var documento = itensUnidade['documento'];
                          var email = itensUnidade['email'];
                          var ddd = itensUnidade['dddtelefone'];
                          var telefone = itensUnidade['telefone'];
                          var login = itensUnidade['login'];

                          bool ativoUnidade = itensUnidade['ativo'];
                          return MyBoxShadow(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ConstsWidget.buildTextSubTitle(
                                            'Nome do Responsável'),
                                        ConstsWidget.buildTextTitle(
                                            nome_responsavel),
                                      ],
                                    ),
                                    ConstsWidget.buildAtivoInativo(
                                        ativoUnidade),
                                  ],
                                ),
                                buildRowUnidade(
                                    title1: 'Localiza do em',
                                    subTitle1:
                                        '$numero - $dividido_por $nome_divisao',
                                    title2: 'Login:',
                                    subTitle2: login),
                                buildRowUnidade(
                                    title1: 'Nascimento:',
                                    subTitle1: data_nascimento,
                                    title2: 'Documento:',
                                    subTitle2: documento),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: size.height * 0.01),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ConstsWidget.buildTextSubTitle('Email:'),
                                      ConstsWidget.buildTextTitle(email),
                                    ],
                                  ),
                                ),
                                ConstsWidget.buildCustomButton(
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
                                          ativo: ativoUnidade,
                                          dataNascimento: data_nascimento,
                                          documento: documento,
                                          email: email,
                                          ddd: ddd,
                                          telefone: telefone,
                                        ));
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
