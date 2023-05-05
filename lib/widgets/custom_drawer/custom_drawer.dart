// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import '../../consts.dart';
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

    Widget buidListTile(
        {required String title,
        required IconData leading,
        IconData trailing = Icons.keyboard_arrow_right_outlined}) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
        child: ListTile(
          iconColor: Theme.of(context).iconTheme.color,
          leading: Icon(
            leading,
            size: 25,
          ),
          title: Consts.buildTextTitle(title),
          trailing: Icon(
            size: 30,
            trailing,
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
                height: size.height * 0.10,
                width: size.width * 0.85,
                child: DrawerHeader(
                  padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.02,
                    horizontal: size.width * 0.03,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        topLeft: Radius.circular(30),
                      ),
                      color: Consts.kColorApp),
                  child: Text(
                    'Menu',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              buidListTile(
                title: 'pagina 1',
                leading: Icons.accessible,
              ),
              buidListTile(
                  title: 'pagina 2', leading: Icons.wrap_text_outlined),
              buidListTile(
                  title: 'pagina 3', leading: Icons.invert_colors_on_sharp),
              buidListTile(
                  title: 'pagina 4', leading: Icons.price_check_outlined),
              ChangeThemeButton(),
              Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Consts.buildCustomButton(
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
