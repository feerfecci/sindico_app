import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:sindico_app/consts/const_widget.dart';
import 'package:sindico_app/consts/consts_future.dart';
import 'package:sindico_app/widgets/my_box_shadow.dart';
import 'package:sindico_app/widgets/page_vazia.dart';
import 'package:sindico_app/widgets/scaffold_all.dart';
import 'package:sindico_app/widgets/shimmer_widget.dart';

import '../../consts/consts.dart';
import 'add_tarefa.dart';

class TarefasScreen extends StatefulWidget {
  const TarefasScreen({super.key});

  @override
  State<TarefasScreen> createState() => _TarefasScreenState();
}

class _TarefasScreenState extends State<TarefasScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: buildScaffoldAll(
        context,
        title: 'Minha Tarefas',
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
                  '${Consts.sindicoApi}tarefas/?fn=listarTarefas&idcond=${ResponsalvelInfos.idcondominio}'),
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
                        var idcondominio = apiTarefas['idcondominio'];
                        var descricao = apiTarefas['descricao'];
                        var data_vencimento = apiTarefas['data_vencimento'];
                        var aviso_dias = apiTarefas['aviso_dias'];
                        var datahora = apiTarefas['datahora'];
                        var ultima_atualizacao =
                            apiTarefas['ultima_atualizacao'];

                        return MyBoxShadow(
                            child: Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            ConstsWidget.buildTextSubTitle('Descrição'),
                            ConstsWidget.buildTextTitle(context, descricao,
                                textAlign: TextAlign.center, maxLines: 6),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            ConstsWidget.buildTextSubTitle(
                                'Data de vencimento'),
                            ConstsWidget.buildTextTitle(
                                context,
                                DateFormat('dd/MM/yyyy')
                                    .format(DateTime.parse(data_vencimento))
                                    .toString()),
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
                                        idtempo: aviso_dias,
                                      ),
                                    );
                                  },
                                ))
                          ],
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
