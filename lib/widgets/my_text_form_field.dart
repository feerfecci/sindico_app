import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sindico_app/consts.dart';

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
