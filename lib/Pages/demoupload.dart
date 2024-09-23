import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Provider/Provider.dart';
import 'package:flutter_application_1/Storage/Storage.dart';
// import 'package:flutter_application_1/helpers/storage_service.dart';
import 'package:flutter_application_1/pages/final_upload.dart';
import 'package:flutter_application_1/pages/send.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart';

import 'package:provider/provider.dart';
// import '../providers/dataproviders.dart';

class UploadPage2 extends StatefulWidget {
  static const routepage = "/demoupload";
  final String? imagepath;
  const UploadPage2({this.imagepath, super.key});

  @override
  State<UploadPage2> createState() => _UploadPage2State();
}

class _UploadPage2State extends State<UploadPage2> {
  File? _selectimage;
  String? _selectpath;
  String? _selectname;
  bool uploaded = false;
  bool uploade = false;

  // Future _imagepick() async {
  //   final image = await ImagePicker().getImage(
  //     source: ImageSource.camera,
  //     maxWidth: 600,
  //   );
  //   return image;
  // }

  uploading(snapshot, storage, uploadserver) async {
    if (snapshot.data!.uid != null) {
      try {
        setState(() {
          uploade = true;
        });
        await storage.upload(_selectname!, _selectpath!).then((value) async {
          Future.delayed(const Duration(seconds: 5), () async {
            await uploadserver(
                _selectname!, "1", snapshot.data!.uid.toString());
          });
          Future.delayed(const Duration(seconds: 2), (() {
            setState(() {
              uploaded = true;
            });
          }));

          Future.delayed(const Duration(seconds: 3), (() {
            // Navigator.of(context).pop();
          }));
        });
      } on Exception catch (e) {
        print(e);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _selectpath = widget.imagepath!;
    _selectimage = File(_selectpath!);
    _selectname = "pic${DateTime.now().toIso8601String()}";
    // try {
    //   _imagepick().then((value) {
    //     if (value.path != null) {
    //       setState(() {
    //         _selectimage = File(value.path);
    //         _selectpath = value.path;
    //         _selectname = "pic" + DateTime.now().toIso8601String();
    //       });
    //     } else {
    //       print("Take a pic idiot!!!");
    //     }
    //   });
    // } on PathException catch (e) {
    //   print(e);
    // }
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Backend>(context, listen: false);
    final Storage storage = Storage();
    // final piclists = products.getuserid;
    // final a = products.g;
    final uploadserver = products.upload_url_firestore;
    final size = MediaQuery.of(context).size;
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Colors.black,
            // appBar: AppBar(
            //   title: const Text("RateFit"),
            //   backgroundColor: Colors.black,
            // ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Stack(
                          alignment: AlignmentDirectional.bottomStart,
                          children: [
                            Container(
                              color: Colors.black,
                              width: size.width,
                              height: size.height,
                              child: widget.imagepath == null
                                  ? const Center(
                                      child: Text(
                                        "Image not Found",
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.grey),
                                      ),
                                    )
                                  : Image.file(
                                      _selectimage!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: SizedBox(
                                width: size.width,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    widget.imagepath == null
                                        ? Container()
                                        : Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: GestureDetector(
                                              onTap: (() async {
                                                // uploading(snapshot, storage,
                                                //     uploadserver);
                                                await Navigator.of(context)
                                                    .push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        FinalUpload(
                                                      imagepath: _selectpath,
                                                    ),
                                                  ),
                                                );
                                              }),
                                              child: Container(
                                                height: 35,
                                                width: 90,
                                                decoration: BoxDecoration(
                                                    color: Colors.cyan,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Text(
                                                      "Upload",
                                                      style: TextStyle(
                                                          color: Colors.white),
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
                                    widget.imagepath == null
                                        ? Container()
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: GestureDetector(
                                              onTap: (() async {
                                                // print(_selectname);
                                                // print(_selectpath);
                                                Navigator.of(context).pushNamed(
                                                    Send.routepage,
                                                    arguments: {
                                                      "id": "true",
                                                      "picname": _selectname,
                                                      "pathname": _selectpath
                                                    });
                                              }),
                                              child: Container(
                                                height: 35,
                                                width: 80,
                                                decoration: BoxDecoration(
                                                    color: Colors.cyan,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Text(
                                                      "Send",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    Icon(
                                                      Icons.send,
                                                      color: Colors.white,
                                                      size: 20,
                                                    )
                                                    // ImageIcon(
                                                    //   AssetImage(
                                                    //       "assets/icons/sendhorizontal.png"),
                                                    //   color: Colors.white,
                                                    //   size: 20,
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                      uploade == false
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: Uploading(
                                uploaded: uploaded,
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class Uploading extends StatefulWidget {
  final bool? uploaded;
  const Uploading({super.key, this.uploaded});

  @override
  State<Uploading> createState() => _UploadingState();
}

class _UploadingState extends State<Uploading> {
  // bool sent = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.cyan, borderRadius: BorderRadius.circular(20)),
            height: 40,
            width: 100,
            child: Padding(
              padding: const EdgeInsets.only(left: 0),
              child: Row(
                mainAxisAlignment: widget.uploaded == false
                    ? MainAxisAlignment.spaceAround
                    : MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: widget.uploaded == false
                        ? const Text(
                            "Uploading",
                            style: TextStyle(color: Colors.white),
                          )
                        : const Text(
                            "Uploaded",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                  widget.uploaded == false
                      ? SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            value: widget.uploaded == false ? null : 0,
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
