import 'package:flutter/material.dart';

import '../../consts/const_widget.dart';
import '../../widgets/my_box_shadow.dart';
import '../../widgets/shimmer_widget.dart';

class LoadingAvisos extends StatefulWidget {
  const LoadingAvisos({super.key});

  @override
  State<LoadingAvisos> createState() => _LoadingAvisos();
}

class _LoadingAvisos extends State<LoadingAvisos> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return MyBoxShadow(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ConstsWidget.buildPadding001(
            context,
            child: ShimmerWidget(
              height: size.height * 0.03,
              width: size.width * 0.7,
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
              height: size.height * 0.03,
              width: size.width * 0.6,
            ),
          ),
        ],
      ),
    );
  }
}
