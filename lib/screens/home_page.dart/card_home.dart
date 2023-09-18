import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:sindico_app/screens/reservas/listar_reservar.dart';
import 'package:sindico_app/screens/tarefas/tarefas_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../consts/const_widget.dart';
import '../../consts/consts_future.dart';
import '../../screens/splash_screen/splash_screen.dart';
import '../../widgets/my_box_shadow.dart';
import '../quadro_avisos/quadro_de_avisos.dart';

Widget buildCardHome(BuildContext context,
    {required String title,
    Widget? pageRoute,
    required String iconApi,
    bool isWhats = false,
    String? numberCall}) {
  var size = MediaQuery.of(context).size;

  launchNumber(number) async {
    await launchUrl(Uri.parse('tel:$number'),
        mode: LaunchMode.externalApplication);
  }

  return ConstsWidget.buildPadding001(
    context,
    vertical: 0.005,
    child: MyBoxShadow(
      paddingAll: 0.03,
      child: InkWell(
        onTap: pageRoute != null
            ? () {
                ConstsFuture.navigatorPagePush(context, pageRoute);
              }
            : () {
                if (isWhats) {
                  launchUrl(Uri.parse('https://wa.me/+55$numberCall'),
                      mode: LaunchMode.externalApplication);
                } else {
                  launchNumber(numberCall);
                }
              },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ConstsWidget.buildBadge(
              context,
              position: BadgePosition.topEnd(
                  end: -size.width * 0.14, top: -size.height * 0.013),
              showBadge: title == "Quadro de Avisos" &&
                      QuadroDeAvisos.qntAvisos.isNotEmpty
                  ? true
                  : title == "Reservas Solicitadas" &&
                          ListaReservas.listIdReserva.isNotEmpty
                      ? true
                      : title == 'Lista | Tarefas' &&
                              TarefasScreen.qntTarefas.isNotEmpty
                          ? true
                          : false,
              title: title == "Quadro de Avisos"
                  ? QuadroDeAvisos.qntAvisos.length
                  : title == "Reservas Solicitadas"
                      ? ListaReservas.listIdReserva.length
                      : title == 'Lista | Tarefas'
                          ? TarefasScreen.qntTarefas.length
                          : 0,
              child: ConstsWidget.buildCachedImage(
                context,
                iconApi: iconApi,
                width: SplashScreen.isSmall ? 0.13 : 0.141,
                height: SplashScreen.isSmall ? 0.06 : 0.0641,
              ),
            ),
            // FutureBuilder(
            //     future: apiImage(),
            //     builder: (context, snapshot) => SizedBox(
            //         width: size.width * 0.12,
            //         height: size.height * 0.075,
            //         child: snapshot.data)),
            SizedBox(
              height: size.height * 0.008,
            ),
            ConstsWidget.buildTextTitle(context, title,
                fontSize: SplashScreen.isSmall ? 14 : 16),
          ],
        ),
      ),
    ),
  );
}
