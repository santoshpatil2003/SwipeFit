import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Storage/Storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

// enum CardStatus { like, dislike, superLike }

// class CardProvider extends ChangeNotifier {
//   List<String> _urlImages = [];
//   List<String> get urlImages => _urlImages;

//   bool _isDragging = false;
//   bool get isDragging => _isDragging;

//   Offset _position = Offset.zero;
//   Offset get position => _position;

//   double _angle = 0;
//   double get angle => _angle;

//   Size _screenSize = Size.zero;
//   Size get screenSize => _screenSize;

//   CardProvider() {
//     print('Initializing cards');
//     resetUsers();
//   }

//   void setScreenSize(Size screenSize) => _screenSize = screenSize;

//   void startPosition(DragStartDetails details) {
//     _isDragging = true;
//     notifyListeners();
//   }

//   void updatePosition(DragUpdateDetails details) {
//     _position += details.delta;
//     final x = _position.dx;
//     _angle = 45 * x / _screenSize.width;
//     notifyListeners();
//   }

//   void endPosition() {
//     _isDragging = false;
//     notifyListeners();

//     final status = getStatus(force: true);

//     if (status != null) {
//       Fluttertoast.cancel();
//       Fluttertoast.showToast(
//         msg: status.toString().split('.').last.toUpperCase(),
//         fontSize: 30,
//       );
//     }
//     // print(status.toString().split('.').last.toUpperCase());

//     switch (status) {
//       case CardStatus.like:
//         like();
//         break;
//       case CardStatus.dislike:
//         dislike();
//         break;
//       case CardStatus.superLike:
//         superLike();
//         break;
//       default:
//         resetPosition();
//     }
//   }

//   void resetPosition() {
//     _isDragging = false;
//     _position = Offset.zero;
//     _angle = 0;
//     notifyListeners();
//   }

//   CardStatus? getStatus({bool force = false}) {
//     final x = _position.dx;
//     final y = _position.dy;
//     final forceSuperLike = x.abs() < 20;

//     if (force) {
//       const delta = 100;

//       if (x >= delta) {
//         return CardStatus.like;
//       } else if (x <= -delta) {
//         return CardStatus.dislike;
//       } else if (y <= -delta / 2 && forceSuperLike) {
//         return CardStatus.superLike;
//       }
//     } else {
//       const delta = 20;

//       if (y <= -delta * 2 && forceSuperLike) {
//         return CardStatus.superLike;
//       } else if (x >= delta) {
//         return CardStatus.like;
//       } else if (x <= -delta) {
//         return CardStatus.dislike;
//       }
//     }

//     return null;
//   }

//   void like() {
//     _angle = 20;
//     _position += Offset(_screenSize.width * 1.5, 0);
//     nextCard();
//     notifyListeners();
//   }

//   void dislike() {
//     _angle = -20;
//     _position -= Offset(_screenSize.width * 1.5, 0);
//     nextCard();
//     notifyListeners();
//   }

//   void superLike() {
//     _angle = 0;
//     _position -= Offset(0, _screenSize.height);
//     nextCard();
//     notifyListeners();
//   }

//   Future nextCard() async {
//     if (_urlImages.isEmpty) return;

//     await Future.delayed(const Duration(milliseconds: 200));
//     _urlImages.removeLast();
//     resetPosition();
//   }

//   void resetUsers() {
//     print('Resetting users');
//     _urlImages = [
//       'https://picsum.photos/id/1/720/1280.jpg',
//       'https://picsum.photos/id/2/720/1280.jpg',
//       'https://picsum.photos/id/31/720/1280.jpg',
//       'https://picsum.photos/id/32/720/1280.jpg',
//       'https://picsum.photos/id/33/720/1280.jpg',
//     ];
//     notifyListeners();
//   }
// }
enum CardStatus { like, dislike, superLike }

class CardProvider extends ChangeNotifier {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  final Storage serverstorage = Storage();

  List<Map<String, String?>> _urlImages = [];
  List<Map<String, String?>> get urlImages => _urlImages;

  bool _isDragging = false;
  bool get isDragging => _isDragging;

  Offset _position = Offset.zero;
  Offset get position => _position;

  double _angle = 0;
  double get angle => _angle;

  Size _screenSize = Size.zero;
  Size get screenSize => _screenSize;

  CardProvider() {
    print('Initializing cards');
    loadImages();
  }

  void setScreenSize(Size screenSize) => _screenSize = screenSize;

  void startPosition(DragStartDetails details) {
    _isDragging = true;
    notifyListeners();
  }

