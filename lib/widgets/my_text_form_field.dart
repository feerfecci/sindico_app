import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sindico_app/consts.dart';
import 'package:validatorless/validatorless.dart';

Widget buildMyTextFormField(
  BuildContext context,
  String title, {
  List<TextInputFormatter>? inputFormatters,
  String? hintText,
}) {
  var size = MediaQuery.of(context).size;
  return Padding(
    padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
    child: TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textAlign: TextAlign.start,
      textInputAction: TextInputAction.next,
      maxLines: 5,
      minLines: 1,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: size.width * 0.04),
        filled: true,
        fillColor: Theme.of(context).canvasColor,
        label: Text(title),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.black26),
        ),
      ),
    ),
  );
}

Widget buildMyTextFormProibido(BuildContext context, String title,
    {String mensagem = 'Este campo é obrigatótio',
    required TextEditingController? textController,
    List<TextInputFormatter>? inputFormatters,
    String? hintText,
    String? Function(String?)? validator}) {
  var size = MediaQuery.of(context).size;
  return Padding(
    padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
    child: TextFormField(
      controller: textController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textAlign: TextAlign.start,
      textInputAction: TextInputAction.next,
      maxLines: 5,
      minLines: 1,
      inputFormatters: inputFormatters,
      validator: Validatorless.multiple([Validatorless.required(mensagem)]),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: size.width * 0.04),
        filled: true,
        fillColor: Theme.of(context).canvasColor,
        label: Text(title),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.black26),
        ),
      ),
    ),
  );
}
