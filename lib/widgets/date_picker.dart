// ignore_for_file: must_be_immutable

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

import '../screens/splash_screen/splash_screen.dart';

class MyDatePicker extends StatefulWidget {
  static String dataSelected = '';
  final List? lista = null;
  final String hintText;
  DateTimePickerType type;
  DateTime? initialDate;
  MyDatePicker(
      {this.hintText = 'Clique aqui para selecionar uma data',
      lista,
      required dataSelected,
      this.type = DateTimePickerType.date,
      this.initialDate,
      super.key});

  @override
  State<MyDatePicker> createState() => _MyDatePickerState();
}

class _MyDatePickerState extends State<MyDatePicker> {
  @override
  Widget build(BuildContext context) {
    var enabled = widget.lista == null
        ? true
        : widget.lista!.isEmpty
            ? false
            : true;
    var size = MediaQuery.of(context).size;
    return DateTimePicker(
      decoration: InputDecoration(
        contentPadding:
            EdgeInsets.only(left: size.width * 0.02, top: size.height * 0.04),
        filled: true,
        fillColor: Theme.of(context).canvasColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontSize: SplashScreen.isSmall ? 16 : 18,
          fontWeight: FontWeight.bold,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.black26),
        ),
      ),
      type: widget.type,
      dateMask: widget.type == DateTimePickerType.dateTime
          ? 'dd MMMM, yyyy HH:mm'
          : 'dd MMMM, yyyy',
      //initialValue: _initialValue,
      firstDate:
          widget.type == DateTimePickerType.dateTime ? DateTime.now() : null,
      lastDate: DateTime(2100),

      //icon: Icon(Icons.event),
      style: TextStyle(
        fontSize: 20,
        color: Theme.of(context).colorScheme.primary,
      ),
      textAlign: TextAlign.center,
      cancelText: 'Cancelar',
      confirmText: 'Selecionar',
      dateLabelText: 'Date Time', initialDate: widget.initialDate,
      locale: Locale('pt', 'BR'),
      use24HourFormat: true,

      calendarTitle: 'Selecione uma data e hora',
      onChanged: (val) {
        DateTime datetime = DateTime.parse(val);
        var diferent = datetime.difference(DateTime.now());

        if (!diferent.isNegative) {
          setState(() {
            MyDatePicker.dataSelected = val;
          });
        } else {
          setState(() {
            MyDatePicker.dataSelected = DateTime.now().toIso8601String();
          });
        }
      },
      enabled: enabled,
      // validator: (val) {
      //   setState(() => _valueToValidate2 = val ?? '');
      //   return null;
      // },
      // onSaved: (val) => setState(() => _valueSaved2 = val ?? ''),
    );
  }
}
