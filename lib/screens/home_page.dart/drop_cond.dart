import 'package:flutter/material.dart';
import 'package:sindico_app/screens/splash_screen/splash_screen.dart';
import '../../consts/const_widget.dart';
import '../../consts/consts.dart';
import '../../consts/consts_future.dart';
import '../../widgets/alert_dialogs/alert_trocar_senha.dart';
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

  int i = 0;

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
  List<DropdownMenuItem> listDrop = [];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    listDrop.clear();
    setState(() {
      i = 0;
    });

    DropCond.listCond.map((e) {
      i++;
      listDrop.add(
        DropdownMenuItem(
            alignment: Alignment.center,
            value: e['idcondominio'],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (i != 1)
                  Container(
                    height: 1,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                if (i != 1)
                  SizedBox(
                    height: size.height * 0.015,
                  ),
                ConstsWidget.buildTextSubTitle(context, e['nome_condominio'],
                    size: 18),
                // if (i == DropCond.listCond.length)
                //   Container(
                //     color: Colors.red,
                //     child: Text('dzfg'),
                //   )
              ],
            )),
      );

      if (i == DropCond.listCond.length) {
        listDrop.add(
          DropdownMenuItem(
              alignment: Alignment.center,
              value: 65684613513,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 1,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  ConstsWidget.buildTextTitle(
                      context, 'Adicionar Meus Condomínios'),
                ],
              )),
        );
      }
      // return DropdownMenuItem(
      //     alignment: Alignment.center,
      //     value: e['idcondominio'],
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         if (i != 1)
      //           Container(
      //             height: 1,
      //             decoration: BoxDecoration(color: Colors.black12),
      //           ),
      //         if (i != 1)
      //           SizedBox(
      //             height: size.height * 0.01,
      //           ),
      //         ConstsWidget.buildTextTitle(
      //           context,
      //           e['nome_condominio'],
      //         ),
      //         if (i == DropCond.listCond.length)
      //           Container(
      //             color: Colors.red,
      //             child: Text('dzfg'),
      //           )
      //       ],
      //     ));
    }).toSet();
    return ConstsWidget.buildPadding001(
      context,
      child: ConstsWidget.buildDecorationDrop(
        context,
        child: DropdownButton(
          alignment: Alignment.center,
          isExpanded: true,
          itemHeight:
              SplashScreen.isSmall ? size.height * 0.09 : size.height * 0.06,
          elevation: 24,
          icon: Icon(
            Icons.arrow_downward,
            color: Theme.of(context).iconTheme.color,
          ),
          borderRadius: BorderRadius.circular(16),
          value: dropCond,
          selectedItemBuilder: (context) {
            return DropCond.listCond.map((e) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ConstsWidget.buildTextTitle(
                    context,
                    e['nome_condominio'],
                  )
                ],
              );
            }).toList();
          },
          items: listDrop,
          // dropdownColor: Colors.red,
          underline: Container(
            color: Colors.red,
            height: 100,
          ),
          isDense: true,

          menuMaxHeight:
              SplashScreen.isSmall ? size.height * 0.65 : size.height * 0.5,

          // DropCond.listCond.map((e) {
          //   i++;
          //   return DropdownMenuItem(
          //       alignment: Alignment.center,
          //       value: e['idcondominio'],
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           if (i != 1)
          //             Container(
          //               height: 1,
          //               decoration: BoxDecoration(color: Colors.black12),
          //             ),
          //           if (i != 1)
          //             SizedBox(
          //               height: size.height * 0.01,
          //             ),
          //           ConstsWidget.buildTextTitle(
          //             context,
          //             e['nome_condominio'],
          //           ),
          //           if (i == DropCond.listCond.length)
          //             Container(
          //               color: Colors.red,
          //               child: Text('dzfg'),
          //             )
          //         ],
          //       ));
          // }).toList(),
          onChanged: (value) {
            if (value != 65684613513) {
              setState(
                () {
                  dropCond = value;
                  ConstsFuture.fazerLogin(context, ResponsalvelInfos.login,
                      ResponsalvelInfos.senhacripto,
                      idCondominio: int.parse('$dropCond'));
                },
              );
            } else {
              alertTrocarSenha(
                context,
              );
            }
          },
        ),
      ),
    );
  }
}
