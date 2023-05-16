import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sindico_app/forms/funcionario_form.dart';
import 'package:sindico_app/forms/unidades_form.dart';
import 'package:http/http.dart' as http;

import 'consts.dart';

class ConstWidget {
  static Widget buildTextTitle(String title,
      {textAlign, color, double size = 16}) {
    return Text(
      title,
      maxLines: 2,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        overflow: TextOverflow.ellipsis,
        fontSize: size,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  static Widget buildTextSubTitle(String title, {color}) {
    return Text(
      title,
      maxLines: 20,
      style: TextStyle(
        color: color,
        fontSize: Consts.fontSubTitulo,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  static Widget buildCustomButton(BuildContext context, String title,
      {IconData? icon,
      double? altura,
      Color? color = Consts.kButtonColor,
      Color? textColor = Colors.white,
      Color? iconColor = Colors.white,
      required void Function()? onPressed}) {
    var size = MediaQuery.of(context).size;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Consts.borderButton),
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.015),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              title,
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              width: size.width * 0.015,
            ),
            icon != null ? Icon(size: 18, icon, color: iconColor) : SizedBox(),
          ],
        ),
      ),
    );
  }

  static Widget buildAtivoInativo(bool ativo) {
    return Container(
      decoration: BoxDecoration(
          color: ativo ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ConstWidget.buildTextTitle(ativo ? 'Ativo' : 'Inativo'),
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
