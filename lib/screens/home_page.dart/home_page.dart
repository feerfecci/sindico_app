import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sindico_app/consts/const_widget.dart';
import 'package:sindico_app/consts/consts_future.dart';
import 'package:sindico_app/repositories/shared_preferences.dart';
import 'package:sindico_app/screens/espacos/lista_espacos.dart';
import 'package:sindico_app/screens/home_page.dart/card_home.dart';
import 'package:sindico_app/screens/home_page.dart/dropCond.dart';
import 'package:sindico_app/screens/reservas/listar_reservar.dart';
import 'package:sindico_app/widgets/custom_drawer/custom_drawer.dart';
import '../../consts/consts.dart';
import '../../widgets/header.dart';
import '../../widgets/my_box_shadow.dart';
import '../colaboradores/lista_colaboradores.dart';
import '../quadro_avisos/quadro_de_avisos.dart';
import '../unidade/lista_unidade.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime timeBackPressed = DateTime.now();
  // late PageController _pageController;
  List<Models> models = [
    Models(
        indexOrder: 0,
        title: 'Reservas Solicitadas',
        pageRoute: ListaReservas(),
        iconApi: '${Consts.iconApiPort}reservas-solicitadas.png'),
    Models(
      indexOrder: 1,
      pageRoute: QuadroDeAvisos(),
      title: 'Quadro de Avisos',
      iconApi: '${Consts.iconApiPort}quadrodeavisos.png',
    ),
    Models(
      indexOrder: 2,
      title: 'Cadastro de Colaboradores',
      iconApi: '${Consts.iconApiPort}visitas.png',
      pageRoute: ListaColaboradores(),
    ),
    Models(
        indexOrder: 3,
        title: 'Cadastro de Unidades',
        pageRoute: ListaUnidades(),
        iconApi: '${Consts.iconApiPort}cadastro-unidades.png'),
    Models(
        indexOrder: 4,
        title: 'Cadastro de Espaços',
        pageRoute: ListaEspacos(),
        iconApi: '${Consts.iconApiPort}cadastroespacos.png'),
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

  @override
  void initState() {
    super.initState();
    initPlatformState();
    gettingCacheDrag();
    // NotificationWidget.init();
    // _pageController = PageController();
  }

  static const String oneSignalAppId = "25709281-f6fc-4ac7-a90e-dac40989a182";

  Future<void> initPlatformState() async {
    OneSignal.shared.setAppId(oneSignalAppId);
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      // OneSignal.shared.setEmail(email: "${User.emailUser}");
      OneSignal.shared.setExternalUserId('26');
      // OneSignal.shared
      //     .sendTags({'isAndroid': 1, 'idweb': logado.idCliente.toString()});
    });
  }

  bool draggable = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
            ConstsFuture.apiImage(
              'https://a.portariaapp.com/img/logo_verde.png',
            );
          });
        },
        child: Scaffold(
          endDrawer: CustomDrawer(),
          appBar: AppBar(
            centerTitle: true,
            title: ConstsWidget.buildTextTitle(
                context, ResponsalvelInfos.nome_responsavel,
                textAlign: TextAlign.center, size: 20),
            iconTheme:
                IconThemeData(color: Theme.of(context).colorScheme.primary),
            backgroundColor: Colors.transparent,
            leading: Padding(
              padding: EdgeInsets.only(left: size.width * 0.025),
              child: FutureBuilder(
                future: ConstsFuture.apiImage(
                  'https://a.portariaapp.com/img/logo_verde.png',
                ),
                builder: (context, snapshot) {
                  return SizedBox(child: snapshot.data);
                },
              ),
            ),
            elevation: 0,
            leadingWidth: size.height * 0.06,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
            child: ListView(
              children: [
                ResponsalvelInfos.qntCond == 1
                    ? ConstsWidget.buildPadding001(
                        context,
                        child: ConstsWidget.buildTextTitle(
                            context, ResponsalvelInfos.nome_condominio,
                            textAlign: TextAlign.center, size: 22),
                      )
                    : DropCond(),
                StatefulBuilder(
                  builder: (context, setState) {
                    return ReorderableListView(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      children: models.map((card) {
                        return Container(
                          key: ValueKey(card),
                          child: buildCardHome(context,
                              title: card.title,
                              pageRoute: card.pageRoute!,
                              iconApi: card.iconApi),
                        );
                      }).toList(),
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
                    );
                  },
                ),
              ],
            ),
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
  Models({
    required this.indexOrder,
    required this.title,
    required this.pageRoute,
    required this.iconApi,
  });
}
