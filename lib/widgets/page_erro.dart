import 'package:flutter/material.dart';
import '../consts/const_widget.dart';

// ignore: must_be_immutable
class PageErro extends StatefulWidget {
  const PageErro({super.key});

  @override
  State<PageErro> createState() => _PageErroState();
}

class _PageErroState extends State<PageErro> {
  @override
  Widget build(BuildContext context) {
    //var size = MediaQuery.of(context).size;
    return ConstsWidget.buildPadding001(
      context,
      vertical: 0.02,
      child: Column(
        children: [
          Center(
            child: Image.asset('assets/erro.png'),
          ),
        ],
      ),
    );
  }
}
