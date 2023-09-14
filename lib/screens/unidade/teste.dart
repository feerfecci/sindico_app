// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import '../../consts/const_widget.dart';

class TesteUnidade extends StatefulWidget {
  const TesteUnidade({super.key});

  @override
  State<TesteUnidade> createState() => _TesteUnidadeState();
}

List<String> rowdetail = [];

// Future excelData() async {
//   ByteData data = await rootBundle.load("assets/teste_condominio.csv");
//   var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
//   var excel = Excel.decodeBytes(bytes);
//   // var file = "assets/teste_condominio.xlsx";
//   // var bytes = File(file).readAsBytesSync();
//   // var excel = Excel.decodeBytes(bytes);
//   int i = 0;
//   int j = 0;

//   for (var table in excel.tables.keys) {
//     int maxCols = excel.tables[table]!.maxCols;
//     int maxRows = excel.tables[table]!.maxRows;
//     for (var row in excel.tables[table]!.rows.last) {
//       for (i; i <= (maxCols - 1); i++) {
//         print(row!.value);
//       }
//     }
//   }

// print(rowdetail.asMap());
// for (var table in excel.tables.keys) {
//   print(table); //sheet Name
//   print(excel.tables[table]!.maxCols);
//   print(excel.tables[table]!.maxRows);
//   for (var row in excel.tables[table]!.rows) {
//     rowdetail.add(row.);
//     print();
//   }
// }
// }

class _TesteUnidadeState extends State<TesteUnidade> {
  // @override
  // void initState() {
  //   excelData();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DropDown List"),
      ),
      body: Center(
        child: ConstsWidget.buildCustomButton(context, 'Exel', onPressed: () {
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TesteUnidade(),
              ));
        }),
      ),
    );
  }
}
