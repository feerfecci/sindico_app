import 'package:flutter/material.dart';

import '../consts/const_widget.dart';

class MyBoxShadow extends StatefulWidget {
  final dynamic child;
  final double paddingAll;
  const MyBoxShadow({
    required this.child,
    // required this.paddingAll,
    super.key,
    this.paddingAll = 0.02,
  });

  @override
  State<MyBoxShadow> createState() => MyBoxShadowState();
}

class MyBoxShadowState extends State<MyBoxShadow> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ConstsWidget.buildPadding001(
      context,
      vertical: 0.003,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor,
                spreadRadius: 1,
                blurRadius: 6,
                offset: Offset(5, 5), // changes position of shadow
              ),
            ],
            border: Border.all(
              color: Theme.of(context).shadowColor,
            ),
            borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(size.width * widget.paddingAll),
          child: widget.child,
        ),
      ),
    );
  }
}
