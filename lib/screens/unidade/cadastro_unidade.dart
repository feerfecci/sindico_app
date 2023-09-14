import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sindico_app/forms/unidades_form.dart';
import 'package:sindico_app/widgets/alert_dialogs/alertdialog_all.dart';
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
  final Object? id_divisao_unidade;
  final bool ativo;
  final String? localizado;
  final String? numero;
  final String? nome_responsavel;
  final bool isDrawer;

  const CadastroUnidades({
    this.iddivisao,
    this.id_divisao_unidade,
    this.idunidade = 0,
    super.key,
    this.numero,
    this.nome_responsavel,
    this.ativo = true,
    this.localizado,
    this.isDrawer = false,
  });

  @override
  State<CadastroUnidades> createState() => _CadastroUnidadesState();
}

class _CadastroUnidadesState extends State<CadastroUnidades> {
  final _formkeyUnidade = GlobalKey<FormState>();
  FormInfosUnidade formInfosUnidade = FormInfosUnidade();
  final TextEditingController senhaContr = TextEditingController();

  @override
  void initState() {
    super.initState();
    apiListarDivisoes();
    setInfosMorador();
    apiListarDivididoPor();
  }

  setInfosMorador() {
    formInfosUnidade = formInfosUnidade.copyWith(iddivisao: widget.iddivisao);
    formInfosUnidade = formInfosUnidade.copyWith(
        id_divisao_unidade: widget.id_divisao_unidade);
    formInfosUnidade = formInfosUnidade.copyWith(numero: widget.numero);
    formInfosUnidade =
        formInfosUnidade.copyWith(responsavel: widget.nome_responsavel);
    formInfosUnidade = formInfosUnidade.copyWith(ativo: widget.ativo ? 1 : 0);
  }

  List categoryItemListDivisoes = [];
  List categoryItemListDivididoPor = [];
  // Object? dropdownValueDivisioes;
  Future apiListarDivisoes() async {
    var uri =
        '${Consts.sindicoApi}divisoes/?fn=listarDivisoes&idcond=${ResponsalvelInfos.idcondominio}&idfuncionario=${ResponsalvelInfos.idfuncionario}';

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

  Future apiListarDivididoPor() async {
    var uri =
        '${Consts.sindicoApi}divisoes_unidades/?fn=listarDivisoesUnidades&idcond=${ResponsalvelInfos.idcondominio}&idfuncionario=${ResponsalvelInfos.idfuncionario}';

    final response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      final jsonresponse = json.decode(response.body);
      var divisoes = jsonresponse['divisoesUnidades'];
      setState(() {
        categoryItemListDivididoPor = divisoes;
      });
    } else {
      throw response.statusCode;
    }
  }

