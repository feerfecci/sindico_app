import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../consts/consts.dart';
import '../../consts/const_widget.dart';
import '../../consts/consts_future.dart';
import '../../widgets/my_box_shadow.dart';

Widget buildCardHome(BuildContext context,
    {required String title,
    required Widget pageRoute,
    required String iconApi}) {
  var size = MediaQuery.of(context).size;
  Future<Widget> apiImage() async {
    var url = Uri.parse(iconApi);
    var resposta = await http.get(url);

    return resposta.statusCode == 200
        ? Image.network(
            iconApi,
          )
        : Image.asset('assets/portaria.png');
  }

  return MyBoxShadow(
    paddingAll: 0.0,
    child: InkWell(
      onTap: () {
        ConstsFuture.navigatorPagePush(context, pageRoute);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder(
              future: apiImage(),
              builder: (context, snapshot) => SizedBox(
                  width: size.width * 0.12,
                  height: size.height * 0.075,
                  child: snapshot.data)),
          SizedBox(
            height: size.height * 0.01,
          ),
          ConstsWidget.buildTextTitle(title),
        ],
      ),
    ),
  );
}
