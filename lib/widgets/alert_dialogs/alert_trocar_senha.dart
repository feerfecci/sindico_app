import 'package:flutter/material.dart';
import 'package:sindico_app/widgets/snackbar/snack.dart';
import 'package:validatorless/validatorless.dart';

import '../../consts/const_widget.dart';
import 'alertdialog_all.dart';
import '../my_text_form_field.dart';

trocarSenhaAlert(
  BuildContext context, {
  required GlobalKey<FormState> formkeySenha,
  required TextEditingController atualSenhaCtrl,
  required TextEditingController novaSenhaCtrl,
  required TextEditingController confirmSenhaCtrl,
}) {
  showAllDialog(context, children: [
    Form(
      key: formkeySenha,
      child: Column(
        children: [
          buildMyTextFormObrigatorio(
            context,
            'Senha Atual',
            validator: Validatorless.multiple([
              Validatorless.required('Confirme a senha'),
              Validatorless.min(6, 'Senha precisa ter 6 caracteres'),
            ]),
            controller: atualSenhaCtrl,
            // onSaved: (text) => formInfosFunc =
            //     formInfosFunc.copyWith(senha: text),
          ),
          buildMyTextFormObrigatorio(
            context,
            'Nova Senha',
            validator: Validatorless.multiple([
              Validatorless.required('Confirme a senha'),
              Validatorless.min(6, 'Senha precisa ter 6 caracteres'),
            ]),
            controller: novaSenhaCtrl,
            // onSaved: (text) => formInfosFunc =
            //     formInfosFunc.copyWith(senha: text),
          ),
          buildMyTextFormObrigatorio(
            context,
            'Confirmar Senha',
            validator: Validatorless.multiple([
              Validatorless.required('Confirme a senha'),
              Validatorless.min(6, 'Senha precisa ter 6 caracteres'),
              Validatorless.compare(novaSenhaCtrl, 'Senhas não são iguais'),
            ]),
            controller: confirmSenhaCtrl,
            // onSaved: (text) => formInfosFunc =
            //     formInfosFunc.copyWith(senha: text),
          ),
          ConstsWidget.buildPadding001(
            context,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Spacer(),
                ConstsWidget.buildOutlinedButton(
                  context,
                  title: 'Cancelar',
                  onPressed: () {
                    Navigator.pop(context);
                    atualSenhaCtrl.clear();
                    novaSenhaCtrl.clear();
                    confirmSenhaCtrl.clear();
                  },
                ),
                Spacer(),
                ConstsWidget.buildCustomButton(
                  context,
                  'Salvar',
                  onPressed: () {
                    var validSenha =
                        formkeySenha.currentState?.validate() ?? false;
                    if (validSenha &&
                        novaSenhaCtrl.text == confirmSenhaCtrl.text) {
                      Navigator.pop(context);
                      buildMinhaSnackBar(context,
                          title: 'Salvou senha',
                          subTitle: 'Não gravou ainda no banco');
                    }
                  },
                )
              ],
            ),
          )
        ],
      ),
    ),
  ]);
}
