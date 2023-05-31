import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sindico_app/consts/consts_future.dart';
import 'package:sindico_app/forms/morador_form.dart';
import 'package:sindico_app/screens/moradores/lista_morador.dart';
import 'package:sindico_app/screens/funcionarios/cadastro_func.dart';
import 'package:http/http.dart' as http;
import '../../consts/const_widget.dart';
import '../../consts/consts.dart';
import '../../widgets/header.dart';
import '../../widgets/my_box_shadow.dart';
import '../../widgets/my_text_form_field.dart';
import '../../widgets/scaffold_all.dart';

class CadastroMorador extends StatefulWidget {
  int? idmorador;
  bool? ativo;
  String? nome_morador;
  String? login;
  String nascimento;
  String? telefone;
  String? ddd;
  String? documento;
  int? acesso;
  int? idunidade;
  int? iddivisao;
  String? numero;
  CadastroMorador(
      {this.idmorador,
      this.nome_morador,
      this.login,
      this.telefone,
      this.ddd,
      this.nascimento = '',
      this.documento,
      this.acesso,
      this.idunidade,
      this.ativo,
      this.iddivisao,
      this.numero,
      super.key});

  @override
  State<CadastroMorador> createState() => _CadastroMoradorState();
}

class _CadastroMoradorState extends State<CadastroMorador> {
  Object? dropdownValueDivisioes;
  List categoryItemListDivisoes = [];
  @override
  void initState() {
    super.initState();
    apiListarDivisoes();
  }

