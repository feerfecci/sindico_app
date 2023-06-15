import 'package:flutter/material.dart';
import '../consts/const_widget.dart';

// ignore: must_be_immutable
class PageVazia extends StatefulWidget {
  String title;

  PageVazia({required this.title, super.key});

  @override
  State<PageVazia> createState() => _PageVaziaState();
}

class _PageVaziaState extends State<PageVazia> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          Center(
            child: Image.network('https://a.portariaapp.com/img/img.png'),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ConstsWidget.buildTextTitle(widget.title),
          ),
        ],
      ),
    );
  }
}
