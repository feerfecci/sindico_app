import 'package:flutter/material.dart';
import 'package:sindico_app/widgets/snack.dart';
import 'package:validatorless/validatorless.dart';

import '../../consts/const_widget.dart';
import '../../consts/consts.dart';
import '../../consts/consts_future.dart';
import '../../widgets/my_text_form_field.dart';
import '../splash_screen/splash_screen.dart';
import 'login_screen.dart';

class EsqueciSenhaScreen extends StatefulWidget {
  const EsqueciSenhaScreen({super.key});

  @override
  State<EsqueciSenhaScreen> createState() => _EsqueciSenhaScreenState();
}

class _EsqueciSenhaScreenState extends State<EsqueciSenhaScreen> {
  final formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _loginController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: ConstsWidget.buildTextTitle(context, 'Recuperar Senha',
              fontSize: SplashScreen.isSmall ? 20 : 24),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
            child: ListView(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                SizedBox(
                  height: size.height * 0.03,
                ),
                ConstsWidget.buildCachedImage(context,
                    height: 0.25,
                    width: 0.5,
                    iconApi: 'https://a.portariaapp.com/img/logo_verde.png'),
                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.01),
                  child: ConstsWidget.buildTextTitle(
                      context, 'Portaria App | Condômino',
                      textAlign: TextAlign.center, fontSize: 19),
                ),
                Container(
                    alignment: Alignment.center,
                    height: size.height * 0.1,
                    width: size.width * 0.80,
                    child: ConstsWidget.buildTextTitle(context,
                        'Para recuperar o acesso, informe o email e login do Portaria App',
                        textAlign: TextAlign.center, fontSize: 18)),

                //  Text(
                //   'Para recuperar o acesso, informe o email cadastrado no Portaria App',
                //   textAlign: TextAlign.left,
                //   style: TextStyle(
                //     fontSize: 18,
                //     fontWeight: FontWeight.w300,
                //   ),
                // ),
                Center(child: ConstsWidget.buildCamposObrigatorios(context)),
                buildMyTextFormObrigatorio(context, 'Email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validatorless.multiple([
                      Validatorless.email('Preencha com email válido'),
                      Validatorless.required('Preencha com seu e-mail')
                    ]),
                    autofillHints: [AutofillHints.email],
                    hintText: 'Digite seu email'),
                buildMyTextFormObrigatorio(context, 'Login',
                    controller: _loginController,
                    autofillHints: [AutofillHints.email],
                    validator: Validatorless.multiple(
                        [Validatorless.required('Preencha com seu login')]),
                    hintText: 'Exemplo: joaosilva0102'),
                ConstsWidget.buildTextSubTitle(
                    context, 'Nome + Sobrenome + 4 digitos do documento',
                    // 'Seu login é composto pelo seu primeiro e último nome e os 4 primeiros números do documento informado no cadastro',
                    size: 16,
                    color: Consts.kColorRed,
                    textAlign: TextAlign.center),
                SizedBox(
                  height: size.height * 0.03,
                ),
                ConstsWidget.buildCustomButton(
                  context,
                  'Recuperar Senha',
                  color: Consts.kColorRed,
                  onPressed: () {
                    var validForm = formKey.currentState?.validate() ?? false;
                    if (validForm) {
                      ConstsFuture.resquestApi(
                              '${Consts.sindicoApi}recupera_senha/?fn=recuperaSenha&email=${_emailController.text}&login=${_loginController.text}')
                          .then((value) {
                        if (!value['erro']) {
                          ConstsFuture.navigatorPagePush(
                              context, LoginScreen());
                          buildMinhaSnackBar(context,
                              title: 'Sucesso!', subTitle: value['mensagem']);
                        } else {
                          buildMinhaSnackBar(context,
                              title: 'Algo saiu mal!',
                              hasError: true,
                              subTitle: value['mensagem']);
                        }
                      });
                    }
                  },
                )
              ],
            ),
          ),
        ));
  }
}
