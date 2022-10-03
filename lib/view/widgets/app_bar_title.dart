import 'package:flutter/material.dart';
import 'package:live_stream/res/custom_colors.dart';

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 8),
        Text(
          'Live Stream',
          style: TextStyle(
            color: CustomColors.firebaseYellow,
            fontSize: 28,
          ),
        ),
        Text(
          ' Ombre',
          style: TextStyle(
            color: CustomColors.firebaseOrange,
            fontSize: 28,
          ),
        ),
      ],
    );
  }
}