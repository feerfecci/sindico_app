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
  final TextEditingController userController = TextEditingController();
  final TextEditingController senhaController =
      TextEditingController(text: '123456');
  bool obscure = true;
  bool isChecked = false;
  bool isLoading = false;
  starLogin() {
    setState(() {
      var formValid = _formKeyLogin.currentState?.validate() ?? false;
      if (formValid && isChecked) {
        LocalInfos.createCache(userController.text, senhaController.text)
            .whenComplete(() {
          setState(() {
            isLoading = !isLoading;
          });

          ConstsFuture.fazerLogin(
              context, userController.text, senhaController.text);
        });
      } else if (formValid && !isChecked) {
        setState(() {
          isLoading = !isLoading;
        });
        ConstsFuture.fazerLogin(
            context, userController.text, senhaController.text);
      } else {
        buildMinhaSnackBar(context);
      }
    });
  }

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
        autofillHints: const [AutofillHints.email],
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
              vertical: size.height * 0.02, horizontal: size.width * 0.04),
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
            autofillHints: const [AutofillHints.password],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: Validatorless.multiple([
              Validatorless.required('Senha é obrigatório'),
              Validatorless.min(3, 'Mínimo de 6 caracteres')
            ]),
            onEditingComplete: () => TextInput.finishAutofillContext(),
            obscureText: obscure,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                  vertical: size.height * 0.02, horizontal: size.width * 0.04),
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
          ConstsWidget.buildPadding001(
            context,
            child: StatefulBuilder(builder: (context, setState) {
              return ConstsWidget.buildCheckBox(context,
                  title: 'Mantenha-me conectado',
                  isChecked: isChecked, onChanged: (bool? value) {
                setState(() {
                  isChecked = value!;
                });
              });
            }),
          )
        ],
      );
    }

    return Scaffold(
      body: AutofillGroup(
        child: Center(
          child: Form(
            key: _formKeyLogin,
            child: Wrap(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: size.width * 0.05,
                      right: size.width * 0.05,
                      bottom: size.height * 0.15),
                  child: Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: FutureBuilder(
                            future: ConstsFuture.apiImage(
                                'https://a.portariaapp.com/img/logo_verde.png'),
                            builder: (context, snapshot) {
                              return SizedBox(
                                height: size.height * 0.2,
                                width: size.width * 0.5,
                                child: snapshot.data,
                              );
                            },
                          )),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: size.height * 0.035,
                            top: size.height * 0.025),
                        child: ConstsWidget.buildTextTitle(
                            context, 'Portaria App | Síndico',
                            size: 19),
                      ),
                      buildTextFormEmail(),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      buildTextFormSenha(),
                      ConstsWidget.buildLoadingButton(context,
                          onPressed: starLogin,
                          isLoading: isLoading,
                          title: 'Entrar',
                          fontSize: 18),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
