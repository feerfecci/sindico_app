import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sindico_app/consts/const_widget.dart';
import 'package:sindico_app/consts/consts.dart';
import 'package:sindico_app/consts/consts_future.dart';
import 'package:sindico_app/screens/splash_screen/splash_screen.dart';
import 'package:sindico_app/widgets/alert_dialogs/alertdialog_all.dart';
import 'package:sindico_app/widgets/my_box_shadow.dart';
import 'package:sindico_app/widgets/my_text_form_field.dart';
import 'package:sindico_app/widgets/scaffold_all.dart';
import 'package:sindico_app/widgets/snack.dart';
import 'package:validatorless/validatorless.dart';

import '../../forms/responsavel_form.dart';
import '../../widgets/date_picker.dart';

class MeuPerfilScreen extends StatefulWidget {
  const MeuPerfilScreen({super.key});

  @override
  State<MeuPerfilScreen> createState() => _MeuPerfilScreenState();
}

bool isChecked = true;

class _MeuPerfilScreenState extends State<MeuPerfilScreen> {
  FormInfosResp responsalvelInfos = FormInfosResp();
  TextEditingController novaSenhaCtrl = TextEditingController();
  TextEditingController confirmSenhaCtrl = TextEditingController();
  final formKeyResp = GlobalKey<FormState>();
  final formKeySenha = GlobalKey<FormState>();
  bool isLoading = false;

  startEditarInfos() {
    setState(() {
      isLoading = true;
    });

    ResponsalvelInfos.nascimento = responsalvelInfos.nascimento;
    ResponsalvelInfos.telefone = responsalvelInfos.telefone!;
    ResponsalvelInfos.documento = responsalvelInfos.documento!;
    ResponsalvelInfos.email = responsalvelInfos.email!;
    ConstsFuture.resquestApi(
            '${Consts.sindicoApi}funcionarios/?fn=editarFuncionario&idcond=${ResponsalvelInfos.idcondominio}&idfuncionariologado=${ResponsalvelInfos.idfuncionario}&idfuncao=2&idfuncionario=${ResponsalvelInfos.idfuncionario}&nome_funcionario=${ResponsalvelInfos.nome_responsavel}&datanasc=${MyDatePicker.dataSelected}&documento=${responsalvelInfos.documento}&email=${responsalvelInfos.email}&telefone=${responsalvelInfos.telefone}&login=${ResponsalvelInfos.login}&avisa_corresp=1&avisa_visita=1&avisa_delivery=1&avisa_encomendas=1&envia_avisos=1')
        .then((value) {
      setState(() {
        isLoading = false;
      });
      if (!value['erro']) {
        Navigator.pop(context);
        MyDatePicker.dataSelected = '';

        novaSenhaCtrl.clear();
        confirmSenhaCtrl.clear();
        isChecked = false;
        buildMinhaSnackBar(context,
            hasError: value['erro'],
            title: 'Muito bem!',
            subTitle: value['mensagem']);
      } else {
        buildMinhaSnackBar(context,
            subTitle: value['mensagem'], hasError: value['erro']);
      }
    });
  }

