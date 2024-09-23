import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_application_1/widgets/commentsprofile.dart';

class DemoPage extends StatefulWidget {
  final bool? buttondis;
  final String? documentid;
  final Function? bottomsheet;
  final String? uid;
  final String? user_id;
  final String? username;
  final String? left;
  final String? right;
  const DemoPage(
      {super.key,
      this.buttondis,
      this.documentid,
      this.username,
      this.bottomsheet,
      this.uid,
      this.user_id,
      this.left,
      this.right});

  @override
  State<DemoPage> createState() => _DemoState();
}

class _DemoState extends State<DemoPage> {
  // double rating2;
  bool button = false;
  bool isback = false;
  double angle = 0;
  double initialratig2 = 0.5;
  String? uid;
  double avg = 0.0;
  bool save = false;
  int right = 0;
  int left = 0;

  check(argid) {
    if (widget.buttondis == true) {
      setState(() {
        button = true;
      });
    }
    print(button);
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> saved_url_firestore(
    String uid,
    String picdocument,
  ) async {
    // print(picName);
    try {
      var namedata = FirebaseFirestore.instance.collection("users").doc(uid);
      namedata.get().then((v) async {
        // print(v.data["user_name"]);
        await FirebaseFirestore.instance
            .collection("globalpics")
            .doc(picdocument)
            .get()
            .then((value) async {
          await FirebaseFirestore.instance
              .collection("globalpics")
              .doc(picdocument)
              .set({
            "pic_name": value.data()!["pic_name"],
            "pic_url": value.data()!["pic_url"],
            "uid": value.data()!["uid"],
            "user_name": value.data()!["user_name"],
            "comments": value.data()!["comments"],
            "ratings": value.data()!["ratings"],
            "savedUid": uid,
          });
        });
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  // void checkSaved() async {
  //   await FirebaseFirestore.instance
  //       .collection("pics/ClpYg741V8dpWjzfq661/Saved_Pics_data")
  //       .snapshots()
  //       .forEach((element) {
  //     for (var e in element.docs) {
  //       if (e.id == widget.documentid) {
  //         setState(() {
  //           save = true;
  //         });
  //       } else {
  //         print("false not found");
  //         continue;
  //       }
  //     }
  //   });
  // }

  Future<void> saved_Delete_url_firestore(String picdocument) async {
    // print(picName);
    try {
      var namedata = FirebaseFirestore.instance
          .collection("users/8x907mNurAgZ2xvma1DG/user_data")
          .doc(uid);
      namedata.get().then((v) async {
        // print(v.data["user_name"]);
        await FirebaseFirestore.instance
            .collection("pics/ClpYg741V8dpWjzfq661/Pics_data")
            .doc(picdocument)
            .get()
            .then((value) async {
          await FirebaseFirestore.instance
              .collection("pics/ClpYg741V8dpWjzfq661/Saved_Pics_data")
              .doc(picdocument)
              .delete();
        });
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  // initialrating(argsid, userid) {
  //   var i = FirebaseFirestore.instance
  //       .collection("pics/ClpYg741V8dpWjzfq661/Pics_data")
  //       .doc(argsid);

  //   try {
  //     i.get().then((value) {
  //       // print(value.data["ratings"]);
  //       if (value.data()!["ratings"].length == 0) {
  //       } else if (value.data()!["ratings"]["$userid"] == null) {
  //       } else {
  //         setState(() {
  //           initialratig2 = double.parse(value.data()!["ratings"]["$userid"]);
  //         });
  //       }
  //     });
  //   } on Exception catch (e) {
  //     print(e);
  //   }
  // }

  void rating(argsid, mainUid, stars) {
    var i = FirebaseFirestore.instance
        .collection("pics/ClpYg741V8dpWjzfq661/Pics_data")
        .doc(argsid);
    i.get().then((event) {
      i.update({
        "ratings.$mainUid": "$stars",
      });
    });
  }

  // void avg2(argsid) {
  //   double a = 0.0;
  //   double avg1 = 0.0;
  //   // double inDouble = 0.0;
  //   var i = FirebaseFirestore.instance
  //       .collection("pics/ClpYg741V8dpWjzfq661/Pics_data")
  //       .doc(argsid);
  //   i.get().then((value) {
  //     Map l2 = value.data()!["ratings"];
  //     l2.forEach((key, value) {
  //       a = double.parse(value) + a;
  //       // print(a.toString() + " " + " jchjscm");
  //     });
  //     // print(l2.length.toString() + "   " + "klhj");
  //     if (l2.isNotEmpty) {
  //       avg1 = a / l2.length;
  //     }
  //     String inString = avg1.toStringAsFixed(1);
  //     double inDouble = double.parse(inString);
  //     // print(inDouble.toString() + " " + " jchjscm");
  //     // return inDouble;
  //     setState(() {
  //       avg = inDouble;
  //     });
  //   });
  // }

  void comments(argsid, mainUid, value) {
    var i = FirebaseFirestore.instance
        .collection("pics/ClpYg741V8dpWjzfq661/Pics_data")
        .doc(argsid);
    i.get().then((event) {
      i.update({
        "comments": FieldValue.arrayUnion([
          {
            "uid": "$mainUid",
            "comment": "$value",
          }
        ]),
      });
    });
    // FocusScope.of(context).unfocus();
  }

  @override
  void initState() {
    FirebaseAuth.instance
        .authStateChanges()
        .first
        .asStream()
        // ignore: void_checks
        .forEach((element) {
      if (element?.uid == null) {
        throw ("error");
      } else {
        setState(() {
          uid = element?.uid.toString();
        });
        try {
          // initialrating(widget.documentid, element?.uid);
        } on Exception catch (e) {
          print(e);
        }
        check(widget.user_id);
      }
    });
    // checkSaved();
    // avg2(widget.documentid);
    super.initState();
  }

  bottomsheet(context, size, fieldText2, uid) {
    showModalBottomSheet(
        elevation: 10,
        context: context,
        backgroundColor: const Color.fromARGB(255, 10, 10, 10),
        builder: (BuildContext context) {
          return Container(
            color: const Color.fromARGB(255, 10, 10, 10),
            height: size.height,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    width: size.width,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Comments",
                          style: TextStyle(
                              color: Color.fromARGB(123, 255, 255, 255),
                              fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
                // SizedBox(
                //   height: size.height / 2.2,
                //   width: size.width,
                //   child: SingleChildScrollView(
                //     controller: ScrollController(keepScrollOffset: false),
                //     child: Column(
                //       children: [
                //         StreamBuilder<DocumentSnapshot>(
                //             stream: FirebaseFirestore.instance
                //                 .collection(
                //                     "pics/ClpYg741V8dpWjzfq661/Pics_data")
                //                 .doc(widget.documentid)
                //                 .snapshots(),
                //             builder: ((context, snapshot) {
                //               if (snapshot.hasData == false) {
                //                 return const Center(
                //                   child: CircularProgressIndicator(
                //                     color: Color.fromRGBO(32, 33, 37, 100),
                //                   ),
                //                 );
                //               }
                //               if (snapshot.connectionState ==
                //                   ConnectionState.waiting) {
                //                 return const Center(
                //                     child: CircularProgressIndicator(
                //                   color: Color.fromRGBO(32, 33, 37, 100),
                //                 ));
                //               }
                //               if (snapshot.hasError) {
                //                 print(snapshot.error);
                //               }

                //               // print(snapshot.data["comments"].length);
                //               return snapshot.data!["comments"].length == 0
                //                   ? SizedBox(
                //                       height: size.height / 2,
                //                       child: const Center(
                //                         child: Text(
                //                           "No Comments",
                //                           style: TextStyle(
                //                               color: Color.fromARGB(
                //                                   123, 255, 255, 255)),
                //                         ),
                //                       ),
                //                     )
                //                   : ListView.builder(
                //                       controller: ScrollController(
                //                           keepScrollOffset: false),
                //                       shrinkWrap: true,
                //                       itemCount:
                //                           snapshot.data!["comments"].length,
                //                       itemBuilder: ((context, index) {
                //                         if (snapshot.data!["comments"] ==
                //                             null) {
                //                           return const Center(
                //                             child: CircularProgressIndicator(),
                //                           );
                //                         }
                //                         return CommentsProfile(
                //                           documentID: widget.documentid,
                //                           userID: snapshot.data!["comments"]
                //                                   [index]["uid"]
                //                               .toString(),
                //                           comment: snapshot.data!["comments"]
                //                                   [index]["comment"]
                //                               .toString(),
                //                         );
                //                       }));
                //             })),
                //       ],
                //     ),
                //   ),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0, top: 0),
                      child: Container(
                        height: size.height / 19,
                        width: size.width / 1.1,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(34, 255, 255, 255)),
                          color: const Color.fromARGB(255, 10, 10, 10),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: TextFormField(
                            controller: fieldText2,
                            onFieldSubmitted: (value) {
                              print(value);
                              comments(widget.documentid, uid, value);
                              fieldText2.clear();
                            },
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(128, 255, 255, 255),
                              ),
                              hintText: 'Comments',
                              enabled: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  deletesheet(context, size) {
    showModalBottomSheet(
        elevation: 10,
        context: context,
        backgroundColor: const Color.fromARGB(127, 0, 0, 0),
        builder: (BuildContext context) {
          return Container(
            color: const Color.fromARGB(255, 25, 25, 30),
            height: size.height / 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: (() {}),
                        child: const Text(
                          "Delete",
                          style:
                              TextStyle(color: Color.fromRGBO(64, 196, 255, 1)),
                        )),
                  ],
                ),
              ],
            ),
          );
        });
  }

  void _flip() {
    setState(() {
      angle = (angle + pi) % (2 * pi);
    });
  }

  final List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.brown,
    Colors.cyan,
    Colors.grey,
    Colors.lightBlue,
    Colors.yellow,
    Colors.deepOrangeAccent,
    Colors.lightGreenAccent,
    Colors.blueGrey,
    Colors.red,
    Colors.green,
    Colors.brown,
    Colors.cyan,
    Colors.grey,
    Colors.lightBlue,
    Colors.yellow,
    Colors.deepOrangeAccent,
    Colors.lightGreenAccent,
    Colors.blueGrey,
    Colors.red,
    Colors.green,
    Colors.brown,
    Colors.cyan,
    Colors.grey,
    Colors.lightBlue,
    Colors.yellow,
    Colors.deepOrangeAccent,
    Colors.lightGreenAccent,
    Colors.blueGrey,
  ];

  @override
  Widget build(BuildContext context) {
    // final fieldText = TextEditingController();
    // final fieldText2 = TextEditingController();

    final size = MediaQuery.of(context).size;
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        // ignore: missing_return
        builder: (context, snap) {
          if (uid == null) {
            return Container();
          }
          if (snap.data != null) {
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(snap.data!.uid)
                      .snapshots(),
                  // ignore: missing_return
                  builder: (context, sna) {
                    if (sna.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                          height: size.height / 1.10,
                          width: size.width,
                          child:
                              const Center(child: CircularProgressIndicator()));
                    }
                    if (sna.hasError) {
                      print(sna.error);
                    }
                    if (sna.data != null) {
                      return Container(
                        height: size.height / 1.10,
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 10, 10, 10),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 2, top: 10, bottom: 10),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: colors[widget.username!
                                                .split('')
                                                .length],
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        width: size.width / 10,
                                        height: size.width / 10,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: sna.data!["DpUrl"] == "none"
                                              ? Center(
                                                  child: Text(
                                                    widget.username!
                                                        .split('')[0],
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            size.width / 19),
                                                  ),
                                                )
                                              // Image.network(
                                              //     "https://firebasestorage.googleapis.com/v0/b/ratefit-bed29.appspot.com/o/pics%2FEllipse%2031.png?alt=media&token=e2573822-9367-4a37-9dbb-6c604a3ac674",
                                              //     fit: BoxFit.cover,
                                              //   )
                                              : Image.network(
                                                  sna.data!["DpUrl"],
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: size.width / 1.18,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10,
                                                            bottom: 0),
                                                    child: Row(
                                                      children: [
                                                        widget.username == null
                                                            ? const Text(" ")
                                                            : Text(
                                                                widget
                                                                    .username!,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      size.height /
                                                                          60,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 0),
                                              child: button == true
                                                  ? SizedBox(
                                                      child: IconButton(
                                                        icon: const Icon(
                                                          Icons.more_vert,
                                                        ),
                                                        color: Colors.white,
                                                        onPressed: () {
                                                          deletesheet(
                                                              context, size);
                                                        },
                                                      ),
                                                    )
                                                  : null,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onDoubleTap: _flip,
                                  child: TweenAnimationBuilder(
                                      tween:
                                          Tween<double>(begin: 0, end: angle),
                                      duration:
                                          const Duration(milliseconds: 400),
                                      builder: (BuildContext context,
                                          double val, __) {
                                        if (val <= (pi / 2)) {
                                          isback = false;
                                        } else {
                                          isback = true;
                                        }
                                        return Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: SizedBox(
                                            height: size.height * (3.88 / 5),
                                            width: size.width / 1,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              child: Image.network(
                                                widget.uid!,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      // color: Colors.red,
                                      width: size.width / 1.06,
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: size.width / 25),
                                            child: SizedBox(
                                              // color: Colors.white,
                                              width: size.width / 1.12,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  // IconButton(
                                                  //     // constraints:
                                                  //     //     BoxConstraints.tight(Size(40, 40)),
                                                  //     onPressed: () {
                                                  //       bottomsheet(
                                                  //           context,
                                                  //           size,
                                                  //           fieldText2,
                                                  //           snap.data?.uid);
                                                  //     },
                                                  //     icon: const ImageIcon(
                                                  //       AssetImage(
                                                  //           "assets/icons/comment.png"),
                                                  //       size: 20,
                                                  //       color: Colors.white,
                                                  //     )
                                                  //   ),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 4),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            'Right Swipe ${widget.right}',
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15),
                                                          ),
                                                        ],
                                                      )),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 4),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            'Left Swipe ${widget.left}',
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15),
                                                          ),
                                                        ],
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // Row(
                            //   children: [
                            //     Padding(
                            //       padding:
                            //           const EdgeInsets.only(left: 20, top: 6),
                            //       child: Container(
                            //         width: size.width / 1.2,
                            //         height: 37,
                            //         decoration: BoxDecoration(
                            //           border: Border.all(
                            //               width: 0.1, color: Colors.white
                            //               // const Color.fromARGB(34, 255, 255, 255)
                            //               ),
                            //           color:
                            //               const Color.fromARGB(255, 10, 10, 10),
                            //           borderRadius: BorderRadius.circular(5),
                            //         ),
                            //         child: Padding(
                            //           padding: const EdgeInsets.only(left: 10),
                            //           child: TextFormField(
                            //             controller: fieldText,
                            //             onFieldSubmitted: (value) {
                            //               print(value);
                            //               comments(widget.documentid,
                            //                   snap.data?.uid, value);
                            //               fieldText.clear();
                            //             },
                            //             style: const TextStyle(
                            //                 color: Colors.white, fontSize: 15),
                            //             decoration: const InputDecoration(
                            //               border: InputBorder.none,
                            //               hintStyle: TextStyle(
                            //                 fontSize: 15,
                            //                 color: Color.fromARGB(
                            //                     69, 255, 255, 255),
                            //               ),
                            //               hintText: 'Comments',
                            //               enabled: true,
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //     )
                            //   ],
                            // )
                          ],
                        ),
                      );
                    } else {
                      return SizedBox(
                        height: size.height,
                        width: size.width,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  }),
            );
          }
          throw ("error");
        });
  }
}
