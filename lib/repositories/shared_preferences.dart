import 'package:shared_preferences/shared_preferences.dart';

class LocalInfos {
  static Future createCache(String usuarioCache, String senhaCache) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('usuario', usuarioCache);
    preferences.setString('senha', senhaCache);
  }

  static Future readCache() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userRead = preferences.getString('usuario');
    var senhaRead = preferences.getString('senha');
    Map<String, dynamic> infosCache = {'usuario': userRead, 'senha': senhaRead};
    return infosCache;
  }

  static Future removeCache() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('usuario');
    preferences.remove('senha');
  }
}
