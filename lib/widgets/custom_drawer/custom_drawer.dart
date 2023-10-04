// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:sindico_app/consts/consts_future.dart';
import 'package:sindico_app/screens/termodeuso/termo_de_uso.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../consts/consts.dart';
import '../../consts/const_widget.dart';
import '../../repositories/shared_preferences.dart';
import '../../screens/login/login_screen.dart';
import '../../screens/meu_perfil/meu_perfil_screen.dart';
import '../../screens/politica/politica_screen.dart';
import '../alert_dialogs/alert_trocar_senha.dart';
import 'change_theme_button.dart';
import '../../screens/splash_screen/splash_screen.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Widget buidListTile({
      required String title,
      required IconData leading,
      void Function()? onTap,
    }) {
      return ConstsWidget.buildPadding001(
        context,
        vertical: SplashScreen.isSmall ? 0 : 0.008,
        child: GestureDetector(
          onTap: onTap,
          child: ListTile(
            iconColor: Theme.of(context).iconTheme.color,
            leading: Icon(
              leading,
              size: SplashScreen.isSmall ? 25 : 30,
            ),
            title: ConstsWidget.buildTextTitle(context, title, fontSize: 16),
            trailing: Icon(
              size: SplashScreen.isSmall ? 25 : 30,
              Icons.keyboard_arrow_right_outlined,
            ),
          ),
        ),
      );
    }

    return SafeArea(
      child: SizedBox(
        height: size.height * 0.95,
        // width: SplashScreen.isSmall ? size.width * 0.9 : size.width * 0.85,
        child: Drawer(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(SplashScreen.isSmall ? 30 : 30),
            ),
          ),
          child: ListView(
            // physics: ClampingScrollPhysics(),
            // shrinkWrap: true,
            children: [
              SizedBox(
                height: SplashScreen.isSmall
                    ? size.width * 0.12
                    : size.height * 0.08,
                width: double.maxFinite,
                child: DrawerHeader(
                  padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.02,
                    horizontal: size.width * 0.03,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                      ),
                      color: Consts.kColorAzul),
                  child: Text(
                    'Menu',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              buidListTile(
                title: 'Meu perfil',
                leading: Icons.person_outline_rounded,
                onTap: () {
                  ConstsFuture.navigatorPagePush(context, MeuPerfilScreen());
                },
              ),
              buidListTile(
                title: 'Unificar Condomínios',
                leading: Icons.lock_person_outlined,
                onTap: () {
                  alertTrocarSenha(
                    context,
                  );
                },
              ),
              buidListTile(
                  title: 'Seja um representante',
                  onTap: () => launchUrl(
                      Uri.parse(
                          'https://www.portariaapp.com/seja-um-representante'),
                      mode: LaunchMode.externalNonBrowserApplication),
                  leading: Icons.business_center_outlined),
              buidListTile(
                  title: 'Política de privacidade',
                  onTap: () =>
                      ConstsFuture.navigatorPagePush(context, PoliticaScreen()),
                  leading: Icons.privacy_tip_outlined),
              buidListTile(
                  title: 'Termos de uso',
                  onTap: () => ConstsFuture.navigatorPagePush(
                      context, TermoDeUsoScreen()),
                  leading: Icons.assignment_outlined),
              buidListTile(
                  title: 'Indicar para amigos',
                  onTap: () => launchUrl(
                      Uri.parse(
                          'https://www.portariaapp.com/indicar-para-amigos'),
                      mode: LaunchMode.externalNonBrowserApplication),
                  leading: Icons.add_reaction_outlined),
              buidListTile(
                title: 'Central de ajuda',
                leading: Icons.support,
                onTap: () => launchUrl(
                    Uri.parse('https://www.portariaapp.com/central-de-ajuda'),
                    mode: LaunchMode.externalNonBrowserApplication),
              ),
              buidListTile(
                title: 'Efetuar logoff',
                leading: Icons.logout_outlined,
                onTap: () {
                  LocalInfos.removeCache();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                      (route) => false);
                },
              ),
              ConstsWidget.buildPadding001(context, child: ChangeThemeButton()),
              SizedBox(
                height: SplashScreen.isSmall
                    ? size.height * 0.01
                    : size.height * 0.00,
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: SplashScreen.isSmall
                        ? size.height * 0.01
                        : size.height * 0.00,
                    right: size.width * 0.02,
                    left: size.width * 0.02),
                child: ConstsWidget.buildOutlinedButton(
                  context,
                  title: 'Fechar Menu',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
