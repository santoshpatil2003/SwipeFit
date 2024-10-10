// ignore_for_file: void_checks, non_constant_identifier_names

// import 'package:flutter_application_1/pages/follow.dart';
// import 'package:flutter_application_1/widgets/draeweritems.dart';
// import 'package:flutter_app2/widgets/picwidgets.dart';
// import 'package:flutter_app2/widgets/profilegridviewwidget.dart';
// import 'package:flutter_application_1/widgets/profilegridviewwidget2.dart';
// import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Widgets/ProfileGridView.dart';
// import '../providers/dataproviders.dart';
// import '../widgets/profilegridviewwidget.dart';

class Profile extends StatefulWidget {
  static const routepage = "/Profilepage";
  final String? name;
  final String? user_name;
  const Profile({this.name, this.user_name, super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var loading = true;
  var init = true;
  // var loading_uid = true;
  int piclength = 0;
  String? name;
  String? user_name;
  String? pic_id;
  String? followingnum;
  String? followers;
  String? friendsnum;

  double avgstr = 0.0;

  void fetchlength(picId2) {
    try {
      // FirebaseFirestore.instance
      //     .collection("pics/ClpYg741V8dpWjzfq661/Pics_data")
      //     .snapshots()
      //     .listen(
      //   (event) {
      //     if (piclength <
      //             event.docs
      //                 .where((element) => element["uid"] == picId2)
      //                 .toList()
      //                 .length ||
      //         piclength >
      //             event.docs
      //                 .where((element) => element["uid"] == picId2)
      //                 .toList()
      //                 .length) {
      //       setState(() {
      //         piclength = event.docs
      //             .where((element) => element["uid"] == picId2)
      //             .toList()
      //             .length;
      //       });
      //     } else {
      //       print('hey');
      //     }
      //     // event.documents
      //     //     .where((element) => element["uid"] == picId2)
      //     //     .toList()
      //     //     .forEach((element) {
      //     //   element["ratings"].forEach((key, value) {
      //     //     stars = double.parse(value) + stars;
      //     //   });
      //     //   // setState(() {

      //     //   // });
      //     // });
      //   },
      // );
      print(picId2);
      var doc =
          FirebaseFirestore.instance.collection("users/$picId2/sentpics").get();
      doc.then((d) => {
            setState(() {
              piclength = d.docs.toList().length;
            })
          });
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  // void avg1(argsid) {
  //   double a = 0.0;
  //   double b = 0.0;
  //   double avg1 = 0.0;
  //   double avgTotal = 0.0;
  //   Map l2;
  //   List l = [];

  //   var i =
  //       FirebaseFirestore.instance.collection("users/$argsid/sentpics").get();
  //   // print(argsid);
  //   i.then((value) {
  //     // List l = value.docs.where((element) => element["uid"] == argsid).toList();

  //     List<QueryDocumentSnapshot<Map<String, dynamic>>> sentpics =
  //         value.docs.toList();
  //     sentpics.forEach((data1) {
  //       var prid = data1.data()['picdata'];
  //       FirebaseFirestore.instance
  //           .collection("globalpics")
  //           .doc(prid)
  //           .get()
  //           .then((data) {
  //         l.add({
  //           'likes': data.data()!['like'],
  //           'dislikes': data.data()!['dislike']
  //         });
  //       });
  //     });

  //     num li = 0;
  //     num dli = 0;

  //     print(l);

  //     for (Map element in l) {
  //       li += element['likes'];
  //       dli += element['dislikes'];
  //     }
  //     if (l.isNotEmpty) {
  //       avgTotal = double.parse(li.toString()) / double.parse(dli.toString());
  //     } else {
  //       avgTotal = 0.0;
  //     }
  //     String inString = avgTotal.toStringAsFixed(1);
  //     double inDouble = double.parse(inString);

  //     setState(() {
  //       avgstr = inDouble;
  //     });
  //   });
  // }

  Future<void> avg1(String? argsid) async {
    try {
      // Fetch sent pics
      QuerySnapshot<Map<String, dynamic>> sentPicsSnapshot =
          await FirebaseFirestore.instance
              .collection("users/$argsid/sentpics")
              .get();

      List<QueryDocumentSnapshot<Map<String, dynamic>>> sentpics =
          sentPicsSnapshot.docs;

      // Use Future.wait to fetch all globalpics data concurrently
      List<Map<String, dynamic>> l =
          await Future.wait(sentpics.map((data1) async {
        String prid = data1.data()['picdata'];
        DocumentSnapshot<Map<String, dynamic>> globalPicDoc =
            await FirebaseFirestore.instance
                .collection("globalpics")
                .doc(prid)
                .get();

        return {
          'likes': globalPicDoc.data()?['like'] ?? 0,
          'dislikes': globalPicDoc.data()?['dislike'] ?? 0
        };
      }));

      num li = 0;
      num dli = 0;

      for (Map<String, dynamic> element in l) {
        li += element['likes'];
        dli += element['dislikes'];
      }

      if (dli == 0) {
        dli = 1;
      }

      double avgTotal = (dli != 0) ? li / dli : 0.0;
      String inString = avgTotal.toStringAsFixed(1);
      double inDouble = double.parse(inString);

      setState(() {
        avgstr = inDouble;
      });
    } catch (e) {
      print("Error in avg1: $e");
      // Handle the error appropriately
    }
  }

  @override
  void didChangeDependencies() {
    FirebaseAuth.instance
        .authStateChanges()
        .first
        .asStream()
        .forEach((element) {
      // if (element?.uid == null) {
      //   throw ("Error");
      // }

      // followerslength(element?.uid);
      // followeinglength(pic_id);
      friendslength(element?.uid);
      fetchlength(pic_id);
      avg1(element?.uid);
    });
    super.didChangeDependencies();
  }

  // void followerslength(picid) {
  //   var i = FirebaseFirestore.instance.collection("users").doc(picid);
  //   i.get().then((event) {
  //     if (event.data()!["followers"]["followers ids"] == null) {
  //       return print("no followers");
  //     }
  //     if (event.data()!["followers"]["followers ids"].length.toString() !=
  //         followers) {
  //       setState(() {
  //         followers =
  //             event.data()!["followers"]["followers ids"].length.toString();
  //         // run1 = true;
  //       });
  //     }
  //   });
  // }

  // void followeinglength(argsid) {
  //   var i = FirebaseFirestore.instance.collection("users").doc(argsid);
  //   i.get().then((event) {
  //     try {
  //       if (event.data()!["following"]["following ids"] == null) {
  //         return print("no followers");
  //       }
  //       if (event.data()!["following"]["following ids"].length.toString() !=
  //           followingnum) {
  //         setState(() {
  //           followingnum =
  //               event.data()!["following"]["following ids"].length.toString();
  //           // run1 = true;
  //         });
  //       }
  //     } on Exception catch (error) {
  //       return print("caught exception : $error");
  //     }
  //   });
  // }

  void friendslength(argsid) {
    var i = FirebaseFirestore.instance.collection("users").doc(argsid);
    i.get().then((event) {
      try {
        if (event.data()!["friends"]["friends ids"] == null) {
          return print("no followers");
        }
        if (event.data()!["friends"]["friends ids"].length.toString() !=
            friendsnum) {
          setState(() {
            friendsnum =
                event.data()!["friends"]["friends ids"].length.toString();
            // run1 = true;
          });
        }
      } on Exception catch (error) {
        return print("caught exception : $error");
      }
    });
  }

  // bottomsheet(context, size) {
  //   showModalBottomSheet(
  //       elevation: 10,
  //       context: context,
  //       backgroundColor: const Color.fromARGB(127, 0, 0, 0),
  //       builder: (BuildContext context) {
  //         return GestureDetector(
  //           onTap: (() {}),
  //           child: Container(
  //             color: const Color.fromARGB(255, 25, 25, 30),
  //             height: size.height / 4.5,
  //             child: Column(
  //               children: [
  //                 Row(
  //                   children: [
  //                     Container(
  //                       width: size.width,
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(10),
  //                       ),
  //                       child: DrawerListItem(
  //                           name: "Sent Pictures",
  //                           iconname: ImageIcon(
  //                               const AssetImage(
  //                                   "assets/icons/sendhorizontal.png"),
  //                               size: size.height / 25,
  //                               color: Colors.white)),
  //                     ),
  //                   ],
  //                 ),
  //                 Row(
  //                   children: [
  //                     Container(
  //                       width: size.width,
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(10),
  //                       ),
  //                       child: DrawerListItem(
  //                           name: "Saved Pictures",
  //                           iconname: ImageIcon(
  //                               const AssetImage("assets/icons/save10.png"),
  //                               size: size.height / 30,
  //                               color: Colors.white)),
  //                     ),
  //                   ],
  //                 ),
  //                 Row(
  //                   children: [
  //                     Container(
  //                       width: size.width,
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(10),
  //                       ),
  //                       child: DrawerListItem(
  //                           name: "Log Out",
  //                           iconname: Icon(Icons.logout,
  //                               size: size.height / 25, color: Colors.white)),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }

  @override
  void initState() {
    FirebaseAuth.instance
        .authStateChanges()
        .first
        .asStream()
        .forEach((element) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(element?.uid)
          .snapshots()
          .listen((event) {
        setState(() {
          pic_id = element?.uid.toString();
          name = event.data()!["name"];
          user_name = event.data()!["user_name"];
        });
      });
      if (element?.uid == null) {
        throw ("Error");
      } else {
        setState(() {
          pic_id = element?.uid;
        });
      }
    });

    super.initState();
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
    final size = MediaQuery.of(context).size;
    // print(avgstr);
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData == false) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data?.uid != null) {
            return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection("users")
                    .doc(snapshot.data?.uid)
                    .get(),
                // ignore: missing_return
                builder: (context, snap) {
                  if (snap.hasData == false) {
                    return Container(
                      color: Colors.black,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (snap.data != null) {
                    return Scaffold(
                      backgroundColor: const Color.fromARGB(243, 10, 10, 10),
                      body: SingleChildScrollView(
                        child: Container(
                          color: const Color.fromARGB(255, 10, 10, 10),
                          height: size.height,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Stack(
                                      alignment: AlignmentDirectional.topEnd,
                                      children: [
                                        Container(
                                          height: size.height / 8,
                                          width: size.height / 8,
                                          decoration: BoxDecoration(
                                              color: colors[
                                                  user_name!.split('').length],
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      size.width / 2)),
                                          child: snap.data!["DpUrl"] == "none"
                                              ? Center(
                                                  child: Text(
                                                    user_name!.split('')[0],
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            size.width / 10),
                                                  ),
                                                )
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          size.width / 2),
                                                  child: Image.network(
                                                    snap.data!["DpUrl"],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                        ),
                                        Container(
                                          height: size.height / 32,
                                          width: size.width / 16,
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 32, 33, 37),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      size.height / 10)),
                                          child: FittedBox(
                                            fit: BoxFit.cover,
                                            child: IconButton(
                                                onPressed: () {
                                                  // Navigator.of(context)
                                                  //     .pushNamed(
                                                  //         DpUpload.routepage);
                                                },
                                                icon: const Icon(Icons.edit,
                                                    color: Colors.white)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      child: Column(
                                        children: [
                                          name == null
                                              ? const Text(" ")
                                              : Text(
                                                  name!,
                                                  style: TextStyle(
                                                    fontSize: size.height / 50,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                          user_name == null
                                              ? const Text(" ")
                                              : Text(
                                                  user_name!,
                                                  style: TextStyle(
                                                    fontSize: size.height / 50,
                                                    color: const Color.fromARGB(
                                                        119, 255, 255, 255),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 0),
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.center,
                              //     children: [
                              //       Padding(
                              //         padding: const EdgeInsets.only(
                              //             top: 10, right: 10),
                              //         child: Padding(
                              //           padding: const EdgeInsets.all(8.0),
                              //           child: Row(
                              //             children: [
                              //               SizedBox(
                              //                 child: Column(
                              //                   children: [
                              //                     Text(
                              //                       "Followers",
                              //                       style: TextStyle(
                              //                         color: Colors.white,
                              //                         fontSize:
                              //                             size.height / 50,
                              //                       ),
                              //                     ),
                              //                     followers == null
                              //                         ? Text("0",
                              //                             style: TextStyle(
                              //                               color: Colors.white,
                              //                               fontSize:
                              //                                   size.height /
                              //                                       50,
                              //                             ))
                              //                         : GestureDetector(
                              //                             onTap: () {
                              //                               // Navigator.of(
                              //                               //         context)
                              //                               //     .pushNamed(
                              //                               //         Follow
                              //                               //             .routepage,
                              //                               //         arguments: {
                              //                               //       "follow":
                              //                               //           "followers",
                              //                               //       "uid": pic_id,
                              //                               //     });
                              //                             },
                              //                             child: Text(
                              //                               followers
                              //                                   .toString(),
                              //                               style: TextStyle(
                              //                                 color:
                              //                                     Colors.white,
                              //                                 fontSize:
                              //                                     size.height /
                              //                                         50,
                              //                               ),
                              //                             ),
                              //                           ),
                              //                   ],
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       ),
                              //       Padding(
                              //         padding: const EdgeInsets.only(
                              //             top: 10, right: 10),
                              //         child: Padding(
                              //           padding: const EdgeInsets.all(8.0),
                              //           child: Row(
                              //             children: [
                              //               SizedBox(
                              //                 child: Column(
                              //                   children: [
                              //                     Text(
                              //                       "Following",
                              //                       style: TextStyle(
                              //                         color: Colors.white,
                              //                         fontSize:
                              //                             size.height / 50,
                              //                       ),
                              //                     ),
                              //                     followingnum == null
                              //                         ? Text("0",
                              //                             style: TextStyle(
                              //                               color: Colors.white,
                              //                               fontSize:
                              //                                   size.height /
                              //                                       50,
                              //                             ))
                              //                         : GestureDetector(
                              //                             onTap: () {
                              //                               // Navigator.of(
                              //                               //         context)
                              //                               //     .pushNamed(
                              //                               //         Follow
                              //                               //             .routepage,
                              //                               //         arguments: {
                              //                               //       "follow":
                              //                               //           "following",
                              //                               //       "uid": pic_id,
                              //                               //     });
                              //                             },
                              //                             child: Text(
                              //                               followingnum!,
                              //                               style: TextStyle(
                              //                                 color:
                              //                                     Colors.white,
                              //                                 fontSize:
                              //                                     size.height /
                              //                                         50,
                              //                               ),
                              //                             ),
                              //                           ),
                              //                   ],
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       ),
                              //       Padding(
                              //         padding: const EdgeInsets.only(top: 10),
                              //         child: Padding(
                              //           padding: const EdgeInsets.all(8.0),
                              //           child: Row(
                              //             children: [
                              //               SizedBox(
                              //                 child: Column(
                              //                   children: [
                              //                     Text(
                              //                       "Friends",
                              //                       style: TextStyle(
                              //                         color: Colors.white,
                              //                         fontSize:
                              //                             size.height / 50,
                              //                       ),
                              //                     ),
                              //                     followingnum == null
                              //                         ? Text("0",
                              //                             style: TextStyle(
                              //                               color: Colors.white,
                              //                               fontSize:
                              //                                   size.height /
                              //                                       50,
                              //                             ))
                              //                         : GestureDetector(
                              //                             onTap: () {
                              //                               // Navigator.of(
                              //                               //         context)
                              //                               //     .pushNamed(
                              //                               //         Follow
                              //                               //             .routepage,
                              //                               //         arguments: {
                              //                               //       "follow":
                              //                               //           "friends",
                              //                               //       "uid": pic_id,
                              //                               //     });
                              //                             },
                              //                             child: Text(
                              //                               friendsnum!,
                              //                               style: TextStyle(
                              //                                 color:
                              //                                     Colors.white,
                              //                                 fontSize:
                              //                                     size.height /
                              //                                         50,
                              //                               ),
                              //                             ),
                              //                           ),
                              //                   ],
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: size.width / 115,
                                    right: size.width / 115,
                                    top: size.height / 30,
                                    bottom: size.height / 70),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color:
                                        const Color.fromRGBO(32, 33, 37, 100),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, left: 5, bottom: 5),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "Posts",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            size.height / 50,
                                                      ),
                                                    ),
                                                    Text(
                                                      piclength.toString(),
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            size.height / 50,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, right: 10, bottom: 5),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "swipe ratio",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            size.height / 50,
                                                      ),
                                                    ),
                                                    Text(
                                                      avgstr.toString(),
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            size.height / 50,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, right: 10, bottom: 5),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "Friends",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            size.height / 50,
                                                      ),
                                                    ),
                                                    Text(
                                                      friendsnum.toString(),
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            size.height / 50,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GridViews2(
                                pics_id: pic_id,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    print("error alert");
                    return Container();
                  }
                });
          } else {
            setState(() {
              loading = true;
            });
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
