// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:sindico_app/repositories/shared_preferences.dart';

import '../items_bottom.dart';
import '../screens/login/login_screen.dart';
import '../widgets/snackbar/snack.dart';
import 'consts.dart';
import 'package:http/http.dart' as http;

class ConstsFuture {
  static Future navigatorPagePush(BuildContext context, Widget route) {
    return Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => route,
    ));
  }

  static navigatorPopPush(BuildContext context, String Namedroute) {
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

  static Future fazerLogin(
      BuildContext context, String usuario, String senha) async {
    var senhaCripto = md5.convert(utf8.encode(senha)).toString();
    var url = Uri.parse(
        'https://a.portariaapp.com/api/login-responsavel/?fn=login&usuario=$usuario&senha=$senhaCripto');
    var resposta = await http.get(
      url,
    );
    if (resposta.statusCode == 200) {
      var apiBody = json.decode(resposta.body);
      bool erro = apiBody['erro'];
      var loginInfos = apiBody['login'];
      if (erro) {
        navigatorPageReplace(context, LoginScreen());
        LocalInfos.removeCache();
        buildMinhaSnackBar(context,
            icon: Icons.warning_amber,
            subTitle: apiBody['mensagem'],
            title: 'Algo Deu Errado!');
      } else if (!erro) {
        ResponsalvelInfos.nome_condominio = loginInfos['nome_condominio'];
        ResponsalvelInfos.idcondominio = loginInfos['idcondominio'];
        ResponsalvelInfos.dividido_por = loginInfos['dividido_por'];
        ResponsalvelInfos.nome_responsavel = loginInfos['nome_responsavel'];
        ResponsalvelInfos.login = loginInfos['login'];
        ResponsalvelInfos.endereco = loginInfos['endereco'];
        ResponsalvelInfos.numero = loginInfos['numero'];
        ResponsalvelInfos.bairro = loginInfos['bairro'];
        ResponsalvelInfos.cep = loginInfos['cep'];
        ResponsalvelInfos.cidade = loginInfos['cidade'];
        ResponsalvelInfos.estado = loginInfos['estado'];
        if (erro == true) {
          return buildMinhaSnackBar(context, icon: Icons.warning_amber);
        } else {
          return navigatorPageReplace(
              context,
              ItensBottom(
                currentTab: 0,
              ));
        }
      } else {
        return navigatorPageReplace(
            context,
            ItensBottom(
              currentTab: 0,
            ));
      }
    } else {
      return buildMinhaSnackBar(context, icon: Icons.warning_amber);
    }
  }

  static Future changeApi(String api) async {
    var resposta = await http.get(
      Uri.parse(api),
    );
    if (resposta.statusCode == 200) {
      return json.decode(resposta.body);
    } else {
      return {'erro': true, 'mensagem': 'Algo deu errado'};
    }
  }
}
