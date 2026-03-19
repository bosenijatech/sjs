import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:winstar/utils/appcolor.dart';

class NotificationTile extends StatelessWidget {
  final Function onTap;
  final String data;

  const NotificationTile({
    super.key,
    required this.onTap,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Image
            // Container(
            //   width: 46,
            //   height: 46,
            //   decoration: BoxDecoration(
            //     color: Appcolor.border,
            //     borderRadius: BorderRadius.circular(8),
            //     image: DecorationImage(
            //         image: AssetImage('${data.imageUrl}'), fit: BoxFit.cover),
            //   ),
            //   margin: const EdgeInsets.only(right: 16),
            // ),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    data,
                    style: const TextStyle(
                        color: Appcolor.black,
                        fontFamily: 'poppins',
                        fontWeight: FontWeight.w500),
                  ),
                  // Description
                  Container(
                    margin: const EdgeInsets.only(top: 2, bottom: 8),
                    child: Text(
                      'description',
                      style: TextStyle(
                          color: Appcolor.black.withOpacity(0.7), fontSize: 12),
                    ),
                  ),
                  // Datetime
                  Row(
                    children: [
                      SvgPicture.asset('assets/icons/timecircle.svg',
                          color: Appcolor.black.withOpacity(0.7)),
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Text(
                          "",
                          style: TextStyle(
                              color: Appcolor.black.withOpacity(0.7),
                              fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
