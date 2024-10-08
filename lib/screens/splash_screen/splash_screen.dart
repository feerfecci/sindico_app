// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sindico_app/repositories/shared_preferences.dart';
import 'package:sindico_app/screens/login/login_screen.dart';
import '../../consts/consts.dart';
import '../../consts/const_widget.dart';
import '../../consts/consts_future.dart';
import '../../repositories/biometrics_auth.dart';
import '../../widgets/snack.dart';

class SplashScreen extends StatefulWidget {
  static bool isSmall = false;
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool load = true;
  startLogin() async {
    await LocalInfos.readCache().then((value) async {
      Map<String, dynamic> infos = value;
      if (infos.values.first != null && infos.values.last != null) {
        final auth = await LocalAuthApi.authenticate();
        final hasBiometrics = await LocalAuthApi.hasBiometrics();
        setState(() {
          load = true;
        });
        if (hasBiometrics) {
          if (auth) {
            return ConstsFuture.fazerLogin(
                context, infos.values.first, infos.values.last);
          }
        } else {
          ConstsFuture.fazerLogin(
              context, infos.values.first, infos.values.last);
        }
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
            (route) => true).then((value) => buildMinhaSnackBar(context));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      startLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    SplashScreen.isSmall = size.width <= 350
        ? true
        // : Platform.isIOS
        //     ? true
        : false;
    return Scaffold(
      backgroundColor: Consts.kBackPageColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          SizedBox(
            height: size.height * 0.2,
            width: size.width * 0.6,
            child: Image.network(
              'https://a.portariaapp.com/img/logo_verde.png',
            ),
          ),
          Spacer(),
          Row(),
          if (load)
            ConstsWidget.buildPadding001(
              context,
              vertical: 0.03,
              horizontal: 0.03,
              child: ConstsWidget.buildCustomButton(
                context,
                'Autenticar Biometria',
                onPressed: () {
                  startLogin();
                },
                textColor: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}
