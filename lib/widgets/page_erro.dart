import 'package:flutter/material.dart';
import '../consts/const_widget.dart';

// ignore: must_be_immutable
class PageErro extends StatefulWidget {

  PageErro({ super.key});

  @override
  State<PageErro> createState() => _PageErroState();
}

class _PageErroState extends State<PageErro> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
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
