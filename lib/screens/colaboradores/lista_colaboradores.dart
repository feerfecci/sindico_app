// ignore_for_file: non_constant_identifier_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sindico_app/screens/colaboradores/cadastro_colab.dart';
import 'package:sindico_app/screens/splash_screen/splash_screen.dart';
import 'package:sindico_app/widgets/my_box_shadow.dart';
import 'package:sindico_app/widgets/page_vazia.dart';
import 'package:sindico_app/widgets/scaffold_all.dart';
import 'package:http/http.dart' as http;
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
      '${Consts.sindicoApi}funcionarios/?fn=listarFuncionarios&idcond=${ResponsalvelInfos.idcondominio}&idfuncionariologado=${ResponsalvelInfos.idfuncionario}');
  var resposta = await http.get(url);

  if (resposta.statusCode == 200) {
    return json.decode(resposta.body);
  } else {
    return null;
  }
}

class _ListaColaboradoresState extends State<ListaColaboradores> {
  @override
  void dispose() {
    listarFuncionario();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Widget buildRowInfos(
        {required String titulo1,
        required String texto1,
        required String titulo2,
        required String texto2,
        double width = 0.4}) {
      return ConstsWidget.buildPadding001(
        context,
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(
            width: size.width * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstsWidget.buildTextSubTitle(context, titulo1),
                ConstsWidget.buildTextTitle(context, texto1),
              ],
            ),
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstsWidget.buildTextSubTitle(context, titulo2),
              SizedBox(
                  width: size.width * width,
                  child: ConstsWidget.buildTextTitle(context, texto2)),
            ],
          ),
        ]),
      );
    }

    Widget buildTilePermissaoSalvo(String title,
        {bool isChecked = false, double width = 0.43}) {
      return ConstsWidget.buildPadding001(
        context,
        vertical: 0.005,
        child: Container(
          height:
              SplashScreen.isSmall ? size.height * 0.08 : size.height * 0.06,
          width: size.width * width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
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
                  color: Consts.kColorRed,
                  onPressed: () {
                    FocusManager.instance.primaryFocus!.unfocus();
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
                            bool envia_avisos = api['envia_avisos'];
                            String email = api['email'];

                            String documento = api['documento'];
                            String ddd = api['dddtelefone'];
                            String telefone = api['telefone'];
                            String? data_nascimento =
                                api['datanasc'] != "0000-00-00"
                                    ? DateFormat('dd/MM/yyyy')
                                        .format(DateTime.parse(api['datanasc']))
                                    : null;

                            return ConstsWidget.buildPadding001(
                              context,
                              vertical: 0.005,
                              child: MyBoxShadow(
                                child: ConstsWidget.buildPadding001(
                                  context,
                                  horizontal: 0.01,
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                        dividerColor: Colors.transparent),
                                    child: ExpansionTile(
                                      tilePadding: EdgeInsets.only(
                                          left: size.width * 0.01),
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ConstsWidget.buildTextTitle(
                                                context,
                                                nome_funcionario,
                                                width: 0.6,
                                              ),
                                              ConstsWidget.buildTextSubTitle(
                                                  context,
                                                  width: 0.4,
                                                  '$funcao'),
                                            ],
                                          ),
                                          ConstsWidget.buildAtivoInativo(
                                              context, ativo),
                                        ],
                                      ),
                                      expandedCrossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      childrenPadding: EdgeInsets.only(
                                          left: size.width * 0.01),
                                      children: [
                                        // Row(
                                        //   mainAxisSize: MainAxisSize.min,
                                        //   children: [
                                        //     ConstsWidget.buildTextTitle(
                                        //         context,
                                        //         width: 0.6,
                                        //         '$nome_funcionario'),
                                        //     Spacer(),
                                        //     ConstsWidget.buildAtivoInativo(
                                        //         context, ativo),
                                        //   ],
                                        // ),
                                        SizedBox(
                                          height: size.height * 0.02,
                                        ),
                                        SizedBox(
                                          width: size.width * 0.9,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ConstsWidget.buildTextSubTitle(
                                                  context, 'Login'),
                                              ConstsWidget.buildTextTitle(
                                                  context, login_funcionario),
                                            ],
                                          ),
                                        ),
                                        // buildRowInfos(
                                        //     titulo1: 'Usuário',
                                        //     texto1: login_funcionario,
                                        //     titulo2: 'Cargo',
                                        //     width: 0.3,
                                        //     texto2: funcao),
                                        ConstsWidget.buildPadding001(
                                          context,
                                          child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  data_nascimento == null
                                                      ? MainAxisAlignment.start
                                                      : MainAxisAlignment
                                                          .spaceBetween,
                                              children: [
                                                if (data_nascimento != null)
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      ConstsWidget
                                                          .buildTextSubTitle(
                                                              context,
                                                              'Nascimento'),
                                                      ConstsWidget
                                                          .buildTextTitle(
                                                              context,
                                                              data_nascimento),
                                                    ],
                                                  ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ConstsWidget
                                                        .buildTextSubTitle(
                                                            context,
                                                            'Documento'),
                                                    ConstsWidget.buildTextTitle(
                                                        context, documento),
                                                  ],
                                                ),
                                              ]),
                                        ),

                                        /*     buildRowInfos(
                                              titulo1: 'Telefone',
                                              texto1: '($ddd) $telefone',
                                              titulo2: 'Documento',
                                              texto2: documento),
                                          buildRowInfos(
                                              titulo1: 'Email',
                                              texto1: email,
                                              titulo2: 'Nascimento',
                                              texto2: data_nascimento),*/

                                        if (telefone != '')
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ConstsWidget.buildTextSubTitle(
                                                  context, 'Telefone'),
                                              ConstsWidget.buildTextTitle(
                                                  context, '($ddd) $telefone'),
                                            ],
                                          ),
                                        SizedBox(
                                          height: size.height * 0.01,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ConstsWidget.buildTextSubTitle(
                                                context, 'Email'),
                                            ConstsWidget.buildTextTitle(
                                                context, email,
                                                maxLines: 2, width: 1),
                                          ],
                                        ),
                                        if (funcao != 'Síndico' &&
                                            funcao != 'Subsíndico' &&
                                            funcao != 'Administrador')
                                          Column(
                                            children: [
                                              SizedBox(
                                                height: size.height * 0.02,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Column(
                                                    children: [
                                                      buildTilePermissaoSalvo(
                                                          'Cartas',
                                                          isChecked:
                                                              avisa_corresp),
                                                      buildTilePermissaoSalvo(
                                                          'Delivery',
                                                          isChecked:
                                                              avisa_delivery),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      buildTilePermissaoSalvo(
                                                          'Visitas',
                                                          isChecked:
                                                              avisa_visita),
                                                      buildTilePermissaoSalvo(
                                                          'Caixas',
                                                          isChecked:
                                                              avisa_encomendas),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        SizedBox(
                                          height: size.height * 0.01,
                                        ),
                                        ConstsWidget.buildPadding001(
                                          context,
                                          child: buildTilePermissaoSalvo(
                                              'Avisos Gerais',
                                              width: double.maxFinite,
                                              isChecked: envia_avisos),
                                        ),
                                        SizedBox(
                                          height: size.height * 0.02,
                                        ),
                                        ConstsWidget.buildCustomButton(
                                          context,
                                          'Editar',
                                          onPressed: () {
                                            ConstsFuture.navigatorPagePush(
                                                context,
                                                CadastroColaborador(
                                                    idfuncionario:
                                                        idfuncionario,
                                                    nomeFuncionario:
                                                        nome_funcionario,
                                                    idfuncao: idfuncao,
                                                    funcao: funcao,
                                                    nascimento: api['datanasc'],
                                                    documento: documento,
                                                    ddd: ddd,
                                                    telefone: telefone,
                                                    email: email,
                                                    login: login_funcionario,
                                                    avisa_corresp:
                                                        avisa_corresp,
                                                    avisa_visita: avisa_visita,
                                                    avisa_delivery:
                                                        avisa_delivery,
                                                    avisa_encomendas:
                                                        avisa_encomendas,
                                                    envia_avisos: envia_avisos,
                                                    ativo: ativo ? 1 : 0));
                                          },
                                        )
                                      ],
                                    ),
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
