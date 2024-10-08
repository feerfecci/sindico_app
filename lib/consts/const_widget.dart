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
      {required String subTitle, Color? color}) {
    return TextSpan(
        text: subTitle,
        style: TextStyle(
            color: color ?? Theme.of(context).textTheme.bodyLarge!.color,
            height: 1.5,
            overflow: TextOverflow.ellipsis,
            fontSize: SplashScreen.isSmall ? 14 : 16));
  }

  static Widget buildExpandedTile(BuildContext context,
      {required Widget title,
      bool titleCenter = true,
      Widget? subtitle,
      required List<Widget> children,
      void Function(bool)? onExpansionChanged,
      CrossAxisAlignment? expandedCrossAxisAlignment,
      Alignment? expandedAlignment}) {
    var size = MediaQuery.of(context).size;
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        // trailing: Icon(Icons.arrow_downward),
        onExpansionChanged: onExpansionChanged,
        iconColor: Theme.of(context).textTheme.bodyLarge!.color,
        subtitle: subtitle == null
            ? null
            : titleCenter
                ? Center(child: subtitle)
                : subtitle,
        expandedCrossAxisAlignment: expandedCrossAxisAlignment,
        childrenPadding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
        expandedAlignment: expandedAlignment,
        tilePadding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
        title: titleCenter ? Center(child: title) : title,
        children: children,
      ),
    );
  }

  static Widget buildCustomButton(BuildContext context, String title,
      {double? altura,
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
        vertical: 0.025,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: size.width * rowSpacing,
            ),
            ConstsWidget.buildTextTitle(
              context,
              title,
              color: textColor,
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
            // padding: EdgeInsets.symmetric(
            //     vertical: SplashScreen.isSmall
            //         ? size.height * 0.035
            //         : size.height * 0.025),
            backgroundColor: color,
            shape: StadiumBorder()),
        onPressed: onPressed,
        child: buildPadding001(context,
            vertical: 0.025,
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
                  )));
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
        // padding: EdgeInsets.symmetric(
        //     vertical: SplashScreen.isSmall
        //         ? size.height * 0.035
        //         : size.height * 0.022,
        //     horizontal: size.width * 0.024),
        side: BorderSide(
            width:
                SplashScreen.isSmall ? size.width * 0.004 : size.width * 0.005,
            color: color ?? Consts.kButtonColor),
        shape: StadiumBorder(),
      ),
      onPressed: onPressed,
      child: ConstsWidget.buildPadding001(
        context,
        vertical: 0.025,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: size.width * rowSpacing,
            ),
            ConstsWidget.buildTextTitle(context, title,
                color: color ?? Consts.kButtonColor),
            // ConstsWidget.buildTextSubTitle(
            //   context,
            //   title,
            //   size: SplashScreen.isSmall ? 16 : 18,
            //   color: color ?? Consts.kButtonColor,
            // ),
            SizedBox(
              width: size.width * rowSpacing,
            ),
          ],
        ),
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
      vertical: 0.01,
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
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        SizedBox(
            width: width,
            child: buildTextTitle(
              context,
              title,
            )),
        Transform.scale(
          scale: 1,
          child: Checkbox(
            // shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(15)
            //     ),
            value: isChecked,
            onChanged: onChanged,
          ),
        ),
      ],
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
      {required String iconApi,
      double? width,
      double? height,
      String? title,
      bool meuWidth = false}) {
    var size = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CachedNetworkImage(
          imageUrl: iconApi,
          height: !meuWidth
              ? height != null
                  ? size.height * height
                  : null
              : height,
          width: !meuWidth
              ? width != null
                  ? size.width * width
                  : null
              : width,
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
            colorScheme: ColorScheme.light(),
            hoverColor: Colors.red,
            shape: Border.all(color: Colors.red),
            child: child),
      ),
    );
  }

  static Widget buildBadge(BuildContext context,
      {int title = 0,
      required bool showBadge,
      required Widget? child,
      BadgePosition? position}) {
    BadgeShape shape = title >= 10 ? BadgeShape.square : BadgeShape.circle;
    String titleString = title > 99
        ? '+99'
        : title == 0
            ? ''
            : title.toString();
    double? fontSize = title >= 10
        ? SplashScreen.isSmall
            ? 12
            : 14
        : SplashScreen.isSmall
            ? 14
            : 16;
    return badges.Badge(
        showBadge: showBadge,
        badgeAnimation: badges.BadgeAnimation.fade(toAnimate: false),
        badgeContent: Text(
          titleString,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: fontSize),
        ),
        position: position,
        badgeStyle: badges.BadgeStyle(
          badgeColor: Consts.kColorRed,
          borderRadius: BorderRadius.circular(16),
          shape: shape,
        ),
        child: child);
  }

  static Widget buildCamposObrigatorios(BuildContext context) {
    return ConstsWidget.buildPadding001(
      context,
      child: ConstsWidget.buildTextTitle(context, '(*) Campos Obrigatórios',
          color: Consts.kColorRed),
    );
  }

  static Widget buildAniversarioField(
      BuildContext context, String? widgetNascimento,
      {required double? width}) {
    var size = MediaQuery.of(context).size;
    widgetNascimento != '0000-00-00' &&
            widgetNascimento != '' &&
            widgetNascimento != null
        ? MyDatePicker.dataSelected = widgetNascimento
        : '';
    bool hasDate = widgetNascimento != '0000-00-00' &&
            widgetNascimento != '' &&
            widgetNascimento != null
        ? true
        : false;
    return SizedBox(
      width: size.width * width!,
      child: MyDatePicker(
          dataSelected: hasDate
              ? DateFormat('dd/MM/yyyy')
                  .format(DateTime.parse(MyDatePicker.dataSelected))
              : DateTime.now(),
          type: DateTimePickerType.date,
          hintText: hasDate
              ? DateFormat('dd/MM/yyyy')
                  .format(DateTime.parse(MyDatePicker.dataSelected))
                  .toString()
              : MyDatePicker.dataSelected,
          aniversario: true),
    );
  }

  static Widget buildTextExplicaSenha(BuildContext context,
      {bool isDrawer = false, textAlign = TextAlign.center}) {
    return RichText(
      textAlign: textAlign,
      text: TextSpan(
          style: TextStyle(color: Colors.red, fontSize: 60),
          children: [
            ConstsWidget.builRichTextSubTitle(
              context,
              //  color: Colors.red,
              subTitle: 'Para unificar todas suas unidades no login atual ',
            ),
            ConstsWidget.builRichTextTitle(context,
                color: Colors.red, textBold: ResponsalvelInfos.login),
            ConstsWidget.builRichTextSubTitle(context,
                //  color: Colors.red,
                subTitle: ', atualize sua senha de acesso,'),
            if (!isDrawer)
              ConstsWidget.builRichTextSubTitle(context,
                  //  color: Colors.red,
                  subTitle: ' selecione a opção '),
            if (!isDrawer)
              ConstsWidget.builRichTextTitle(context,
                  color: Colors.red, textBold: 'Adicionar Meus Condomínios'),
            ConstsWidget.builRichTextSubTitle(context,
                //  color: Colors.red,
                subTitle: ' e clique no botão '),
            if (!isDrawer)
              ConstsWidget.builRichTextTitle(context,
                  color: Colors.red, textBold: 'Salvar'),
            if (!isDrawer)
              ConstsWidget.builRichTextSubTitle(context,
                  //  color: Colors.red,
                  subTitle:
                      '. Se deseja alterar a senha e manter separados os acessos a cada unidade no Portaria App, preencha os campos abaixo e clique em '),
            ConstsWidget.builRichTextTitle(context,
                color: Colors.red, textBold: 'Salvar'),
          ]),
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
