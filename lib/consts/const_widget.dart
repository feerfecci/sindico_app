import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import '../../screens/splash_screen/splash_screen.dart';
import '../widgets/shimmer_widget.dart';
import 'consts.dart';
import 'package:badges/badges.dart' as badges;
import 'consts_future.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ConstsWidget {
  static Widget buildPadding001(BuildContext context,
      {double horizontal = 0, double vertical = 0.01, required Widget? child}) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: size.height * vertical,
        horizontal: size.width * horizontal,
      ),
      child: child,
    );
  }

  static Widget buildTextTitle(
    BuildContext context,
    String title, {
    textAlign,
    Color? color,
    double fontSize = 16,
    int maxLines = 2,
    double? width,
    double? height,
  }) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: width != null ? size.width * width : null,
      height: height != null ? size.height * height : null,
      child: Text(
        title,
        maxLines: maxLines,
        textAlign: textAlign,
        style: TextStyle(
          color: color ?? Theme.of(context).colorScheme.primary,
          overflow: TextOverflow.ellipsis,
          fontSize: SplashScreen.isSmall ? (fontSize - 2) : fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static Widget buildTextSubTitle(
    BuildContext context,
    String title, {
    color,
    TextAlign? textAlign,
    double size = 14,
    double? width,
    double? height,
  }) {
    var sizeMedia = MediaQuery.of(context).size;
    return SizedBox(
      width: width != null ? sizeMedia.width * width : null,
      height: height != null ? sizeMedia.height * height : null,
      child: Text(
        title,
        maxLines: 20,
        textAlign: textAlign,
        style: TextStyle(
          height: 1.4,
          color: color,
          fontSize: SplashScreen.isSmall ? (size - 2) : size,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  static Widget buildCustomButton(BuildContext context, String title,
      {IconData? icon,
      double altura = 0.023,
      double largura = 0.0,
      Color? color = Consts.kColorAzul,
      Color? textColor = Colors.white,
      Color? iconColor = Colors.white,
      double fontSize = 18,
      required void Function()? onPressed}) {
    var size = MediaQuery.of(context).size;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: color, shape: StadiumBorder()),
      onPressed: onPressed,
      child: buildPadding001(
        context,
        vertical: altura,
        horizontal: largura,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            if (icon != null) Icon(size: 18, icon, color: iconColor),
            if (icon != null)
              SizedBox(
                width: size.width * 0.015,
              ),
            Text(
              title,
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: Colors.white,
                fontSize: SplashScreen.isSmall ? (fontSize - 5) : fontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildLoadingButton(BuildContext context,
      {required void Function()? onPressed,
      required bool isLoading,
      required String title,
      color = Consts.kColorAzul,
      double fontSize = 16}) {
    var size = MediaQuery.of(context).size;

    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.025),
            backgroundColor: color,
            shape: StadiumBorder()),
        onPressed: onPressed,
        child: isLoading == false
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ConstsWidget.buildTextTitle(context, title,
                      color: Colors.white),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: size.height * 0.025,
                    width: size.width * 0.05,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                ],
              ));
  }

  static Widget buildAtivoInativo(BuildContext context, bool ativo) {
    return Container(
      decoration: BoxDecoration(
          color: ativo ? Consts.kColorVerde : Colors.red,
          borderRadius: BorderRadius.circular(16)),
      child: buildPadding001(
        context,
        horizontal: 0.035,
        child: ConstsWidget.buildTextTitle(context, ativo ? 'Ativo' : 'Inativo',
            color: Colors.white),
      ),
    );
  }

  static Widget buildAtivoInativo2(BuildContext context,
      {int seEditando = 0,
      required void Function(dynamic)? onChanged,
      required List<dynamic> list,
      required Object? dropdownValue}) {
    var size = MediaQuery.of(context).size;
    return ConstsWidget.buildPadding001(
      context,
      child: StatefulBuilder(builder: (context, setState) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                value: dropdownValue,
                icon: Padding(
                  padding: EdgeInsets.only(right: size.height * 0.03),
                  child: Icon(
                    Icons.arrow_downward,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
                elevation: 24,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w400,
                    fontSize: SplashScreen.isSmall ? 16 : 18),
                borderRadius: BorderRadius.circular(16),
                onChanged: onChanged,
                items: list.map<DropdownMenuItem>((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: value == 0
                        ? Text(
                            'Inativo',
                          )
                        : Text('Ativo'),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      }),
    );
  }

  static Widget buildCheckBox(BuildContext context,
      {required bool isChecked,
      required void Function(bool?)? onChanged,
      required String title,
      MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center}) {
    //var size = MediaQuery.of(context).size;
    return ConstsWidget.buildPadding001(
      context,
      vertical: 0.005,
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: [
          buildTextTitle(context, title),
          Transform.scale(
            scale: 1.3,
            child: Checkbox(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              value: isChecked,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildOutlinedButton(BuildContext context,
      {required String title,
      required void Function()? onPressed,
      Color? color}) {
    var size = MediaQuery.of(context).size;
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
            vertical: size.height * 0.021, horizontal: size.width * 0.024),
        side:
            BorderSide(width: size.width * 0.005, color: color ?? Colors.blue),
        shape: StadiumBorder(),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ConstsWidget.buildTextSubTitle(
            context,
            title,
            size: SplashScreen.isSmall ? 16 : 18,
            color: color ?? Colors.blue,
          ),
        ],
      ),
    );
  }

  static Widget buildRefreshIndicator(
    BuildContext context, {
    required Widget child,
    required Future<void> Function() onRefresh,
  }) {
    var size = MediaQuery.of(context).size;
    return RefreshIndicator(
        strokeWidth: 2,
        backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
        color: Theme.of(context).canvasColor,
        displacement: size.height * 0.1,
        onRefresh: onRefresh,
        child: child);
  }

  static Widget buildCachedImage(BuildContext context,
      {required String iconApi, double? width, double? height, String? title}) {
    var size = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CachedNetworkImage(
          imageUrl: iconApi,
          height: height != null ? size.height * height : null,
          width: width != null ? size.width * width : null,
          fit: BoxFit.fill,
          fadeInDuration: Duration.zero,
          fadeOutDuration: Duration.zero,
          placeholder: (context, url) => ShimmerWidget(
              height: SplashScreen.isSmall
                  ? size.height * 0.06
                  : size.height * 0.068,
              width: size.width * 0.15),
          errorWidget: (context, url, error) => Image.asset('ico-error.png'),
        )
      ],
    );
  }

  static Widget buildDecorationDrop(BuildContext context,
      {required Widget child}) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: SplashScreen.isSmall ? size.height * 0.055 : size.height * 0.0725,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
            alignedDropdown: true,
            shape: Border.all(color: Colors.black),
            child: child),
      ),
    );
  }

  static Widget buildBadge(BuildContext context,
      {int title = 0,
      required bool showBadge,
      required Widget? child,
      BadgePosition? position}) {
    return badges.Badge(
        showBadge: showBadge,
        badgeAnimation: badges.BadgeAnimation.fade(toAnimate: false),
        badgeContent: Text(
          title > 99
              ? '+99'
              : title == 0
                  ? ''
                  : title.toString(),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        position: position,
        badgeStyle: badges.BadgeStyle(
          badgeColor: Consts.kColorRed,
        ),
        child: child);
  }
}


