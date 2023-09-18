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
    //
    //var size = MediaQuery.of(context).size;
    return ConstsWidget.buildPadding001(
      context,
      vertical: 0.02,
      child: Column(
        children: [
          Center(
            child: ConstsWidget.buildCachedImage(context,
                iconApi:
                    'https://a.portariaapp.com/img/ico-nao-encontrado.png'),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ConstsWidget.buildTextTitle(context, widget.title,
                textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}
