import 'package:flutter/material.dart';

Widget buildHeaderPage(
  BuildContext context, {
  required String titulo,
  required String subTitulo,
  required Widget widget,
}) {
  var size = MediaQuery.of(context).size;
  return StatefulBuilder(builder: (context, setState) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(
          () {},
        );
      },
      child: ListView(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              SizedBox(
                child: TweenAnimationBuilder(
                  curve: Curves.easeIn,
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Padding(
                        padding:
                            EdgeInsets.only(top: value * size.height * 0.025),
                        child: child,
                      ),
                    );
                  },
                  duration: Duration(milliseconds: 800),
                  child: Column(
                    children: [
                      Text(
                        titulo,
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      Text(
                        subTitulo,
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: size.height * 0.14,
                  right: size.width * 0.01,
                  left: size.width * 0.01,
                ),
                child: widget,
              ),
            ],
          ),
        ],
      ),
    );
  });
  ;
}
