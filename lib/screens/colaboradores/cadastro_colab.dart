import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sindico_app/screens/colaboradores/lista_colaboradores.dart';
import 'package:sindico_app/screens/splash_screen/splash_screen.dart';
import 'package:sindico_app/widgets/header.dart';
import 'package:sindico_app/widgets/scaffold_all.dart';
import 'package:sindico_app/widgets/snackbar/snack.dart';
import 'package:http/http.dart' as http;
import 'package:validatorless/validatorless.dart';

import '../../consts/consts.dart';
import '../../consts/const_widget.dart';
import '../../consts/consts_future.dart';
import '../../forms/funcionario_form.dart';
import '../../widgets/alert_dialogs/alertdialog_all.dart';
import '../../widgets/my_box_shadow.dart';
import '../../widgets/my_text_form_field.dart';
import 'package:diacritic/diacritic.dart';

class CadastroColaborador extends StatefulWidget {
  final int? idfuncionario;
  final Object? idfuncao;
  final int ativo;
  final String nomeFuncionario;
  final String funcao;
  final String login;
  final String? nascimento;
  final String? telefone;
  final String? ddd;
  final String? email;
  final String? documento;
  final bool avisa_corresp;
  final bool avisa_visita;
  final bool avisa_delivery;
  final bool avisa_encomendas;
  final bool envia_avisos;

  const CadastroColaborador({
    this.ativo = 1,
    this.idfuncao,
    this.idfuncionario,
    this.nomeFuncionario = '',
    this.funcao = '',
    this.login = '',
    this.telefone,
    this.ddd,
    this.email,
    this.nascimento,
    this.documento,
    this.avisa_corresp = false,
    this.avisa_visita = false,
    this.avisa_delivery = false,
    this.avisa_encomendas = false,
    this.envia_avisos = false,
    super.key,
  });

  @override
  State<CadastroColaborador> createState() => _CadastroColaboradorState();
}

List listAtivo = [1, 0];

class _CadastroColaboradorState extends State<CadastroColaborador> {
  Object? dropdownValueAtivo;
  bool isLoadingLogin = false;
  final _formkeyFuncionario = GlobalKey<FormState>();
  final _formkeySenha = GlobalKey<FormState>();
  FormInfosFunc formInfosFunc = FormInfosFunc();
  final TextEditingController atualSenhaCtrl = TextEditingController();
  final TextEditingController novaSenhaCtrl = TextEditingController();
  final TextEditingController confirmSenhaCtrl = TextEditingController();
  @override
  void initState() {
    super.initState();
    apiListarFuncoes();
    salvarFuncaoForm();
  }

  salvarFuncaoForm() {
    formInfosFunc = formInfosFunc.copyWith(ativo: widget.ativo);
    formInfosFunc = formInfosFunc.copyWith(idfuncao: widget.idfuncao);
    formInfosFunc = formInfosFunc.copyWith(idfuncao: widget.idfuncao);
    formInfosFunc = formInfosFunc.copyWith(
        avisa_corresp: widget.avisa_corresp == true ? 1 : 0);
    formInfosFunc = formInfosFunc.copyWith(
        avisa_delivery: widget.avisa_delivery == true ? 1 : 0);
    formInfosFunc = formInfosFunc.copyWith(
        avisa_visita: widget.avisa_visita == true ? 1 : 0);
    formInfosFunc = formInfosFunc.copyWith(
        avisa_encomendas: widget.avisa_encomendas == true ? 1 : 0);
    formInfosFunc = formInfosFunc.copyWith(
        envia_avisos: widget.envia_avisos == true ? 1 : 0);
  }