// Widget buildDropDivisoes({required void Function(Object?)? onChanged}) {
//   return StatefulBuilder(
//     builder: (context, setState) {
//       Object? dropdownValueDivisioes;
//       List categoryItemListDivisoes = [];
//       Future apiListarDivisoes() async {
//         var uri =
//             'https://a.portariaapp.com/sindico/api/divisoes/?fn=listarDivisoes&idcond=13';
//         final response = await http.get(Uri.parse(uri));
//         if (response.statusCode == 200) {
//           final jsonresponse = json.decode(response.body);
//           var divisoes = jsonresponse['divisoes'];
//           setState(() {
//             categoryItemListDivisoes = divisoes;
//           });
//         } else {
//           throw response.statusCode;
//         }
//       }
//       return FutureBuilder<dynamic>(
//           future: apiListarDivisoes(),
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               return Container(color: Colors.red);
//             }
//             return Container(
//               width: double.infinity,
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                 color: Theme.of(context).canvasColor,
//                 border: Border.all(color: Colors.black26),
//                 borderRadius: BorderRadius.all(Radius.circular(16)),
//               ),
//               child: DropdownButtonHideUnderline(
//                 child: ButtonTheme(
//                   alignedDropdown: true,
//                   shape: Border.all(color: Colors.black),
//                   child: DropdownButton(
//                     elevation: 24,
//                     isExpanded: true,
//                     hint: Text('Selecione uma Divisão'),
//                     icon: Icon(Icons.arrow_drop_down_sharp),
//                     borderRadius: BorderRadius.circular(16),
//                     style: TextStyle(
//                         // fontWeight: FontWeight.bold,
//                         fontSize: Consts.fontTitulo,
//                         color: Colors.black),
//                     items: categoryItemListDivisoes.map((e) {
//                       return DropdownMenuItem(
//                         value: e['iddivisao'],
//                         child: Text(
//                           e['nome_divisao'],
//                         ),
//                       );
//                     }).toList(),
//                     onChanged: onChanged,
//                     value: dropdownValueDivisioes,
//                   ),
//                 ),
//               ),
//             );
//           });
//     },
//   );
// }