  @override
  void initState() {
    MyDatePicker.dataSelected =
        ResponsalvelInfos.nascimento != '' ? '' : ResponsalvelInfos.nascimento;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    // alertTrocarSenha() {
    //   showDialog(
    //       context: context,
    //       barrierDismissible: false,
    //       builder: (context) {
    //         return AlertDialog(
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(13),
    //           ),
    //           insetPadding: EdgeInsets.symmetric(
    //               horizontal: size.width * 0.05, vertical: size.height * 0.05),
    //           title: Center(
    //               child: ConstsWidget.buildTextTitle(context, 'Nova Senha')),
    //           content: SizedBox(
    //             width: size.width * 0.9,
    //             height: SplashScreen.isSmall
    //                 ? size.height * 0.45
    //                 : size.height * 0.38,
    //             child: ListView(
    //               children: [],
    //             ),
    //           ),
    //         );
    //       });
    //   // showAllDialog(context,
    //   //     title: ConstsWidget.buildTextTitle(context, 'Nova Senha'),
    //   //     children: [

    //   //     ]);
    // }

    return buildScaffoldAll(context,
        body: Form(
          key: formKeyResp,
          child: MyBoxShadow(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ConstsWidget.buildPadding001(
                context,
                horizontal: 0,
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      ConstsWidget.buildTextTitle(
                          context, ResponsalvelInfos.nome_responsavel,
                          fontSize: 18),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      ConstsWidget.buildTextSubTitle(context, 'Meu Login'),
                      ConstsWidget.buildTextTitle(
                          context, ResponsalvelInfos.login,
                          fontSize: 20),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                    ],
                  ),
                ),
              ),
              ConstsWidget.buildTextExplicaSenha(context),
              ConstsWidget.buildPadding001(
                context,
                child: ConstsWidget.buildCamposObrigatorios(context),
              ),

              Row(
                children: [
                  ConstsWidget.buildAniversarioField(
                      context, ResponsalvelInfos.nascimento,
                      width: 0.4),
                  // SizedBox(
                  //   width: size.width * 0.4,
                  //   child: buildMyTextFormField(context,
                  //       title: 'Data de Nascimento',
                  //       hintText: 'Ex: 25/09/1997',
                  //       initialValue: DateFormat('dd/MM/yyyy').format(
                  //           DateTime.parse(ResponsalvelInfos.nascimento)),
                  //       onSaved: (text) {
                  //     if (text!.length >= 6) {
                  //       var ano = text.substring(6);
                  //       var mes = text.substring(3, 5);
                  //       var dia = text.substring(0, 2);
                  //       responsalvelInfos = responsalvelInfos.copyWith(
                  //           nascimento: '$ano-$mes-$dia');
                  //     }
                  //   }, mask: '##/##/####', keyboardType: TextInputType.number),
                  // ),
                  Spacer(),
                  SizedBox(
                    width: size.width * 0.45,
                    child: buildMyTextFormObrigatorio(context, 'Documento',
                        hintText: 'Ex: CPF',
                        initialValue: ResponsalvelInfos.documento,
                        readOnly: true,
                        onSaved: (text) => responsalvelInfos =
                            responsalvelInfos.copyWith(documento: text),
                        keyboardType: TextInputType.number),
                  )
                ],
              ),
              // ConstsWidget.buildPadding001(context,
              //     child: ConstsWidget.buildTextTitle(context, 'Contatos',
              //         fontSize: 18)),
              Row(
                children: [
                  // SizedBox(
                  //   width: size.width * 0.2,
                  //   child: buildMyTextFormObrigatorio(context, 'DDD',
                  //       initialValue: ResponsalvelInfos.ddd,
                  //       hintText: 'Ex: 11',
                  //       onSaved: (text) => responsalvelInfos =
                  //           responsalvelInfos.copyWith(ddd: text),
                  //       mask: '##',
                  //       keyboardType: TextInputType.number),
                  // ),
                  // Spacer(),
                  SizedBox(
                    width: size.width * 0.5,
                    child: buildMyTextFormField(context,
                        title: 'Telefone',
                        initialValue: ResponsalvelInfos.telefone,
                        onSaved: (text) => responsalvelInfos =
                            responsalvelInfos.copyWith(telefone: text),
                        hintText: '11911223344',
                        mask: '###########',
                        keyboardType: TextInputType.number),
                  ),
                  Spacer(),
                ],
              ),
              buildMyTextFormObrigatorio(
                context,
                'Email',
                keyboardType: TextInputType.emailAddress,
                initialValue: ResponsalvelInfos.email,
                hintText: 'Ex: exemplo@exp.com',
                onSaved: (text) =>
                    responsalvelInfos = responsalvelInfos.copyWith(email: text),
                validator: Validatorless.multiple([
                  Validatorless.email('Não é um email válido'),
                  Validatorless.required('Preencha')
                ]),
              ),

              // Form(
              //   key: formKeySenha,
              //   child: ConstsWidget.buildPadding001(context,
              //       child: ConstsWidget.buildCustomButton(
              //         context,
              //         'Trocar Senha',
              //         onPressed: () {
              //           alertTrocarSenha();
              //         },
              //       )),
              // ),
              Form(
                key: formKeySenha,
                child: Column(
                  children: [
                    ConstsWidget.buildPadding001(context,
                        child: ConstsWidget.buildTextTitle(
                            context, 'Trocar Senha')),
                    buildMyTextFormField(
                      context,
                      title: 'Nova Senha',
                      controller: novaSenhaCtrl,
                      validator: Validatorless.multiple([
                        Validatorless.required('Confirme a senha'),
                        Validatorless.min(6, 'Senha precisa ter 6 caracteres'),
                      ]),
                    ),
                    buildMyTextFormField(
                      context,
                      title: 'Confirmar Senha',
                      controller: confirmSenhaCtrl,
                      validator: Validatorless.multiple([
                        Validatorless.required('Confirme a senha'),
                        Validatorless.min(6, 'Senha precisa ter 6 caracteres'),
                        Validatorless.compare(
                            novaSenhaCtrl, 'Senhas não são iguais'),
                      ]),
                    ),
                    ConstsWidget.buildPadding001(
                      context,
                      horizontal: 0,
                      child: StatefulBuilder(builder: (context, setState) {
                        return ConstsWidget.buildCheckBox(context,
                            isChecked: isChecked,
                            width: size.width * 0.7, onChanged: (p0) {
                          setState(() {
                            isChecked = !isChecked;

                            FocusManager.instance.primaryFocus!.unfocus();
                          });
                        }, title: 'Adicionar Meus Condomínios');
                      }),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              /*  ConstsWidget.buildPadding001(
                context,
                child:*/
              ConstsWidget.buildTextTitle(
                  context, ResponsalvelInfos.nome_condominio,
                  textAlign: TextAlign.center, fontSize: 20),
              //     ),
              SizedBox(
                height: size.height * 0.01,
              ),
              ConstsWidget.buildTextSubTitle(
                context,
                'Aqui só pode ser alterados pela nossa equipe',
              ),
              SizedBox(
                height: size.height * 0.02,
              ),

              MyBoxShadow(
                child: Column(
                  children: [
                    ConstsWidget.buildPadding001(
                      context,
                      horizontal: 0.01,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ConstsWidget.buildTextSubTitle(context, 'Logradouro'),
                          ConstsWidget.buildTextTitle(
                              context, ResponsalvelInfos.endereco,
                              maxLines: 2),
                        ],
                      ),
                    ),
                    ConstsWidget.buildPadding001(
                      context,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ConstsWidget.buildTextSubTitle(context, 'Numero'),
                              ConstsWidget.buildTextTitle(
                                  context, ResponsalvelInfos.numero),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ConstsWidget.buildTextSubTitle(context, 'CEP'),
                              ConstsWidget.buildTextTitle(
                                  context, ResponsalvelInfos.cep),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstsWidget.buildTextSubTitle(context, 'Bairro'),
                            SizedBox(
                              width: size.width * 0.3,
                              child: ConstsWidget.buildTextTitle(
                                  context, ResponsalvelInfos.bairro,
                                  maxLines: 3),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstsWidget.buildTextSubTitle(context, 'Estado'),
                            SizedBox(
                              width: size.width * 0.2,
                              child: ConstsWidget.buildTextTitle(
                                  context, ResponsalvelInfos.estado,
                                  maxLines: 3),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstsWidget.buildTextSubTitle(context, 'Cidade'),
                            SizedBox(
                              width: size.width * 0.2,
                              child: ConstsWidget.buildTextTitle(
                                  context, ResponsalvelInfos.cidade,
                                  maxLines: 3, width: 0.3),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ConstsWidget.buildPadding001(
                      context,
                      child: ConstsWidget.buildPadding001(
                        context,
                        horizontal: 0.01,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ConstsWidget.buildTextSubTitle(
                                context, 'Resposta do morador para portaria'),
                            ConstsWidget.buildTextTitle(context,
                                '${ResponsalvelInfos.temporespostas} minutos'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ConstsWidget.buildPadding001(
                context,
                child: ConstsWidget.buildLoadingButton(
                  context,
                  title: 'Salvar',
                  isLoading: isLoading,
                  color: Consts.kColorRed,
                  onPressed: () {
                    FocusManager.instance.primaryFocus!.unfocus();
                    bool validForm =
                        formKeyResp.currentState?.validate() ?? false;

                    bool formValidSenha = false;
                    if ((novaSenhaCtrl.text.isNotEmpty &&
                        novaSenhaCtrl.text.length >= 6 &&
                        confirmSenhaCtrl.text == novaSenhaCtrl.text)) {
                      setState(() {
                        formValidSenha = true;
                      });
                    } else if ((novaSenhaCtrl.text.isNotEmpty &&
                        novaSenhaCtrl.text.length < 6 &&
                        confirmSenhaCtrl.text != novaSenhaCtrl.text)) {
                      setState(() {
                        formValidSenha = false;
                      });
                    } else if (novaSenhaCtrl.text.isEmpty) {
                      setState(() {
                        formValidSenha = false;
                      });
                    } else {
                      setState(() {
                        formValidSenha = false;
                      });
                    }

                    if (validForm && novaSenhaCtrl.text.isEmpty) {
                      formKeyResp.currentState?.save();
                      startEditarInfos();
                    } else if (validForm && formValidSenha) {
                      formKeyResp.currentState?.save();
                      startEditarInfos();
                      if (novaSenhaCtrl.text.isNotEmpty &&
                          novaSenhaCtrl.text == confirmSenhaCtrl.text) {
                        ConstsFuture.resquestApi(
                            '${Consts.sindicoApi}funcionarios/?fn=mudarSenha&idfuncionario=${ResponsalvelInfos.idfuncionario}&senha=${novaSenhaCtrl.text}&mudasenhalogin=${isChecked ? 1 : 0}&login=${ResponsalvelInfos.login}');
                      }
                    }
                  },
                ),
              )
            ],
          )),
        ),
        title: 'Meu Perfil');
  }
}
