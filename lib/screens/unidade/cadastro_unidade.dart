import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sindico_app/forms/unidades_form.dart';
import 'package:sindico_app/widgets/header.dart';
import 'package:sindico_app/widgets/scaffold_all.dart';
import 'package:sindico_app/widgets/snackbar/snack.dart';
import '../../consts/consts.dart';
import '../../consts/const_widget.dart';
import '../../consts/consts_future.dart';
import '../../widgets/my_box_shadow.dart';
import '../../widgets/my_text_form_field.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class CadastroUnidades extends StatefulWidget {
  final int? idunidade;
  final Object? iddivisao;
  final bool ativo;
  final String? localizado;
  final String? numero;
  final String? nome_responsavel;
  final String? dataNascimento;
  final String? documento;
  final String? email;
  final String? login;
  final String? ddd;
  final String? telefone;
  const CadastroUnidades({
    this.iddivisao,
    this.idunidade,
    super.key,
    this.numero,
    this.nome_responsavel,
    this.dataNascimento,
    this.documento,
    this.email,
    this.login,
    this.ddd,
    this.telefone,
    this.ativo = true,
    this.localizado,
  });

  @override
  State<CadastroUnidades> createState() => _CadastroUnidadesState();
}

class _CadastroUnidadesState extends State<CadastroUnidades> {
  final _formkeyUnidade = GlobalKey<FormState>();
  FormInfosUnidade formInfosUnidade = FormInfosUnidade();

  @override
  void initState() {
    super.initState();
    apiListarDivisoes();
    setInfosMorador();
  }

  setInfosMorador() {
    formInfosUnidade = formInfosUnidade.copyWith(iddivisao: widget.iddivisao);
    formInfosUnidade = formInfosUnidade.copyWith(numero: widget.numero);
    formInfosUnidade =
        formInfosUnidade.copyWith(responsavel: widget.nome_responsavel);
    formInfosUnidade =
        formInfosUnidade.copyWith(nascimento: widget.dataNascimento);
    formInfosUnidade = formInfosUnidade.copyWith(documento: widget.documento);
    formInfosUnidade = formInfosUnidade.copyWith(email: widget.email);
    formInfosUnidade = formInfosUnidade.copyWith(login: widget.login);
    formInfosUnidade = formInfosUnidade.copyWith(ddd: widget.ddd);
    formInfosUnidade = formInfosUnidade.copyWith(telefone: widget.telefone);
    formInfosUnidade = formInfosUnidade.copyWith(ativo: widget.ativo ? 1 : 0);
  }

