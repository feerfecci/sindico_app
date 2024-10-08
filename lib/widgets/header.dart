import 'package:flutter/material.dart';

import '../consts/const_widget.dart';

Widget buildHeaderPage(
  BuildContext context, {
  required String titulo,
  required String subTitulo,
  required Widget widget,
}) {
  var size = MediaQuery.of(context).size;
  return StatefulBuilder(builder: (context, setState) {
    return ListView(
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            SizedBox(
              child: TweenAnimationBuilder(
                curve: Curves.easeIn,
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Padding(
                      padding:
                          EdgeInsets.only(top: value * size.height * 0.025),
                      child: child,
                    ),
                  );
                },
                duration: Duration(milliseconds: 800),
                child: Column(
                  children: [
                    ConstsWidget.buildTextTitle(
                      context,
                      titulo,
                      fontSize: 24,
                    ),
                    ConstsWidget.buildTextSubTitle(context, subTitulo),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: size.height * 0.09,
                right: size.width * 0.02,
                left: size.width * 0.02,
              ),
              child: widget,
            ),
          ],
        ),
      ],
    );
  });
}
