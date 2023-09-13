import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:sindico_app/consts/const_widget.dart';
import 'package:sindico_app/consts/consts_future.dart';
import 'package:sindico_app/widgets/alert_dialogs/alertdialog_all.dart';
import 'package:sindico_app/widgets/my_box_shadow.dart';
import 'package:sindico_app/widgets/page_vazia.dart';
import 'package:sindico_app/widgets/scaffold_all.dart';
import 'package:sindico_app/widgets/shimmer_widget.dart';
import 'package:sindico_app/widgets/snackbar/snack.dart';

import '../../consts/consts.dart';
import 'add_tarefa.dart';

class TarefasScreen extends StatefulWidget {
  static List qntTarefas = [];
  const TarefasScreen({super.key});

  @override
  State<TarefasScreen> createState() => _TarefasScreenState();
}

Future apiTarefas() async {
  ConstsFuture.resquestApi(
          '${Consts.sindicoApi}tarefas/?fn=listarTarefas&idcond=${ResponsalvelInfos.idcondominio}&idfuncionario=${ResponsalvelInfos.idfuncionario}')
      .then((value) {
    if (!value['erro']) {
      for (var i = 0; i <= value['tarefas'].length - 1; i++) {
        Duration diferencia =
            DateTime.parse(value['tarefas'][i]['data_vencimento'])
                .difference(DateTime.now());

        if (diferencia.inDays == 0 &&
            !TarefasScreen.qntTarefas
                .contains(value['tarefas'][i]['idtarefa'])) {
          TarefasScreen.qntTarefas.add(value['tarefas'][i]['idtarefa']);
        }
      }
    }
  });
}

