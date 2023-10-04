import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sindico_app/consts/const_widget.dart';
import '../../repositories/themes_provider.dart';
import '../../screens/splash_screen/splash_screen.dart';

class ChangeThemeButton extends StatefulWidget {
  const ChangeThemeButton({super.key});

  @override
  State<ChangeThemeButton> createState() => _ChangeThemeButtonState();
}

class _ChangeThemeButtonState extends State<ChangeThemeButton> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    String title =
        themeProvider.isDarkMode ? 'Ativar Modo Claro' : 'Ativar Modo Escuro';
    bool isOn = themeProvider.isDarkMode;
    return ListTile(
      title: ConstsWidget.buildTextTitle(context, title, fontSize: 16),
      iconColor: Theme.of(context).iconTheme.color,
      leading: isOn == true
          ? Icon(
              Icons.light_mode,
              size: SplashScreen.isSmall ? 20 : 25,
            )
          : Icon(Icons.dark_mode_outlined,
              size: SplashScreen.isSmall ? 20 : 25),
      trailing: Switch.adaptive(
        value: themeProvider.isDarkMode,
        onChanged: (value) {
          final provider = Provider.of<ThemeProvider>(context, listen: false);

          provider.toggleTheme(value);
          setState(() {
            isOn = !value;
          });
        },
      ),
    );
  }
}
