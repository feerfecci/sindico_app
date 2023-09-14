import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sindico_app/repositories/themes_provider.dart';
import 'package:sindico_app/screens/colaboradores/lista_colaboradores.dart';
import 'package:sindico_app/screens/home_page.dart/home_page.dart';
import 'package:sindico_app/screens/quadro_avisos/quadro_de_avisos.dart';
import 'package:sindico_app/screens/tarefas/tarefas_screen.dart';
import 'package:sindico_app/screens/unidade/lista_unidade.dart';
import 'repositories/themes_model.dart';
import 'screens/splash_screen/splash_screen.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: '/splashScreen',
          routes: {
            '/splashScreen': (context) => SplashScreen(),
            '/listaColaboradores': (context) => ListaColaboradores(),
            '/listaUnidade': (context) => ListaUnidades(),
            '/quadroDeAvisos': (context) => QuadroDeAvisos(),
            '/tarefasScreen': (context) => TarefasScreen(),
            '/homePage': (context) => HomePage(),
          },
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'USA'), // English, UK
            Locale('pt', 'BR'), // Arabic, UAE
          ],
          title: 'Flutter Demo',
          themeMode: themeProvider.themeMode,
          theme: themeLight(context),
          darkTheme: themeDark(context),
          // home: SplashScreen(),
          builder: (context, child) {
            return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
                child: child!);
          },
        );
      },
    );
  }
}
