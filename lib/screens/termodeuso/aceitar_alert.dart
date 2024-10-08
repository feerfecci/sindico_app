import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:sindico_app/widgets/shimmer_widget.dart';
import 'package:sindico_app/widgets/snack.dart';
import '../../consts/const_widget.dart';
import '../../consts/consts.dart';
import '../../consts/consts_future.dart';
import '../../widgets/page_erro.dart';
import '../../widgets/page_vazia.dart';
import '../home_page.dart/home_page.dart';
import '../splash_screen/splash_screen.dart';

class AceitarTermosScreen extends StatefulWidget {
  const AceitarTermosScreen({super.key});

  @override
  State<AceitarTermosScreen> createState() => _AceitarTermosScreenState();
}

politicaApi() async {
  final url = Uri.parse(
      '${Consts.sindicoApi}termo_uso/?fn=mostrarTermo&idcond=${ResponsalvelInfos.idcondominio}');
  var resposta = await http.get(url);

  if (resposta.statusCode == 200) {
    return jsonDecode(resposta.body);
  } else {
    return null;
  }
}

bool isChecked = false;

class _AceitarTermosScreenState extends State<AceitarTermosScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(
          horizontal: size.width * 0.05, vertical: size.height * 0.05),
      content: SizedBox(
        width: size.width * 0.98,
        child: Column(
          children: [
            FutureBuilder<dynamic>(
                future: politicaApi(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: ShimmerWidget(height: size.height * 0.64),
                    );
                  } else if (snapshot.hasData) {
                    if (!snapshot.data['erro']) {
                      var texto = snapshot.data['termo_uso'][0]['texto'];
                      return SizedBox(
                        height: SplashScreen.isSmall
                            ? size.height * 0.57
                            : size.height * 0.63,
                        child: ListView(
                          children: [
                            Html(
                              data: texto,
                              style: {
                                'p': Style(
                                  fontSize: FontSize(16),
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color,
                                ),
                                'i': Style(
                                    fontSize: FontSize(16),
                                    fontStyle: FontStyle.italic),
                                'ul': Style(fontSize: FontSize(14)),
                                'strong': Style(
                                    fontSize: FontSize(16),
                                    fontWeight: FontWeight.bold)
                              },
                            ),
                          ],
                        ),
                      );
                    } else {
                      return PageVazia(title: snapshot.data['mensagem']);
                    }
                  } else {
                    return PageErro();
                  }
                }),
            StatefulBuilder(builder: (context, setState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Padding(
                  //   padding: EdgeInsets.symmetric(
                  //       vertical: size.height * 0.04),
                  //   child: Image(
                  //     image: NetworkImage(
                  //         '${logado.arquivoAssets}logo-login-f.png'),
                  //   ),
                  // ),

                  ConstsWidget.buildCheckBox(context, isChecked: isChecked,
                      onChanged: (value) {
                    setState(() {
                      isChecked = value!;
                    });
                  }, title: 'Li e aceito os termos'),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ConstsWidget.buildCustomButton(
                        context,
                        rowSpacing: 0.13,
                        'Aceitar',
                        color: isChecked ? Consts.kColorRed : Colors.grey,
                        onPressed: isChecked
                            ? () {
                                ConstsFuture.resquestApi(
                                        '${Consts.sindicoApi}termo_uso/?fn=aceitaTermo&idfuncionario=${ResponsalvelInfos.idfuncionario}')
                                    .then((value) {
                                  if (!value['erro']) {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HomePage(),
                                        ),
                                        (route) => false);
                                  } else {
                                    buildMinhaSnackBar(context,
                                        title: 'algo saiu mal!',
                                        hasError: value['erro'],
                                        subTitle: value['mensagem']);
                                  }
                                });
                              }
                            : () {},
                      )
                    ],
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
