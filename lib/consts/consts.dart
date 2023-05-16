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
  static double fontTitulo = 18;
  static double fontSubTitulo = 16;
  static double borderButton = 60;

  static const kBackPageColor = Color.fromARGB(255, 245, 245, 255);
  // static const kButtonColor = Color.fromARGB(255, 0, 134, 252);
  static const kButtonColor = kColorApp;

  static const kColorApp = Color.fromARGB(255, 127, 99, 254);

  static const String iconApi = 'https://escritorioapp.com/img/ico-';
}
