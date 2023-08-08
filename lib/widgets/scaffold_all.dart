import 'package:flutter/material.dart';
import 'package:sindico_app/consts/const_widget.dart';

import 'custom_drawer/custom_drawer.dart';

Widget buildScaffoldAll(BuildContext context,
    {required String title, required Widget body}) {
  var size = MediaQuery.of(context).size;
  return Scaffold(
    extendBody: true,
    appBar: AppBar(
      centerTitle: true,
      title: ConstsWidget.buildTextTitle(context, title, size: 24),
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
      elevation: 0,
      backgroundColor: Colors.transparent,
    ),
    endDrawer: CustomDrawer(),
    body: ListView(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
          child: body,
        ),
      ],
    ),
  );
}
