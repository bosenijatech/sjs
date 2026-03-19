import 'package:flutter/material.dart';

Widget statusPendingColor({
  required String text,
  double fontSize = 10,
}) {
  Color bgColor;
  Color textColor;
  IconData icon;

  switch (text) {
    case "Pending":
    case "Pending Approval":
      bgColor = const Color(0xFFFFF3E0);
      textColor = const Color(0xffFB8C00);
      icon = Icons.access_time_rounded;
      break;
    case "Rejected":
    case "Cancelled":
      bgColor = const Color(0xFFFFEBEE);
      textColor = const Color(0xffE53935);
      icon = Icons.cancel_rounded;
      break;
    default:
      bgColor = const Color(0xFFE8F5E9);
      textColor = const Color(0xff2E7D32);
      icon = Icons.check_circle_rounded;
  }

  return Container(
    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(
          color: bgColor.withOpacity(0.4),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: textColor),
        const SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ],
    ),
  );
}

Widget appovalPending({
  required String text,
  double size = 22,
}) {
  IconData icon;
  Color color;

  switch (text) {
    case "Approved":
      icon = Icons.check_circle_rounded;
      color = Colors.green.shade600;
      break;
    case "Rejected":
      icon = Icons.cancel_rounded;
      color = Colors.red.shade600;
      break;
    default:
      icon = Icons.schedule_rounded;
      color = Colors.orange.shade700;
  }

  return AnimatedSwitcher(
    duration: const Duration(milliseconds: 300),
    transitionBuilder: (child, animation) => ScaleTransition(
      scale: animation,
      child: child,
    ),
    child: Icon(
      icon,
      key: ValueKey<String>(text),
      color: color,
      size: size,
    ),
  );
}
