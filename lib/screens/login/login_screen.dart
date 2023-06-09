import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sindico_app/repositories/shared_preferences.dart';
import 'package:sindico_app/widgets/snackbar/snack.dart';
import 'package:validatorless/validatorless.dart';

import '../../consts/const_widget.dart';
import '../../consts/consts.dart';
import '../../consts/consts_future.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKeyLogin = GlobalKey<FormState>();
  final TextEditingController userController =
      TextEditingController(text: 'respcondominio');
  final TextEditingController senhaController =
      TextEditingController(text: '123456');
  bool obscure = true;
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Widget buildTextFormEmail() {
      return TextFormField(
        keyboardType: TextInputType.emailAddress,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: userController,
        validator: Validatorless.multiple([
          Validatorless.required('Usuário é obrigatório'),
          // Validatorless.email('Preencha com um email Válido')
        ]),
        // autofillHints: [AutofillHints.email],
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: size.width * 0.04),
          filled: true,
          fillColor: Theme.of(context).canvasColor,
          hintText: 'Digite seu usuário',
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
      return Column(
        children: [
          TextFormField(
            textInputAction: TextInputAction.done,
            controller: senhaController,
            // autofillHints: [AutofillHints.password],
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
          StatefulBuilder(builder: (context, setState) {
            return CheckboxListTile(
              title: Text('Mantenha-me conectado'),
              value: isChecked,
              activeColor: Consts.kButtonColor,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value!;
                });
              },
            );
          })
        ],
      );
    }

    // var bytes = utf8.encode("01");
    // var digest = md5.convert(bytes);
    // print('${digest.bytes}');
    // print('$digest');
    // var url = Uri.parse(
    //     'https://a.portariaapp.com/api/login-responsavel/?fn=login&usuario=$usuario&senha=${utf8.encode($senha)}');
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

    // Widget buildLoginButton() {
    //   return ElevatedButton(
    //     onPressed: () async {
    //       var formValid = _formkey.currentState?.validate() ?? false;
    //       if (formValid && isChecked) {
    //         LocalInfos.createCache(userController.text, senhaController.text)
    //             .whenComplete(
    //           () => Consts.fazerLogin(
    //               context, userController.text, senhaController.text),
    //         );
    //       } else if (formValid && !isChecked) {
    //         Consts.fazerLogin(
    //             context, userController.text, senhaController.text);
    //       } else {
    //         buildMinhaSnackBar(context);
    //       }
    //     },
    //     style: ElevatedButton.styleFrom(
    //       backgroundColor: Consts.kButtonColor,
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(60),
    //       ),
    //     ),
    //     child: Padding(
    //       padding: EdgeInsets.symmetric(vertical: size.height * 0.023),
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           Text(
    //             'Entrar',
    //             style:
    //                 TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
    //           ),
    //         ],
    //       ),
    //     ),
    //   );
    // }

    return Scaffold(
      body: Center(
        child: Form(
          key: _formKeyLogin,
          child: Wrap(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: size.height * 0.05),
                      child: ConstsWidget.buildTextTitle('App Sindico'),
                    ),
                    buildTextFormEmail(),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    buildTextFormSenha(),
                    ElevatedButton(
                      onPressed: () async {
                        var formValid =
                            _formKeyLogin.currentState?.validate() ?? false;
                        if (formValid && isChecked) {
                          LocalInfos.createCache(
                                  userController.text, senhaController.text)
                              .whenComplete(
                            () => ConstsFuture.fazerLogin(context,
                                userController.text, senhaController.text),
                          );
                        } else if (formValid && !isChecked) {
                          ConstsFuture.fazerLogin(context, userController.text,
                              senhaController.text);
                        } else {
                          buildMinhaSnackBar(context);
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
                            ConstsWidget.buildTextTitle(
                              'Entrar',
                            ),
                          ],
                        ),
                      ),
                    ),
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
