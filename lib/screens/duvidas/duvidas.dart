import 'package:flutter/material.dart';
import 'package:sindico_app/widgets/scaffold_all.dart';

import '../../widgets/header.dart';

class DuvidaScreen extends StatefulWidget {
  const DuvidaScreen({super.key});

  @override
  State<DuvidaScreen> createState() => _DuvidaScreenState();
}

class _DuvidaScreenState extends State<DuvidaScreen> {
  @override
  Widget build(BuildContext context) {
    return buildHeaderPage(
      context,
      titulo: 'Duvidas',
      subTitulo: 'Tire suas dúvidas',
      widget: Container(),
    );
  }
}
