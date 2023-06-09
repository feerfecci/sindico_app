import 'package:flutter/material.dart';

import 'custom_drawer/custom_drawer.dart';

Widget buildScaffoldAll(BuildContext context, {required Widget? body}) {
  return Scaffold(
    appBar: AppBar(
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
      elevation: 0,
      backgroundColor: Colors.transparent,
    ),
    endDrawer: CustomDrawer(),
    body: body,
  );
}