  void updatePosition(DragUpdateDetails details) {
    _position += details.delta;
    final x = _position.dx;
    _angle = 45 * x / _screenSize.width;
    notifyListeners();
  }

  Future<void> swipe_update(dynamic prid, String status) async {
    try {
      var namedata =
          FirebaseFirestore.instance.collection("globalpics").doc(prid);
      namedata.update({status: FieldValue.increment(1)});
      // print('$prid,  $status');
    } on Exception catch (e) {
      print(e);
    }
  }

  void endPosition(pid) {
    _isDragging = false;
    notifyListeners();

    final status = getStatus(force: true);

    if (status != null) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: status.toString().split('.').last.toUpperCase(),
        fontSize: 30,
      );
    }

    switch (status) {
      case CardStatus.like:
        like();
        swipe_update(pid, 'like');
        break;
      case CardStatus.dislike:
        dislike();
        swipe_update(pid, 'dislike');
        break;
      case CardStatus.superLike:
        superLike();
        swipe_update(pid, 'superLike');
        break;
      default:
        resetPosition();
    }
  }

  void resetPosition() {
    _isDragging = false;
    _position = Offset.zero;
    _angle = 0;
    notifyListeners();
  }

  CardStatus? getStatus({bool force = false}) {
    final x = _position.dx;
    final y = _position.dy;
    final forceSuperLike = x.abs() < 20;

    if (force) {
      const delta = 100;

      if (x >= delta) {
        return CardStatus.like;
      } else if (x <= -delta) {
        return CardStatus.dislike;
      } else if (y <= -delta / 2 && forceSuperLike) {
        return CardStatus.superLike;
      }
    } else {
      const delta = 20;

      if (y <= -delta * 2 && forceSuperLike) {
        return CardStatus.superLike;
      } else if (x >= delta) {
        return CardStatus.like;
      } else if (x <= -delta) {
        return CardStatus.dislike;
      }
    }

    return null;
  }

  void like() {
    _angle = 20;
    _position += Offset(_screenSize.width * 1.5, 0);
    nextCard();
    notifyListeners();
  }

  void dislike() {
    _angle = -20;
    _position -= Offset(_screenSize.width * 1.5, 0);
    nextCard();
    notifyListeners();
  }

  void superLike() {
    _angle = 0;
    _position -= Offset(0, _screenSize.height);
    nextCard();
    notifyListeners();
  }

  Future nextCard() async {
    if (_urlImages.isEmpty) return;

    await Future.delayed(const Duration(milliseconds: 200));
    _urlImages.removeLast();
    resetPosition();
  }

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
                .collection('recivedpics')
                .get();

        List<Map<String, String?>> picUrls = [];

        for (var doc in receivedPicsSnapshot.docs) {
          final picId = doc.data()['picdata'] as String;
          DocumentSnapshot<Map<String, dynamic>> picDataSnapshot =
              await FirebaseFirestore.instance
                  .collection("globalpics")
                  .doc(picId)
                  .get();

          // final picUrl = picDataSnapshot.data()?['pic_url'] as String?;
          final picUrl = {
            'pic_url': picDataSnapshot.data()?['pic_url'] as String?,
            'pid': picId
          };
          picUrls.add(picUrl);
        }
        print(picUrls.reversed.toList());
        _urlImages = picUrls.reversed.toList();
        notifyListeners();
      } catch (e) {
        print("Error fetching data: $e");
      }
    }
  }

  void resetUsers() {
    loadImages();
  }
}

class Pics {
  final String id;
  final String name;
  final String url;

  const Pics(this.id, this.name, this.url);
}

class Camerapic {
  // final String id;
  final File filename;
  final String id;
  const Camerapic(this.id, this.filename);
}

// class OutFitDetails {
//   final String link;
//   final String heignt;
//   final String size;
//   final String Gender;
//   OutFitDetails(this.Gender, this.link, this.heignt, this.size);
// }

class Backend with ChangeNotifier {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  final Storage serverstorage = Storage();

  final List<Camerapic> _list = [];

  List<Camerapic> get list {
    return [..._list];
  }

  final List<Pics> _piclist = [];

  List<Pics> get piclist {
    return [..._piclist];
  }

  final List _piclistnames = [];

  List<String> get piclistnames {
    return [..._piclistnames];
  }

  Future g(String picName, String uid) async {
    String b;
    var a = await storage.ref().child('pics/$uid/$picName').getDownloadURL();
    return a;
  }

