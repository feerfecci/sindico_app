import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sindico_app/consts/const_widget.dart';
import 'package:sindico_app/consts/consts_future.dart';
import 'package:sindico_app/widgets/date_picker.dart';
import 'package:sindico_app/widgets/my_box_shadow.dart';
import 'package:sindico_app/widgets/my_text_form_field.dart';
import 'package:sindico_app/widgets/scaffold_all.dart';
import 'package:sindico_app/widgets/snack.dart';

import '../../consts/consts.dart';
import '../splash_screen/splash_screen.dart';

// ignore: must_be_immutable
class AdicionarTarefa extends StatefulWidget {
  int? idtarefa;
  int? aviso_dias;
  int? repetir_dias;
  String? dateSelected;
  String? nomeTarefaCtrl;

  AdicionarTarefa(
      {this.idtarefa,
      this.dateSelected,
      this.nomeTarefaCtrl,
      this.aviso_dias,
      this.repetir_dias,
      super.key});

  @override
  State<AdicionarTarefa> createState() => _AdicionarTarefaState();
}

Object? dropdownAvisoDias;
Object? dropdownRepetirDias;
bool isLoading = false;
bool isRepet = false;
bool isDayle = false;
List<dynamic> listAviso_dias = [
  // {
  //   'idtempo': 30,
  //   'nometempo': '30 Dias Antes',
  // },
  // {
  //   'idtempo': 15,
  //   'nometempo': '15 Dias Antes',
  // },
  // {
  //   'idtempo': 7,
  //   'nometempo': '7 Dias Antes',
  // },
  // {
  //   'idtempo': 5,
  //   'nometempo': '5 Dias Antes',
  // },
  // {
  //   'idtempo': 2,
  //   'nometempo': '2 Dias Antes',
  // },
  // {
  //   'idtempo': 1,
  //   'nometempo': '1 Dia Antes',
  // },
  // {
  //   'idtempo': 0,
  //   'nometempo': 'No dia',
  // },
];
List<dynamic> listRepetir = [];

class _AdicionarTarefaState extends State<AdicionarTarefa> {
  final GlobalKey<FormState> keyTarefa = GlobalKey<FormState>();
  String dataSelected = '';
  String nomeTarefaCtrl = '';
  int diferenca = 0;

  apiListarDiasAvisar() {
    ConstsFuture.resquestApi(
            '${Consts.sindicoApi}tarefas_dias/?fn=listarDiasAvisar')
        .then((value) {
      if (value != null) {
        setState(() {
          listAviso_dias = value['listar_dias_avisar'];
        });
      }
    });
  }

  apiListarDiasRepetir() {
    ConstsFuture.resquestApi(
            '${Consts.sindicoApi}tarefas_dias/?fn=listarDiasRepetir')
        .then((value) {
      if (value != null) {
        setState(() {
          listRepetir = value['listar_dias_repetir'];
        });
      }
    });
  }

  initDatas() {
    if (widget.aviso_dias == 0 && widget.repetir_dias == 1 ||
        widget.aviso_dias == null) {
      isDayle = true;
      isRepet = true;
      dropdownAvisoDias = null;
      dropdownRepetirDias = null;
    } else if (widget.aviso_dias == 0 && widget.repetir_dias != 0 ||
        widget.aviso_dias != 0 && widget.repetir_dias != 0) {
      isDayle = false;
      isRepet = true;
      dropdownAvisoDias = widget.aviso_dias;
      dropdownRepetirDias = widget.repetir_dias;
    }
  }

