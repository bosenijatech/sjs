import 'package:flutter/cupertino.dart';
import 'package:winstar/utils/Appcolor.dart';

class CustomIndicator extends StatelessWidget {
  const CustomIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 100,
        width: 100,
        child: CupertinoActivityIndicator(
          color: Appcolor.black,
          radius: 20,
          animating: true,
        ),
      ),
    );
  }
}
