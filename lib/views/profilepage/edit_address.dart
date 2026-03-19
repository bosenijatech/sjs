import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:winstar/utils/app_utils.dart';
import 'package:winstar/utils/appcolor.dart';

class EditAddress extends StatefulWidget {
  const EditAddress({super.key});

  @override
  State<EditAddress> createState() => _EditAddressState();
}

String countryValue = "";
String stateValue = "";
String cityValue = "";

class _EditAddressState extends State<EditAddress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Appcolor.kwhite,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: AppUtils.buildNormalText(
            text: "Address", color: Colors.black, fontSize: 20),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [currentaddressdetails()],
        ),
      ),
    );
  }

  Widget countrypicker() {
    return Container(
      child: const Column(
        children: [],
      ),
    );
  }

  Widget currentaddressdetails() {
    return Column(children: [
      Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Doc Entry',
                icon: Icon(Icons.numbers),
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Whs Name ',
                icon: Icon(Icons.warehouse),
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Bar Code',
                icon: Icon(Icons.qr_code),
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Scan Rack',
                icon: Icon(Icons.qr_code),
              ),
            ),
            TextFormField(
              enabled: false,
              decoration: const InputDecoration(
                labelText: 'Department',
                icon: Icon(Icons.account_balance_rounded),
              ),
            )
          ]))
    ]);
  }
}