  List categoryItemListDivisoes = [];
  // Object? dropdownValueDivisioes;
  Future apiListarDivisoes() async {
    var uri =
        '${Consts.sindicoApi}divisoes/?fn=listarDivisoes&idcond=${ResponsalvelInfos.idcondominio}';

    final response = await http.get(Uri.parse(uri));

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

  String loginGerado = '';
  String dataLogin = '';
  bool isChecked = true;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Widget buildDropButton() {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              shape: Border.all(color: Colors.black),
              child: DropdownButton(
                elevation: 24,
                isExpanded: true,
                hint: Text('Selecione uma Divisão'),
                icon: Icon(
                  Icons.arrow_downward_outlined,
                ),
                borderRadius: BorderRadius.circular(16),
                style: TextStyle(
                  // fontWeight: FontWeight.bold,
                  fontSize: Consts.fontTitulo,
                ),
                items: categoryItemListDivisoes.map((e) {
                  return DropdownMenuItem(
                    alignment: Alignment.center,
                    value: e['iddivisao'],
                    child:
                        ConstsWidget.buildTextTitle(context, e['nome_divisao']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    // dropdownValueDivisioes = value;
                    formInfosUnidade =
                        formInfosUnidade.copyWith(iddivisao: value);
                  });
                },
                value: formInfosUnidade.iddivisao,
              ),
            ),
          ),
        ),
      );
    }

    List<String> listAtivo = <String>['Ativo', 'Inativo'];
    var seAtivo = widget.ativo == true ? 'Ativo' : 'Inativo';
    var dropdownValueAtivo = listAtivo.first;

    return buildScaffoldAll(context,
        title: widget.idunidade == 0 ? 'Nova Unidade' : 'Editar Unidade',
        body: Form(
          key: _formkeyUnidade,
          child: MyBoxShadow(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //infos unidade
                  // if (widget.idunidade == null)
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          border: Border.all(color: Colors.black26),
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            shape: Border.all(color: Colors.black),
                            child: DropdownButton(
                              alignment: Alignment.center,
                              value: widget.idunidade == 0
                                  ? dropdownValueAtivo
                                  : seAtivo,
                              icon: Icon(
                                Icons.arrow_downward_outlined,
                              ),
                              elevation: 24,
                              style: TextStyle(
                                fontSize: Consts.fontTitulo,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              items: listAtivo
                                  .map<DropdownMenuItem>((String value) {
                                return DropdownMenuItem(
                                  alignment: Alignment.center,
                                  value: value,
                                  child: ConstsWidget.buildTextTitle(
                                      context, value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  dropdownValueAtivo = value!;
                                  if (dropdownValueAtivo == 'Ativo') {
                                    formInfosUnidade =
                                        formInfosUnidade.copyWith(ativo: 1);
                                  } else if (dropdownValueAtivo == 'Inativo') {
                                    formInfosUnidade =
                                        formInfosUnidade.copyWith(ativo: 0);
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      widget.idunidade == null
                          ? buildDropButton()
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: size.height * 0.015),
                              child: ConstsWidget.buildTextTitle(
                                  context, widget.localizado!),
                            ),
                      //infos resp
                      if (widget.idunidade == null)
                        buildMyTextFormObrigatorio(
                          context,
                          'Número',
                          // readOnly: widget.idunidade == null ? false : true,
                          initialValue: widget.numero,
                          onSaved: (text) => formInfosUnidade =
                              formInfosUnidade.copyWith(numero: text),
                        ),
                      buildMyTextFormObrigatorio(
                        context,
                        'Nome Responsável',
                        // readOnly: widget.idunidade == null ? false : true,
                        initialValue: widget.nome_responsavel,
                        onSaved: (text) => formInfosUnidade =
                            formInfosUnidade.copyWith(responsavel: text),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: size.width * 0.35,
                        child: buildMyTextFormObrigatorio(
                          context,
                          'Nascimento',
                          // readOnly: widget.idunidade == null ? false : true,
                          initialValue: widget.dataNascimento,
                          mask: '##/##/####',
                          keyboardType: TextInputType.number,
                          onSaved: (text) {
                            if (text!.length >= 6) {
                              var ano = text.substring(6);
                              var mes = text.substring(3, 5);
                              var dias = text.substring(0, 2);
                              dataLogin = '$dias$mes';
                              formInfosUnidade = formInfosUnidade.copyWith(
                                  nascimento: "$ano-$mes-$dias");
                            } else {
                              buildMinhaSnackBar(context,
                                  title: 'Cuidado',
                                  subTitle: 'Complete a data');
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.5,
                        child: buildMyTextFormObrigatorio(
                          context,
                          'Documento',
                          // readOnly: widget.idunidade == null ? false : true,
                          keyboardType: TextInputType.number,
                          initialValue: widget.documento,
                          onSaved: (text) {
                            if (text!.length >= 4) {
                              formInfosUnidade =
                                  formInfosUnidade.copyWith(documento: text);
                            } else {
                              buildMinhaSnackBar(context,
                                  title: 'Cuidado',
                                  subTitle: 'Complete a documento');
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  //contato
                  buildMyTextFormObrigatorio(
                    context,
                    'Email',
                    initialValue: formInfosUnidade.email,
                    onSaved: (text) => formInfosUnidade =
                        formInfosUnidade.copyWith(email: text),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: size.width * 0.2,
                          child: buildMyTextFormObrigatorio(
                            context,
                            'DDD',
                            initialValue: formInfosUnidade.ddd,
                            mask: '##',
                            onSaved: (text) => formInfosUnidade =
                                formInfosUnidade.copyWith(ddd: text),
                          )),
                      SizedBox(
                          width: size.width * 0.6,
                          child: buildMyTextFormObrigatorio(
                            context,
                            initialValue: formInfosUnidade.telefone,
                            'Telefone',
                            mask: '# ########',
                            onSaved: (text) => formInfosUnidade =
                                formInfosUnidade.copyWith(telefone: text),
                          )),
                    ],
                  ),

                  if (widget.idunidade == null)
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                  // if (widget.idunidade == null)
                  ConstsWidget.buildCustomButton(
                    context,
                    'Gerar Login',
                    onPressed: () {
                      var formValid =
                          _formkeyUnidade.currentState?.validate() ?? false;
                      if (formValid) {
                        _formkeyUnidade.currentState!.save();
                        List nomeToList =
                            formInfosUnidade.responsavel.split(' ');
                        List listNome = nomeToList;

                        setState(() {
                          loginGerado =
                              "${listNome.first.toString().toLowerCase()}${listNome.last.toString().toLowerCase()}${formInfosUnidade.documento.substring(0, 4)}r";
                        });
                        formInfosUnidade =
                            formInfosUnidade.copyWith(login: loginGerado);
                      } else if (widget.idunidade == 0) {}
                    },
                  ),
                  //loginGerado
                  if (loginGerado != '')
                    Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        MyBoxShadow(
                            child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.005),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: size.width * 0.01,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ConstsWidget.buildTextSubTitle('Login:'),
                                  SizedBox(
                                    height: size.height * 0.01,
                                  ),
                                  ConstsWidget.buildTextTitle(
                                      context, loginGerado),
                                ],
                              ),
                            ],
                          ),
                        )),
                        ConstsWidget.buildCheckBox(context,
                            isChecked: isChecked, onChanged: (p0) {
                          setState(() {
                            isChecked = !isChecked;
                          });
                        }, title: "Acesso ao Sistema"),
                        buildMyTextFormObrigatorio(
                          context,
                          'Senha Login',
                          onSaved: (text) => formInfosUnidade =
                              formInfosUnidade.copyWith(senha: text),
                        ),
                      ],
                    ),

                  if (loginGerado != '' || widget.idunidade != null)
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                  if (loginGerado != '' || widget.idunidade != null)
                    ConstsWidget.buildCustomButton(
                      context,
                      'Salvar',
                      onPressed: () {
                        _formkeyUnidade.currentState!.save();
                        var formValid =
                            _formkeyUnidade.currentState?.validate() ?? false;
                        if (formValid) {
                          String incluindoEditando = widget.idunidade == null
                              ? "incluirUnidade&"
                              : 'editarUnidade&id=${widget.idunidade}&senha=${formInfosUnidade.senha}&';

                          ConstsFuture.resquestApi(
                                  // print(
                                  '${Consts.sindicoApi}unidades/?fn=${incluindoEditando}idcond=${ResponsalvelInfos.idcondominio}&iddivisao=${formInfosUnidade.iddivisao}&ativo=${formInfosUnidade.ativo}&responsavel=${formInfosUnidade.responsavel}&login=${formInfosUnidade.login}&numero=${formInfosUnidade.numero}&datanasc=${formInfosUnidade.nascimento}&documento=${formInfosUnidade.documento}&dddtelefone=${formInfosUnidade.ddd}&telefone=${formInfosUnidade.telefone}&email=${formInfosUnidade.email}&acessa_sistema=${isChecked ? 1 : 0}')
                              .then((value) {
                            if (!value['erro']) {
                              ConstsFuture.navigatorPopPush(
                                  context, '/listaUnidade');
                              buildMinhaSnackBar(context,
                                  title: 'Muito Bem',
                                  subTitle: value['mensagem']);
                              setState(() {
                                apiListarDivisoes();
                              });
                            } else {
                              buildMinhaSnackBar(context,
                                  title: 'Uma pena',
                                  subTitle: value['mensagem']);
                            }
                          });
                        } else if (widget.idunidade == 0) {}
                      },
                    )
                ],
              ),
            ),
          ),
        ));
  }
}
