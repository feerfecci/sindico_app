// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:sindico_app/screens/login/login_screen.dart';

import '../items_bottom.dart';
import '../widgets/snackbar/snack.dart';
import 'package:http/http.dart' as http;

class ResponsalvelInfos {
  static int idcondominio = 0;
  static String nome_condominio = "";
  static String dividido_por = "";
  static String nome_responsavel = "";
  static String login = "";
  static String endereco = "";
  static String numero = "";
  static String bairro = "";
  static String cep = "";
  static String cidade = "";
  static String estado = "";
}

class Consts {
  static double fontTitulo = 16;
  static double fontSubTitulo = 14;
  static double borderButton = 60;

  static const kBackPageColor = Color.fromARGB(255, 245, 245, 255);
  // static const kButtonColor = Color.fromARGB(255, 0, 134, 252);
  static const kButtonColor = kColorApp;

  static const kColorApp = Color.fromARGB(255, 127, 99, 254);

  static const String iconApi = 'https://escritorioapp.com/img/ico-';

  static Future navigatorPageRoute(BuildContext context, Widget route) {
    return Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => route,
    ));
  }

  static Future fazerLogin(
      BuildContext context, String usuario, String senha) async {
    var senhaCripto = md5.convert(utf8.encode(senha)).toString();
    var url = Uri.parse(
        'https://a.portariaapp.com/api/login-responsavel/?fn=login&usuario=${usuario}&senha=${senhaCripto}');
    var resposta = await http.get(
      url,
    );
    if (resposta.statusCode == 200) {
      var apiBody = json.decode(resposta.body);
      bool erro = apiBody['erro'];
      var loginInfos = apiBody['login'];
      if (erro) {
        Consts.navigatorPageRoute(context, LoginScreen());
      } else if (erro == false) {
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
          return Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => ItensBottom(currentTab: 0),
              ),
              (route) => false);
        }
      } else {
        return Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => ItensBottom(currentTab: 0),
            ),
            (route) => false);
      }
    } else {
      return buildMinhaSnackBar(context, icon: Icons.warning_amber);
    }

    // FutureBuilder<dynamic>(
    //   future: api(),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       print('esperando api');
    //     } else if (snapshot.hasError == true) {
    //       return buildMinhaSnackBar(context, icon: Icons.warning_amber);
    //     }
    //     var usuarioAPI = snapshot.data['mensagem'];
    //     navigatorRoute(context, ItensBottom(currentTab: 0));
    //     return Text(usuarioAPI);
    //   },
    // );
    // if (usuario == respost && senha == LoginAcess.senha) {
    //   navigatorRoute(context, ItensBottom(currentTab: 0));
    // } else {
    //   buildMinhaSnackBar(context, icon: Icons.warning_amber);
    // }
  }

  static Future<http.Response> changeApi(String api) {
    return http.post(
      Uri.parse(api),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }
}
// class UserLogin {
//   static String email = "fernandofecci@hotmail.com";
//   static String password = '123mudar';

//   static efetuaLogin(context, String emailUser, String passwordUser) {
//     if (emailUser == email && passwordUser == password) {
//       Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (context) => ItensBottom(
//             currentTab: 0,
//           ),
//         ),
//       );
//     } else {
//       buildCustomSnackBar(
//         context,
//         'Login Errado',
//         'Tente Verificar os dados preenchidos',
//       );
//       LocalPreferences.removeUserLogin();
//     }
//   }
// }
