// // ignore_for_file: avoid_print

// import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// // import 'package:ratefit_firestore/helpers/storage_service.dart';
// import 'package:ratefit_firestore/pages/final_upload.dart';

// import '../providers/dataproviders.dart';

// class FinalUploadMulti extends StatefulWidget {
//   static const routepage = "/finaluploadmulti";
//   final String? imagepath;
//   const FinalUploadMulti({this.imagepath, Key? key}) : super(key: key);

//   @override
//   State<FinalUploadMulti> createState() => _FinalUploadMultiState();
// }

// class _FinalUploadMultiState extends State<FinalUploadMulti> {
//   final List<XFile> _selectimage = [];
//   final List _selectpath = [];
//   String? _selectname;
//   bool done = false;
//   int index = 1;
//   String? _selectsize = "For Everyone";

//   String? _selectsize2 = "S";

//   bool uploaded = false;

//   bool uploade = false;

//   List<String> l = [];
//   List<String> l2 = [];

//   Future _imagepick() async {
//     final List<XFile> image = await ImagePicker().pickMultiImage(
//       maxWidth: 600,
//     );
//     if (image.isEmpty) {
//       print("image is null");
//     } else {
//       print("image is present");
//     }
//     return image;
//   }

//   @override
//   void initState() {
//     super.initState();
//     _imagepick().then((value) {
//       if (value!.isNotEmpty) {
//         _selectimage.addAll(value);
//         value.forEach((each) {
//           _selectpath.add(each.path);
//         });
//         // _selectpath!.addAll(value.path);
//         _selectname = "pic${DateTime.now().toIso8601String()}";
//         setState(() {
//           done = true;
//         });
//       }
//     });
//   }

//   // uploading(snapshot, storage, uploadserver, OutFitDetails a) async {
//   //   if (snapshot.data!.uid != null) {
//   //     try {
//   //       setState(() {
//   //         uploade = true;
//   //       });
//   //       await storage.upload(_selectpath!, _selectpath!).then((value) async {
//   //         Future.delayed(const Duration(seconds: 5), () async {
//   //           await uploadserver(
//   //               _selectpath!, "1", snapshot.data!.uid.toString(), a);
//   //         });
//   //         Future.delayed(const Duration(seconds: 2), (() {
//   //           setState(() {
//   //             uploaded = true;
//   //           });
//   //         }));

