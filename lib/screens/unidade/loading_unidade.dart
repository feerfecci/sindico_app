import 'package:flutter/material.dart';

import '../../consts/const_widget.dart';
import '../../widgets/my_box_shadow.dart';
import '../../widgets/shimmer_widget.dart';

class LoadingUnidades extends StatefulWidget {
  const LoadingUnidades({super.key});

  @override
  State<LoadingUnidades> createState() => _LoadingUnidadesState();
}

class _LoadingUnidadesState extends State<LoadingUnidades> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return MyBoxShadow(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerWidget(
                  width: size.width * 0.35, height: size.height * 0.035),
              ShimmerWidget(
                  width: size.width * 0.2, height: size.height * 0.035),
            ],
          ),
          ConstsWidget.buildPadding001(
            context,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerWidget(
                    width: size.width * 0.4, height: size.height * 0.035),
                ShimmerWidget(
                    width: size.width * 0.3, height: size.height * 0.035),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ShimmerWidget(
                  width: size.width * 0.42, height: size.height * 0.045),
              ShimmerWidget(
                  width: size.width * 0.42, height: size.height * 0.045),
            ],
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ShimmerWidget(
                  width: size.width * 0.42, height: size.height * 0.045),
            ],
          ),
          ConstsWidget.buildPadding001(
            context,
            child: ShimmerWidget(
              height: size.height * 0.07,
              circular: 30,
            ),
          )
        ],
      ),
    );
  }
}