  @override
  void initState() {
    initDatas();
    apiListarDiasRepetir();
    apiListarDiasAvisar();
    MyDatePicker.dataSelected = widget.dateSelected ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    startSaveTarefa() {
      setState(() {
        isLoading = true;
      });
      String incluirEditar = widget.idtarefa == null
          ? 'incluirTarefa'
          : 'editarTarefa&idtarefa=${widget.idtarefa}';

      String dateTarefa = DateFormat('yyyy-MM-dd HH:mm:ss')
          .format(DateTime.parse(MyDatePicker.dataSelected));
      ConstsFuture.resquestApi(
              '${Consts.sindicoApi}tarefas/?fn=$incluirEditar&idcond=${ResponsalvelInfos.idcondominio}&idfuncionario=${ResponsalvelInfos.idfuncionario}&descricao=$nomeTarefaCtrl&data_vencimento=$dateTarefa&aviso_dias=${isRepet && isDayle ? '0' : !isRepet && !isDayle ? '0' : dropdownAvisoDias.toString()}&repetir_dias=${isDayle ? 1 : !isRepet && !isDayle ? '0' : dropdownRepetirDias.toString()}')
          .then((value) {
        setState(() {
          isLoading = false;
        });
        if (!value['erro']) {
          // setState(() {
          //   dropdownRepetirDias == null;
          //   dropdownAvisoDias == null;
          // });
          ConstsFuture.navigatorPopPush(context, '/tarefasScreen');

          buildMinhaSnackBar(context,
              hasError: value['erro'],
              title: 'Muito bem!',
              subTitle: value['mensagem']);
        } else {
          buildMinhaSnackBar(context,
              hasError: value['erro'],
              title: 'algo saiu mal',
              subTitle: value['mensagem']);
        }
      });
    }

    startTarefaSind(validForm) {
      keyTarefa.currentState?.save();
      if (validForm && MyDatePicker.dataSelected != '') {
        if (isDayle) {
          startSaveTarefa();
        } else if (dropdownRepetirDias != null && dropdownAvisoDias != null) {
          startSaveTarefa();
        } else if (!isRepet) {
          startSaveTarefa();
        } else {
          buildMinhaSnackBar(context,
              hasError: true,
              title: 'Cuidado!',
              subTitle: 'Complete as informações');
        }
      }
    }

    // String? initialDate;
    // if (widget.dateSelected != null) {
    //   initialDate = widget.dateSelected != null
    //       ? DateFormat('dd/MM/yyyy HH:mm')
    //           .format(DateTime.parse(widget.dateSelected!))
    //       : null;
    // }
    var size = MediaQuery.of(context).size;
    return buildScaffoldAll(context,
        title: widget.idtarefa == null ? 'Adicionar Tarefa' : 'Editar Tarefa',
        body: Form(
          key: keyTarefa,
          child: MyBoxShadow(
              child: Column(
            children: [
              ConstsWidget.buildPadding001(
                context,
                child: ConstsWidget.buildCamposObrigatorios(context),
              ),
              buildMyTextFormObrigatorio(
                context,
                'Descrição da Tarefa',
                textCapitalization: TextCapitalization.sentences,
                hintText: 'Exemplo: Dedetização de todos os blocos',
                // readOnly: !isExpired,
                initialValue: widget.nomeTarefaCtrl,
                maxLength: 80,
                onSaved: (text) {
                  setState(() {
                    nomeTarefaCtrl = text!;
                  });
                },
              ),
              // if (!isExpired)
              ConstsWidget.buildPadding001(
                context,
                child: MyDatePicker(
                  type: DateTimePickerType.dateTime,
                  dataSelected: widget.dateSelected != '0000-00-00' &&
                          widget.dateSelected != '' &&
                          widget.dateSelected != null
                      ? DateFormat('dd/MM/yyyy')
                          .format(DateTime.parse(widget.dateSelected!))
                      : DateTime.now(),
                  hintText: widget.dateSelected != '0000-00-00' &&
                          widget.dateSelected != '' &&
                          widget.dateSelected != null
                      ? DateFormat('dd/MM/yyyy HH:mm')
                          .format(DateTime.parse(MyDatePicker.dataSelected))
                          .toString()
                      : 'Selecione uma data',
                  // initialDate: initialDate != null
                  //     ? DateTime.parse(widget.initialDate!)
                  //     : null,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      ConstsWidget.buildTextSubTitle(context, 'Repetir tarefa',
                          size: 14),
                      Switch.adaptive(
                        value: isRepet,
                        onChanged: (value) {
                          setState(() {
                            isRepet = value;
                            isDayle = value;
                          });
                        },
                      ),
                    ],
                  ),
                  if (isRepet)
                    Column(
                      children: [
                        ConstsWidget.buildTextSubTitle(context, 'Todos os dias',
                            size: 14),
                        Switch.adaptive(
                          value: isDayle,
                          onChanged: (value) {
                            setState(() {
                              isDayle = value;
                            });
                          },
                        ),
                      ],
                    ),
                ],
              ),
              if (isRepet && !isDayle)
                Column(
                  children: [
                    ConstsWidget.buildTextSubTitle(context, 'Repetir tarefa',
                        size: 14),
                    StatefulBuilder(builder: (context, setState) {
                      return ConstsWidget.buildDecorationDrop(
                        context,
                        child: DropdownButton(
                          value: dropdownRepetirDias,
                          isExpanded: true,
                          alignment: Alignment.center,
                          icon: Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.arrow_downward_outlined,
                            ),
                          ),
                          elevation: 24,
                          // style: TextStyle(
                          //     // color: Theme.of(context)
                          //     //     .colorScheme
                          //     //     .primary,
                          //     fontWeight: FontWeight.bold,
                          //     fontSize: 18),
                          borderRadius: BorderRadius.circular(16),
                          onChanged: (value) {
                            setState(() {
                              dropdownRepetirDias = value!;
                            });
                          },
                          hint: ConstsWidget.buildTextSubTitle(
                              context, 'Selecione',
                              size: SplashScreen.isSmall ? 16 : 18),
                          items: listRepetir.map((value) {
                            return DropdownMenuItem(
                                value: value['idtempo'],
                                child: Center(
                                  child: ConstsWidget.buildTextTitle(
                                      context, value['nometempo'],
                                      fontSize: SplashScreen.isSmall ? 16 : 18),
                                ));
                          }).toList(),
                        ),
                      );
                    }),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    if (!isDayle)
                      Column(
                        children: [
                          ConstsWidget.buildTextSubTitle(
                              context, 'Ser notificado',
                              size: 14),
                          StatefulBuilder(builder: (context, setState) {
                            return ConstsWidget.buildDecorationDrop(
                              context,
                              child: DropdownButton(
                                value: dropdownAvisoDias, isExpanded: true,
                                alignment: Alignment.center,
                                icon: Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Icon(
                                    Icons.arrow_downward_outlined,
                                  ),
                                ),
                                elevation: 24,
                                // style: TextStyle(
                                //     // color: Theme.of(context)
                                //     //     .colorScheme
                                //     //     .primary,
                                //     fontWeight: FontWeight.bold,
                                //     fontSize: 18),
                                borderRadius: BorderRadius.circular(16),
                                onChanged: (value) {
                                  setState(() {
                                    dropdownAvisoDias = value!;
                                  });
                                },
                                hint: ConstsWidget.buildTextSubTitle(
                                    context, 'Selecione',
                                    size: SplashScreen.isSmall ? 16 : 18),
                                items: listAviso_dias.map((value) {
                                  return DropdownMenuItem(
                                      value: value['idtempo'],
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: ConstsWidget.buildTextTitle(
                                            context, value['nometempo'],
                                            fontSize:
                                                SplashScreen.isSmall ? 16 : 18),
                                      ));
                                }).toList(),
                              ),
                            );
                          }),
                        ],
                      ),
                  ],
                ),
              SizedBox(
                height: size.height * 0.01,
              ),
              ConstsWidget.buildPadding001(
                context,
                child: ConstsWidget.buildLoadingButton(
                  context,
                  title: 'Salvar',
                  isLoading: isLoading,
                  color: Consts.kColorRed,
                  onPressed: () {
                    var validForm = keyTarefa.currentState?.validate() ?? false;

                    FocusManager.instance.primaryFocus!.unfocus();
                    startTarefaSind(validForm);
                  },
                ),
              ),
            ],
          )),
        ));
  }
}
