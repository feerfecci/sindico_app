import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:sindico_app/screens/home_page.dart/home_page.dart';
import 'package:validatorless/validatorless.dart';

import '../consts/const_widget.dart';
import '../screens/splash_screen/splash_screen.dart';

Widget buildMyTextFormField(BuildContext context,
    {required String title,
    String? mask,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? hintText,
    String? initialValue,
    bool labelCenter = false,
    final void Function(String? text)? onSaved}) {
  var size = MediaQuery.of(context).size;
  return ConstsWidget.buildPadding001(
    context,
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
      style: TextStyle(fontSize: SplashScreen.isSmall ? 16 : 18),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
            horizontal: size.width * 0.035, vertical: size.height * 0.023),
        filled: true,
        fillColor: Theme.of(context).canvasColor,
        label: labelCenter
            ? Center(
                child: Text(
                  title,
                  style: TextStyle(fontSize: SplashScreen.isSmall ? 14 : 16),
                ),
              )
            : Text(
                title,
                style: TextStyle(fontSize: SplashScreen.isSmall ? 14 : 16),
              ),
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
    {String mensagem = 'Obrigatório',
    String? mask,
    String? hintText,
    String? initialValue,
    TextInputType? keyboardType,
    bool readOnly = false,
    bool labelCenter = false,
    int? maxLength,
    int? maxLines,
    int? minLines,
    TextEditingController? controller,
    String? Function(String?)? validator,
    final void Function(String? text)? onSaved}) {
  var size = MediaQuery.of(context).size;
  return ConstsWidget.buildPadding001(
    context,
    child: TextFormField(
      controller: controller,
      initialValue: initialValue,
      keyboardType: keyboardType,
      readOnly: readOnly,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textAlign: TextAlign.start,
      textInputAction: TextInputAction.next,
      onSaved: onSaved,
      maxLength: maxLength,
      minLines: minLines,
      maxLines: maxLines,
      style: TextStyle(fontSize: SplashScreen.isSmall ? 14 : 18),
      inputFormatters: [MaskTextInputFormatter(mask: mask)],
      validator: validator ??
          Validatorless.multiple([Validatorless.required(mensagem)]),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
            horizontal:
                SplashScreen.isSmall ? size.width * 0.03 : size.width * 0.035,
            vertical: SplashScreen.isSmall
                ? size.height * 0.01
                : size.height * 0.023),
        filled: true,
        fillColor: Theme.of(context).canvasColor,
        label: labelCenter
            ? Center(
                child: Text(
                  title,
                  style: TextStyle(fontSize: SplashScreen.isSmall ? 14 : 16),
                ),
              )
            : Text(
                title,
                style: TextStyle(fontSize: SplashScreen.isSmall ? 14 : 16),
              ),
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
    {void Function(String?)? onSaved,
    String? initialValue,
    required String label,
    String? hintText}) {
  var size = MediaQuery.of(context).size;
  return ConstsWidget.buildPadding001(
    context,
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
        hintText: hintText,
        fillColor: Theme.of(context).canvasColor,
        label: Text(
          label,
          style: TextStyle(fontSize: SplashScreen.isSmall ? 14 : 16),
        ),
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
