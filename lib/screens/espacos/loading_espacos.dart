import 'package:flutter/material.dart';

import '../../consts/const_widget.dart';
import '../../widgets/my_box_shadow.dart';
import '../../widgets/shimmer_widget.dart';

class LoadingEspacos extends StatefulWidget {
  const LoadingEspacos({super.key});

  @override
  State<LoadingEspacos> createState() => _LoadingEspacos();
}

class _LoadingEspacos extends State<LoadingEspacos> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return MyBoxShadow(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ConstsWidget.buildPadding001(
            context,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerWidget(
                  height: size.height * 0.03,
                  width: size.width * 0.5,
                ),
                ShimmerWidget(
                  height: size.height * 0.03,
                  width: size.width * 0.2,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShimmerWidget(
                height: size.height * 0.03,
                width: size.width * 0.6,
              ),
            ],
          ),
          ConstsWidget.buildPadding001(
            context,
            child: ShimmerWidget(
              circular: 30,
              height: size.height * 0.07,
            ),
          ),
        ],
      ),
    );
  }
}
