// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:sindico_app/screens/home_page.dart/home_page.dart';
import 'package:sindico_app/screens/splash_screen/splash_screen.dart';

class ResponsalvelInfos {
  static String login = "";
  static String senhacripto = '';
  static int qntCond = 0;
  static int idcondominio = 0;
  static int idfuncionario = 0;
  static int qtd_publicidade = 0;
  static String nome_condominio = "";
  static String dividido_por = "";
  static String nome_responsavel = "";
  static String nascimento = "";
  static String documento = "";
  static String telefone = "";
  static String telefone_portaria = "";
  static String email = "";
  static String estado = "";
  static String endereco = "";
  static String numero = "";
  static String bairro = "";
  static String cep = "";
  static String cidade = "";
  static int temporespostas = 0;
}

class Consts {
  static double fontTitulo = SplashScreen.isSmall ? 18 : 20;
  static double fontSubTitulo = SplashScreen.isSmall ? 16 : 18;
  static const double borderButton = 60;

  static const kBackPageColor = Color.fromARGB(255, 245, 245, 255);
  // static const kButtonColor = Color.fromARGB(255, 0, 134, 252);
  static const kButtonColor = kColorApp;

  static const kColorApp = Color.fromARGB(255, 127, 99, 254);
  static const kColorRed = Color.fromARGB(255, 251, 80, 93);
  static const kColorAzul = Color.fromARGB(255, 75, 132, 255);
  static const kColorVerde = Color.fromARGB(255, 44, 201, 104);
  static const kColorAmarelo = Color.fromARGB(255, 255, 193, 7);
  static const String iconApi = 'https://a.portariaapp.com/img/ico-';
  static const String sindicoApi = 'https://a.portariaapp.com/sindico/api/';
  static const String iconApiPort = 'https://a.portariaapp.com/img/ico-';
}
