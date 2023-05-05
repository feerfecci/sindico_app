import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:sindico_app/screens/login/login_screen.dart';

import 'items_bottom.dart';
import 'widgets/snackbar/snack.dart';
import 'package:http/http.dart' as http;

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

  static Widget buildTextTitle(String title,
      {textAlign, color, double size = 16}) {
    return Text(
      title,
      maxLines: 20,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  static Widget buildTextSubTitle(String title, {color}) {
    return Text(
      title,
      maxLines: 20,
      style: TextStyle(
        color: color,
        fontSize: fontSubTitulo,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  static Widget buildCustomButton(BuildContext context, String title,
      {IconData? icon,
      double? altura,
      Color? color = kButtonColor,
      Color? textColor = Colors.white,
      Color? iconColor = Colors.white,
      required void Function()? onPressed}) {
    var size = MediaQuery.of(context).size;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderButton),
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.023),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              title,
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              width: size.width * 0.015,
            ),
            icon != null ? Icon(size: 18, icon, color: iconColor) : SizedBox(),
          ],
        ),
      ),
    );
  }

  static Future navigatorRoute(BuildContext context, Widget pageRoute) {
    return Navigator.push(context, MaterialPageRoute(builder: (context) {
      return pageRoute;
    }));
  }

  static Future fazerLogin(
      BuildContext context, String usuario, String senha) async {
    var senhaCripto = md5.convert(utf8.encode(senha)).toString();
    var url = Uri.parse(
        'https://a.portariaapp.com/api/login-responsavel/?fn=login&usuario=$usuario&senha=${senhaCripto}');
    var resposta = await http.get(
      url,
    );
    if (resposta.statusCode == 200) {
      var apiBody = json.decode(resposta.body);
      bool erro = apiBody['erro'];
      var mesagemAPI = apiBody['mensagem'];
      if (erro == true) {
        return buildMinhaSnackBar(context, icon: Icons.warning_amber);
      } else {
        return navigatorRoute(context, ItensBottom(currentTab: 0));
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