// class DropDivisoes extends StatefulWidget {
//   void Function(Object?)? onChanged;
//   DropDivisoes({required void Function(Object?)? onChanged, super.key});
//   @override
//   State<DropDivisoes> createState() => DropDivisoesState();
// }
// class DropDivisoesState extends State<DropDivisoes> {
//   @override
//   void initState() {
//     super.initState();
//     apiListarDivisoes();
//   }
//   Object? dropdownValueDivisioes;
//   List categoryItemListDivisoes = [];
//   Future apiListarDivisoes() async {
//     var uri =
//         'https://a.portariaapp.com/sindico/api/divisoes/?fn=listarDivisoes&idcond=13';
//     final response = await http.get(Uri.parse(uri));
//     if (response.statusCode == 200) {
//       final jsonresponse = json.decode(response.body);
//       var divisoes = jsonresponse['divisoes'];
//       setState(() {
//         categoryItemListDivisoes = divisoes;
//       });
//     } else {
//       throw response.statusCode;
//     }
//   }
//   FormInfosUnidade formInfosUnidade = FormInfosUnidade();
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       alignment: Alignment.center,
//       decoration: BoxDecoration(
//         color: Theme.of(context).canvasColor,
//         border: Border.all(color: Colors.black26),
//         borderRadius: BorderRadius.all(Radius.circular(16)),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: ButtonTheme(
//           alignedDropdown: true,
//           shape: Border.all(color: Colors.black),
//           child: DropdownButton(
//             elevation: 24,
//             isExpanded: true,
//             hint: Text('Selecione uma Divisão'),
//             icon: Icon(Icons.arrow_drop_down_sharp),
//             borderRadius: BorderRadius.circular(16),
//             style: TextStyle(
//                 // fontWeight: FontWeight.bold,
//                 fontSize: Consts.fontTitulo,
//                 color: Colors.black),
//             items: categoryItemListDivisoes.map((e) {
//               return DropdownMenuItem(
//                 value: e['iddivisao'],
//                 child: Text(
//                   e['nome_divisao'],
//                 ),
//               );
//             }).toList(),
//             onChanged: widget.onChanged,
//             value: dropdownValueDivisioes,
//           ),
//         ),
//       ),
//     );  
//   }
// }
