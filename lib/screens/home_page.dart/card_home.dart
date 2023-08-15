import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../consts/const_widget.dart';
import '../../consts/consts_future.dart';
import '../../screens/splash_screen/splash_screen.dart';
import '../../widgets/my_box_shadow.dart';

Widget buildCardHome(BuildContext context,
    {required String title,
    Widget? pageRoute,
    required String iconApi,
    bool isWhats = false,
    String? numberCall}) {
  var size = MediaQuery.of(context).size;

  launchNumber(number) async {
    await launchUrl(Uri.parse('tel:$number'));
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
            ConstsWidget.buildFutureImage(
              context,
              iconApi: iconApi,
              width: SplashScreen.isSmall ? 0.12 : 0.14,
              height: SplashScreen.isSmall ? 0.07 : 0.065,
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
                size: SplashScreen.isSmall ? 14 : 16),
          ],
        ),
      ),
    ),
  );
}
