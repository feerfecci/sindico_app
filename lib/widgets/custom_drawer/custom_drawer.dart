// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import '../../consts/consts.dart';
import '../../consts/const_widget.dart';
import '../../repositories/shared_preferences.dart';
import '../../screens/login/login_screen.dart';
import 'change_theme_button.dart';

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
    }) {
      return ConstsWidget.buildPadding001(
        context,
        child: ListTile(
          iconColor: Theme.of(context).iconTheme.color,
          leading: Icon(
            leading,
            size: 25,
          ),
          title: ConstsWidget.buildTextTitle(context, title),
          trailing: Icon(
            size: 30,
            Icons.keyboard_arrow_right_outlined,
          ),
        ),
      );
    }

    return SafeArea(
      child: SizedBox(
        height: size.height * 0.95,
        child: Drawer(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.08,
                width: size.width * 0.85,
                child: DrawerHeader(
                  padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.015,
                    horizontal: size.width * 0.03,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                      ),
                      color: Consts.kColorApp),
                  child: Text(
                    'Menu',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              buidListTile(
                  title: 'Meu perfil', leading: Icons.person_outline_rounded),
              buidListTile(
                  title: 'Seja um representante',
                  leading: Icons.business_center_outlined),
              buidListTile(
                  title: 'Política de privacidade',
                  leading: Icons.privacy_tip_outlined),
              buidListTile(
                  title: 'Indicar para amigos',
                  leading: Icons.add_reaction_outlined),
              buidListTile(title: 'Central de ajuda', leading: Icons.support),
              ChangeThemeButton(),
              Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: ConstsWidget.buildCustomButton(
                  context,
                  'Sair',
                  onPressed: () {
                    LocalInfos.removeCache();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                        (route) => false);
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
