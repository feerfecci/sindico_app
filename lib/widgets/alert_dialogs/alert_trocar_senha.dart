import 'package:flutter/material.dart';
import 'package:validatorless/validatorless.dart';

import '../../consts/const_widget.dart';
import '../../consts/consts.dart';
import '../../consts/consts_future.dart';
import '../../screens/splash_screen/splash_screen.dart';
import '../date_picker.dart';
import '../snack.dart';
import 'alertdialog_all.dart';
import '../my_text_form_field.dart';

alertTrocarSenha(
  BuildContext context,
) {
  TextEditingController novaSenhaCtrl = TextEditingController();
  TextEditingController confirmSenhaCtrl = TextEditingController();
  final formKeySenha = GlobalKey<FormState>();
  // bool isChecked = false;
  var size = MediaQuery.of(context).size;
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Form(
          key: formKeySenha,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
            insetPadding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05, vertical: size.height * 0.05),
            title: Center(
                child: ConstsWidget.buildTextTitle(context, 'Nova Senha')),
            content: SizedBox(
              width: size.width * 0.9,
              height: SplashScreen.isSmall
                  ? size.height * 0.37
                  : size.height * 0.50,
              child: ListView(
                children: [
                  ConstsWidget.buildTextExplicaSenha(context),
                  buildMyTextFormObrigatorio(
                    context,
                    'Nova Senha',
                    controller: novaSenhaCtrl,
                    validator: Validatorless.multiple([
                      Validatorless.required('Confirme a senha'),
                      Validatorless.min(6, 'Senha precisa ter 6 caracteres'),
                    ]),
                  ),
                  buildMyTextFormObrigatorio(
                    context,
                    'Confirmar Senha',
                    controller: confirmSenhaCtrl,
                    validator: Validatorless.multiple([
                      Validatorless.required('Confirme a senha'),
                      Validatorless.min(6, 'Senha precisa ter 6 caracteres'),
                      Validatorless.compare(
                          novaSenhaCtrl, 'Senhas não são iguais'),
                    ]),
                  ),
                  // ConstsWidget.buildPadding001(
                  //   context,
                  //   horizontal: 0,
                  //   child: StatefulBuilder(builder: (context, setState) {
                  //     return ConstsWidget.buildCheckBox(context,
                  //         isChecked: isChecked,
                  //         width: size.width * 0.6, onChanged: (p0) {
                  //       setState(() {
                  //         isChecked = !isChecked;
                  //         FocusManager.instance.primaryFocus!.unfocus();
                  //       });
                  //     }, title: 'Trocar em todos condomínios');
                  //   }),
                  // ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ConstsWidget.buildOutlinedButton(
                        context,
                        title: 'Cancelar',
                        rowSpacing: SplashScreen.isSmall ? 0.05 : 0.063,
                        onPressed: () {
                          Navigator.pop(context);
                          novaSenhaCtrl.clear();
                          confirmSenhaCtrl.clear();
                          // isChecked = false;
                        },
                      ),
                      ConstsWidget.buildCustomButton(
                        context,
                        rowSpacing: SplashScreen.isSmall ? 0.07 : 0.08,
                        'Salvar',
                        color: Consts.kColorRed,
                        onPressed: () {
                          var formValid =
                              formKeySenha.currentState?.validate() ?? false;
                          if (formValid &&
                              novaSenhaCtrl.text != '' &&
                              novaSenhaCtrl.text.length >= 6) {
                            ConstsFuture.resquestApi(
                                    '${Consts.sindicoApi}funcionarios/?fn=mudarSenha&idfuncionario=${ResponsalvelInfos.idfuncionario}&senha=${novaSenhaCtrl.text}&mudasenhalogin=1&login=${ResponsalvelInfos.login}')
                                .then((value) {
                              if (!value['erro']) {
                                Navigator.pop(context);
                                MyDatePicker.dataSelected = '';

                                novaSenhaCtrl.clear();
                                confirmSenhaCtrl.clear();
                                // isChecked = false;
                                buildMinhaSnackBar(context,
                                    title: 'Acessos Unificados',
                                    subTitle:
                                        'Refaça o login para ter todos os acessos');
                              } else {
                                buildMinhaSnackBar(context,
                                    title: 'Algo Saiu Mau',
                                    hasError: value['erro'],
                                    subTitle: value['mensagem']);
                              }
                            });
                          }
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
            // actionsAlignment: MainAxisAlignment.spaceBetween,
            // alignment: Alignment.center,
            actionsOverflowAlignment: OverflowBarAlignment.end,
            // actionsOverflowDirection: VerticalDirection.up,
            // actionsOverflowButtonSpacing: 60,
          ),
        );
      });
  // showAllDialog(context,
  //     title: ConstsWidget.buildTextTitle(context, 'Nova Senha'),
  //     children: [

  //     ]);
}