class _TarefasScreenState extends State<TarefasScreen> {
  @override
  void initState() {
    apiTarefas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: buildScaffoldAll(
        context,
        title: 'Minhas Tarefas',
        body: Column(
          children: [
            ConstsWidget.buildCustomButton(
              context,
              'Adicionar Tarefa',
              icon: Icons.add,
              onPressed: () {
                ConstsFuture.navigatorPagePush(context, AdicionarTarefa());
              },
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            FutureBuilder(
              future: ConstsFuture.resquestApi(
                  '${Consts.sindicoApi}tarefas/?fn=listarTarefas&idcond=${ResponsalvelInfos.idcondominio}&idfuncionario=${ResponsalvelInfos.idfuncionario}'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: 5,
                      itemBuilder: (context, snapshot) {
                        return MyBoxShadow(
                          child: Column(
                            children: [
                              ShimmerWidget(
                                height: size.height * 0.04,
                                width: size.height * 0.3,
                              ),
                              ConstsWidget.buildPadding001(context,
                                  child: ShimmerWidget(
                                      height: size.height * 0.07)),
                              ShimmerWidget(
                                height: size.height * 0.07,
                                circular: 30,
                              ),
                            ],
                          ),
                        );
                      });
                } else if (snapshot.hasData) {
                  if (!snapshot.data['erro']) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: snapshot.data['tarefas'].length,
                      itemBuilder: (context, index) {
                        var apiTarefas = snapshot.data['tarefas'][index];

                        var idtarefa = apiTarefas['idtarefa'];
                        var concluida = apiTarefas['concluida'];
                        var idcondominio = apiTarefas['idcondominio'];
                        var descricao = apiTarefas['descricao'];
                        var data_vencimento = apiTarefas['data_vencimento'];
                        var aviso_dias = apiTarefas['aviso_dias'];
                        var txt_aviso_dias = apiTarefas['txt_aviso_dias'];
                        var repetir_dias = apiTarefas['repetir_dias'];
                        var texto_repetir_dias =
                            apiTarefas['texto_repetir_dias'];
                        var datahora = apiTarefas['datahora'];
                        var ultima_atualizacao =
                            apiTarefas['ultima_atualizacao'];
                        bool isToday = false;
                        if (TarefasScreen.qntTarefas.contains(idtarefa)) {
                          isToday = true;
                        }
                        return MyBoxShadow(
                            child: ConstsWidget.buildBadge(
                          context,
                          showBadge: isToday,
                          position:
                              BadgePosition.topEnd(end: size.width * 0.015),
                          child: Column(
                            children: [
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: double.maxFinite,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            showAllDialog(context,
                                                title:
                                                    ConstsWidget.buildTextTitle(
                                                        context,
                                                        'Excluir tarefa'),
                                                children: [
                                                  ConstsWidget.buildTextTitle(
                                                      context,
                                                      'Ao continuar você não recebará mais aviso sobre está tarefa',
                                                      textAlign:
                                                          TextAlign.center),
                                                  SizedBox(
                                                    height: size.height * 0.01,
                                                  ),
                                                  ConstsWidget.buildPadding001(
                                                    context,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        ConstsWidget
                                                            .buildOutlinedButton(
                                                          context,
                                                          title: '  Cancelar  ',
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                        ConstsWidget
                                                            .buildCustomButton(
                                                          context,
                                                          '  Excluir  ',
                                                          color:
                                                              Consts.kColorRed,
                                                          onPressed: () {
                                                            ConstsFuture.resquestApi(
                                                                    '${Consts.sindicoApi}tarefas/?fn=excluirTarefa&idtarefa=$idtarefa&idfuncionario=${ResponsalvelInfos.idfuncionario}')
                                                                .then((value) {
                                                              if (!value[
                                                                  'erro']) {
                                                                Navigator.pop(
                                                                    context);
                                                                setState(() {});
                                                              }
                                                            });
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ]);
                                          },
                                          child: Icon(
                                            Icons.delete_outlined,
                                            color: Colors.red,
                                            size: 30,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            showAllDialog(context,
                                                barrierDismissible: true,
                                                title:
                                                    ConstsWidget.buildTextTitle(
                                                        context,
                                                        !concluida
                                                            ? 'Concluir Tarefa'
                                                            : 'Reativar Tarefa'),
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      ConstsWidget
                                                          .buildOutlinedButton(
                                                        context,
                                                        title: '  Cancelar  ',
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                      ConstsWidget
                                                          .buildCustomButton(
                                                        context,
                                                        !concluida
                                                            ? ' Concluir '
                                                            : ' Reativar ',
                                                        onPressed: () {
                                                          ConstsFuture.resquestApi(
                                                                  '${Consts.sindicoApi}tarefas/?fn=editarTarefa&idcond=${ResponsalvelInfos.idcondominio}&idfuncionario=${ResponsalvelInfos.idfuncionario}&idtarefa=$idtarefa&concluida=${concluida ? 0 : 1}&descricao=$descricao&data_vencimento=$data_vencimento&aviso_dias=$aviso_dias&repetir_dias=$repetir_dias')
                                                              .then((value) {
                                                            if (!value[
                                                                'erro']) {
                                                              Navigator.pop(
                                                                  context);
                                                              setState(() {});
                                                            } else {
                                                              return buildMinhaSnackBar(
                                                                  context,
                                                                  title:
                                                                      'Algo Saiu Mau',
                                                                  subTitle: value[
                                                                      'mensagem']);
                                                            }
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  )
                                                ]);
                                          },
                                          child: Icon(
                                            Icons.check_circle_outline_outlined,
                                            color: concluida
                                                ? Colors.blue
                                                : Colors.grey,
                                            size: 30,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.width * 0.77,
                                    child: ConstsWidget.buildTextTitle(
                                        context, descricao,
                                        textAlign: TextAlign.center),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              if (!isToday)
                                ConstsWidget.buildTextTitle(
                                    context, 'Data de vencimento'),
                              if (isToday)
                                ConstsWidget.buildTextTitle(
                                    context, 'Vence Hoje',
                                    color: Consts.kColorRed),
                              ConstsWidget.buildTextSubTitle(
                                DateFormat('dd/MM/yyyy HH:mm')
                                    .format(DateTime.parse(data_vencimento))
                                    .toString(),
                                // color: isToday ? Consts.kColorRed : null,
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              if (aviso_dias == 0 && repetir_dias == 1)
                                ConstsWidget.buildTextTitle(
                                    context, 'Tarefa Diária',
                                    color: Colors.red),
                              // if (aviso_dias == 0 && repetir_dias == 0)
                              //   ConstsWidget.buildTextTitle(
                              //       context, 'Apenas Hoje',
                              //       color: Colors.red),
                              if ((aviso_dias == 0 &&
                                      repetir_dias != 1 &&
                                      repetir_dias != 0) ||
                                  (aviso_dias != 0 && repetir_dias != 1))
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ConstsWidget.buildTextSubTitle(
                                            'Será avisado '),
                                        ConstsWidget.buildTextTitle(
                                            context, '$txt_aviso_dias '),
                                        if (aviso_dias != 0)
                                          ConstsWidget.buildTextSubTitle(
                                              'antes'),
                                      ],
                                    ),
                                    SizedBox(
                                      height: size.height * 0.01,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ConstsWidget.buildTextSubTitle(
                                            'Repetir a cada '),
                                        ConstsWidget.buildTextTitle(
                                            context, '$texto_repetir_dias '),
                                      ],
                                    ),
                                  ],
                                ),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              ConstsWidget.buildPadding001(context,
                                  child: ConstsWidget.buildOutlinedButton(
                                    context,
                                    title: 'Editar Tarefa',
                                    onPressed: () {
                                      ConstsFuture.navigatorPagePush(
                                        context,
                                        AdicionarTarefa(
                                          idtarefa: idtarefa,
                                          nomeTarefaCtrl: descricao,
                                          initialDate: data_vencimento,
                                          aviso_dias: aviso_dias,
                                          repetir_dias: repetir_dias,
                                        ),
                                      );
                                    },
                                  ))
                            ],
                          ),
                        ));
                      },
                    );
                  } else {
                    return PageVazia(title: snapshot.data['mensagem']);
                  }
                } else {
                  return Container();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
