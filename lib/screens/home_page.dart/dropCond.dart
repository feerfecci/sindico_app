import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../consts/const_widget.dart';
import '../../consts/consts.dart';
import '../../consts/consts_future.dart';
import '../../widgets/my_box_shadow.dart';

class DropCond extends StatefulWidget {
  const DropCond({super.key});
  static List listCond = [];
  @override
  State<DropCond> createState() => _DropCondState();
}

class _DropCondState extends State<DropCond> {
  Object? dropCond = ResponsalvelInfos.idcondominio == 0
      ? null
      : ResponsalvelInfos.idcondominio;
  @override
  void initState() {
    super.initState();
  }

  // Future<dynamic> apiAptos() async {
  //   var url = Uri.parse(
  //       'https://a.portariaapp.com/api/login-responsavel/?fn=login&usuario=${ResponsalvelInfos.login}&senha=${ResponsalvelInfos.senhacripto}');
  //   var resposta = await get(url);
  //   if (resposta.statusCode == 200) {
  //     var jsonReponse = json.decode(resposta.body);
  //     setState(() {
  //       listCond = jsonReponse['login'];
  //     });
  //   } else {
  //     return false;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ConstsWidget.buildPadding001(
      context,
      child: MyBoxShadow(
        child: Container(
          width: double.maxFinite,
          height: size.height * 0.05,
          decoration: BoxDecoration(
            // color:Colors.red,
            // border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton(
                alignment: Alignment.center,
                isExpanded: true,
                elevation: 24,
                icon: Icon(
                  Icons.arrow_downward,
                  color: Theme.of(context).iconTheme.color,
                ),
                borderRadius: BorderRadius.circular(16),
                // style: TextStyle(
                //     color: Theme.of(context).colorScheme.primary,
                //     fontWeight: FontWeight.w400,
                //     fontSize: 18),
                value: dropCond,
                items: DropCond.listCond.map((e) {
                  return DropdownMenuItem(
                      alignment: Alignment.center,
                      value: e['idcondominio'],
                      child: ConstsWidget.buildTextTitle(
                        context,
                        e['nome_condominio'],
                      ));
                }).toList(),
                onChanged: (value) {
                  setState(
                    () {
                      dropCond = value;
                      Navigator.pop(context);
                      ConstsFuture.fazerLogin(context, ResponsalvelInfos.login,
                          ResponsalvelInfos.senhacripto,
                          idCondominio: int.parse('$dropCond'));
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
