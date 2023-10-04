import 'package:flutter/material.dart';

import '../../consts/const_widget.dart';
import '../../consts/consts_future.dart';
import '../../widgets/my_box_shadow.dart';
import '../moradores/lista_morador.dart';

Widget buildCardUnidade(
  BuildContext context, {
  required int idunidade,
  required int iddivisao,
  required String localizado,
}) {
  var size = MediaQuery.of(context).size;
  return ConstsWidget.buildPadding001(
    context,
    vertical: 0.005,
    child: MyBoxShadow(
      child: ConstsWidget.buildPadding001(
        context,
        vertical: 0.005,
        horizontal: 0.02,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ConstsWidget.buildTextTitle(context, localizado),
            SizedBox(
              height: size.height * 0.01,
            ),
            ConstsWidget.buildCustomButton(
              context,
              'Listar Moradores',
              onPressed: () {
                ConstsFuture.navigatorPagePush(
                    context,
                    ListaMorador(
                      idunidade: idunidade,
                      idvisisao: iddivisao,
                      localizado: localizado,
                    ));
              },
            )
          ],
        ),
      ),
    ),
  );
}
