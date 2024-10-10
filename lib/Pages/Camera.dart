import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/Send.dart';
import 'package:flutter_application_1/Pages/final_upload.dart';
import 'package:flutter_application_1/Provider/Provider.dart';
import 'package:flutter_application_1/Storage/Storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Camera extends StatefulWidget {
  static const routepage = "/camera";
  final String uid;
  const Camera({super.key, required this.uid});

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  File? _selectimage;
  String? _selectpath;
  String? _selectname;

  Future<XFile?> _imagepick() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    return image;
  }

  @override
  void initState() {
    super.initState();
    _imagepick().then((value) {
      if (value != null && value.path.isNotEmpty) {
        setState(() {
          _selectimage = File(value.path);
          _selectpath = value.path;
          _selectname = "pic${DateTime.now().toIso8601String()}";
        });
      } else {
        print("Image not selected or an error occurred!");
      }
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Backend>(context, listen: false);
    final Storage storage = Storage();
    final a = products.g;
    final uploadserver = products.upload_url_firestore;
    final size = MediaQuery.of(context).size;

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final userId = snapshot.data!.uid;

          return Scaffold(
            backgroundColor: Colors.black,
            // appBar: AppBar(
            //   title: const Text("RateFit"),
            //   backgroundColor: Colors.black,
            // ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: Colors.black,
                    width: size.width,
                    height: size.height / 1.4,
                    child: _selectimage == null
                        ? const Center(
                            child: Text(
                              "Image not Found",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.grey),
                            ),
                          )
                        : Image.file(
                            _selectimage!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _selectimage == null
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: GestureDetector(
                                  onTap: () async {
                                    // try {
                                    //   await storage
                                    //       .upload(_selectname!, _selectpath!,
                                    //           userId)
                                    //       .then((value) async {
                                    //     await Future.delayed(
                                    //         const Duration(seconds: 5));
                                    //     await uploadserver(
                                    //         _selectname!, "1", userId);
                                    //   });
                                    // } catch (e) {
                                    //   print(e);
                                    // }
                                    // Navigator.of(context).pop();
                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => FinalUpload(
                                          imagepath: _selectpath,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 35,
                                    width: 90,
                                    decoration: BoxDecoration(
                                      color: Colors.cyan,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Tryon AI",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Icon(
                                          Icons.upload_rounded,
                                          color: Colors.white,
                                          size: 20,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                        _selectimage == null
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed(Send.routepage, arguments: {
                                      "id": "true",
                                      "picname": _selectname,
                                      "pathname": _selectpath,
                                    });
                                  },
                                  child: Container(
                                    height: 35,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.cyan,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          "Send",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        // ImageIcon(
                                        //   AssetImage(
                                        //       "assets/icons/sendhorizontal.png"),
                                        //   color: Colors.white,
                                        //   size: 10,
                                        // ),
                                        Icon(
                                          Icons.send,
                                          color: Colors.white,
                                          size: 20,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Text(
                "User not authenticated",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          );
        }
      },
    );
  }
}
