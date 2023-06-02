// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../consts/consts.dart';

class TesteUnidade extends StatefulWidget {
  const TesteUnidade({super.key});

  @override
  State<TesteUnidade> createState() => _TesteUnidadeState();
}

class _TesteUnidadeState extends State<TesteUnidade> {
  List categoryItemlist = [];

  var dropdownvalue;

  @override
  void initState() {
    super.initState();
    getAllCategory();
  }

  Future getAllCategory() async {
    var baseUrl = "${Consts.sindicoApi}divisoes/?fn=listarDivisoes&idcond=13";

    http.Response response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var divisoes = jsonData['divisoes'];
      setState(() {
        categoryItemlist = divisoes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DropDown List"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton(
              hint: Text('Selecione uma Divisão'),
              items: categoryItemlist.map((item) {
                return DropdownMenuItem(
                  value: item['iddivisao'].toString(),
                  child: Text(item['nome_divisao'].toString()),
                );
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  dropdownvalue = newVal;
                });
              },
              value: dropdownvalue,
            ),
          ],
        ),
      ),
    );
  }
}
