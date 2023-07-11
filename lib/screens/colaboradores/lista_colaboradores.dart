// ignore_for_file: non_constant_identifier_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sindico_app/screens/colaboradores/cadastro_colab.dart';
import 'package:sindico_app/widgets/header.dart';
import 'package:sindico_app/widgets/my_box_shadow.dart';
import 'package:sindico_app/widgets/page_vazia.dart';
import 'package:sindico_app/widgets/scaffold_all.dart';
import 'package:http/http.dart' as http;
import 'package:sindico_app/widgets/shimmer_widget.dart';
import '../../consts/consts.dart';
import '../../consts/const_widget.dart';
import '../../consts/consts_future.dart';
import '../../widgets/page_erro.dart';
import 'loding_colab.dart';

class ListaColaboradores extends StatefulWidget {
  const ListaColaboradores({super.key});

  @override
  State<ListaColaboradores> createState() => _ListaColaboradoresState();
}

listarFuncionario() async {
  var url = Uri.parse(
      '${Consts.sindicoApi}funcionarios/?fn=listarFuncionarios&idcond=${ResponsalvelInfos.idcondominio}');
  var resposta = await http.get(url);

  if (resposta.statusCode == 200) {
    return json.decode(resposta.body);
  } else {
    return null;
  }
}

class _ListaColaboradoresState extends State<ListaColaboradores> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Widget buildRowInfos({
      required String titulo1,
      required String texto1,
      required String titulo2,
      required String texto2,
    }) {
      return ConstsWidget.buildPadding001(
        context,
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstsWidget.buildTextSubTitle(titulo1),
              ConstsWidget.buildTextTitle(context, texto1),
            ],
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstsWidget.buildTextSubTitle(titulo2),
              ConstsWidget.buildTextTitle(context, texto2),
            ],
          ),
        ]),
      );
    }

    Widget buildTilePermissaoSalvo(String title, {bool isChecked = false}) {
      return ConstsWidget.buildPadding001(
        context,
        vertical: 0.005,
        child: Container(
          height: size.height * 0.05,
          width: size.width * 0.43,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            color: isChecked ? Consts.kColorVerde : Colors.grey,
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

    return ConstsWidget.buildRefreshIndicator(
      context,
      onRefresh: () async {
        setState(
          () {
            listarFuncionario();
          },
        );
      },
      child: buildScaffoldAll(context,
          title: 'Colaboradores',
          body: ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: [
              // EditarFuncionario(),
              ConstsWidget.buildPadding001(
                context,
                child: ConstsWidget.buildCustomButton(
                  context,
                  'Adicionar Colaborador',
                  icon: Icons.add,
                  color: Consts.kColorRed,
                  onPressed: () {
                    ConstsFuture.navigatorPagePush(
                        context, CadastroColaborador());
                  },
                ),
              ),

              FutureBuilder<dynamic>(
                  future: listarFuncionario(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return LoadingColaboradores();
                    } else if (!snapshot.hasError) {
                      if (!snapshot.data['erro']) {
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
                            var idfuncao = api['idfuncao'];
                            var funcao = api['funcao'];
                            bool avisa_corresp = api['avisa_corresp'];
                            bool avisa_visita = api['avisa_visita'];
                            bool avisa_delivery = api['avisa_delivery'];
                            bool avisa_encomendas = api['avisa_encomendas'];

                            String documento = '500929816';
                            String ddd = '11';
                            String telefone = '942169968';
                            String email = 'exemplo@ex.com';
                            String data_nascimento = DateFormat('dd/MM/yyyy')
                                .format(DateTime.parse('1997-09-25'));

                            return ConstsWidget.buildPadding001(
                              context,
                              vertical: 0.005,
                              child: MyBoxShadow(
                                child: ConstsWidget.buildPadding001(
                                  context,
                                  horizontal: 0.01,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                              width: size.width * 0.7,
                                              child:
                                                  ConstsWidget.buildTextTitle(
                                                      context,
                                                      '$nome_funcionario')),
                                          Spacer(),
                                          ConstsWidget.buildAtivoInativo(
                                              context, ativo),
                                        ],
                                      ),
                                      buildRowInfos(
                                          titulo1: 'Usuário',
                                          texto1: '$login_funcionario',
                                          titulo2: 'Cargo',
                                          texto2: '$funcao'),
                                      buildRowInfos(
                                          titulo1: 'Telefone',
                                          texto1: '($ddd) $telefone',
                                          titulo2: 'Documento',
                                          texto2: documento),
                                      buildRowInfos(
                                          titulo1: 'Email',
                                          texto1: email,
                                          titulo2: 'Nascimento',
                                          texto2: data_nascimento),
                                      ConstsWidget.buildPadding001(
                                        context,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Column(
                                              children: [
                                                buildTilePermissaoSalvo(
                                                    'Cartas',
                                                    isChecked: avisa_corresp),
                                                buildTilePermissaoSalvo(
                                                    'Delivery',
                                                    isChecked: avisa_delivery),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                buildTilePermissaoSalvo(
                                                    'Visitas',
                                                    isChecked: avisa_visita),
                                                buildTilePermissaoSalvo(
                                                    'Caixas',
                                                    isChecked:
                                                        avisa_encomendas),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      ConstsWidget.buildOutlinedButton(
                                        context,
                                        title: 'Editar',
                                        onPressed: () {
                                          ConstsFuture.navigatorPagePush(
                                              context,
                                              CadastroColaborador(
                                                  idfuncionario: idfuncionario,
                                                  nomeFuncionario:
                                                      nome_funcionario,
                                                  idfuncao: idfuncao,
                                                  funcao: funcao,
                                                  nascimento: data_nascimento,
                                                  documento: documento,
                                                  ddd: ddd,
                                                  telefone: telefone,
                                                  email: email,
                                                  login: login_funcionario,
                                                  avisa_corresp: avisa_corresp,
                                                  avisa_visita: avisa_visita,
                                                  avisa_delivery:
                                                      avisa_delivery,
                                                  avisa_encomendas:
                                                      avisa_encomendas,
                                                  ativo: ativo ? 1 : 0));
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return PageVazia(title: snapshot.data['mensagem']);
                      }
                    } else {
                      return PageErro();
                    }
                  }),
            ],
          )),
    );
  }
}
