import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sindico_app/repositories/shared_preferences.dart';
import 'package:sindico_app/screens/splash_screen/splash_screen.dart';
import 'package:validatorless/validatorless.dart';
import '../../consts/const_widget.dart';
import '../../consts/consts_future.dart';
import '../politica/politica_screen.dart';
import '../termodeuso/termo_de_uso.dart';
import 'esqueci_senha.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKeyLogin = GlobalKey<FormState>();
  final TextEditingController userController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
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
            isLoading = !true;
          });

          ConstsFuture.fazerLogin(
              context, userController.text, senhaController.text);
        });
      } else if (formValid && !isChecked) {
        setState(() {
          isLoading = false;
        });
        ConstsFuture.fazerLogin(
            context, userController.text, senhaController.text);
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
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary),
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
              Validatorless.required('Preencha com sua senha de acesso'),
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
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.primary),
              ),
              hintText: 'Digite sua Senha',
              suffixIcon: GestureDetector(
                onTap: (() {
                  setState(() {
                    obscure = !obscure;
                  });
                }),
                child: obscure
                    ? Icon(
                        Icons.visibility_off_outlined,
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      )
                    : Icon(
                        Icons.visibility_outlined,
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
              ),
            ),
          ),
          ConstsWidget.buildPadding001(
            context,
            child: StatefulBuilder(builder: (context, setState) {
              return ConstsWidget.buildCheckBox(context,
                  title: 'Mantenha-me conectado',
                  isChecked: isChecked, onChanged: (bool? value) {
                FocusManager.instance.primaryFocus!.unfocus();
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
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.03,
              ),
              child: ListView(
                children: [
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  ConstsWidget.buildCachedImage(context,
                      height: SplashScreen.isSmall ? 0.2 : 0.2,
                      width: SplashScreen.isSmall ? 0.3 : 0.4,
                      iconApi: 'https://a.portariaapp.com/img/logo_verde.png'),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: size.height * 0.035, top: size.height * 0.025),
                    child: ConstsWidget.buildTextTitle(
                        context, 'Portaria App | Síndico',
                        textAlign: TextAlign.center, fontSize: 19),
                  ),
                  Center(child: ConstsWidget.buildCamposObrigatorios(context)),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  buildTextFormEmail(),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  buildTextFormSenha(),
                  ConstsWidget.buildLoadingButton(context, onPressed: () {
                    starLogin();
                  }, isLoading: isLoading, title: 'Entrar', fontSize: 18),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PoliticaScreen(hasDrawer: false),
                            ),
                          );
                        },
                        child: Text(
                          'Política de Privacidade',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TermoDeUsoScreen(
                                hasDrawer: false,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Termos de Uso',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EsqueciSenhaScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Recuperar Senha',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
