import 'package:flutter/material.dart';

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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor,
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(2, 2), // changes position of shadow
              ),
            ],
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(size.width * widget.paddingAll),
          child: widget.child,
        ),
      ),
    );
  }
}