  List categoryItemListFuncoes = [];
  Future apiListarFuncoes() async {
    var uri = Uri.parse(
        '${Consts.sindicoApi}funcoes/?fn=listarFuncoes&idcond=${ResponsalvelInfos.idcondominio}&idfuncionariologado=${ResponsalvelInfos.idfuncionario}');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      setState(() {
        categoryItemListFuncoes = jsonResponse['funcao'];
      });
    } else {
      return false;
    }
  }

  String loginGerado2 = '';
  bool isLoading = false;
  bool nomeDocAlterado = false;
  bool isGerarSenha = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Widget buildDropdownButtonFuncoes() {
      return ConstsWidget.buildDecorationDrop(
        context,
        child: DropdownButton(
          elevation: 24,
          isExpanded: true,
          icon: Icon(
            Icons.arrow_downward,
            color: Theme.of(context).iconTheme.color,
          ),
          borderRadius: BorderRadius.circular(16),
          hint: Text('Selecione Uma Função'),
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w400,
              fontSize: SplashScreen.isSmall ? 16 : 18),
          items: categoryItemListFuncoes.map((e) {
            return DropdownMenuItem(
              value: e['idfuncao'],
              child: Text(e['funcao']),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              formInfosFunc = formInfosFunc.copyWith(idfuncao: value);
            });
          },
          value: formInfosFunc.idfuncao,
        ),
      );
    }

    Widget buildTilePermissao(BuildContext context, String title,
        {required int nomeCampo, bool isChecked = false}) {
      return StatefulBuilder(builder: (context, setState) {
        return ConstsWidget.buildCheckBox(context,
            isChecked: isChecked,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            onChanged: (bool? value) {
          setState(() {
            isChecked = value!;
            int isCheckedApi = isChecked ? 1 : 0;
            switch (nomeCampo) {
              case 0:
                formInfosFunc =
                    formInfosFunc.copyWith(avisa_corresp: isCheckedApi);
                break;
              case 1:
                formInfosFunc =
                    formInfosFunc.copyWith(avisa_visita: isCheckedApi);
                break;
              case 2:
                formInfosFunc =
                    formInfosFunc.copyWith(avisa_delivery: isCheckedApi);

                break;
              case 3:
                formInfosFunc =
                    formInfosFunc.copyWith(avisa_encomendas: isCheckedApi);
                break;
              case 4:
                formInfosFunc =
                    formInfosFunc.copyWith(envia_avisos: isCheckedApi);

                break;
              default:
            }
            // if (nomeCampo == 0) {
            //   formInfosFunc = formInfosFunc.copyWith(
            //       avisa_corresp: isCheckedApi);
            // } else if (nomeCampo == 1) {
            //   formInfosFunc = formInfosFunc.copyWith(
            //       avisa_visita: isCheckedApi);
            // } else if (nomeCampo == 2) {
            //   formInfosFunc = formInfosFunc.copyWith(
            //       avisa_delivery: isCheckedApi);
            // } else if (nomeCampo == 3) {
            //   formInfosFunc = formInfosFunc.copyWith(
            //       avisa_encomendas: isCheckedApi);
            // }
          });
        }, title: title);
      });
    }

    return buildScaffoldAll(
      context,
      title: widget.idfuncionario != null
          ? 'Editar Colaborador'
          : 'Novo Colaborador',
      body: Form(
        key: _formkeyFuncionario,
        child: MyBoxShadow(
          child: ConstsWidget.buildPadding001(
            context,
            vertical: 0.015,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildDropAtivo(
                  context,
                ),
                buildMyTextFormObrigatorio(
                    context,
                    initialValue: widget.nomeFuncionario,
                    textCapitalization: TextCapitalization.words,
                    'Nome Completo',
                    hintText: 'Joao da Silva Sousa', onSaved: (text) {
                  formInfosFunc =
                      formInfosFunc.copyWith(nome_funcionario: text);
                  if (text != widget.nomeFuncionario) {
                    setState(() {
                      nomeDocAlterado = true;
                    });
                  }
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: size.width * 0.4,
                      child: buildMyTextFormField(context,
                          title: 'Data de nascimento',
                          initialValue: widget.nascimento, onSaved: (text) {
                        if (text != '') {
                          if (text!.length >= 6) {
                            var ano = text.substring(6);
                            var mes = text.substring(3, 5);
                            var dia = text.substring(0, 2);
                            formInfosFunc = formInfosFunc.copyWith(
                                nascimento: '$ano-$mes-$dia');
                          }
                        } else {
                          formInfosFunc =
                              formInfosFunc.copyWith(nascimento: "");
                        }
                      }, hintText: '25/09/1997', mask: '##/##/####'),
                    ),
                    SizedBox(
                      width: size.width * 0.5,
                      child: buildMyTextFormObrigatorio(
                        context,
                        'Documento',
                        hintText: 'Exemplo: RG, CPF',
                        initialValue: widget.documento,
                        onSaved: (text) {
                          if (text!.length >= 4) {
                            formInfosFunc =
                                formInfosFunc.copyWith(documento: text);
                            if (text != widget.documento) {
                              setState(() {
                                nomeDocAlterado = true;
                              });
                            }
                          } else {
                            buildMinhaSnackBar(context,
                                title: 'Cuidado',
                                subTitle: 'Complete o documento');
                          }
                        },
                      ),
                    ),
                  ],
                ),
                ConstsWidget.buildPadding001(
                  context,
                  child: buildDropdownButtonFuncoes(),
                ),
                ConstsWidget.buildPadding001(
                  context,
                  horizontal: 0.01,
                  child: ConstsWidget.buildTextTitle(context, 'Contatos'),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: size.width * 0.2,
                      child: buildMyTextFormField(
                        context,
                        title: 'DDD',
                        hintText: '11',
                        initialValue: widget.ddd,
                        mask: '##',
                        onSaved: (text) =>
                            formInfosFunc = formInfosFunc.copyWith(ddd: text),
                      ),
                    ),
                    Spacer(),
                    SizedBox(
                      width: size.width * 0.4,
                      child: buildMyTextFormField(context,
                          title: 'Telefone',
                          onSaved: (text) => formInfosFunc =
                              formInfosFunc.copyWith(telefone: text),
                          initialValue: widget.telefone,
                          mask: '#########',
                          hintText: '911112222'),
                    ),
                    Spacer(),
                  ],
                ),
                buildMyTextFormObrigatorio(
                  context,
                  'Email',
                  hintText: 'exemplo@exp.com',
                  initialValue: widget.email,
                  validator: Validatorless.multiple([
                    Validatorless.required('Obrigatório'),
                    Validatorless.email('Preencha com um email válido')
                  ]),
                  onSaved: (text) =>
                      formInfosFunc = formInfosFunc.copyWith(email: text),
                ),
                ConstsWidget.buildLoadingButton(
                  context,
                  title: 'Gerar Login',
                  isLoading: isLoadingLogin,
                  onPressed: () {
                    setState(() {
                      isLoadingLogin = true;
                    });
                    var formValid =
                        _formkeyFuncionario.currentState?.validate() ?? false;
                    if (formValid) {
                      _formkeyFuncionario.currentState?.save();
                      ConstsFuture.gerarLogin(context,
                              documento: formInfosFunc.documento!,
                              nomeDocAlterado: nomeDocAlterado,
                              nomeUsado: formInfosFunc.nome_funcionario)
                          .then((value) {
                        setState(() {
                          isLoadingLogin = false;
                        });
                        if (value != '') {
                          setState(() {
                            loginGerado2 = value;
                            formInfosFunc =
                                formInfosFunc.copyWith(login: loginGerado2);
                          });
                        } else {
                          buildMinhaSnackBar(context,
                              title: 'Algo Saiu Mal',
                              subTitle: 'O login não foi gerado');
                        }
                      });
                    } else {
                      setState(() {
                        isLoadingLogin = false;
                      });
                      buildMinhaSnackBar(context,
                          title: 'Cuidado',
                          subTitle: 'Complete as Informações');
                    }
                  },
                ),
                if (loginGerado2 != '')
                  ConstsWidget.buildPadding001(
                    context,
                    child: Column(
                      children: [
                        MyBoxShadow(
                            child: ConstsWidget.buildPadding001(
                          context,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ConstsWidget.buildTextSubTitle('Login'),
                                  ConstsWidget.buildTextTitle(
                                      context, loginGerado2),
                                ],
                              ),
                            ],
                          ),
                        )),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        if (formInfosFunc.idfuncao != 2 &&
                            formInfosFunc.idfuncao != 5 &&
                            formInfosFunc.idfuncao != 4)
                          ConstsWidget.buildPadding001(
                            context,
                            child: Column(
                              children: [
                                ConstsWidget.buildTextTitle(
                                    context, 'Tipos de acesso'),
                                buildTilePermissao(context, 'Avisos de Cartas',
                                    nomeCampo: 0,
                                    isChecked: widget.avisa_corresp),
                                buildTilePermissao(context, 'Avisos de Visitas',
                                    nomeCampo: 1,
                                    isChecked: widget.avisa_visita),
                                buildTilePermissao(
                                    context, 'Avisos de Delivery',
                                    nomeCampo: 2,
                                    isChecked: widget.avisa_delivery),
                                buildTilePermissao(context, 'Avisos de Caixas',
                                    nomeCampo: 3,
                                    isChecked: widget.avisa_encomendas),
                              ],
                            ),
                          ),
                        buildTilePermissao(context, 'Avisos Gerais',
                            nomeCampo: 4, isChecked: widget.envia_avisos),
                        if (widget.idfuncionario != null)
                          StatefulBuilder(builder: (context, setState) {
                            return ConstsWidget.buildCheckBox(context,
                                isChecked: isGerarSenha,
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween, onChanged: (bool? value) {
                              setState(() {
                                isGerarSenha = value!;
                              });
                            }, title: 'Gerar Senha e Enviar Acesso');
                          }),
                        ConstsWidget.buildLoadingButton(
                          context,
                          title: 'Salvar',
                          isLoading: isLoading,
                          color: Consts.kColorRed,
                          onPressed: () {
                            if (_formkeyFuncionario.currentState!.validate() &&
                                formInfosFunc.idfuncao != null) {
                              _formkeyFuncionario.currentState!.save();
                              loadingSalvar();
                            } else {
                              buildMinhaSnackBar(context,
                                  subTitle: 'Selecione uma Função');
                            }
                          },
                        )
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

  loadingSalvar() {
    setState(() {
      isLoading = true;
    });

    var apiEditarIncluir = widget.idfuncionario != null
        ? 'editarFuncionario&idfuncionario=${widget.idfuncionario}&gerarsenha=${isGerarSenha ? 1 : 0}'
        : 'incluirFuncionario';

    String datanasc = formInfosFunc.nascimento != ''
        ? '&datanasc=${formInfosFunc.nascimento}'
        : '';
    String dddtelefone =
        formInfosFunc.ddd != '' ? '&dddtelefone=${formInfosFunc.ddd}' : '';
    String telefone = formInfosFunc.telefone != ''
        ? '&telefone=${formInfosFunc.telefone}'
        : '';

    ConstsFuture.resquestApi(
            '${Consts.sindicoApi}funcionarios/?fn=$apiEditarIncluir&idcond=${ResponsalvelInfos.idcondominio}&idfuncionariologado=${ResponsalvelInfos.idfuncionario}&nome_funcionario=${formInfosFunc.nome_funcionario}&idfuncao=${formInfosFunc.idfuncao}&email=${formInfosFunc.email}&documento=${formInfosFunc.documento}$dddtelefone$telefone$datanasc&login=${formInfosFunc.login}&avisa_corresp=${formInfosFunc.avisa_corresp}&avisa_visita=${formInfosFunc.avisa_visita}&avisa_delivery=${formInfosFunc.avisa_delivery}&avisa_encomendas=${formInfosFunc.avisa_encomendas}&envia_avisos=${formInfosFunc.envia_avisos}&ativo=${formInfosFunc.ativo}')
        .then((value) {
      setState(() {
        isLoading = false;
      });
      if (!value['erro']) {
        ConstsFuture.navigatorPopPush(context, '/listaColaboradores');
        return buildMinhaSnackBar(context,
            title: 'Parabéns', subTitle: value['mensagem']);
      }
      return buildMinhaSnackBar(context,
          title: 'Algo deu errado!', subTitle: value['mensagem']);
    });
  }

  Widget buildDropAtivo(
    BuildContext context, {
    int seEditando = 0,
  }) {
    var size = MediaQuery.of(context).size;
    return ConstsWidget.buildPadding001(
      context,
      child: StatefulBuilder(builder: (context, setState) {
        return ConstsWidget.buildDecorationDrop(
          context,
          child: DropdownButton(
            value: dropdownValueAtivo = formInfosFunc.ativo,
            icon: Padding(
              padding: EdgeInsets.only(right: size.height * 0.03),
              child: Icon(
                Icons.arrow_downward,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            elevation: 24,
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w400,
                fontSize: 18),
            borderRadius: BorderRadius.circular(16),
            onChanged: (value) {
              setState(() {
                dropdownValueAtivo = value!;
                formInfosFunc = formInfosFunc.copyWith(ativo: value);
              });
            },
            items: listAtivo.map<DropdownMenuItem>((value) {
              return DropdownMenuItem(
                value: value,
                child: value == 0 ? Text('Inativo') : Text('Ativo'),
              );
            }).toList(),
          ),
        );
      }),
    );
  }
}
