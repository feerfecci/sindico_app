// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sindico_app/repositories/shared_preferences.dart';
import 'package:sindico_app/screens/login/login_screen.dart';
import '../../consts/consts.dart';
import '../../consts/const_widget.dart';
import '../../consts/consts_future.dart';
import '../../repositories/biometrics_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startLogin() async {
    await LocalInfos.readCache().then((value) async {
      Map<String, dynamic> infos = value;
      if (infos.values.first != null && infos.values.last != null) {
        final auth = await LocalAuthApi.authenticate();
        final hasBiometrics = await LocalAuthApi.hasBiometrics();
        if (auth && hasBiometrics) {
          return ConstsFuture.fazerLogin(
              context, infos.values.first, infos.values.last);
        }
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
            (route) => false);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Timer(Duration(seconds: 3), () {
    //   startLogin();
    // });
    startLogin();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: size.height * 0.03, horizontal: size.width * 0.03),
            child: ConstsWidget.buildCustomButton(
              context,
              'Autenticar Biometria',
              icon: Icons.lock_open_outlined,
              onPressed: () {
                startLogin();
              },
              textColor: Consts.kColorApp,
            ),
          ),
        ],
      ),
    );
  }
}
