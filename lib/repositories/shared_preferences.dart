import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalInfos {
  static Future setOrderDragg(indexOrder) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setStringList('indexOrder', indexOrder);
  }

  static Future getOrderDragg() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var getOrder = preferences.getStringList('indexOrder');
    return getOrder;
  }

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

  static Future setLoginDate() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(
        'dateLogin', DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()));
  }

  static Future getLoginDate() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? dateLogin = preferences.getString('dateLogin');
    return dateLogin;
  }
}
