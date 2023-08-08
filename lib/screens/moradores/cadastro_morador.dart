// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sindico_app/consts/consts_future.dart';
import 'package:sindico_app/forms/morador_form.dart';
import 'package:sindico_app/screens/moradores/lista_morador.dart';
import 'package:http/http.dart' as http;
import 'package:sindico_app/widgets/alert_dialogs/alertdialog_all.dart';
import '../../consts/const_widget.dart';
import '../../consts/consts.dart';
import '../../widgets/alert_dialogs/alert_trocar_senha.dart';
import '../../widgets/header.dart';
import '../../widgets/my_box_shadow.dart';
import '../../widgets/my_text_form_field.dart';
import '../../widgets/scaffold_all.dart';
import '../../widgets/snackbar/snack.dart';

class CadastroMorador extends StatefulWidget {
  int? idmorador;
  bool? ativo;
  String? nome_morador;
  String? login;
  String nascimento;
  String? telefone;
  String? ddd;
  String? documento;
  String? email;
  int? acesso;
  int? idunidade;
  int? iddivisao;
  String? localizado;
  bool isDrawer;
  int responsavel;
  CadastroMorador(
      {this.idmorador,
      this.nome_morador,
      this.login,
      this.telefone,
      this.ddd,
      this.nascimento = '',
      this.email = '',
      this.documento,
      this.acesso = 1,
      this.idunidade,
      this.ativo = true,
      this.iddivisao,
      this.localizado,
      this.isDrawer = false,
      this.responsavel = 1,
      super.key});

  @override
  State<CadastroMorador> createState() => _CadastroMoradorState();
}