//   //         Future.delayed(const Duration(seconds: 3), (() {
//   //           Navigator.of(context).pop();
//   //         }));
//   //       });
//   //     } on Exception catch (e) {
//   //       print(e);
//   //     }
//   //   }
//   // }
//   uploading2(snapshot, storage, uploadserver, OutFitDetails a) async {
//     if (snapshot.data!.uid != null) {
//       try {
//         setState(() {
//           uploade = true;
//         });
//         await storage.upload2(_selectname, _selectpath).then((value) async {
//           Future.delayed(const Duration(seconds: 8), () async {
//             await uploadserver(
//                 _selectpath, "1", snapshot.data!.uid.toString(), a);
//           });
//           Future.delayed(const Duration(seconds: 2), (() {
//             setState(() {
//               uploaded = true;
//             });
//           }));
//           Future.delayed(const Duration(seconds: 3), (() {
//             Navigator.of(context).pop();
//           }));
//         });
//       } on Exception catch (e) {
//         print(e);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final products = Provider.of<Products>(context, listen: false);
//     final fieldText = TextEditingController();
//     final fieldText2 = TextEditingController();
//     // final Storage storage = Storage();
//     // final uploadserver = products.upload_url_firestore2;
//     final uploadfile = products.uploadfile;
//     final size = MediaQuery.of(context).size;
//     l = const ["S", "M", "L"];
//     l2 = const ["Male", "Female", "For Everyone"];
//     // print(_selectpath);
//     // print(fieldText.text);
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: const Text("RateFit"),
//         backgroundColor: Colors.black,
//       ),
//       body: StreamBuilder<User?>(
//           stream: FirebaseAuth.instance.authStateChanges(),
//           builder: (context, snapshot) {
//             return SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Stack(
//                     children: [
//                       Padding(
//                         padding:
//                             const EdgeInsets.only(left: 10, right: 10, top: 2),
//                         child: Container(
//                           width: size.width,
//                           height: size.height / 2,
//                           decoration: const BoxDecoration(
//                               color: Color.fromARGB(255, 10, 10, 10),
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(20))),
//                           child: _selectimage.isEmpty
//                               ? const Center(
//                                   child: Text(
//                                     "Image not Found",
//                                     style: TextStyle(
//                                         fontSize: 20, color: Colors.grey),
//                                   ),
//                                 )
//                               : Stack(
//                                   alignment: AlignmentDirectional.topEnd,
//                                   children: [
//                                       PageView.builder(
//                                         onPageChanged: (value) {
//                                           setState(() {
//                                             index = value + 1;
//                                           });
//                                         },
//                                         physics: const BouncingScrollPhysics(),
//                                         itemCount: _selectimage.length,
//                                         itemBuilder: (context, index) {
//                                           return Image.file(
//                                             File(_selectimage[index].path),
//                                             fit: BoxFit.contain,
//                                             width: double.infinity,
//                                           );
//                                         },
//                                       ),
//                                       _selectimage.length == 1
//                                           ? Container()
//                                           : Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: Container(
//                                                 height: size.height / 35,
//                                                 width: size.width / 10,
//                                                 decoration: BoxDecoration(
//                                                     color: const Color.fromARGB(
//                                                         181, 0, 0, 0),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             7)),
//                                                 child: Column(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   children: [
//                                                     Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .center,
//                                                       children: [
//                                                         Text(
//                                                           "$index/${_selectimage.length}",
//                                                           style:
//                                                               const TextStyle(
//                                                                   color: Colors
//                                                                       .white),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                     ]),
//                         ),
//                       ),
//                       uploade == false
//                           ? Container()
//                           : Padding(
//                               padding: const EdgeInsets.only(top: 25),
//                               child: Uploading(
//                                 uploaded: uploaded,
//                               ),
//                             ),
//                     ],
//                   ),
//                   DefaultTabController(
//                     length: 1,
//                     child: SizedBox(
//                       height: size.height / 3.2,
//                       width: size.width,
//                       child: Column(
//                         children: [
//                           SizedBox(
//                             height: 50,
//                             child: AppBar(
//                                 backgroundColor: Colors.black,
//                                 bottom: const TabBar(
//                                   indicatorColor: Colors.cyan,
//                                   labelColor: Colors.cyan,
//                                   unselectedLabelColor:
//                                       Color.fromARGB(113, 255, 255, 255),
//                                   tabs: [
//                                     Tab(
//                                       child: Text("Dress Details"),
//                                     ),
//                                     // Tab(
//                                     //   child: Text("Accessories Details"),
//                                     // ),
//                                   ],
//                                 )),
//                           ),
//                           Expanded(
//                             child: TabBarView(
//                               children: [
//                                 // first tab bar view widget
//                                 Column(
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.only(
//                                           left: 0, top: 10),
//                                       child: Container(
//                                         width: size.width / 1.1,
//                                         height: 37,
//                                         decoration: BoxDecoration(
//                                           border: Border.all(
//                                               width: 0.1, color: Colors.white
//                                               // const Color.fromARGB(34, 255, 255, 255)
//                                               ),
//                                           color: const Color.fromARGB(
//                                               255, 10, 10, 10),
//                                           borderRadius:
//                                               BorderRadius.circular(5),
//                                         ),
//                                         child: Padding(
//                                             padding:
//                                                 const EdgeInsets.only(left: 10),
//                                             child: DropdownButtonFormField<
//                                                     String?>(
//                                                 hint: const Text(
//                                                   "Gender",
//                                                   style: TextStyle(
//                                                       color: Color.fromARGB(
//                                                           96, 255, 255, 255)),
//                                                 ),
//                                                 decoration:
//                                                     const InputDecoration(
//                                                         isDense: true,
//                                                         focusedBorder:
//                                                             InputBorder.none,
//                                                         enabledBorder:
//                                                             InputBorder.none),
//                                                 isExpanded: true,
//                                                 isDense: true,
//                                                 value: _selectsize.toString(),
//                                                 // itemHeight: l.length,
//                                                 items: l2
//                                                     .map<
//                                                             DropdownMenuItem<
//                                                                 String>>(
//                                                         (e) => DropdownMenuItem(
//                                                             value: e,
//                                                             child: Text(
//                                                               e,
//                                                               style: const TextStyle(
//                                                                   color: Colors
//                                                                       .white),
//                                                             )))
//                                                     .toList(),
//                                                 onChanged: ((value) {
//                                                   setState(() {
//                                                     _selectsize =
//                                                         value.toString();
//                                                   });
//                                                 }))),
//                                       ),
//                                     ),
//                                     Column(
//                                       children: [
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceAround,
//                                           children: [
//                                             Padding(
//                                               padding: const EdgeInsets.only(
//                                                   left: 0, top: 10),
//                                               child: Container(
//                                                 width: size.width / 2.4,
//                                                 height: 37,
//                                                 decoration: BoxDecoration(
//                                                   border: Border.all(
//                                                       width: 0.1,
//                                                       color: Colors.white
//                                                       // const Color.fromARGB(34, 255, 255, 255)
//                                                       ),
//                                                   color: const Color.fromARGB(
//                                                       255, 10, 10, 10),
//                                                   borderRadius:
//                                                       BorderRadius.circular(5),
//                                                 ),
//                                                 child: Padding(
//                                                     padding:
//                                                         const EdgeInsets.only(
//                                                             left: 10),
//                                                     child: DropdownButtonFormField<
//                                                             String>(
//                                                         hint: const Text(
//                                                           "Size",
//                                                           style: TextStyle(
//                                                               color: Color
//                                                                   .fromARGB(
//                                                                       96,
//                                                                       255,
//                                                                       255,
//                                                                       255)),
//                                                         ),
//                                                         decoration:
//                                                             const InputDecoration(
//                                                                 isDense: true,
//                                                                 focusedBorder:
//                                                                     InputBorder
//                                                                         .none,
//                                                                 enabledBorder:
//                                                                     InputBorder
//                                                                         .none),
//                                                         isExpanded: true,
//                                                         isDense: true,
//                                                         value: _selectsize2
//                                                             .toString(),
//                                                         // itemHeight: l.length,
//                                                         items: l
//                                                             .map<
//                                                                 DropdownMenuItem<
//                                                                     String>>((e) =>
//                                                                 DropdownMenuItem(
//                                                                     value: e,
//                                                                     child: Text(
//                                                                       e,
//                                                                       style: const TextStyle(
//                                                                           color:
//                                                                               Colors.white),
//                                                                     )))
//                                                             .toList(),
//                                                         onChanged: ((value) {
//                                                           setState(() {
//                                                             _selectsize2 = value
//                                                                 .toString();
//                                                           });
//                                                         }))),
//                                               ),
//                                             ),
//                                             Padding(
//                                               padding: const EdgeInsets.only(
//                                                   left: 0, top: 10),
//                                               child: Container(
//                                                 width: size.width / 2.4,
//                                                 height: 37,
//                                                 decoration: BoxDecoration(
//                                                   border: Border.all(
//                                                       width: 0.1,
//                                                       color: Colors.white
//                                                       // const Color.fromARGB(34, 255, 255, 255)
//                                                       ),
//                                                   color: const Color.fromARGB(
//                                                       255, 10, 10, 10),
//                                                   borderRadius:
//                                                       BorderRadius.circular(5),
//                                                 ),
//                                                 child: Padding(
//                                                   padding:
//                                                       const EdgeInsets.only(
//                                                           left: 10),
//                                                   child: TextFormField(
//                                                     controller: fieldText2,
//                                                     onFieldSubmitted: (value) {
//                                                       print(value);

//                                                       // fieldText.clear();
//                                                     },
//                                                     style: const TextStyle(
//                                                         color: Colors.white,
//                                                         fontSize: 15),
//                                                     decoration:
//                                                         const InputDecoration(
//                                                       border: InputBorder.none,
//                                                       hintStyle: TextStyle(
//                                                         fontSize: 15,
//                                                         color: Color.fromARGB(
//                                                             69, 255, 255, 255),
//                                                       ),
//                                                       hintText: 'Height in CM',
//                                                       enabled: true,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                               left: 0, top: 10),
//                                           child: Container(
//                                             width: size.width / 1.1,
//                                             height: 37,
//                                             decoration: BoxDecoration(
//                                               border: Border.all(
//                                                   width: 0.1,
//                                                   color: Colors.white
//                                                   // const Color.fromARGB(34, 255, 255, 255)
//                                                   ),
//                                               color: const Color.fromARGB(
//                                                   255, 10, 10, 10),
//                                               borderRadius:
//                                                   BorderRadius.circular(5),
//                                             ),
//                                             child: Padding(
//                                               padding: const EdgeInsets.only(
//                                                   left: 10),
//                                               child: TextFormField(
//                                                 restorationId: fieldText.text,
//                                                 controller: fieldText,
//                                                 // onFieldSubmitted: (value) {
//                                                 //   print(value);
//                                                 //   // comments(widget.documentid,
//                                                 //   //     snapshot.data?.uid, value);
//                                                 //   // fieldText.clear();
//                                                 // },
//                                                 style: const TextStyle(
//                                                     color: Colors.white,
//                                                     fontSize: 15),
//                                                 decoration:
//                                                     const InputDecoration(
//                                                   border: InputBorder.none,
//                                                   hintStyle: TextStyle(
//                                                     fontSize: 15,
//                                                     color: Color.fromARGB(
//                                                         69, 255, 255, 255),
//                                                   ),
//                                                   hintText: 'Link',
//                                                   enabled: true,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ],
//                                 ),

//                                 // second tab bar viiew widget
//                                 // Column(
//                                 //   children: [
//                                 //     Row(
//                                 //       mainAxisAlignment:
//                                 //           MainAxisAlignment.center,
//                                 //       children: [
//                                 //         Padding(
//                                 //           padding: const EdgeInsets.only(
//                                 //               left: 0, top: 10),
//                                 //           child: Container(
//                                 //             width: size.width / 1.1,
//                                 //             height: 37,
//                                 //             decoration: BoxDecoration(
//                                 //               border: Border.all(
//                                 //                   width: 0.1,
//                                 //                   color: Colors.white
//                                 //                   // const Color.fromARGB(34, 255, 255, 255)
//                                 //                   ),
//                                 //               color: const Color.fromARGB(
//                                 //                   255, 10, 10, 10),
//                                 //               borderRadius:
//                                 //                   BorderRadius.circular(5),
//                                 //             ),
//                                 //             child: Padding(
//                                 //               padding: const EdgeInsets.only(
//                                 //                   left: 10),
//                                 //               child: TextFormField(
//                                 //                 controller: fieldText,
//                                 //                 onFieldSubmitted: (value) {
//                                 //                   print(value);

//                                 //                   fieldText.clear();
//                                 //                 },
//                                 //                 style: const TextStyle(
//                                 //                     color: Colors.white,
//                                 //                     fontSize: 15),
//                                 //                 decoration:
//                                 //                     const InputDecoration(
//                                 //                   border: InputBorder.none,
//                                 //                   hintStyle: TextStyle(
//                                 //                     fontSize: 15,
//                                 //                     color: Color.fromARGB(
//                                 //                         69, 255, 255, 255),
//                                 //                   ),
//                                 //                   hintText: 'Link',
//                                 //                   enabled: true,
//                                 //                 ),
//                                 //               ),
//                                 //             ),
//                                 //           ),
//                                 //         )
//                                 //       ],
//                                 //     ),
//                                 //     Column(
//                                 //       children: [
//                                 //         Row(
//                                 //           mainAxisAlignment:
//                                 //               MainAxisAlignment.spaceAround,
//                                 //           children: [
//                                 //             Padding(
//                                 //               padding: const EdgeInsets.only(
//                                 //                   left: 0, top: 10),
//                                 //               child: Container(
//                                 //                 width: size.width / 2.4,
//                                 //                 height: 37,
//                                 //                 decoration: BoxDecoration(
//                                 //                   border: Border.all(
//                                 //                       width: 0.1,
//                                 //                       color: Colors.white
//                                 //                       // const Color.fromARGB(34, 255, 255, 255)
//                                 //                       ),
//                                 //                   color: const Color.fromARGB(
//                                 //                       255, 10, 10, 10),
//                                 //                   borderRadius:
//                                 //                       BorderRadius.circular(5),
//                                 //                 ),
//                                 //                 child: Padding(
//                                 //                   padding:
//                                 //                       const EdgeInsets.only(
//                                 //                           left: 10),
//                                 //                   child: TextFormField(
//                                 //                     controller: fieldText2,
//                                 //                     onFieldSubmitted: (value) {
//                                 //                       print(value);
//                                 //                       // comments(widget.documentid,
//                                 //                       //     snapshot.data?.uid, value);
//                                 //                       fieldText.clear();
//                                 //                     },
//                                 //                     style: const TextStyle(
//                                 //                         color: Colors.white,
//                                 //                         fontSize: 15),
//                                 //                     decoration:
//                                 //                         const InputDecoration(
//                                 //                       border: InputBorder.none,
//                                 //                       hintStyle: TextStyle(
//                                 //                         fontSize: 15,
//                                 //                         color: Color.fromARGB(
//                                 //                             69, 255, 255, 255),
//                                 //                       ),
//                                 //                       hintText: 'Height in CM',
//                                 //                       enabled: true,
//                                 //                     ),
//                                 //                   ),
//                                 //                 ),
//                                 //               ),
//                                 //             ),
//                                 //             Padding(
//                                 //               padding: const EdgeInsets.only(
//                                 //                   left: 0, top: 10),
//                                 //               child: Container(
//                                 //                 width: size.width / 2.4,
//                                 //                 height: 37,
//                                 //                 decoration: BoxDecoration(
//                                 //                   border: Border.all(
//                                 //                       width: 0.1,
//                                 //                       color: Colors.white
//                                 //                       // const Color.fromARGB(34, 255, 255, 255)
//                                 //                       ),
//                                 //                   color: const Color.fromARGB(
//                                 //                       255, 10, 10, 10),
//                                 //                   borderRadius:
//                                 //                       BorderRadius.circular(5),
//                                 //                 ),
//                                 //                 child: Padding(
//                                 //                     padding:
//                                 //                         const EdgeInsets.only(
//                                 //                             left: 10),
//                                 //                     child: DropdownButtonFormField<
//                                 //                             String?>(
//                                 //                         hint: const Text(
//                                 //                           "Gender",
//                                 //                           style: TextStyle(
//                                 //                               color: Color
//                                 //                                   .fromARGB(
//                                 //                                       96,
//                                 //                                       255,
//                                 //                                       255,
//                                 //                                       255)),
//                                 //                         ),
//                                 //                         decoration:
//                                 //                             const InputDecoration(
//                                 //                                 isDense: true,
//                                 //                                 focusedBorder:
//                                 //                                     InputBorder
//                                 //                                         .none,
//                                 //                                 enabledBorder:
//                                 //                                     InputBorder
//                                 //                                         .none),
//                                 //                         isExpanded: true,
//                                 //                         isDense: true,
//                                 //                         value: _selectsize,
//                                 //                         // itemHeight: l.length,
//                                 //                         items: l2
//                                 //                             .map<
//                                 //                                 DropdownMenuItem<
//                                 //                                     String?>>((e) =>
//                                 //                                 DropdownMenuItem(
//                                 //                                     value: e,
//                                 //                                     child: Text(
//                                 //                                       e,
//                                 //                                       style: const TextStyle(
//                                 //                                           color:
//                                 //                                               Colors.white),
//                                 //                                     )))
//                                 //                             .toList(),
//                                 //                         onChanged: ((value) {
//                                 //                           setState(() {
//                                 //                             _selectsize = value
//                                 //                                 .toString();
//                                 //                           });
//                                 //                         }))),
//                                 //               ),
//                                 //             )
//                                 //           ],
//                                 //         ),
//                                 //       ],
//                                 //     ),
//                                 //   ],
//                                 // ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 10),
//                     child: SizedBox(
//                       width: size.width,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           _selectimage.isEmpty
//                               ? Container()
//                               : Padding(
//                                   padding: const EdgeInsets.only(left: 10),
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       setState(() {
//                                         uploade = true;
//                                       });
//                                       OutFitDetails a = OutFitDetails(
//                                         _selectsize.toString(),
//                                         fieldText.text,
//                                         fieldText2.text,
//                                         _selectsize2.toString(),
//                                       );
//                                       uploadfile(_selectpath, "1",
//                                           snapshot.data!.uid, a);
//                                       Future.delayed(const Duration(seconds: 2),
//                                           (() {
//                                         setState(() {
//                                           uploaded = true;
//                                         });
//                                       }));
//                                       Future.delayed(const Duration(seconds: 3),
//                                           (() {
//                                         Navigator.of(context).pop();
//                                       }));
//                                     },
//                                     child: Container(
//                                       height: 35,
//                                       width: 90,
//                                       decoration: BoxDecoration(
//                                           color: Colors.cyan,
//                                           borderRadius:
//                                               BorderRadius.circular(20)),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceAround,
//                                         children: const [
//                                           Text(
//                                             "Upload",
//                                             style:
//                                                 TextStyle(color: Colors.white),
//                                           ),
//                                           Icon(
//                                             Icons.upload_rounded,
//                                             color: Colors.white,
//                                             size: 20,
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }),
//     );
//   }
// }

// // class OutFitDetails {
// //   final String link;
// //   final String heignt;
// //   final String size;
// //   OutFitDetails(this.link, this.heignt, this.size);
// // }

// class Uploading extends StatefulWidget {
//   final bool? uploaded;
//   const Uploading({Key? key, this.uploaded}) : super(key: key);

//   @override
//   State<Uploading> createState() => _UploadingState();
// }

// class _UploadingState extends State<Uploading> {
//   // bool sent = false;
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(top: 10),
//           child: Container(
//             decoration: BoxDecoration(
//                 color: Colors.cyan, borderRadius: BorderRadius.circular(20)),
//             height: 40,
//             width: 100,
//             child: Padding(
//               padding: const EdgeInsets.only(left: 0),
//               child: Row(
//                 mainAxisAlignment: widget.uploaded == false
//                     ? MainAxisAlignment.spaceAround
//                     : MainAxisAlignment.center,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(right: 0),
//                     child: widget.uploaded == false
//                         ? const Text(
//                             "Uploading",
//                             style: TextStyle(color: Colors.white),
//                           )
//                         : const Text(
//                             "Uploaded",
//                             style: TextStyle(color: Colors.white),
//                           ),
//                   ),
//                   widget.uploaded == false
//                       ? SizedBox(
//                           height: 15,
//                           width: 15,
//                           child: CircularProgressIndicator(
//                             value: widget.uploaded == false ? null : 0,
//                           ),
//                         )
//                       : Container()
//                 ],
//               ),
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }
