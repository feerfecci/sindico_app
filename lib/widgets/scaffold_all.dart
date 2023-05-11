import 'package:flutter/material.dart';

import '../consts/consts.dart';
import 'custom_drawer/custom_drawer.dart';

Widget buildScaffoldAll({required Widget? body}) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Consts.kColorApp,
    ),
    endDrawer: CustomDrawer(),
    body: body,
  );
}
