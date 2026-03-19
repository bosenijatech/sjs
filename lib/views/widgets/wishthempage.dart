import 'package:flutter/material.dart';

class WishThemWidget extends StatelessWidget {
  final List<Map<String, String>> wishList;
  final String type;
  const WishThemWidget({super.key, required this.wishList, required this.type});

  @override
  Widget build(BuildContext context) {
    if (wishList.isEmpty) {
      return const SizedBox.shrink(); // hide if no data
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            type,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: wishList.length,
              itemBuilder: (context, index) {
                final person = wishList[index];
                return Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          // Circle Image or Initials
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: person["photo"]!.isNotEmpty
                                ? NetworkImage(person["photo"]!)
                                : null,
                            child: person["photo"]!.isEmpty
                                ? Text(
                                    person["initials"]!,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple,
                                    ),
                                  )
                                : null,
                          ),
                          // Tag (B'DAY / YRS)
                          Positioned(
                            bottom: -2,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: person["type"] == "LEAVE"
                                    ? Colors.red
                                    : person["type"] == "B'DAY"
                                        ? Colors.blue
                                        : Colors.purple,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                person["type"]!,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        person["name"]!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        person["date"]!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