class _CadastroMoradorState extends State<CadastroMorador> {
  Object? dropdownValueAtivo;
  List listAtivo = [1, 0];
  List categoryItemListDivisoes = [];
  String loginGerado = '';
  bool nomeDocAlterado = false;
  bool isLoading = false;
  var formkeySenha = GlobalKey<FormState>();
  TextEditingController atualSenhaCtrl = TextEditingController();
  TextEditingController novaSenhaCtrl = TextEditingController();
  TextEditingController confirmSenhaCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    apiListarDivisoes();
    _formInfosMorador =
        _formInfosMorador.copyWith(ativo: widget.ativo == true ? 1 : 0);
    _formInfosMorador = _formInfosMorador.copyWith(acesso: widget.acesso);
    _formInfosMorador =
        _formInfosMorador.copyWith(resposavel: widget.responsavel);
  }

  final _formKeyMorador = GlobalKey<FormState>();
  FormInfosMorador _formInfosMorador = FormInfosMorador();

  @override
  Widget build(BuildContext context) {
    @override
    var dataParsed = widget.nascimento != '' ? widget.nascimento : '';
    bool boolResponsavel = widget.idmorador == null
        ? true
        : widget.responsavel == 0
            ? false
            : true;
    bool isChecked = widget.acesso == null
        ? true
        : widget.acesso == 0
            ? false
            : true;
    var size = MediaQuery.of(context).size;

    return buildScaffoldAll(
      context,
      title: widget.isDrawer
          ? 'Meu Perfil'
          : widget.idmorador == null
              ? 'Incluir Morador'
              : 'Editar Morador',
      body: Form(
        key: _formKeyMorador,
        child: MyBoxShadow(
          child: Column(
            children: [
              ConstsWidget.buildPadding001(context,
                  child: ConstsWidget.buildTextTitle(
                      context, widget.localizado!,
                      size: 20)),
              buildAtivoInativo2(
                context,
              ),
              buildMyTextFormObrigatorio(
                context,
                'Nome Completo',
                initialValue: widget.nome_morador,
                onSaved: (text) {
                  if (_formInfosMorador.nome_morador != text) {
                    setState(() {
                      nomeDocAlterado = true;
                    });
                  }
                  _formInfosMorador =
                      _formInfosMorador.copyWith(nome_morador: text);
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: size.width * 0.37,
                    child: buildMyTextFormObrigatorio(
                        context,
                        initialValue: dataParsed,
                        'Data de Nascimento',
                        keyboardType: TextInputType.number,
                        mask: '##/##/####',
                        hintText: '##/##/####', onSaved: (text) {
                      // var replace = text!.replaceAll('/', '-');

                      var ano = text!.substring(6);
                      var mes = text.substring(3, 5);
                      var dia = text.substring(0, 2);

                      _formInfosMorador = _formInfosMorador.copyWith(
                          nascimento: '$ano-$mes-$dia');
                    }),
                  ),
                  SizedBox(
                    width: size.width * 0.5,
                    child: buildMyTextFormObrigatorio(
                      context,
                      'Documento',
                      initialValue: widget.documento,
                      keyboardType: TextInputType.number,
                      hintText: 'RG, CPF',
                      onSaved: (text) {
                        if (_formInfosMorador.nome_morador != text) {
                          setState(() {
                            nomeDocAlterado = true;
                          });
                        }
                        _formInfosMorador =
                            _formInfosMorador.copyWith(documento: text);
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: size.width * 0.18,
                    child: buildMyTextFormObrigatorio(
                        context,
                        initialValue: widget.ddd,
                        onSaved: (text) => _formInfosMorador =
                            _formInfosMorador.copyWith(ddd: text),
                        'DDD',
                        keyboardType: TextInputType.number,
                        mask: '##',
                        hintText: '11'),
                  ),
                  SizedBox(
                    width: size.width * 0.1,
                  ),
                  SizedBox(
                    width: size.width * 0.5,
                    child: buildMyTextFormObrigatorio(
                      context,
                      'Telefone',
                      initialValue: widget.telefone,
                      keyboardType: TextInputType.number,
                      mask: '# ########',
                      hintText: '9 11223344',
                      onSaved: (text) => _formInfosMorador =
                          _formInfosMorador.copyWith(telefone: text),
                    ),
                  ),
                ],
              ),
              buildMyTextFormObrigatorio(
                context,
                'Email',
                initialValue: widget.email,
                keyboardType: TextInputType.number,
                hintText: 'exemplo@exe.com',
                onSaved: (text) =>
                    _formInfosMorador = _formInfosMorador.copyWith(email: text),
              ),
              ConstsWidget.buildCustomButton(
                context,
                'Gerar Login',
                onPressed: () {
                  var formValid =
                      _formKeyMorador.currentState?.validate() ?? false;
                  if (nomeDocAlterado) {
                    buildMinhaSnackBar(context,
                        title: 'Dados alterados',
                        subTitle: 'Alteramos o login');
                  }
                  if (formValid) {
                    _formKeyMorador.currentState?.save();
                    if (_formInfosMorador.nascimento!.length >= 6) {
                      List nomeEmLista =
                          _formInfosMorador.nome_morador!.split(' ');
                      List listaNome = nomeEmLista;

                      setState(() {
                        loginGerado =
                            '${listaNome.first.toString().toLowerCase()}${listaNome.last.toString().toLowerCase()}${_formInfosMorador.documento!.substring(0, 4)}';
                        _formInfosMorador =
                            _formInfosMorador.copyWith(login: loginGerado);
                      });
                    } else {
                      buildMinhaSnackBar(context,
                          title: 'Cuidado', subTitle: 'Complete a data');
                    }
                  }
                },
              ),
              if (loginGerado != '')
                Column(
                  children: [
                    ConstsWidget.buildPadding001(
                      context,
                      child: MyBoxShadow(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                ConstsWidget.buildTextSubTitle('Login'),
                                ConstsWidget.buildTextTitle(
                                  context,
                                  loginGerado,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (widget.idmorador == null)
                      buildMyTextFormObrigatorio(context, 'Senha Login',
                          onSaved: (text) => _formInfosMorador =
                              _formInfosMorador.copyWith(senhaLogin: text),
                          initialValue: '123456'),
                    if (widget.idmorador == null)
                      buildMyTextFormObrigatorio(context, 'Senha Retirada',
                          onSaved: (text) => _formInfosMorador =
                              _formInfosMorador.copyWith(senhaRetirada: text),
                          initialValue: '123456'),
                    // widget.idmorador == null
                    //     ? buildMyTextFormObrigatorio(
                    //         context,
                    //         'Senha Login',
                    //         controller: novaSenhaCtrl,
                    //       )
                    //     : ConstsWidget.buildOutlinedButton(
                    //         context,
                    //         title: 'Trocar Senha',
                    //         onPressed: () {
                    //           trocarSenhaAlert(
                    //             context,
                    //             formkeySenha: formkeySenha,
                    //             atualSenhaCtrl: atualSenhaCtrl,
                    //             novaSenhaCtrl: novaSenhaCtrl,
                    //             confirmSenhaCtrl: confirmSenhaCtrl,
                    //           );
                    //         },
                    //       ),
                    StatefulBuilder(builder: (context, setState) {
                      return ConstsWidget.buildCheckBox(context,
                          isChecked: boolResponsavel, onChanged: (p0) {
                        setState(() {
                          boolResponsavel = !boolResponsavel;
                          _formInfosMorador = _formInfosMorador.copyWith(
                              resposavel: boolResponsavel ? 1 : 0);
                        });
                      }, title: 'Resposável');
                    }),
                    StatefulBuilder(builder: (context, setState) {
                      return ConstsWidget.buildCheckBox(context,
                          isChecked: isChecked, onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                          _formInfosMorador = _formInfosMorador.copyWith(
                              acesso: isChecked == true ? 1 : 0);
                        });
                      }, title: 'Permitir acesso ao sistema');
                    }),
                    ConstsWidget.buildLoadingButton(
                      context,
                      title: 'Salvar',
                      isLoading: isLoading,
                      color: Consts.kColorRed,
                      onPressed: () {
                        var formValid =
                            _formKeyMorador.currentState?.validate() ?? false;
                        if (formValid && !widget.isDrawer) {
                          salvarMorador();
                        }
                      },
                    )
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }

  Future apiListarDivisoes() async {
    var uri =
        '${Consts.sindicoApi}divisoes/?fn=listarDivisoes&idcond=${ResponsalvelInfos.idcondominio}';

    final response = await http.get(Uri.parse(uri));
    _formInfosMorador = _formInfosMorador.copyWith(acesso: widget.acesso);

    if (response.statusCode == 200) {
      final jsonresponse = json.decode(response.body);
      var divisoes = jsonresponse['divisoes'];
      setState(() {
        categoryItemListDivisoes = divisoes;
      });
    } else {
      throw response.statusCode;
    }
  }

  salvarMorador() {
    setState(() {
      isLoading = true;
    });
    _formKeyMorador.currentState?.save();
    String restoApi = '';
    widget.idmorador == null
        ? restoApi =
            'incluirMorador&senha=${_formInfosMorador.senhaLogin}&senha_retirada=${_formInfosMorador.senhaRetirada}'
        : restoApi = 'editarMorador&id=${widget.idmorador}';
    return ConstsFuture.resquestApi(
      '${Consts.sindicoApi}moradores/?fn=$restoApi&idunidade=${widget.idunidade}&idcond=${ResponsalvelInfos.idcondominio}&iddivisao=${widget.iddivisao}&ativo=${_formInfosMorador.ativo}&nomeMorador=${_formInfosMorador.nome_morador}&login=$loginGerado&datanasc=${_formInfosMorador.nascimento}&documento=${_formInfosMorador.documento}&dddtelefone=${_formInfosMorador.ddd}&telefone=${_formInfosMorador.telefone}&email=${_formInfosMorador.email}&acessa_sistema=${_formInfosMorador.acesso}&responsavel=${_formInfosMorador.resposavel}',
    ).then((value) {
      setState(() {
        isLoading = false;
      });
      if (!value['erro']) {
        Navigator.pop(context);
        ConstsFuture.navigatorPagePush(
          context,
          ListaMorador(
            idunidade: widget.idunidade,
            idvisisao: widget.iddivisao,
            localizado: widget.localizado,
          ),
        ).then((value) {
          setState(() {});
          Navigator.pop(context);
          return buildMinhaSnackBar(context,
              title: 'Tudo Certo!', subTitle: value['Mensagem']);
        });
      } else {
        return buildMinhaSnackBar(context, subTitle: value['Mensagem']);
      }
    });

    // ConstsFuture.navigatorPageReplace(
    //     context,
    //     ListaMorador(
    //       idunidade: widget.idunidade,
    //     ));
  }

  Widget buildAtivoInativo2(
    BuildContext context, {
    int seEditando = 0,
  }) {
    var size = MediaQuery.of(context).size;
    return ConstsWidget.buildPadding001(
      context,
      child: StatefulBuilder(builder: (context, setState) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                value: dropdownValueAtivo =
                    widget.idmorador == null ? 1 : _formInfosMorador.ativo,
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
                    _formInfosMorador =
                        _formInfosMorador.copyWith(ativo: value);
                  });
                },
                items: listAtivo.map<DropdownMenuItem>((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: value == 0 ? Text('Inativo') : Text('Ativo'),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      }),
    );
  }
}
