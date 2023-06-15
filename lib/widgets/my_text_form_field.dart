import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:validatorless/validatorless.dart';

Widget buildMyTextFormField(BuildContext context,
    {required String title,
    String? mask,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? hintText,
    String? initialValue,
    final void Function(String? text)? onSaved}) {
  var size = MediaQuery.of(context).size;
  return Padding(
    padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
    child: TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: [MaskTextInputFormatter(mask: mask)],
      initialValue: initialValue,
      onSaved: onSaved,
      textAlign: TextAlign.start,
      textInputAction: TextInputAction.next,
      keyboardType: keyboardType,
      maxLines: 5,
      minLines: 1,
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

Widget buildMyTextFormObrigatorio(BuildContext context, String title,
    {String mensagem = 'Este campo é obrigatótio',
    String? mask,
    String? hintText,
    String? initialValue,
    TextInputType? keyboardType,
    bool readOnly = false,
    int? maxLength,
    String? Function(String?)? validator,
    final void Function(String? text)? onSaved}) {
  var size = MediaQuery.of(context).size;
  return Padding(
    padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
    child: TextFormField(
      initialValue: initialValue,
      keyboardType: keyboardType,
      readOnly: readOnly,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textAlign: TextAlign.start,
      textInputAction: TextInputAction.next,
      onSaved: onSaved,
      maxLength: maxLength,
      inputFormatters: [MaskTextInputFormatter(mask: mask)],
      validator: Validatorless.multiple([Validatorless.required(mensagem)]),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: size.width * 0.02),
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

Widget buildTextFormLinhas(BuildContext context,
    {void Function(String?)? onSaved, String? initialValue}) {
  var size = MediaQuery.of(context).size;
  return Padding(
    padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
    child: TextFormField(
      onSaved: onSaved,
      minLines: 5,
      maxLines: 5,
      maxLength: 1000,
      initialValue: initialValue,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textAlign: TextAlign.justify,
      textInputAction: TextInputAction.next,
      validator: Validatorless.multiple([Validatorless.required('mensagem')]),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
            vertical: size.height * 0.015, horizontal: size.width * 0.02),
        filled: true,
        fillColor: Theme.of(context).canvasColor,
        label: Text('Texto'),
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
