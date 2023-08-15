import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sindico_app/consts/const_widget.dart';
import 'package:sindico_app/consts/consts.dart';
import 'package:sindico_app/consts/consts_future.dart';
import 'package:sindico_app/widgets/my_box_shadow.dart';
import 'package:sindico_app/widgets/my_text_form_field.dart';
import 'package:sindico_app/widgets/scaffold_all.dart';
import 'package:sindico_app/widgets/snackbar/snack.dart';
import 'package:validatorless/validatorless.dart';

import '../../forms/responsavel_form.dart';

class MeuPerfilScreen extends StatefulWidget {
  const MeuPerfilScreen({super.key});

  @override
  State<MeuPerfilScreen> createState() => _MeuPerfilScreenState();
}

class _MeuPerfilScreenState extends State<MeuPerfilScreen> {
  FormInfosResp responsalvelInfos = FormInfosResp();
  final formKeyResp = GlobalKey<FormState>();
  bool isLoading = false;

  startEditarInfos() {
    setState(() {
      isLoading = true;
    });

    ConstsFuture.resquestApi(
            '${Consts.sindicoApi}funcionarios/?fn=editarFuncionario&idcond=${ResponsalvelInfos.idcondominio}&idfuncao=2&idfuncionario=${ResponsalvelInfos.idfuncionario}&nome_funcionario=${ResponsalvelInfos.nome_responsavel}&datanasc=${responsalvelInfos.nascimento}&documento=${responsalvelInfos.documento}&email=${responsalvelInfos.email}&telefone=${responsalvelInfos.telefone}&login=${ResponsalvelInfos.login}&avisa_corresp=1&avisa_visita=1&avisa_delivery=1&avisa_encomendas=1')
        .then((value) {
      setState(() {
        isLoading = false;
      });
      if (!value['erro']) {
        Navigator.pop(context);
        buildMinhaSnackBar(context,
            title: 'Muito bem!', subTitle: value['mensagem']);
      } else {
        buildMinhaSnackBar(context, subTitle: value['mensagem']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return buildScaffoldAll(context,
        body: Form(
          key: formKeyResp,
          child: MyBoxShadow(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstsWidget.buildPadding001(
                context,
                child: Center(
                  child: Column(
                    children: [
                      ConstsWidget.buildTextTitle(
                          context, ResponsalvelInfos.nome_responsavel,
                          size: 18),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      ConstsWidget.buildTextSubTitle('Meu Login'),
                      ConstsWidget.buildTextTitle(
                          context, ResponsalvelInfos.login,
                          size: 20),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: size.width * 0.4,
                    child: buildMyTextFormObrigatorio(
                        context, 'Data de Nascimento',
                        hintText: 'Ex: 25/09/1997',
                        readOnly: true,
                        initialValue: DateFormat('dd/MM/yyyy').format(
                            DateTime.parse(ResponsalvelInfos.nascimento)),
                        onSaved: (text) {
                      if (text!.length >= 6) {
                        var ano = text.substring(6);
                        var mes = text.substring(3, 5);
                        var dia = text.substring(0, 2);
                        responsalvelInfos = responsalvelInfos.copyWith(
                            nascimento: '$ano-$mes-$dia');
                      }
                    }, mask: '##/##/####', keyboardType: TextInputType.number),
                  ),
                  Spacer(),
                  SizedBox(
                    width: size.width * 0.45,
                    child: buildMyTextFormObrigatorio(context, 'Documento',
                        hintText: 'Ex: RG, CPF',
                        initialValue: ResponsalvelInfos.documento,
                        readOnly: true,
                        onSaved: (text) => responsalvelInfos =
                            responsalvelInfos.copyWith(documento: text),
                        keyboardType: TextInputType.number),
                  )
                ],
              ),
              ConstsWidget.buildPadding001(context,
                  child: ConstsWidget.buildTextTitle(context, 'Contatos',
                      size: 18)),
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
                    child: buildMyTextFormObrigatorio(context, 'Telefone',
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
                validator: Validatorless.email('Não é um email válido'),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),

              /*  ConstsWidget.buildPadding001(
                context,
                child:*/
              ConstsWidget.buildTextTitle(
                  context, 'Dados ${ResponsalvelInfos.nome_condominio}',
                  size: 20),
              //     ),
              ConstsWidget.buildTextSubTitle(
                  'Aqui só pode ser alterados pela nossa equipe'),
              SizedBox(
                height: size.height * 0.01,
              ),
              MyBoxShadow(
                child: Column(
                  children: [
                    ConstsWidget.buildPadding001(
                      context,
                      horizontal: 0.01,
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ConstsWidget.buildTextSubTitle('Logradouro'),
                              ConstsWidget.buildTextTitle(
                                  context, ResponsalvelInfos.endereco),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstsWidget.buildTextSubTitle('Numero'),
                            ConstsWidget.buildTextTitle(
                                context, ResponsalvelInfos.numero),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstsWidget.buildTextSubTitle('CEP'),
                            ConstsWidget.buildTextTitle(
                                context, ResponsalvelInfos.cep),
                          ],
                        ),
                      ],
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
                            ConstsWidget.buildTextSubTitle('Bairro'),
                            ConstsWidget.buildTextTitle(
                                context, ResponsalvelInfos.bairro),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstsWidget.buildTextSubTitle('Estado'),
                            ConstsWidget.buildTextTitle(
                                context, ResponsalvelInfos.estado),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstsWidget.buildTextSubTitle('Cidade'),
                            ConstsWidget.buildTextTitle(
                                context, ResponsalvelInfos.cidade),
                          ],
                        ),
                      ],
                    ),
                    ConstsWidget.buildPadding001(
                      context,
                      horizontal: 0.01,
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ConstsWidget.buildTextSubTitle(
                                  'Resposta do morador para portaria'),
                              ConstsWidget.buildTextTitle(context,
                                  '${ResponsalvelInfos.temporespostas} minutos'),
                            ],
                          ),
                        ],
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
                  onPressed: () {
                    bool validForm =
                        formKeyResp.currentState?.validate() ?? false;
                    if (validForm) {
                      formKeyResp.currentState?.save();
                      ResponsalvelInfos.nascimento =
                          responsalvelInfos.nascimento;
                      ResponsalvelInfos.telefone = responsalvelInfos.telefone!;
                      ResponsalvelInfos.documento =
                          responsalvelInfos.documento!;
                      ResponsalvelInfos.email = responsalvelInfos.email!;
                      startEditarInfos();
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