  // Future<void> upload(temp, uid, picName, a) async {
  //   if (temp.isNotEmpty) {
  //     var namedata = FirebaseFirestore.instance
  //         .collection("users/8x907mNurAgZ2xvma1DG/user_data")
  //         .doc(uid);
  //     namedata.get().then((v) async {
  //       // print(v.data["user_name"]);
  //       await FirebaseFirestore.instance
  //           .collection("pics/ClpYg741V8dpWjzfq661/Pics_data")
  //           .add({
  //         "pic_name": picName,
  //         "pic_url": temp,
  //         "uid": uid,
  //         "user_name": v.data()!["user_name"],
  //         "comments": [],
  //         "ratings": {},
  //         "link": a.link,
  //         "height": a.heignt,
  //         "size": a.size,
  //         "Gender": a.Gender,
  //       });
  //     });
  //     print("done");
  //   } else {
  //     print("list is empty idiot try to figure out");
  //     // upload(temp, uid, picName, a);
  //   }
  // }

  // void uploadfile(List picName, String id, String uid, OutFitDetails a) {
  //   List temp = [];
  //   picName.forEach((element) async {
  //     String imagename = element.toString().split("cache/")[1];
  //     File file = File(element.toString());
  //     try {
  //       var ref = storage.ref().child('pics/$imagename');
  //       await ref.putFile(file).whenComplete(() async {
  //         await ref.getDownloadURL().then((value) {
  //           temp.add(value);
  //         });
  //       });
  //       print(temp);
  //     } on Exception catch (e) {
  //       print(e);
  //     }
  //   });
  //   Future.delayed(const Duration(seconds: 5), () {
  //     upload(temp, uid, picName, a);
  //   });
  // }

  Future<void> upload_url_firestore(
      String picName, String id, String uid) async {
    print(picName);
    try {
      var str = await storage
          .ref()
          .child('pics/$uid/$picName')
          .getDownloadURL()
          .then((value) async {
        String picUrl = value;
        var namedata = FirebaseFirestore.instance.collection("users").doc(uid);
        namedata.get().then((v) async {
          // print(v.data["user_name"]);
          // await FirebaseFirestore.instance.collection("pics").doc(picName).set({
          //   "pic_name": picName,
          //   "pic_url": picUrl,
          //   "uid": uid,
          //   "user_name": v.data()!["user_name"],
          //   "right": 0,
          //   "left": 0,
          // });
          // await FirebaseFirestore.instance
          //     .collection("users/$uid")
          //     .doc('sent_pic')
          //     .set({
          //   "pic_name": picName,
          //   "pic_url": picUrl,
          //   "uid": uid,
          //   "user_name": v.data()!["user_name"],
          //   "right": 0,
          //   "left": 0,
          // });
        });

        return picUrl;
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> upload_Dp_url_firestore(
      String picName, String id, String uid) async {
    print(picName);
    try {
      var str = await storage
          .ref()
          .child('pics/$picName')
          .getDownloadURL()
          .then((value) async {
        // print(value.toString() + " " + "value is empty");
        String picUrl = value;
        var namedata = FirebaseFirestore.instance
            .collection("users/8x907mNurAgZ2xvma1DG/user_data")
            .doc(uid);
        namedata.get().then((v) async {
          // print(v.data["user_name"]);
          // await Firestore.instance
          //     .collection("pics/ClpYg741V8dpWjzfq661/Pics_data")
          //     .add({
          //   "pic_name": picName,
          //   "pic_url": picUrl,
          //   "uid": uid,
          //   "user_name": v.data["user_name"],
          //   "comments": [],
          //   "ratings": {},
          // });
          namedata.update({"DpUrl": picUrl});
        });
        // namedata.updateData({"DpUrl": picUrl});

        return picUrl;
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> remove_url_firestore(
      String picName, String id, String uid) async {
    print(picName);
    try {
      var str = await storage
          .ref()
          .child('pics/$uid/$picName')
          .getDownloadURL()
          .then((value) async {
        // print(value.toString() + " " + "value is empty");
        String picUrl = value;
        FirebaseFirestore.instance
            .collection("pics/ClpYg741V8dpWjzfq661/Pics_data");

        return picUrl;
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  void length_of_pic() {
    List<Pics> templist3 = [];
    final datalist = FirebaseFirestore.instance
        .collection("pics/ClpYg741V8dpWjzfq661/Pics_data")
        .snapshots()
        .length
        .then((value) => print(value));
  }

  getuserid() {
    User? uid;
    FirebaseAuth.instance.authStateChanges().forEach((element) {
      // print(element.uid.toString());
      uid = element;
      // print(element.uid.toString() + " " +"hi");
    });
    // print(uid);
    return uid;
  }

  Future demo(List l) async {
    var a;
    for (var element in l) {
      a = element;
    }
    return a;
  }
}
