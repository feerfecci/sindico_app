import 'package:flutter/material.dart';
import 'package:sindico_app/forms/funcionario_form.dart';

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

  static Widget buildDropdownButton(
    BuildContext context,
    List<String> list, {
    bool editando = false,
  }) {
    return StatefulBuilder(builder: (context, setState) {
      var dropdownValue = list.first;

      var size = MediaQuery.of(context).size;
      return ButtonTheme(
        alignedDropdown: true,
        child: DropdownButtonFormField<String>(
          value: dropdownValue,

          icon: Padding(
            padding: EdgeInsets.only(
              right: size.height * 0.015,
            ),
            child: Icon(
              Icons.arrow_downward,
              color: Theme.of(context).iconTheme.color,
            ),
          ),

          elevation: 90,
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w400,
              fontSize: 18),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(right: size.width * 0.0),
            filled: true,
            fillColor: Theme.of(context).canvasColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          // underline: Container(
          //   height: 1,
          //   color: Consts.kColorApp,
          // ),
          borderRadius: BorderRadius.circular(16),

          onChanged: (String? value) {
            setState(() {
              // funcao = value!;
              // if (funcao == 'Porteiro') {
              //   formInfos = formInfos.copyWith(funcao: 1);
              // } else if (funcao == 'Síndico') {
              //   formInfos = formInfos.copyWith(funcao: 2);
              // } else if (funcao == 'Zelador') {
              //   formInfos = formInfos.copyWith(funcao: 3);
              // } else if (funcao == 'Administrador(a)') {
              //   formInfos = formInfos.copyWith(funcao: 4);
              // } else {
              //   formInfos = formInfos.copyWith(funcao: 0);
              // }
            });
          },

          items: list.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      );
    });
  }
}
