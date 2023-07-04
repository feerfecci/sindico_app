import 'package:flutter/material.dart';
import 'consts.dart';

class ConstsWidget {
  static Widget buildTextTitle(BuildContext context, String title,
      {textAlign, Color? color, double size = 16}) {
    return Text(
      title,
      maxLines: 2,
      textAlign: textAlign,
      style: TextStyle(
        color: color ?? Theme.of(context).colorScheme.primary,
        overflow: TextOverflow.ellipsis,
        fontSize: size,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  static Widget buildTextSubTitle(
    String title, {
    color,
    TextAlign? textAlign,
    double? size = Consts.fontSubTitulo,
  }) {
    return Text(
      title,
      maxLines: 20,
      textAlign: textAlign,
      style: TextStyle(
        height: 1.4,
        color: color,
        fontSize: size,
        fontWeight: FontWeight.normal,
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
      double fontSize = Consts.fontTitulo,
      required void Function()? onPressed}) {
    var size = MediaQuery.of(context).size;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: color, shape: StadiumBorder()),
      onPressed: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: size.height * altura, horizontal: size.width * largura),
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
                fontSize: fontSize,
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
      double fontSize = 14}) {
    var size = MediaQuery.of(context).size;

    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.023),
            backgroundColor: color,
            shape: StadiumBorder()),
        onPressed: onPressed,
        child: isLoading == false
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: size.height * 0.020,
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
    var size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          color: ativo ? Consts.kColorVerde : Colors.red,
          borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: size.height * 0.01, horizontal: size.width * 0.035),
        child: ConstsWidget.buildTextTitle(context, ativo ? 'Ativo' : 'Inativo',
            color: Colors.white),
      ),
    );
  }

  static Widget buildCheckBox(BuildContext context,
      {required bool isChecked,
      required void Function(bool?)? onChanged,
      required String title,
      MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center}) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.005),
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
      {required String title, required void Function()? onPressed}) {
    var size = MediaQuery.of(context).size;
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: size.height * 0.021),
        side: BorderSide(width: size.width * 0.005, color: Colors.blue),
        shape: StadiumBorder(),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ConstsWidget.buildTextSubTitle(
            title,
            size: 18,
            color: Colors.blue,
          ),
        ],
      ),
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
