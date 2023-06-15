import 'package:flutter/material.dart';
import 'package:sindico_app/consts/consts.dart';
import 'package:sindico_app/consts/consts_future.dart';
import 'package:validatorless/validatorless.dart';

import '../../consts/const_widget.dart';
import '../../widgets/my_text_form_field.dart';

class WidgetModalAvisos extends StatefulWidget {
  const WidgetModalAvisos({super.key});

  @override
  State<WidgetModalAvisos> createState() => _WidgetModalAvisosState();
}

class _WidgetModalAvisosState extends State<WidgetModalAvisos> {
  final _keyForm = GlobalKey<FormFieldState>();
  TextEditingController tituloCntl = TextEditingController();
  TextEditingController textoCntl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Form(
      key: _keyForm,
      child: ListView(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: [
          Row(
            children: [
              Spacer(),
              ConstsWidget.buildTextTitle('Aviso Geral'),
              Spacer(),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close)),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
            child: TextFormField(
              controller: tituloCntl,
              minLines: 1,
              maxLines: 1,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textAlign: TextAlign.start,
              textInputAction: TextInputAction.next,
              validator:
                  Validatorless.multiple([Validatorless.required('mensagem')]),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                    vertical: size.height * 0.015,
                    horizontal: size.width * 0.02),
                filled: true,
                fillColor: Theme.of(context).canvasColor,
                label: Text('Título'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.black26),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
            child: TextFormField(
              controller: textoCntl,
              minLines: 5,
              maxLines: 20,
              maxLength: 1000,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textAlign: TextAlign.start,
              textInputAction: TextInputAction.next,
              validator:
                  Validatorless.multiple([Validatorless.required('mensagem')]),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                    vertical: size.height * 0.015,
                    horizontal: size.width * 0.02),
                filled: true,
                fillColor: Theme.of(context).canvasColor,
                label: Text('Texto'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.black26),
                ),
              ),
            ),
          ),
          ConstsWidget.buildCustomButton(context, 'Enviar Aviso',
              onPressed: () {
            ConstsFuture.resquestApi(
                    'https://a.portariaapp.com/sindico/api/quadro_avisos/index.php?fn=incluirAviso&idcond=${ResponsalvelInfos.idcondominio}&tipo=1&titulo=${tituloCntl.text}&texto=${textoCntl.text}')
                .then((value) {
              if (!value['erro']) {
                ConstsFuture.navigatorPopPush(context, 'quadroDeAvisos');
              }
            });
          })
        ],
      ),
    );
  }
}
