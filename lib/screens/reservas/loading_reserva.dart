import 'package:flutter/material.dart';

import '../../widgets/my_box_shadow.dart';
import '../../widgets/shimmer_widget.dart';

class LoadingReservas extends StatefulWidget {
  const LoadingReservas({super.key});

  @override
  State<LoadingReservas> createState() => _LoadingReservasState();
}

class _LoadingReservasState extends State<LoadingReservas> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return MyBoxShadow(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShimmerWidget(
              height: size.height * 0.04,
              width: size.width * 0.45,
            ),
            ShimmerWidget(
              height: size.height * 0.04,
              width: size.width * 0.3,
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
          child: ShimmerWidget(
            height: size.height * 0.06,
            width: size.width * 0.5,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShimmerWidget(
              height: size.height * 0.04,
              width: size.width * 0.4,
            ),
            ShimmerWidget(
              height: size.height * 0.04,
              width: size.width * 0.4,
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShimmerWidget(
                circular: 30,
                height: size.height * 0.06,
                width: size.width * 0.35,
              ),
              SizedBox(
                width: size.width * 0.01,
              ),
              ShimmerWidget(
                circular: 30,
                height: size.height * 0.06,
                width: size.width * 0.35,
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
