import 'package:flutter/material.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/nointernetimage.png'))),
            ),
            const Text(
              'No Internet Connection',
              style: TextStyle(color: Colors.red, fontSize: 20),
            ),
            const Padding(
                padding: EdgeInsets.all(5),
                child: Text('Please enable your internet connection!')),
          ],
        ),
      ),
    );
  }
}
