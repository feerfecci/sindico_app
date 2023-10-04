import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:sindico_app/consts/consts.dart';
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
    TextEditingController? controller,
    String? Function(String?)? validator,
    TextCapitalization textCapitalization = TextCapitalization.none,
    bool labelCenter = false,
    final void Function(String? text)? onSaved}) {
  var size = MediaQuery.of(context).size;
  return ConstsWidget.buildPadding001(
    context,
    child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        inputFormatters: [
          MaskTextInputFormatter(
            mask: mask,
          )
        ],
        controller: controller,
        initialValue: initialValue,
        onSaved: onSaved,
        validator: validator,
        textCapitalization: textCapitalization,
        textAlign: TextAlign.start,
        textInputAction: TextInputAction.next,
        keyboardType: keyboardType,
        maxLines: 5,
        minLines: 1,
        style: TextStyle(fontSize: SplashScreen.isSmall ? 16 : 18),
        decoration:
            buildTextFieldDecoration(context, title: title, hintText: hintText)

        // InputDecoration(
        //   contentPadding: EdgeInsets.symmetric(
        //       horizontal: size.width * 0.035, vertical: size.height * 0.023),
        //   filled: true,
        //   fillColor: Theme.of(context).canvasColor,
        //   label: labelCenter
        //       ? Center(
        //           child: Text(
        //             title,
        //             style: TextStyle(fontSize: SplashScreen.isSmall ? 14 : 16),
        //           ),
        //         )
        //       : Text(
        //           title,
        //           style: TextStyle(fontSize: SplashScreen.isSmall ? 14 : 16),
        //         ),
        //   hintText: hintText,
        //   border: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(16),
        //   ),
        //   enabledBorder: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(16),
        //     borderSide: BorderSide(color: Colors.black26),
        //   ),
        // ),
        ),
  );
}

Widget buildMyTextFormObrigatorio(BuildContext context, String title,
    {String mensagem = 'Obrigatório',
    String? mask,
    String? hintText,
    String? initialValue,
    Iterable<String>? autofillHints,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    TextCapitalization textCapitalization = TextCapitalization.none,
    bool readOnly = false,
    int? maxLength,
    int? maxLines,
    int? minLines,
    TextInputAction? textInputAction,
    Widget? suffixIcon,
    bool obscureText = false,
    void Function()? onEditingComplete,
    TextEditingController? controller,
    final void Function(String? text)? onSaved}) {
  var size = MediaQuery.of(context).size;
  return ConstsWidget.buildPadding001(
    context,
    child: TextFormField(
        controller: controller,
        autofillHints: autofillHints,
        initialValue: initialValue,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        readOnly: readOnly,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textAlign: TextAlign.start,
        textInputAction: textInputAction ?? TextInputAction.next,
        onSaved: onSaved,
        maxLength: maxLength,
        obscureText: obscureText,
        onEditingComplete: onEditingComplete,
        minLines: obscureText ? null : minLines,
        maxLines: obscureText ? null : maxLines,
        style: TextStyle(fontSize: SplashScreen.isSmall ? 14 : 18),
        inputFormatters: [MaskTextInputFormatter(mask: mask)],
        validator: validator ??
            Validatorless.multiple([Validatorless.required(mensagem)]),
        decoration: buildTextFieldDecoration(context,
            title: title, hintText: hintText, isobrigatorio: true)),
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
        textCapitalization: TextCapitalization.sentences,
        textAlign: TextAlign.justify,
        textInputAction: TextInputAction.next,
        validator: Validatorless.multiple([Validatorless.required('Preencha')]),
        decoration: buildTextFieldDecoration(context, title: label)),
  );
}

InputDecoration buildTextFieldDecoration(BuildContext context,
    {required String title,
    String? hintText,
    bool isobrigatorio = false,
    Widget? suffixIcon}) {
  var size = MediaQuery.of(context).size;
  return InputDecoration(
    suffixIcon: suffixIcon,
    contentPadding: EdgeInsets.symmetric(
        horizontal: size.width * 0.035,
        vertical:
            SplashScreen.isSmall ? size.height * 0.03 : size.height * 0.025),
    filled: true,
    fillColor: Theme.of(context).canvasColor,
    label: isobrigatorio
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstsWidget.buildTextSubTitle(context, title,
                  size: SplashScreen.isSmall ? 14 : 16),
              // Text(
              //   title,
              //   style: TextStyle(fontSize: SplashScreen.isSmall ? 14 : 16),
              // ),
              Text(
                ' *',
                style: TextStyle(
                    fontSize: SplashScreen.isSmall ? 14 : 16,
                    color: Consts.kColorRed),
              ),
            ],
          )
        : ConstsWidget.buildTextSubTitle(context, title,
            size: SplashScreen.isSmall ? 14 : 16),
    hintText: hintText,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
    ),
  );
}
