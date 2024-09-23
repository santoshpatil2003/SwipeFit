// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/profilepicslist.dart';
// import 'package:ratefit_firestore/pages/profilepicslist.dart';

class Pictures extends StatelessWidget {
  final int? index;
  final String? filename;
  final String? pagename;
  final String? uid;
  const Pictures(
      {super.key, this.pagename, this.index, this.filename, this.uid});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: GestureDetector(
        onTap: (() {
          // if (pagename == "/SavedPage") {
          //   Navigator.of(context).pushNamed(ProfilePics.routepage,
          //       arguments: {"id": uid, "check": "false"});
          // } else {
          //   Navigator.of(context).pushNamed(ProfilePics.routepage,
          //       arguments: {"id": uid, "check": "true"});
          // }
          Navigator.of(context).pushNamed(ProfilePics.routepage,
              arguments: {"id": uid, "check": "true"});
        }),
        child: Container(
          color: const Color.fromRGBO(32, 33, 37, 100),
          height: size.height / 7,
          width: size.width / 3.5,
          child: filename == "pic1"
              ? const Center(
                  child: Text("name"),
                )
              : Image.network(
                  filename!,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}
