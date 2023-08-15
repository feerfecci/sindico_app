import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:sindico_app/consts/const_widget.dart';
import 'package:sindico_app/consts/consts_future.dart';
import 'package:sindico_app/screens/tarefas/tarefas_screen.dart';
import 'package:sindico_app/widgets/date_picker.dart';
import 'package:sindico_app/widgets/my_box_shadow.dart';
import 'package:sindico_app/widgets/my_text_form_field.dart';
import 'package:sindico_app/widgets/scaffold_all.dart';
import 'package:sindico_app/widgets/snackbar/snack.dart';

import '../../consts/consts.dart';
import '../splash_screen/splash_screen.dart';

// ignore: must_be_immutable
class AdicionarTarefa extends StatefulWidget {
  int? idtarefa;
  int? idtempo;
  String? initialDate;
  String? nomeTarefaCtrl;

  AdicionarTarefa(
      {this.idtarefa,
      this.initialDate,
      this.nomeTarefaCtrl,
      this.idtempo,
      super.key});

  @override
  State<AdicionarTarefa> createState() => _AdicionarTarefaState();
}

Object? dropdownValueAtivo;
bool isLoading = false;
List<Map<String, dynamic>> listLembretes = [
  {
    'idtempo': 30,
    'nometempo': '30 Dias',
  },
  {
    'idtempo': 15,
    'nometempo': '15 Dias',
  },
  {
    'idtempo': 7,
    'nometempo': '7 Dias',
  },
  {
    'idtempo': 5,
    'nometempo': '5 Dias',
  },
  {
    'idtempo': 2,
    'nometempo': '2 Dias',
  },
  {
    'idtempo': 1,
    'nometempo': '1 Dia',
  },
  {
    'idtempo': 0,
    'nometempo': 'No dia',
  },
];

class _AdicionarTarefaState extends State<AdicionarTarefa> {
  final GlobalKey<FormState> keyTarefa = GlobalKey<FormState>();
  String dataSelected = '';
  String nomeTarefaCtrl = '';
  int diferenca = 0;

  @override
  void initState() {
    dropdownValueAtivo = widget.idtempo;
    MyDatePicker.dataSelected = widget.initialDate ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime? timeBackPressed = widget.initialDate == null
        ? DateTime.now()
        : DateTime.parse(widget.initialDate!);

    final differenceBack = DateTime.now().difference(timeBackPressed);
    final isExpired = differenceBack < Duration(days: 1);
    String? initialDate;
    if (widget.initialDate != null) {
      initialDate = widget.initialDate != null
          ? DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.initialDate!))
          : null;
    }
    var size = MediaQuery.of(context).size;
    return buildScaffoldAll(context,
        title: 'Adicionar Tarefa',
        body: Form(
          key: keyTarefa,
          child: MyBoxShadow(
              child: Column(
            children: [
              buildMyTextFormObrigatorio(
                context,
                'Descrição da Tarefa',
                hintText: 'Exemplo: Dedetização de todos os blocos',
                readOnly: !isExpired,
                labelCenter: true,
                initialValue: widget.nomeTarefaCtrl,
                onSaved: (text) {
                  setState(() {
                    nomeTarefaCtrl = text!;
                  });
                },
              ),
              if (isExpired)
                ConstsWidget.buildPadding001(
                  context,
                  child: MyDatePicker(
                    dataSelected: dataSelected,
                    initialDate: initialDate != null
                        ? DateTime.parse(widget.initialDate!)
                        : null,
                    hintText: initialDate ?? 'Escolha uma data',
                  ),
                ),
              ConstsWidget.buildTextSubTitle('Ser Notificado em', size: 14),
              StatefulBuilder(builder: (context, setState) {
                return Container(
                  width: double.infinity,
                  height: size.height * 0.066,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: dropdownValueAtivo,
                        icon: Icon(
                          Icons.arrow_downward_outlined,
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
                            dropdownValueAtivo = value!;
                          });
                        },
                        hint: ConstsWidget.buildTextTitle(context, 'Selecione',
                            size: SplashScreen.isSmall ? 16 : 18),
                        items: listLembretes.map((value) {
                          return DropdownMenuItem(
                              value: value['idtempo'],
                              child: ConstsWidget.buildTextTitle(
                                  context, value['nometempo'],
                                  size: SplashScreen.isSmall ? 16 : 18));
                        }).toList(),
                      ),
                    ),
                  ),
                );
              }),
              SizedBox(
                height: size.height * 0.01,
              ),
              ConstsWidget.buildTextSubTitle('Repitir em', size: 14),
              StatefulBuilder(builder: (context, setState) {
                return Container(
                  width: double.infinity,
                  height: size.height * 0.066,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: dropdownValueAtivo,
                        icon: Icon(
                          Icons.arrow_downward_outlined,
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
                            dropdownValueAtivo = value!;
                          });
                        },
                        hint: ConstsWidget.buildTextTitle(context, 'Selecione',
                            size: SplashScreen.isSmall ? 16 : 18),
                        items: listLembretes.map((value) {
                          return DropdownMenuItem(
                              value: value['idtempo'],
                              child: ConstsWidget.buildTextTitle(
                                  context, value['nometempo'],
                                  size: SplashScreen.isSmall ? 16 : 18));
                        }).toList(),
                      ),
                    ),
                  ),
                );
              }),
              if (!isExpired)
                ConstsWidget.buildPadding001(context,
                    child: Column(
                      children: [
                        ConstsWidget.buildTextTitle(context,
                            'Essa tarefa expirou em ${initialDate}. Inclua uma nova tarefa',
                            color: Colors.red)
                      ],
                    )),
              SizedBox(
                height: size.height * 0.01,
              ),
              ConstsWidget.buildLoadingButton(
                context,
                title: 'Salvar',
                isLoading: isLoading,
                onPressed: () {
                  var validForm = keyTarefa.currentState?.validate() ?? false;
                  startTarefaSind(validForm);
                },
              ),
            ],
          )),
        ));
  }

  void startTarefaSind(validForm) {
    keyTarefa.currentState?.save();
    if (validForm &&
        dropdownValueAtivo != null &&
        MyDatePicker.dataSelected != '') {
      setState(() {
        isLoading = true;
      });
      String incluirEditar = widget.idtarefa == null
          ? 'incluirTarefa'
          : 'editarTarefa&idtarefa=${widget.idtarefa}';
      ConstsFuture.resquestApi(
              '${Consts.sindicoApi}tarefas/?fn=$incluirEditar&idcond=${ResponsalvelInfos.idcondominio}&descricao=$nomeTarefaCtrl&data_vencimento=${MyDatePicker.dataSelected}&aviso_dias=$dropdownValueAtivo')
          .then((value) {
        setState(() {
          isLoading = false;
        });
        if (!value['erro']) {
          ConstsFuture.navigatorPopPush(context, '/tarefasScreen');

          buildMinhaSnackBar(context,
              title: 'Muito bem!', subTitle: value['mensagem']);
        } else {
          buildMinhaSnackBar(context,
              title: 'Algo Saiu Mau', subTitle: value['mensagem']);
        }
      });
    } else {
      buildMinhaSnackBar(context);
    }
  }
}
