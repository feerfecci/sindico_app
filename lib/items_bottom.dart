import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sindico_app/screens/divisoes/divisoes_screen.dart';
import 'package:sindico_app/screens/funcoes/funcoes.dart';
import 'screens/home_page.dart/home_page.dart';
import 'widgets/custom_drawer/custom_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: must_be_immutable
class ItensBottom extends StatefulWidget {
  int currentTab;
  BuildContext? context;
  ItensBottom({this.context, required this.currentTab, super.key});

  @override
  State<ItensBottom> createState() => _ItensBottomState();
}

class _ItensBottomState extends State<ItensBottom> {
  DateTime timeBackPressed = DateTime.now();
  late PageController _pageController;
  @override
  void initState() {
    super.initState();
    initPlatformState();
    // NotificationWidget.init();
    _pageController = PageController();
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
      child: Scaffold(
        endDrawer: CustomDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Image.network(
              'https://www.portariaapp.com/wp-content/uploads/2023/03/portria.png',
            ),
          ),
          elevation: 0,
          leadingWidth: 40,
        ),
        bottomNavigationBar: BottomNavigationBar(
          iconSize: size.height * 0.035,
          currentIndex: widget.currentTab,
          onTap: (p) {
            _pageController.jumpToPage(p);
          },
          items: [
            BottomNavigationBarItem(
              label: 'Início',
              icon: Icon(
                widget.currentTab == 0 ? Icons.home_sharp : Icons.home_outlined,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                widget.currentTab == 1
                    ? Icons.shopping_cart_rounded
                    : Icons.shopping_cart_outlined,
              ),
              label: 'Divisões',
            ),
            BottomNavigationBarItem(
              label: 'Funções',
              icon: Icon(
                widget.currentTab == 2
                    ? Icons.question_mark_sharp
                    : Icons.question_mark_outlined,
              ),
            ),
          ],
        ),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: (p) {
            setState(() {
              widget.currentTab = p;
            });
          },
          children: const [HomePage(), DivisoesScreen(), FuncoesScreen()],
        ),
      ),
    );
  }
}
