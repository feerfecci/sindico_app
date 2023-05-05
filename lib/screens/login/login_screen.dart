import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sindico_app/repositories/shared_preferences.dart';
import 'package:sindico_app/screens/home_page.dart/home_page.dart';
import 'package:sindico_app/widgets/my_text_form_field.dart';
import 'package:sindico_app/widgets/scaffold_all.dart';
import 'package:sindico_app/widgets/snackbar/snack.dart';
import 'package:validatorless/validatorless.dart';
import 'package:http/http.dart' as http;

import '../../consts.dart';
import '../../items_bottom.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController userController =
        TextEditingController(text: 'feeh');
    final TextEditingController senhaController =
        TextEditingController(text: '123');
    bool obscure = true;
    bool isChecked = false;

    var size = MediaQuery.of(context).size;
    Widget buildTextFormEmail() {
      return TextFormField(
        keyboardType: TextInputType.emailAddress,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: userController,
        validator: Validatorless.multiple([
          Validatorless.required('Email é obrigatório'),
          // Validatorless.email('Preencha com um email Válido')
        ]),
        autofillHints: [AutofillHints.email],
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: size.width * 0.04),
          filled: true,
          fillColor: Theme.of(context).canvasColor,
          hintText: 'Digite seu Email',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.blue,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.black26),
          ),
        ),
      );
    }

    Widget buildTextFormSenha() {
      return StatefulBuilder(builder: (context, setState) {
        return Column(
          children: [
            TextFormField(
              textInputAction: TextInputAction.done,
              controller: senhaController,
              autofillHints: [AutofillHints.password],
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: Validatorless.multiple([
                Validatorless.required('Senha é obrigatório'),
                Validatorless.min(3, 'Mínimo de 6 caracteres')
              ]),
              onEditingComplete: () => TextInput.finishAutofillContext(),
              obscureText: obscure,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: size.width * 0.04),
                filled: true,
                fillColor: Theme.of(context).canvasColor,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.black26),
                ),
                hintText: 'Digite sua Senha',
                suffixIcon: GestureDetector(
                  onTap: (() {
                    setState(() {
                      obscure = !obscure;
                    });
                  }),
                  child: obscure
                      ? Icon(Icons.visibility_off_outlined)
                      : Icon(Icons.visibility_outlined),
                ),
              ),
            ),
            CheckboxListTile(
              title: Text('Mantenha-me conectado'),
              value: isChecked,
              activeColor: Consts.kButtonColor,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value!;
                });
              },
            )
          ],
        );
      });
    }

    // var url = Uri.parse(
    //     'https://a.portariaapp.com/api/login-responsavel/?fn=login&usuario=$usuario&senha=$senha');
    // var resposta = await http.get(
    //   url,
    //   // headers: <String, String>{
    //   //   'Content-Type': 'application/json; charset=UTF-8',
    //   // },
    //   // body: json.encode(<String, String>{
    //   //   'fn': 'login',
    //   //   'usuario': usuario,
    //   //   'senha': senha,
    //   // }),
    // );
    // if (resposta.statusCode == 200) {
    //   print(resposta.body);
    // } else {
    //   return null;
    // }

    return AutofillGroup(
      child: Scaffold(
        body: Center(
          child: Wrap(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: Column(
                  children: [
                    buildTextFormEmail(),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    buildTextFormSenha(),
                    ElevatedButton(
                      onPressed: () async {
                        Consts.fazerLogin(
                            context, userController.text, senhaController.text);
                        if (isChecked) {
                          LocalInfos.createCache(
                              userController.text, senhaController.text);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Consts.kButtonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60),
                        ),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.023),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Entrar',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginAcess {
  static String usuario = 'feeh_fecci';
  static String senha = '123456';
}
