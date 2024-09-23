// import '../widgets/drawerdemo.dart';
// import '../widgets/drawerprofile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/itemwidget.dart';

class ProfilePics extends StatefulWidget {
  static const routepage = "/ProfilePics";
  const ProfilePics({super.key});

  @override
  State<ProfilePics> createState() => _ProfilePicsState();
}

class _ProfilePicsState extends State<ProfilePics> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, String?>;
    final argsid = args["id"];
    final argscheck = args["check"];
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   title: const Text("RateFit"),
      //   backgroundColor: Colors.black,
      // ),
      // endDrawer: Drawer(
      //   backgroundColor: Colors.black,
      //   child: Padding(
      //     padding: EdgeInsets.only(top: size.height / 10),
      //     child: const Column(
      //       children: [
      //         ProfileDrawer(),
      //         Divider(
      //           thickness: 1,
      //           color: Color.fromARGB(120, 255, 255, 255),
      //         ),
      //         DrawerDemo(),
      //       ],
      //     ),
      //   ),
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            argscheck == "true"
                ? StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("globalpics")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        print(snapshot.error);
                      }

                      return ListView.builder(
                          controller: ScrollController(keepScrollOffset: false),
                          itemCount: snapshot.data?.docs
                              .where((element) => element["uid"] == argsid)
                              .toList()
                              .length,
                          shrinkWrap: true,
                          itemBuilder: ((context, index) {
                            print(snapshot.data?.docs.toList()[index]
                                ["user_name"]);
                            return DemoPage(
                              buttondis: true,
                              documentid: snapshot.data?.docs
                                  .where((element) => element["uid"] == argsid)
                                  .toList()[index]
                                  .id
                                  .toString(),
                              username: snapshot.data?.docs
                                  .where((element) => element["uid"] == argsid)
                                  .toList()[index]["user_name"],
                              uid: snapshot.data?.docs
                                  .where((element) => element["uid"] == argsid)
                                  .toList()[index]["pic_url"],
                              user_id: argsid,
                              left: snapshot.data?.docs
                                  .where((element) => element["uid"] == argsid)
                                  .toList()[index]["dislike"]
                                  .toString(),
                              right: snapshot.data?.docs
                                  .where((element) => element["uid"] == argsid)
                                  .toList()[index]["like"]
                                  .toString(),
                            );
                          }));
                    })
                : StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("pics/ClpYg741V8dpWjzfq661/Saved_Pics_data")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        print(snapshot.error);
                      }
                      List l = snapshot.data!.docs
                          .where((element) => element["savedUid"] == argsid)
                          .toList();

                      return ListView.builder(
                          controller: ScrollController(keepScrollOffset: false),
                          itemCount: l.length,
                          shrinkWrap: true,
                          itemBuilder: ((context, index) {
                            print(snapshot.data!.docs.toList()[index]
                                ["user_name"]);
                            return DemoPage(
                              buttondis: true,
                              documentid: l[index].documentID.toString(),
                              username: l[index]["user_name"],
                              uid: l[index]["pic_url"],
                              user_id: l[index]["uid"],
                            );
                          }));
                    }),
          ],
        ),
      ),
    );
  }
}