  String loginGerado = '';
  String dataLogin = '';
  bool isChecked = true;
  bool nomeDocAlterado = false;
  List listAtivo = [1, 0];
  Object? dropdownValueAtivo;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    // List<String> listAtivo = <String>['Ativo', 'Inativo'];
    // var seAtivo = widget.ativo == true ? 'Ativo' : 'Inativo';
    // var dropdownValueAtivo = listAtivo.first;
    Widget buildDropButtonDivisao() {
      return ConstsWidget.buildPadding001(
        context,
        child: ConstsWidget.buildDecorationDrop(
          context,
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
                child: ConstsWidget.buildTextTitle(context, e['nome_divisao']),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                // dropdownValueDivisioes = value;
                formInfosUnidade = formInfosUnidade.copyWith(iddivisao: value);
              });
            },
            value: dropdownValueAtivo = formInfosUnidade.iddivisao,
          ),
        ),
      );
    }

    Widget buildDropAtivo(
      BuildContext context, {
      int seEditando = 0,
    }) {
      //var size = MediaQuery.of(context).size;
      return ConstsWidget.buildPadding001(
        context,
        child: StatefulBuilder(builder: (context, setState) {
          return ConstsWidget.buildDecorationDrop(
            context,
            child: DropdownButton(
              isExpanded: true,
              value: dropdownValueAtivo = formInfosUnidade.ativo,
              icon: Icon(
                Icons.arrow_downward_outlined,
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
                  formInfosUnidade = formInfosUnidade.copyWith(ativo: value);
                });
              },
              items: listAtivo.map<DropdownMenuItem>((value) {
                return DropdownMenuItem(
                  alignment: Alignment.center,
                  value: value,
                  child: value == 0
                      ? ConstsWidget.buildTextTitle(context, 'Inativo')
                      : ConstsWidget.buildTextTitle(context, 'Ativo'),
                );
              }).toList(),
            ),
          );
        }),
      );
    }

    Widget buildDropButtonDividoPor() {
      return ConstsWidget.buildDecorationDrop(
        context,
        child: DropdownButton(
          elevation: 24,
          isExpanded: true,
          hint: Text('Selecione'),
          icon: Icon(
            Icons.arrow_downward_outlined,
          ),
          borderRadius: BorderRadius.circular(16),
          style: TextStyle(
            // fontWeight: FontWeight.bold,
            fontSize: Consts.fontTitulo,
          ),
          items: categoryItemListDivididoPor.map((e) {
            return DropdownMenuItem(
              alignment: Alignment.center,
              value: e['id_divisao_unidade'],
              child: ConstsWidget.buildTextTitle(
                  context, e['nome_divisao_unidade']),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              // dropdownValueDivisioes = value;
              formInfosUnidade =
                  formInfosUnidade.copyWith(id_divisao_unidade: value);
              categoryItemListDivididoPor.map((e) {
                if (value == e['id_divisao_unidade']) {
                  setState(() {
                    tipoSelec = e['nome_divisao_unidade'];
                  });
                }
              }).toList();
            });
          },
          value: formInfosUnidade.id_divisao_unidade,
        ),
      );
    }

    return buildScaffoldAll(context,
        title: widget.isDrawer
            ? 'Meu Perfil'
            : widget.idunidade == 0
                ? 'Nova Unidade'
                : 'Editar Unidade',
        body: Form(
          key: _formkeyUnidade,
          child: MyBoxShadow(
            child: ConstsWidget.buildPadding001(
              context,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //infos unidade
                  // if (widget.idunidade == 0)
                  Column(
                    children: [
                      buildDropAtivo(
                        context,
                      ),
                      widget.isDrawer
                          ? Row()
                          : widget.idunidade == 0
                              ? buildDropButtonDivisao()
                              : ConstsWidget.buildPadding001(
                                  context,
                                  vertical: 0.015,
                                  child: ConstsWidget.buildTextTitle(
                                      context, widget.localizado!),
                                ),
                      //infos resp
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: size.width * 0.55,
                            child: buildDropButtonDividoPor(),
                          ),
                          Spacer(),
                          SizedBox(
                            width: size.width * 0.3,
                            child: buildMyTextFormObrigatorio(
                              context,
                              'Número',
                              hintText: '335',
                              // readOnly: widget.idunidade == 0 ? false : true,
                              initialValue: widget.numero,
                              onSaved: (text) => formInfosUnidade =
                                  formInfosUnidade.copyWith(numero: text),
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ],
                  ),
                  ConstsWidget.buildCustomButton(
                    context,
                    'Salvar',
                    color: Consts.kColorRed,
                    onPressed: () {
                      var formValid =
                          _formkeyUnidade.currentState?.validate() ?? false;

                      if (formValid && !widget.isDrawer) {
                        _formkeyUnidade.currentState!.save();

                        showAllDialog(context,
                            title: ConstsWidget.buildTextTitle(
                                context, 'Deseja continuar?'),
                            children: [
                              RichText(
                                  text: TextSpan(children: const [
                                TextSpan(
                                    text:
                                        'Confira as informações antes de prosseguir. Após salvar os dados, eles não poderão ser editados',
                                    style: TextStyle(
                                        color: Consts.kColorRed, fontSize: 20))
                              ])),
                              SizedBox(
                                height: size.height * 0.025,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ConstsWidget.buildOutlinedButton(
                                    context,
                                    title: 'Cancelar',
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  SizedBox(
                                    width: size.width * 0.05,
                                  ),
                                  ConstsWidget.buildCustomButton(
                                    context,
                                    'Salvar',
                                    color: Consts.kColorRed,
                                    onPressed: () {
                                      String incluindoEditando = widget
                                                  .idunidade ==
                                              0
                                          ? "incluirUnidade&"
                                          : 'editarUnidade&id=${widget.idunidade}&';

                                      ConstsFuture.resquestApi(
                                              '${Consts.sindicoApi}unidades/?fn=${incluindoEditando}idcond=${ResponsalvelInfos.idcondominio}&idfuncionario=${ResponsalvelInfos.idfuncionario}&iddivisao=${formInfosUnidade.iddivisao}&ativo=${formInfosUnidade.ativo}&numero=${"$tipoSelec${formInfosUnidade.numero}"}')
                                          .then((value) {
                                        if (!value['erro']) {
                                          ConstsFuture.navigatorPopPush(
                                                  context, '/listaUnidade')
                                              .whenComplete(() {
                                            buildMinhaSnackBar(context,
                                                title: 'Muito Bem',
                                                subTitle: value['mensagem']);
                                          });
                                        } else {
                                          buildMinhaSnackBar(context,
                                              title: 'Uma pena',
                                              subTitle: value['mensagem']);
                                        }
                                      });
                                    },
                                  )
                                ],
                              )
                            ]);
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ));
  }

  String tipoSelec = '';
}