  Future apiListarDivisoes() async {
    var uri =
        'https://a.portariaapp.com/sindico/api/divisoes/?fn=listarDivisoes&idcond=${ResponsalvelInfos.idcondominio}';

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

  final _formKeyMorador = GlobalKey<FormState>();
  FormInfosMorador _formInfosMorador = FormInfosMorador();

  @override
  Widget build(BuildContext context) {
    @override
    var dataParsed = widget.nascimento != ''
        ? DateFormat('dd/MM/yyy').format(DateTime.parse(widget.nascimento))
        : '';
    bool isChecked = widget.acesso == null
        ? false
        : widget.acesso == 0
            ? false
            : true;
    var size = MediaQuery.of(context).size;
    Widget buildAtivoInativo2(
      BuildContext context, {
      int seEditando = 0,
      bool? seAtivoApi,
    }) {
      var size = MediaQuery.of(context).size;
      return Padding(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
        child: StatefulBuilder(builder: (context, setState) {
          List<String> listAtivo = <String>['Ativo', 'Inativo'];
          // var seAtivo = seAtivoApi == null ? 'Inativo' : 'Ativo';
          var dropdownValueAtivo = listAtivo.first;
          String itemComeco = '';
          if (seAtivoApi == true) {
            itemComeco = 'Ativo';
            // _formInfosMorador = _formInfosMorador.copyWith(ativo: 1);
          } else {
            itemComeco = 'Inativo';
            // _formInfosMorador = _formInfosMorador.copyWith(ativo: 0);
          }

          return ButtonTheme(
            alignedDropdown: true,
            child: DropdownButtonFormField<String>(
              value: seEditando == 0 ? dropdownValueAtivo : itemComeco,

              icon: Padding(
                padding: EdgeInsets.only(right: size.height * 0.03),
                child: Icon(
                  Icons.arrow_downward,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),

              elevation: 90,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w400,
                  fontSize: 18),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: size.width * 0.00),
                filled: true,
                fillColor: Theme.of(context).canvasColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              // underline: Container(
              //   height: 1,
              //   color: Consts.kColorApp,
              // ),
              borderRadius: BorderRadius.circular(16),
              onChanged: (String? value) {
                setState(() {
                  dropdownValueAtivo = value!;
                  if (dropdownValueAtivo == 'Ativo') {
                    _formInfosMorador = _formInfosMorador.copyWith(ativo: 1);
                    print(_formInfosMorador.ativo);
                  } else if (dropdownValueAtivo == 'Inativo') {
                    _formInfosMorador = _formInfosMorador.copyWith(ativo: 0);
                    print(_formInfosMorador.ativo);
                  }
                });
              },
              items: listAtivo.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          );
        }),
      );
    }

    return buildScaffoldAll(
      body: buildHeaderPage(
        context,
        titulo: widget.idmorador == null ? 'Incluir Morador' : 'Editar Morador',
        subTitulo: widget.idmorador == null
            ? 'Adicionar Morador'
            : 'Adicione um morador',
        widget: Form(
          key: _formKeyMorador,
          child: MyBoxShadow(
            child: Column(
              children: [
                buildAtivoInativo2(
                  context,
                  seAtivoApi: widget.ativo,
                  seEditando: widget.idmorador == null ? 0 : 1,
                ),
                buildMyTextFormObrigatorio(
                  context,
                  'Nome Completo',
                  initialValue: widget.nome_morador,
                  onSaved: (text) => _formInfosMorador =
                      _formInfosMorador.copyWith(nome_morador: text),
                ),
                buildMyTextFormObrigatorio(
                  context,
                  'Usário de login',
                  initialValue: widget.login,
                  onSaved: (text) => _formInfosMorador =
                      _formInfosMorador.copyWith(login: text),
                ),
                widget.idmorador == null
                    ? buildMyTextFormObrigatorio(
                        context,
                        'Senha Login',
                        onSaved: (text) => _formInfosMorador =
                            _formInfosMorador.copyWith(senha: text),
                      )
                    : SizedBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: size.width * 0.37,
                      child: buildMyTextFormField(context,
                          initialValue: dataParsed,
                          title: 'Data de Nascimento',
                          keyboardType: TextInputType.number,
                          mask: '##/##/####',
                          hintText: '##/##/####', onSaved: (text) {
                        // var replace = text!.replaceAll('/', '-');

                        var ano = text!.substring(6);
                        var mes = text.substring(3, 5);
                        var dia = text.substring(0, 2);
                        // print(replace);

                        _formInfosMorador = _formInfosMorador.copyWith(
                            nascimento: '$ano-$mes-$dia');
                      }),
                    ),
                    SizedBox(
                      width: size.width * 0.5,
                      child: buildMyTextFormField(
                        context,
                        title: 'Documento',
                        initialValue: widget.documento,
                        keyboardType: TextInputType.number,
                        hintText: 'RG, CPF',
                        onSaved: (text) => _formInfosMorador =
                            _formInfosMorador.copyWith(documento: text),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: size.width * 0.145,
                      child: buildMyTextFormField(context,
                          initialValue: widget.ddd,
                          onSaved: (text) => _formInfosMorador =
                              _formInfosMorador.copyWith(ddd: text),
                          title: 'DDD',
                          keyboardType: TextInputType.number,
                          mask: '##',
                          hintText: '11'),
                    ),
                    SizedBox(
                      width: size.width * 0.1,
                    ),
                    SizedBox(
                      width: size.width * 0.5,
                      child: buildMyTextFormField(
                        context,
                        initialValue: widget.telefone,
                        title: 'Telefone',
                        keyboardType: TextInputType.number,
                        mask: '# ########',
                        hintText: '9 11223344',
                        onSaved: (text) => _formInfosMorador =
                            _formInfosMorador.copyWith(telefone: text),
                      ),
                    ),
                  ],
                ),
                ListTile(
                  title:
                      ConstWidget.buildTextTitle('Permitir acesso ao sistema'),
                  trailing: StatefulBuilder(builder: (context, setState) {
                    return SizedBox(
                        width: size.width * 0.125,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Checkbox(
                              value: isChecked,
                              activeColor: Consts.kColorApp,
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked = value!;
                                  int salvaAcesso = isChecked == true ? 1 : 0;
                                  _formInfosMorador = _formInfosMorador
                                      .copyWith(acesso: salvaAcesso);
                                });
                              },
                            ),
                          ],
                        ));
                  }),
                ),
                ConstWidget.buildCustomButton(
                  context,
                  'Salvar',
                  onPressed: () {
                    var formValid =
                        _formKeyMorador.currentState?.validate() ?? false;
                    if (formValid) {
                      _formKeyMorador.currentState?.save();
                      String restoApi = '';
                      widget.idmorador == null
                          ? restoApi =
                              'incluirMorador&senha=${_formInfosMorador.senha}'
                          : restoApi = 'editarMorador&id=${widget.idmorador}';
                      ConstsFuture.changeApi(
                        'https://a.portariaapp.com/sindico/api/moradores/?fn=$restoApi&idunidade=${widget.idunidade}&idcond=${ResponsalvelInfos.idcondominio}&iddivisao=${widget.iddivisao}&ativo=${_formInfosMorador.ativo}&numero=${widget.numero}&nomeMorador=${_formInfosMorador.nome_morador}&login=${_formInfosMorador.login}&datanasc=${_formInfosMorador.nascimento}&documento=${_formInfosMorador.documento}&dddtelefone=${_formInfosMorador.ddd}&telefone=${_formInfosMorador.telefone}&acessa_sistema=${_formInfosMorador.acesso}',
                      );
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListaMorador(
                                    idunidade: widget.idunidade,
                                  )));
                      // ConstsFuture.navigatorPageReplace(
                      //     context,
                      //     ListaMorador(
                      //       idunidade: widget.idunidade,
                      //     ));
                    } else {
                      print(formValid.toString());
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
