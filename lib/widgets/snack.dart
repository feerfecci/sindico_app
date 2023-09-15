import 'package:flutter/material.dart';
import 'package:sindico_app/consts/consts.dart';
import '../consts/const_widget.dart';

buildMinhaSnackBar(
  BuildContext context, {
  IconData icon = Icons.error_outline,
  bool hasError = false,
  String title = 'Algo deu errado',
  String subTitle = 'Tente novamente',
}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  var size = MediaQuery.of(context).size;

  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        action: SnackBarAction(
            label: 'Entendi',
            textColor: Colors.white,
            onPressed: (() {
              try {
                ScaffoldMessenger.of(context).clearSnackBars();
              } on FlutterError {
                // ignore: avoid_print
              }
            })),
        elevation: 8,
        duration: Duration(seconds: 4),
        backgroundColor: hasError ? Consts.kColorRed : Consts.kColorVerde,
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.endToStart,
        content: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            SizedBox(
              width: size.width * 0.02,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstsWidget.buildTextTitle(
                    context,
                    title,
                    color: Colors.white,
                  ),
                  ConstsWidget.buildTextSubTitle(
                    context,
                    subTitle,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ],
        )),
  );
}
