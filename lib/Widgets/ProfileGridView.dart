// import 'package:ratefit_firestore/widgets/picwidgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Widgets/GridPictures.dart';

class GridViews2 extends StatefulWidget {
  final String? pics_id;
  const GridViews2({this.pics_id, super.key});

  @override
  State<GridViews2> createState() => _GridViews2State();
}

class _GridViews2State extends State<GridViews2> {
  var _urlImages = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future<void> loadImages() async {
      print('start');
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          QuerySnapshot<Map<String, dynamic>> receivedPicsSnapshot =
              // await FirebaseFirestore.instance
              //     .collection("users")
              //     .doc(user.uid)
              //     .collection('recivedpics')
              //     .get();
              await FirebaseFirestore.instance
                  .collection("users")
                  .doc(user.uid.toString())
                  .collection('sentpics')
                  .get();

          List<Map<String, dynamic>> picUrls = [];

          for (var doc in receivedPicsSnapshot.docs) {
            final picId = doc.data()['picdata'] as String;
            DocumentSnapshot<Map<String, dynamic>> picDataSnapshot =
                await FirebaseFirestore.instance
                    .collection("globalpics")
                    .doc(picId)
                    .get();

            // final picUrl = picDataSnapshot.data()?['pic_url'] as String?;
            final picUrl = picDataSnapshot.data();
            if (picUrl != null) {
              picUrls.add(picUrl);
            }
          }
          print("het j: $picUrls ");
          setState(() {
            _urlImages = picUrls.reversed.toList();
          });
        } catch (e) {
          print("Error fetching data: $e");
        }
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadImages();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final uid = widget.pics_id;
    // final data1 = FirebaseFirestore.instance.collection("user/$uid");
    // final data1 = FirebaseFirestore.instance.collection("user/$uid/sentpics");
    // print("urliname j: $_urlImages ");
    return _urlImages.isEmpty
        ? SizedBox(
            width: size.width,
            height: size.height / 2.4,
            child: const Center(
              child: Text(
                "No Posts",
                style: TextStyle(color: Color.fromARGB(119, 255, 255, 255)),
              ),
            ),
          )
        : GridView.builder(
            controller: ScrollController(
              keepScrollOffset: false,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: _urlImages.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              if (index > _urlImages.length) {
                return Container();
              }
              return Pictures(
                pagename: "/none",
                index: index,
                filename: _urlImages[index]['pic_url'],
                uid: widget.pics_id,
              );
            });

    // ListView.builder(
    //     itemCount: _urlImages.length,
    //     itemBuilder: (BuildContext context, int index) {
    //       return Pictures(
    //         pagename: "/none",
    //         index: index,
    //         filename: _urlImages[index]["pic_url"],
    //         uid: widget.pics_id,
    //       );
    //     });
    // FutureBuilder<QuerySnapshot>(
    //     future: data1.get(),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return const Center(child: CircularProgressIndicator());
    //       }
    //       if (snapshot.hasError) {
    //         return Text('Error: ${snapshot.error}');
    //       }
    //       int length = snapshot.data!.docs.toList().length;

    //       return length == 0
    //           ? SizedBox(
    //               width: size.width,
    //               height: size.height / 2.4,
    //               child: const Center(
    //                 child: Text(
    //                   "No Posts",
    //                   style:
    //                       TextStyle(color: Color.fromARGB(119, 255, 255, 255)),
    //                 ),
    //               ),
    //             )
    //           : GridView.builder(
    //               controller: ScrollController(
    //                 keepScrollOffset: false,
    //               ),
    //               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //                 crossAxisCount: 3,
    //               ),
    //               itemCount: length,
    //               shrinkWrap: true,
    //               itemBuilder: (BuildContext context, int index) {
    //                 if (index > length) {
    //                   return Container();
    //                 }
    //                 return Pictures(
    //                   pagename: "/none",
    //                   index: index,
    //                   filename: snapshot.data!.docs.toList()[index]["pic_url"],
    //                   uid: widget.pics_id,
    //                 );
    //               });
    //     });
  }
}
