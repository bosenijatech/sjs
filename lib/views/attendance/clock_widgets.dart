import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sjs/utils/app_utils.dart';

class ClockWidget extends StatelessWidget {
  const ClockWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        return AppUtils.buildNormalText(
            text: DateFormat("hh:mm:ss a").format(
              DateTime.now(),
            ),
            fontSize: 18,
            fontWeight: FontWeight.bold);
      },
    );
  }
}
