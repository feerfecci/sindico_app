import 'package:flutter/material.dart';
import 'package:sindico_app/widgets/scaffold_all.dart';

import '../../widgets/header.dart';

class CarrinhoScreen extends StatelessWidget {
  const CarrinhoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return buildHeaderPage(
      context,
      titulo: 'Carrinho',
      subTitulo: 'Faça suas compras',
      widget: Container(),
    );
  }
}
