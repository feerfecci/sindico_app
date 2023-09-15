// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sindico_app/consts/consts.dart';
import 'package:sindico_app/consts/consts_future.dart';
import 'package:sindico_app/screens/colaboradores/loding_colab.dart';
import 'package:sindico_app/screens/moradores/cadastro_morador.dart';
import 'package:sindico_app/widgets/my_box_shadow.dart';
import 'package:sindico_app/widgets/page_vazia.dart';
import 'package:sindico_app/widgets/scaffold_all.dart';
import '../../consts/const_widget.dart';
import '../../widgets/page_erro.dart';

class ListaMorador extends StatefulWidget {
  final int? idunidade;
  final String? localizado;
  final int? idvisisao;
  const ListaMorador(
      {this.idvisisao, required this.idunidade, this.localizado, super.key});

  @override
  State<ListaMorador> createState() => _ListaMoradorState();
}

class _ListaMoradorState extends State<ListaMorador> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ConstsWidget.buildRefreshIndicator(
      context,
      onRefresh: () async {
        setState(() {
          ConstsFuture.resquestApi(
              '${Consts.sindicoApi}moradores/?fn=listarMoradores&idunidade=${widget.idunidade}&idcond=${ResponsalvelInfos.idcondominio}&idfuncionario=${ResponsalvelInfos.idfuncionario}');
        });
      },
      child: buildScaffoldAll(
        context,
        title: 'Moradores',
        body: Column(
          children: [
            ConstsWidget.buildPadding001(
              context,
              child: ConstsWidget.buildCustomButton(
                  context, 'Adicionar Morador',
                  color: Consts.kColorRed, icon: Icons.add, onPressed: () {
                ConstsFuture.navigatorPagePush(
                    context,
                    CadastroMorador(
                      localizado: widget.localizado,
                      iddivisao: widget.idvisisao,
                      idunidade: widget.idunidade,
                    ));
              }),
            ),
            FutureBuilder<dynamic>(
              future: ConstsFuture.resquestApi(
                  '${Consts.sindicoApi}moradores/?fn=listarMoradores&idunidade=${widget.idunidade}&idcond=${ResponsalvelInfos.idcondominio}&idfuncionario=${ResponsalvelInfos.idfuncionario}'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingColaboradores();
                }
                if (snapshot.hasData) {
                  if (!snapshot.data['erro']) {
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
                        var data_nascimento = apiMorador['data_nascimento'] !=
                                '0000-00-00'
                            ? DateFormat('dd/MM/yyy').format(
                                DateTime.parse(apiMorador['data_nascimento']))
                            : null;
                        var ddd = apiMorador['ddd'];
                        var telefone = apiMorador['telefone'];
                        var email = apiMorador['email'];
                        var acessa_sistema = apiMorador['acessa_sistema'];
                        var responsavel = apiMorador['responsavel'];
                        int acesso = acessa_sistema ? 1 : 0;

                        return MyBoxShadow(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ConstsWidget.buildTextTitle(
                                    context, nome_morador,
                                    width: 0.7),
                                Container(
                                  child: ConstsWidget.buildAtivoInativo(
                                      context, ativo),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ConstsWidget.buildTextSubTitle(
                                        context, 'Localizado em'),
                                    ConstsWidget.buildTextTitle(context,
                                        '$dividido_por $nome_divisao - $numero',
                                        maxLines: 3, width: 0.55),
                                  ],
                                ),
                                ConstsWidget.buildCheckBox(
                                  context,
                                  isChecked: responsavel == 0 ? false : true,
                                  onChanged: (p0) {},
                                  title: 'Resposável',
                                ),
                              ],
                            ),
                            ConstsWidget.buildPadding001(
                              context,
                              vertical: 0.015,
                              child: Row(
                                mainAxisAlignment: data_nascimento == null
                                    ? MainAxisAlignment.start
                                    : MainAxisAlignment.spaceBetween,
                                children: [
                                  if (data_nascimento != null)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ConstsWidget.buildTextSubTitle(
                                            context, 'Data Nascimento'),
                                        ConstsWidget.buildTextTitle(
                                            context, data_nascimento),
                                      ],
                                    ),
                                  if (data_nascimento != null)
                                    SizedBox(
                                      width: size.width * 0.1,
                                    ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ConstsWidget.buildTextSubTitle(
                                          context, 'Documento'),
                                      ConstsWidget.buildTextTitle(
                                          context, documento),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: telefone == null
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.spaceBetween,
                              children: [
                                if (telefone != '' && ddd != '')
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ConstsWidget.buildTextSubTitle(
                                          context, 'Telefone'),
                                      Row(
                                        children: [
                                          ConstsWidget.buildTextTitle(
                                              context, '($ddd) '),
                                          ConstsWidget.buildTextTitle(
                                              context, telefone),
                                        ],
                                      ),
                                    ],
                                  ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ConstsWidget.buildTextSubTitle(
                                        context, 'Login'),
                                    ConstsWidget.buildTextTitle(context, login),
                                  ],
                                ),
                              ],
                            ),
                            ConstsWidget.buildPadding001(context,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ConstsWidget.buildTextSubTitle(
                                        context, 'Email'),
                                    ConstsWidget.buildTextTitle(context, email,
                                        maxLines: 2, width: 1),
                                  ],
                                )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: size.width * 0.6,
                                  child: ConstsWidget.buildCheckBox(
                                    context,
                                    title: 'Acesso ao sistema',
                                    isChecked: acessa_sistema,
                                    onChanged: (value) {},
                                  ),
                                ),
                              ],
                            ),
                            ConstsWidget.buildCustomButton(
                                context, 'Editar Morador', onPressed: () {
                              // Navigator.pushReplacement(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => CadastroMorador(
                              //         idmorador: idmorador,
                              //         iddivisao: iddivisao,
                              //         idunidade: idunidade,
                              //         localizado: widget.localizado,
                              //         nome_morador: nome_morador,
                              //         login: login,
                              //         documento: documento,
                              //         nascimento: data_nascimento,
                              //         telefone: telefone,
                              //         ddd: ddd,
                              //         acesso: acesso,
                              //         ativo: ativo,
                              //         responsavel: responsavel,
                              //         email: email),
                              //   ),
                              // );
                              // Navigator.replace(
                              //   context,
                              //   oldRoute: MaterialPageRoute(
                              //     builder: (context) =>
                              //         ListaMorador(idunidade: widget.idunidade),
                              //   ),
                              // newRoute: MaterialPageRoute(
                              //   builder: (context) => CadastroMorador(
                              //       idmorador: idmorador,
                              //       iddivisao: iddivisao,
                              //       idunidade: idunidade,
                              //       localizado: widget.localizado,
                              //       nome_morador: nome_morador,
                              //       login: login,
                              //       documento: documento,
                              //       nascimento: data_nascimento,
                              //       telefone: telefone,
                              //       ddd: ddd,
                              //       acesso: acesso,
                              //       ativo: ativo,
                              //       responsavel: responsavel,
                              //       email: email),
                              // ),
                              // );
                              // Navigator.pushAndRemoveUntil(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => CadastroMorador(
                              //           idmorador: idmorador,
                              //           iddivisao: iddivisao,
                              //           idunidade: idunidade,
                              //           localizado: widget.localizado,
                              //           nome_morador: nome_morador,
                              //           login: login,
                              //           documento: documento,
                              //           nascimento: data_nascimento,
                              //           telefone: telefone,
                              //           ddd: ddd,
                              //           acesso: acesso,
                              //           ativo: ativo,
                              //           responsavel: responsavel,
                              //           email: email),
                              //     ),
                              //     (route) => false
                              // ConstsFuture.navigatorPageReplace(
                              //   context,
                              //   CadastroMorador(
                              //       idmorador: idmorador,
                              //       iddivisao: iddivisao,
                              //       idunidade: idunidade,
                              //       localizado: widget.localizado,
                              //       nome_morador: nome_morador,
                              //       login: login,
                              //       documento: documento,
                              //       nascimento: data_nascimento,
                              //       telefone: telefone,
                              //       ddd: ddd,
                              //       acesso: acesso,
                              //       ativo: ativo,
                              //       responsavel: responsavel,
                              //       email: email),
                              // );
                              // Navigator.pop(context);

                              ConstsFuture.navigatorPagePush(
                                context,
                                CadastroMorador(
                                    idmorador: idmorador,
                                    iddivisao: iddivisao,
                                    idunidade: idunidade,
                                    localizado: widget.localizado,
                                    nome_morador: nome_morador,
                                    login: login,
                                    documento: documento,
                                    nascimento: data_nascimento,
                                    telefone: telefone,
                                    ddd: ddd,
                                    acesso: acesso,
                                    ativo: ativo,
                                    responsavel: responsavel,
                                    email: email),
                              );
                            })
                          ],
                        ));
                      },
                    );
                  } else {
                    return PageVazia(title: snapshot.data['mensagem']);
                  }
                } else {
                  return PageErro();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
