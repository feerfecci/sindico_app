import 'package:badges/badges.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../screens/splash_screen/splash_screen.dart';
import '../widgets/date_picker.dart';
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
    double fontSize = 18,
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
          color: color ?? Theme.of(context).textTheme.bodyLarge!.color,
          overflow: TextOverflow.ellipsis,
          fontSize: SplashScreen.isSmall ? (fontSize - 4) : fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static Widget buildTextSubTitle(
    BuildContext context,
    String title, {
    Color? color,
    TextAlign? textAlign,
    double size = 16,
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
          color: color ?? Theme.of(context).textTheme.bodyLarge!.color,
          fontSize: SplashScreen.isSmall ? (size - 2) : size,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  static TextSpan builRichTextTitle(BuildContext context,
      {required String textBold, Color? color}) {
    return TextSpan(
        text: textBold,
        style: TextStyle(
          color: color ?? Theme.of(context).textTheme.bodyLarge!.color,

          // Theme.of(context)
          //     .colorScheme
          //     .primary,
          overflow: TextOverflow.ellipsis,
          fontSize: SplashScreen.isSmall ? 16 : 18,
          fontWeight: FontWeight.bold,
        ));
  }

  static TextSpan builRichTextSubTitle(BuildContext context,
      {required String subTitle}) {
    return TextSpan(
        text: subTitle,
        style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge!.color,
            height: 1.5,
            overflow: TextOverflow.ellipsis,
            fontSize: SplashScreen.isSmall ? 14 : 16));
  }

  static Widget buildCustomButton(BuildContext context, String title,
      {double? altura,
      double largura = 0.0,
      Color? color = Consts.kColorAzul,
      Color? textColor = Colors.white,
      Color? iconColor = Colors.white,
      double rowSpacing = 0.00,
      double fontSize = 18,
      required void Function()? onPressed}) {
    var size = MediaQuery.of(context).size;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          // side: BorderSide(
          //   width: size.width * 0.005,
          //   color: Consts.kButtonColor,
          // ),
          backgroundColor: color,
          shape: StadiumBorder()),
      onPressed: onPressed,
      child: buildPadding001(
        context,
        vertical: altura == null
            ? SplashScreen.isSmall
                ? 0.035
                : 0.025
            : 0.025,
        horizontal: largura,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: size.width * rowSpacing,
            ),
            Text(
              title,
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: textColor,
                fontSize: SplashScreen.isSmall ? 14 : 18,
                // fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              width: size.width * rowSpacing,
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
      double fontSize = 18}) {
    var size = MediaQuery.of(context).size;

    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(
                vertical: SplashScreen.isSmall
                    ? size.height * 0.035
                    : size.height * 0.025),
            backgroundColor: color,
            shape: StadiumBorder()),
        onPressed: onPressed,
        child: isLoading == false
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ConstsWidget.buildTextTitle(context, title,
                      fontSize: fontSize, color: Colors.white),
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

  static Widget buildOutlinedButton(BuildContext context,
      {required String title,
      required void Function()? onPressed,
      double rowSpacing = 0.00,
      Color? color}) {
    var size = MediaQuery.of(context).size;
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
            vertical: SplashScreen.isSmall
                ? size.height * 0.035
                : size.height * 0.022,
            horizontal: size.width * 0.024),
        side: BorderSide(
            width: size.width * 0.005, color: color ?? Consts.kButtonColor),
        shape: StadiumBorder(),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size.width * rowSpacing,
          ),
          ConstsWidget.buildTextSubTitle(
            context,
            title,
            size: SplashScreen.isSmall ? 16 : 18,
            color: color ?? Consts.kButtonColor,
          ),
          SizedBox(
            width: size.width * rowSpacing,
          ),
        ],
      ),
    );
  }

  static Widget buildAtivoInativo(BuildContext context, bool ativo) {
    return Container(
      decoration: BoxDecoration(
          color: ativo ? Consts.kColorVerde : Colors.red,
          borderRadius: BorderRadius.circular(Consts.borderButton)),
      child: buildPadding001(
        context,
        horizontal: 0.035,
        child: ConstsWidget.buildTextTitle(context, ativo ? 'Ativo' : 'Inativo',
            textAlign: TextAlign.center, color: Colors.white),
      ),
    );
  }

  static Widget buildDropAtivoInativo(BuildContext context,
      {int seEditando = 0,
      required void Function(dynamic)? onChanged,
      required Object? dropdownValue}) {
    var size = MediaQuery.of(context).size;

    List listAtivo = [1, 0];
    return ConstsWidget.buildPadding001(
      context,
      vertical: 0.02,
      child: StatefulBuilder(builder: (context, setState) {
        return Container(
          width: double.infinity,
          height:
              SplashScreen.isSmall ? size.height * 0.09 : size.height * 0.07,
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            border: Border.all(color: Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                isExpanded: true,
                value: dropdownValue,
                iconSize: SplashScreen.isSmall ? 20 : 30,
                icon: Padding(
                  padding: EdgeInsets.only(right: size.height * 0.03),
                  child: Icon(
                    Icons.arrow_downward,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
                elevation: 24,
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    fontWeight: FontWeight.w400,
                    fontSize: SplashScreen.isSmall ? 16 : 18),
                borderRadius: BorderRadius.circular(15),
                onChanged: onChanged,
                items: listAtivo.map<DropdownMenuItem>((value) {
                  return DropdownMenuItem(
                    value: value,
                    alignment: Alignment.center,
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
      double? width,
      MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center}) {
    //var size = MediaQuery.of(context).size;
    return ConstsWidget.buildPadding001(
      context,
      vertical: 0.005,
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: [
          SizedBox(
              width: width,
              child: buildTextTitle(
                context,
                title,
              )),
          Transform.scale(
            scale: 1.2,
            child: Checkbox(
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(15)
              //     ),
              value: isChecked,
              onChanged: onChanged,
            ),
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
      height: SplashScreen.isSmall ? size.height * 0.09 : size.height * 0.0725,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        border: Border.all(color: Theme.of(context).colorScheme.primary),
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
              fontSize: title >= 10
                  ? SplashScreen.isSmall
                      ? 12
                      : 14
                  : SplashScreen.isSmall
                      ? 14
                      : 16),
        ),
        position: position,
        badgeStyle: badges.BadgeStyle(
          badgeColor: Consts.kColorRed,
        ),
        child: child);
  }

  static Widget buildCamposObrigatorios(BuildContext context) {
    return ConstsWidget.buildPadding001(
      context,
      child: ConstsWidget.buildTextSubTitle(context, '(*) Campo Obrigatório',
          color: Consts.kColorRed),
    );
  }

  static Widget buildAniversarioField(
      BuildContext context, String? widgetNascimento,
      {required double? width}) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * width!,
      child: MyDatePicker(
          dataSelected: widgetNascimento != '0000-00-00' &&
                  widgetNascimento != '' &&
                  widgetNascimento != null
              ? DateFormat('dd/MM/yyyy')
                  .format(DateTime.parse(MyDatePicker.dataSelected))
              : DateTime.now(),
          type: DateTimePickerType.date,
          hintText: MyDatePicker.dataSelected != '0000-00-00' &&
                  MyDatePicker.dataSelected != ''
              ? DateFormat('dd/MM/yyyy')
                  .format(DateTime.parse(MyDatePicker.dataSelected))
                  .toString()
              : MyDatePicker.dataSelected,
          aniversario: true),
    );
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
//                 borderRadius: BorderRadius.all(Radius.circular(Consts.borderButton)),
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
//                     borderRadius: BorderRadius.circular(Consts.borderButton),
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
//         borderRadius: BorderRadius.all(Radius.circular(Consts.borderButton)),
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
//             borderRadius: BorderRadius.circular(Consts.borderButton),
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
