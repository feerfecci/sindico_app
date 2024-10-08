// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sindico_app/repositories/shared_preferences.dart';
import 'package:sindico_app/screens/home_page.dart/home_page.dart';
import 'package:sindico_app/screens/login/login_screen.dart';
import 'package:sindico_app/screens/meu_perfil/meu_perfil_screen.dart';
import 'package:sindico_app/widgets/alert_dialogs/alertdialog_all.dart';
import '../screens/home_page.dart/drop_cond.dart';
import '../screens/quadro_avisos/quadro_de_avisos.dart';
import '../screens/reservas/listar_reservar.dart';
import '../screens/tarefas/tarefas_screen.dart';
import '../screens/termodeuso/aceitar_alert.dart';
import '../widgets/snack.dart';
import 'const_widget.dart';
import 'consts.dart';
import 'package:http/http.dart' as http;

class ConstsFuture {
  static Future navigatorPagePush(BuildContext context, Widget route) {
    return Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => route,
    ));
  }
//NÃO DÁ CERTO POR CAUSA DO SNAPSHOT QUE VEM DO LISTBUILDER

  // static buildFutureBuilder(
  //   {required Widget listBuilder,required Future<Object?>? future}
  // ) {
  //   FutureBuilder<dynamic>(
  //     future: future,
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return CircularProgressIndicator();
  //       } else if (snapshot.hasData) {
  //         if (!snapshot.data['erro']) {
  //           return listBuilder;
  //         } else {
  //           return Text(snapshot.data['mensagem']);
  //         }
  //       } else {
  //         return Text('Algo Deu errado');
  //       }
  //     },
  //   );
  // }
  // static Future criptoSenha(String senha) async {
  //   String senhacripto = md5.convert(utf8.encode(senha)).toString();
  //   return senhacripto;
  // }

  static Future navigatorPopPush(
      BuildContext context, String Namedroute) async {
    Navigator.pop(context);
    Navigator.popAndPushNamed(context, Namedroute);
  }

  static Future navigatorPageReplace(BuildContext context, Widget route) {
    return Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => route,
        ),
        (route) => false);
  }

  static Future gerarLogin(BuildContext context,
      {required String nomeUsado,
      required bool nomeDocAlterado,
      required String documento}) async {
    FocusManager.instance.primaryFocus?.unfocus();

    List<String> nomeEmLista = nomeUsado.split(' ');
    List<String> listaNome = [];

    // if (nomeDocAlterado) {
    //   buildMinhaSnackBar(context,
    //       title: 'Dados alterados', subTitle: 'Alteramos o login');
    // }
    nomeEmLista.map((e) {
      if (e != '') {
        listaNome.add(removeDiacritics(e).toLowerCase());
      }
    }).toSet();

    String loginGerado =
        '${listaNome.first}${listaNome.last}${documento.substring(0, 4)}';

    return loginGerado;
  }

  static Future fazerLogin(BuildContext context, String usuario, String senha,
      {int? idCondominio, OSNotificationOpenedResult? openedResult}) async {
    var senhaCripto = md5.convert(utf8.encode(senha)).toString();

    ResponsalvelInfos.senhacripto = idCondominio == null ? senhaCripto : senha;
    var url = Uri.parse(
        'https://a.portariaapp.com/api/login-responsavel/?fn=login&usuario=$usuario&senha=${idCondominio == null ? senhaCripto : ResponsalvelInfos.senhacripto}${idCondominio != null ? '&idcond=$idCondominio' : ''}');
    var resposta = await http.get(
      url,
    );
    if (resposta.statusCode == 200) {
      var apiBody = json.decode(resposta.body);
      bool erro = apiBody['erro'];

      if (!erro) {
        if (idCondominio == null) {
          ResponsalvelInfos.qntCond = apiBody['login'].length;
          DropCond.listCond = apiBody['login'];
          ResponsalvelInfos.listIdCond.clear();
          ResponsalvelInfos.listIdFuncionario.clear();
          ResponsalvelInfos.listIdFuncao.clear();
          for (var i = 0; i < ResponsalvelInfos.qntCond; i++) {
            ResponsalvelInfos.listIdCond
                .add(apiBody['login'][i]['idcondominio'].toString());
            ResponsalvelInfos.listIdFuncionario
                .add(apiBody['login'][i]['idfuncionario'].toString());
            ResponsalvelInfos.listIdFuncao
                .add(apiBody['login'][i]['idfuncao'].toString());
          }
        }
        var loginInfos = apiBody['login'][0];
        ResponsalvelInfos.nome_condominio = loginInfos['nome_condominio'];
        ResponsalvelInfos.idcondominio = loginInfos['idcondominio'];
        ResponsalvelInfos.idfuncionario = loginInfos['idfuncionario'];
        ResponsalvelInfos.qtd_publicidade = loginInfos['qtd_publicidade'];
        ResponsalvelInfos.dividido_por = loginInfos['dividido_por'];
        ResponsalvelInfos.nome_responsavel = loginInfos['nome_funcionario'];
        ResponsalvelInfos.login = loginInfos['login'];
        ResponsalvelInfos.nascimento = loginInfos['datanasc'];
        ResponsalvelInfos.telefone = loginInfos['telefone'];
        ResponsalvelInfos.telefone_portaria = loginInfos['telefone_portaria'];
        ResponsalvelInfos.documento = loginInfos['documento'];
        ResponsalvelInfos.email = loginInfos['email'];
        ResponsalvelInfos.endereco = loginInfos['endereco'];
        ResponsalvelInfos.numero = loginInfos['numero'];
        ResponsalvelInfos.bairro = loginInfos['bairro'];
        ResponsalvelInfos.cep = loginInfos['cep'];
        ResponsalvelInfos.cidade = loginInfos['cidade'];
        ResponsalvelInfos.estado = loginInfos['estado'];
        ResponsalvelInfos.temporespostas = loginInfos['temporespostas'];
        ResponsalvelInfos.aceitou_termos = loginInfos['aceitou_termos'];
        ResponsalvelInfos.idfuncao = loginInfos['idfuncao'];
        ResponsalvelInfos.senha_alterada = loginInfos['senha_alterada'];
        apiQuadroAvisos().whenComplete(() {
          apiResevas().whenComplete(() {
            apiTarefas().whenComplete(() {
              if (!ResponsalvelInfos.aceitou_termos) {
                return showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return AceitarTermosScreen();
                    });
              }
              navigatorPageReplace(context, HomePage());
              if (openedResult != null) {
                if (openedResult.notification.additionalData!['rota'] ==
                    'reserva_espacos') {
                  ConstsFuture.navigatorPagePush(context, ListaReservas());
                } else if (openedResult.notification.additionalData!['rota'] ==
                    'aviso') {
                  ConstsFuture.navigatorPagePush(context, QuadroDeAvisos());
                } else if (openedResult.notification.additionalData!['rota'] ==
                    'tarefa') {
                  ConstsFuture.navigatorPagePush(context, TarefasScreen());
                }
              }
            });
          });
        });
      } else {
        // navigatorPageReplace(context, LoginScreen()).then((value) {

        // });
        LocalInfos.removeCache();
        if (idCondominio == null) {
          navigatorPageReplace(context, LoginScreen());
        }
        buildMinhaSnackBar(context,
            icon: Icons.warning_amber,
            hasError: apiBody['erro'],
            subTitle: apiBody['mensagem'],
            title: 'Algo Deu Errado!');
      }
    } else {
      buildMinhaSnackBar(context, icon: Icons.warning_amber, hasError: true);
    }
  }

  static Future resquestApi(
    String api,
  ) async {
    var resposta = await http.get(
      Uri.parse(api),
    );
    if (resposta.statusCode == 200) {
      try {
        return json.decode(resposta.body);
      } catch (e) {
        return {'erro': true, "mensagem": 'Tente Novamente'};
      }
    } else {
      return {'erro': true, 'mensagem': 'Tente Novamente'};
    }
  }

  static Future<Widget> apiImage(iconApi) async {
    var url = Uri.parse(iconApi);
    var resposta = await http.get(url);

    try {
      return resposta.statusCode == 200
          ? Image.network(iconApi)
          : Image.asset('assets/ico-error.png');
    } catch (e) {
      return Image.asset('assets/ico-error.png');
    }
  }
}
