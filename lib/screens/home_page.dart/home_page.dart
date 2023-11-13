// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sindico_app/consts/const_widget.dart';
import 'package:sindico_app/consts/consts_future.dart';
import 'package:sindico_app/repositories/shared_preferences.dart';
import 'package:sindico_app/screens/espacos/lista_espacos.dart';
import 'package:sindico_app/screens/home_page.dart/card_home.dart';
import 'package:sindico_app/screens/home_page.dart/drop_cond.dart';
import 'package:sindico_app/screens/meu_perfil/meu_perfil_screen.dart';
import 'package:sindico_app/screens/reservas/listar_reservar.dart';
import 'package:sindico_app/widgets/custom_drawer/custom_drawer.dart';
import 'package:sindico_app/widgets/shimmer_widget.dart';
import 'package:sindico_app/widgets/snack.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../consts/consts.dart';
import '../../widgets/alert_dialogs/alertdialog_all.dart';
import '../../widgets/my_box_shadow.dart';
import '../../widgets/page_erro.dart';
import '../colaboradores/lista_colaboradores.dart';
import '../quadro_avisos/quadro_de_avisos.dart';
import '../tarefas/tarefas_screen.dart';
import '../unidade/lista_unidade.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import '../../screens/splash_screen/splash_screen.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List telefonesList1 = [];
  List telefonesList2 = [];
  List telefonesList3 = [];
  DateTime timeBackPressed = DateTime.now();
  // late PageController _pageController;
  List<Models> models = [
    Models(
        indexOrder: 0,
        title: 'Bombeiros',
        numberCall: '193',
        iconApi: '${Consts.iconApiPort}bombeiro.png'),
    Models(
        indexOrder: 1,
        title: 'Samu',
        numberCall: '192',
        iconApi: '${Consts.iconApiPort}ambulancia.png'),
    Models(
        indexOrder: 2,
        title: 'Polícia',
        numberCall: '190',
        iconApi: '${Consts.iconApiPort}policia.png'),
    Models(
      indexOrder: 3,
      title: 'Lista | Colaboradores',
      iconApi: '${Consts.iconApiPort}visitas.png',
      pageRoute: ListaColaboradores(),
    ),
    Models(
        indexOrder: 4,
        title: 'Cadastro | Espaços',
        pageRoute: ListaEspacos(),
        iconApi: '${Consts.iconApiPort}cadastro-espacos-azul.png'),
    Models(
        indexOrder: 5,
        title: 'Cadastro | Unidades',
        pageRoute: ListaUnidades(),
        iconApi: '${Consts.iconApiPort}cadastro-unidades.png'),
    Models(
        indexOrder: 6,
        title: 'Reservas Solicitadas',
        pageRoute: ListaReservas(),
        iconApi: '${Consts.iconApiPort}reservas-solicitadas.png'),
    Models(
      indexOrder: 7,
      pageRoute: QuadroDeAvisos(),
      title: 'Quadro de Avisos',
      iconApi: '${Consts.iconApiPort}quadrodeavisos.png',
    ),
    Models(
      indexOrder: 7,
      title: 'Ligar Portaria',
      //isWhats: true,
      numberCall: ResponsalvelInfos.telefone_portaria,
      iconApi: '${Consts.iconApiPort}ligar.png',
    ),
    Models(
      indexOrder: 7,
      pageRoute: TarefasScreen(),
      title: 'Lista | Tarefas',
      iconApi: '${Consts.iconApiPort}tarefas.png',
    ),
  ];

  gettingCacheDrag() async {
    await LocalInfos.getOrderDragg().then((value) {
      if (value != null) {
        List<String> listCacheDrag = value;
        List<Models> listModels = [];
        listModels = listCacheDrag
            .map(
              (String indx) => models.where((Models item) {
                return int.parse(indx) == item.indexOrder;
              }).first,
            )
            .toList();
        setState(() {
          models = listModels;
        });
      } else {
        return models;
      }
    });
  }

  Future<dynamic> cliquePubli(String api) async {
    var url = Uri.parse(api);
    var resposta = await http.get(url);
    if (resposta.statusCode == 200) {
      try {
        return json.decode(resposta.body);
      } catch (e) {
        return {'erro': true, 'mensagem': 'Tente Novamente'};
      }
    }
  }

  alertSenhaPadrao() {
    if (!ResponsalvelInfos.senha_alterada) {
      return showAllDialog(context,
          title: Stack(
            alignment: Alignment.center,
            children: [
              ConstsWidget.buildTextTitle(context, 'Senha Padrão',
                  textAlign: TextAlign.center),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close)),
                ],
              )
            ],
          ),
          children: [
            ConstsWidget.buildTextTitle(context,
                'Sua senha é a padrão. Acesse seu Perfil para trocar para uma senha personalizada e garantir sua segurança',
                maxLines: 8, textAlign: TextAlign.center),
            SizedBox(
              height: 10,
            ),
            ConstsWidget.buildCustomButton(context, 'Trocar Senha',
                onPressed: () {
              Navigator.pop(context);
              ConstsFuture.navigatorPagePush(context, MeuPerfilScreen());
            }),
          ]);
    }
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    gettingCacheDrag();
    // NotificationWidget.init();
    // _pageController = PageController();
  }

  Future<dynamic> apiPubli({required int local}) {
    return ConstsFuture.resquestApi(
        '${Consts.sindicoApi}publicidade/?fn=mostrarPublicidade&idcond=${ResponsalvelInfos.idcondominio}&local=$local');
  }

  Future<void> initPlatformState() async {
    OneSignal.shared.setAppId('efbab610-a64a-41ea-ac83-df2d674b81a2');
    OneSignal.shared.deleteTags(['idcond', 'idmorador', 'idunidade']);

    OneSignal.shared.promptUserForPushNotificationPermission().then((value) {
      for (var i = 0; i <= (ResponsalvelInfos.listIdCond.length - 1); i++) {
        OneSignal.shared.deleteTags([
          'idcond${ResponsalvelInfos.listIdCond[i]}',
          'idfuncionario${ResponsalvelInfos.listIdFuncionario[i]}',
          'idfuncao${ResponsalvelInfos.listIdFuncao[i]}'
              'idcond',
          'idfuncionario',
          'idfuncao'
        ]);

        OneSignal.shared.sendTags({
          'idcond${ResponsalvelInfos.listIdCond[i]}':
              ResponsalvelInfos.listIdCond[i],
          'idfuncionario${ResponsalvelInfos.listIdFuncionario[i]}':
              ResponsalvelInfos.listIdFuncionario[i],
          'idfuncao${ResponsalvelInfos.listIdFuncao[i]}':
              ResponsalvelInfos.listIdFuncao[i],
        });
      }
    });

    OneSignal.shared.setNotificationOpenedHandler((openedResult) {
      if (openedResult.notification.additionalData!['idcond'] != null) {
        ConstsFuture.fazerLogin(
            context, ResponsalvelInfos.login, ResponsalvelInfos.senhacripto,
            idCondominio:
                int.parse(openedResult.notification.additionalData!['idcond']),
            openedResult: openedResult);
      }
    });
    Timer(Duration(seconds: 3), () {
      alertSenhaPadrao();
    });
  }

  bool draggable = false;

  lauchEmail(String email) {
    launchUrl(Uri.parse('mailto:$email'), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Widget buildBanerPubli({required int local, required List usarList}) {
      return FutureBuilder(
        future: apiPubli(local: local),
        builder: (context, snapshot) {
          usarList.clear();
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ShimmerWidget(height: size.height * 0.25);
          } else if (snapshot.hasData) {
            if (!snapshot.data!["erro"]) {
              if (snapshot.data['publicidade'][0] != null) {
                var apiPublicidade = snapshot.data['publicidade'][0];
                var idpublidade = apiPublicidade['idpublidade'];
                var idcondominio = apiPublicidade['idcondominio'];
                var arquivo = apiPublicidade['arquivo'];
                var email = apiPublicidade['email'];
                var site = apiPublicidade['site'];
                var whatsapp = apiPublicidade['whatsapp'];
                var telefone = apiPublicidade['telefone'];
                var telefone2 = apiPublicidade['telefone2'];
                var impressoes = apiPublicidade['impressoes'];
                var datahora = apiPublicidade['datahora'];
                var ultima_atualizacao = apiPublicidade['ultima_atualizacao'];

                bool hasWhats = false;

                if (whatsapp != '') {
                  usarList.add(whatsapp);
                  hasWhats = true;
                }
                if (telefone != '') {
                  if (telefone != whatsapp) {
                    usarList.add(telefone);
                  } else {
                    hasWhats = true;
                  }
                }
                if (telefone2 != '') {
                  if (telefone2 != whatsapp && telefone2 != telefone) {
                    usarList.add(telefone2);
                  } else {
                    hasWhats = true;
                  }
                }

                return GestureDetector(
                  onTap: () {
                    cliquePubli(
                        'https://a.portariaapp.com/unidade/api/publicidade/?fn=cliquePublicidade&idpublicidade=$idpublidade');
                    if (usarList.length == 1 && email == '' && site == '') {
                      if (hasWhats) {
                        launchUrl(Uri.parse('https://wa.me/+55$whatsapp'),
                            mode: LaunchMode.externalApplication);
                      } else if (telefone != '') {
                        launchUrl(Uri.parse('tel:$telefone'),
                            mode: LaunchMode.externalApplication);
                      } else {
                        launchUrl(Uri.parse('tel:$telefone2'),
                            mode: LaunchMode.externalApplication);
                      }
                    } else if (usarList.isEmpty && email == '' && site != '') {
                      launchUrl(Uri.parse(site),
                          mode: LaunchMode.externalApplication);
                    } else if (usarList.isEmpty && site == '' && email != '') {
                      lauchEmail(email);
                    } else {
                      showAllDialog(context,
                          title: ConstsWidget.buildTextTitle(
                              context, 'Entrar em contato',
                              fontSize: 18),
                          barrierDismissible: true,
                          children: [
                            Column(
                              children: usarList.map((e) {
                                return GestureDetector(
                                  onTap: hasWhats && e == whatsapp
                                      ? () {
                                          launchUrl(
                                              Uri.parse(
                                                  'https://wa.me/+55$whatsapp'),
                                              mode: LaunchMode
                                                  .externalApplication);
                                        }
                                      : whatsapp != null
                                          ? () {
                                              launchUrl(Uri.parse('tel:$e'));
                                            }
                                          : () {},
                                  child: MyBoxShadow(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: size.width * 0.01,
                                        ),
                                        ConstsWidget.buildTextTitle(context, e),
                                        Spacer(),
                                        if (hasWhats && e == whatsapp)
                                          IconButton(
                                              onPressed: () {
                                                launchUrl(
                                                    Uri.parse(
                                                        'https://wa.me/+55$whatsapp'),
                                                    mode: LaunchMode
                                                        .externalApplication);
                                              },
                                              icon: Icon(Icons.wechat_rounded)),
                                        if (whatsapp != null)
                                          IconButton(
                                              onPressed: () {
                                                launchUrl(Uri.parse('tel:$e'));
                                              },
                                              icon: Icon(Icons.call)),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            if (site != '')
                              GestureDetector(
                                onTap: () {
                                  launchUrl(Uri.parse(site),
                                      mode: LaunchMode.inAppWebView);
                                },
                                child: MyBoxShadow(
                                    child: Row(
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.01,
                                    ),
                                    ConstsWidget.buildTextTitle(
                                        context, 'Acesse o site'),
                                    Spacer(),
                                    ConstsWidget.buildPadding001(
                                      context,
                                      vertical: 0.015,
                                      horizontal: 0.025,
                                      child: Icon(Icons.wordpress_rounded),
                                    ),
                                  ],
                                )),
                              ),
                            if (email != '')
                              GestureDetector(
                                onTap: () {
                                  lauchEmail(email);
                                },
                                child: MyBoxShadow(
                                    child: Row(
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.01,
                                    ),
                                    ConstsWidget.buildTextTitle(
                                        context, 'Envie um email'),
                                    Spacer(),
                                    ConstsWidget.buildPadding001(
                                      context,
                                      vertical: 0.015,
                                      horizontal: 0.025,
                                      child: Icon(Icons.email),
                                    ),
                                  ],
                                )),
                              )
                          ]);
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    child: ConstsWidget.buildCachedImage(context,
                        /* title: 'Ver mais $idpublidade',*/ iconApi: arquivo),
                  ),
                );
              } else {
                ResponsalvelInfos.qtd_publicidade == 0;
                return SizedBox();
              }
            } else {
              ResponsalvelInfos.qtd_publicidade == 0;
              return SizedBox();
            }
          } else {
            ResponsalvelInfos.qtd_publicidade == 0;
            return SizedBox();
          }
        },
      );
    }

    return WillPopScope(
      onWillPop: () async {
        final differenceBack = DateTime.now().difference(timeBackPressed);
        final isExitWarning = differenceBack >= Duration(seconds: 1);
        timeBackPressed = DateTime.now();

        if (isExitWarning) {
          Fluttertoast.showToast(
              msg: 'Pressione novamente para sair',
              fontSize: 18,
              backgroundColor: Colors.black);
          return false;
        } else {
          Fluttertoast.cancel();
          return true;
        }
      },
      child: ConstsWidget.buildRefreshIndicator(
        context,
        onRefresh: () async {
          setState(() {
            // ConstsFuture.apiImage(
            //   'https://a.portariaapp.com/img/logo_verde.png',
            // );
          });
        },
        child: Scaffold(
          endDrawer: CustomDrawer(),
          appBar: AppBar(
            centerTitle: true,
            title: ConstsWidget.buildTextTitle(
                context, ResponsalvelInfos.nome_responsavel,
                textAlign: TextAlign.center,
                maxLines: 3,
                fontSize: SplashScreen.isSmall ? 18 : 20),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            iconTheme: IconThemeData(
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
            toolbarHeight:
                SplashScreen.isSmall ? size.height * 0.09 : size.height * 0.07,
            leading: Padding(
              padding: EdgeInsets.only(
                  left: size.width * 0.025,
                  top: SplashScreen.isSmall
                      ? size.height * 0.02
                      : size.height * 0.01,
                  bottom: SplashScreen.isSmall
                      ? size.height * 0.005
                      : size.height * 0.01),
              child: ConstsWidget.buildCachedImage(
                context,
                iconApi: 'https://a.portariaapp.com/img/logo_verde.png',
              ),
              // FutureBuilder(
              //   future: ConstsFuture.apiImage(
              //     'https://a.portariaapp.com/img/logo_verde.png',
              //   ),
              //   builder: (context, snapshot) {
              //     return SizedBox(child: snapshot.data);
              //   },
              // ),
            ),
            elevation: 0,
            leadingWidth:
                SplashScreen.isSmall ? size.height * 0.08 : size.height * 0.06,
          ),
          body: ListView(
            padding: EdgeInsets.symmetric(horizontal: size.height * 0.01),
            children: [
              DropCond(),
              StatefulBuilder(
                builder: (context, setState) {
                  return ReorderableGridView.count(
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 0.5,
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    childAspectRatio: SplashScreen.isSmall ? 1.6 : 1.40,
                    physics: ClampingScrollPhysics(),
                    onReorder: (oldIndex, newIndex) {
                      var card = models.removeAt(oldIndex);
                      setState(
                        () {
                          models.insert(
                              newIndex == 5 ? newIndex - 1 : newIndex, card);
                          LocalInfos.setOrderDragg(models.map((e) {
                            return e.indexOrder.toString();
                          }).toList());
                        },
                      );
                    },
                    children: models.map((card) {
                      return Container(
                        key: ValueKey(card),
                        child: buildCardHome(context,
                            title: card.title,
                            pageRoute: card.pageRoute,
                            isWhats: card.isWhats,
                            numberCall: card.numberCall,
                            iconApi: card.iconApi),
                      );
                    }).toList(),
                  );
                },
              ),
              if (ResponsalvelInfos.qtd_publicidade != 0)
                Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    buildBanerPubli(local: 1, usarList: telefonesList1)
                  ],
                ),
              if (ResponsalvelInfos.qtd_publicidade != 0)
                Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.018,
                    ),
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1,
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        buildBanerPubli(local: 2, usarList: telefonesList2),
                        buildBanerPubli(local: 3, usarList: telefonesList3),
                      ],
                    ),
                  ],
                ),
              SizedBox(
                height: size.height * 0.02,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Models {
  int indexOrder = 0;
  String title = '';

  Widget? pageRoute;

  String iconApi = '';

  bool isWhats;
  String? numberCall;
  Models({
    required this.indexOrder,
    required this.title,
    this.pageRoute,
    required this.iconApi,
    this.isWhats = false,
    this.numberCall,
  });
}
