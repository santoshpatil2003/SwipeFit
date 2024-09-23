import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';

class Storage with ChangeNotifier {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  // Future<void> upload(String filename, String filepath, String uid) async {
  //   File file = File(filepath);
  //   print("pic is uploaded");
  //   try {
  //     storage.ref().child('pics/$uid/$filename').putFile(file);
  //   } on Exception catch (e) {
  //     print(e);
  //   }
  // }

  Future<void> upload(String filename, String filepath, String uid) async {
    File file = File(filepath);
    print("Uploading pic...");
    try {
      // Create a reference to the location in Firebase Storage
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('pics/$uid/$filename');

      // Upload the file with the content type set to 'image/jpeg'
      await ref.putFile(
        file,
        firebase_storage.SettableMetadata(
          contentType: 'image/jpeg',
        ),
      );

      print("Upload successful!");
    } on Exception catch (e) {
      print("Error uploading file: $e");
    }
  }

  Future<void> delete(String filename) async {
    // File file = File(filepath);
    print("pic is uploaded");
    try {
      storage.ref().child('pics/$filename').delete();
    } on Exception catch (e) {
      print(e);
    }
  }

  List<String> list = [];
}
