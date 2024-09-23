import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/CameraCustom.dart';
import 'package:flutter_application_1/Pages/LogIn.dart';
import 'package:flutter_application_1/Pages/Profile.dart';
import 'package:flutter_application_1/Pages/Send.dart';
import 'package:flutter_application_1/Pages/SignIn.dart';
import 'package:flutter_application_1/Pages/WelcomePage.dart';
import 'package:flutter_application_1/Pages/profilepicslist.dart';
import 'package:flutter_application_1/Provider/Provider.dart';
import 'package:flutter_application_1/Widgets/TinderCard.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

// ...
List<CameraDescription> cameras = [];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  cameras = await availableCameras();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CardProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => Backend(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swipefit',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        LogInPage.routepage: ((context) => const LogInPage()),
        SignInPage.routepage: ((context) => const SignInPage()),
        Send.routepage: (context) => const Send(),
        ProfilePics.routepage: (context) => const ProfilePics(),
      },
      home: Builder(builder: (context) {
        return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              // print(snapshot.data);
              if (snapshot.hasData) {
                return HomePage(uid: snapshot.data!.uid.toString());
              }
              return const WelcomePage();
            });
      }),
    );
  }
}

class HomePage extends StatefulWidget {
  final String uid;
  const HomePage({super.key, required this.uid});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final cardSize = const Size(300, 400);
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // Initialize _pages here
    _pages = [
      const Home(),
      CameraApp(
        camera: cameras,
      ),
      // Camera(uid: widget.uid),
      // const Center(child: Text('Profile Page')),
      const Profile(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update selected index
    });
  }

  Future<void> _refresh() async {
    // await FirebaseAuth.instance.signOut();
    // final provider = Provider.of<CardProvider>(context, listen: false);
    // provider.resetUsers();
    setState(() {});
  }

  void sign_out() async {
    await FirebaseAuth.instance.signOut();
    print('log out');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Swipefit',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 18, 18, 18),
        actions: [
          IconButton(
            onPressed: () => {sign_out()},
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _refresh,
      //   child: const Icon(Icons.refresh),
      // ),
      // bottomNavigationBar: ,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.add),
          //   label: 'camera',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex, // Set the current index
        selectedItemColor: Colors.white,
        showUnselectedLabels: false,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<CardProvider>(context, listen: false);
      provider.resetUsers();
    });
  }

  Future<void> _refresh() async {
    // final provider = Provider.of<CardProvider>(context, listen: false);
    // provider.resetUsers();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: Colors.blue,
        backgroundColor: Colors.white,
        child: Consumer<CardProvider>(
          builder: (context, provider, child) {
            return CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverFillRemaining(
                  child: provider.urlImages.isEmpty
                      ? Center(
                          child: ElevatedButton(
                            onPressed: _refresh,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 18, 18, 18),
                            ),
                            child: const Text('Empty Feed'),
                          ),
                        )
                      : Stack(
                          fit: StackFit.expand,
                          children: provider.urlImages
                              .map((urlImage) {
                                final picUrl = urlImage['pic_url'];
                                final pid = urlImage['pid'];
                                if (picUrl == null || pid == null) {
                                  // Skip this item if required data is missing
                                  return const Center(
                                    child: Text(
                                      "No Picture",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                }
                                return TinderCard(
                                  urlImage: picUrl,
                                  isFront: provider.urlImages.last == urlImage,
                                  prid: pid,
                                );
                              })
                              .whereType<Widget>() // Filter out null widgets
                              .toList(),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}












// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   final cardSize = const Size(300, 400);
//   List pic_urls_list = [];
//   String uid1 = '';
//   Future<void> _refresh() async {
//     // final provider = Provider.of<CardProvider>(context, listen: false);
//     // provider.resetUsers();
//     setState(() {});
//   }

//   @override
//   void initState() {
//     super.initState();

//     // Listen to authentication changes
//     FirebaseAuth.instance.authStateChanges().listen((User? user) async {
//       if (user != null) {
//         final uid = user.uid;
//         try {
//           // Fetch received pictures from Firestore
//           QuerySnapshot<Map<String, dynamic>> receivedPicsSnapshot =
//               await FirebaseFirestore.instance
//                   .collection("users")
//                   .doc("P0cEzZReQrX9jEBPzwHeJ6eeNIT2")
//                   .collection('recivedpics')
//                   .get();

//           // Prepare a list to store picture URLs
//           List<String> picUrls = [];

//           // Fetch picture data for each received picture
//           for (var doc in receivedPicsSnapshot.docs) {
//             final picId = doc.data()['picdata'] as String;
//             DocumentSnapshot<Map<String, dynamic>> picDataSnapshot =
//                 await FirebaseFirestore.instance
//                     .collection("globalpics")
//                     .doc(picId)
//                     .get();

//             // Add picture URL to the list
//             final picUrl = picDataSnapshot.data()?['pic_url'] as String?;
//             if (picUrl != null) {
//               picUrls.add(picUrl);
//             }
//           }

//           // Update state after fetching all data
//           if (mounted) {
//             // Ensure the widget is still mounted before calling setState
//             setState(() {
//               uid1 = uid;
//               pic_urls_list = picUrls;
//             });
//           }
//         } catch (e) {
//           print("Error fetching data: $e");
//         }
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // print("Pic Urls: $pic_urls_list");
//     // print("Uid: $uid1");
//     return RefreshIndicator(
//       onRefresh: _refresh,
//       backgroundColor: Colors.black,
//       child: Consumer<CardProvider>(
//         builder: (context, provider, child) {
//           if (pic_urls_list.isEmpty) {
//             return Container(
//               color: Colors.black,
//               child: const Center(
//                 child: Text('Reset Cards'),
//                 // ElevatedButton(
//                 //   onPressed: () => provider.resetUsers(),
//                 //   style: ElevatedButton.styleFrom(
//                 //     backgroundColor: const Color.fromARGB(255, 18, 18, 18),
//                 //   ),
//                 //   child: const Text('Reset Cards'),
//                 // ),
//               ),
//             );
//           } else {
//             return Container(
//               color: Colors.black,
//               child: Stack(
//                 children: pic_urls_list
//                     .map((urlImage) => TinderCard(
//                           urlImage: urlImage,
//                           isFront: pic_urls_list.last == urlImage,
//                           cardSize: cardSize,
//                         ))
//                     .toList(),
//                 // children: provider.urlImages
//                 //     .map((urlImage) => TinderCard(
//                 //           urlImage: urlImage,
//                 //           isFront: provider.urlImages.last == urlImage,
//                 //           cardSize: cardSize,
//                 //         ))
//                 //     .toList(),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// class Home extends StatefulWidget {
//   const Home({Key? key}) : super(key: key);

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   var r = false;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     final provider = Provider.of<CardProvider>(context, listen: false);
//     provider.resetUsers();
//   }

//   // @override
//   // void didChangeDependencies() {
//   //   // TODO: implement didChangeDependencies
//   //   super.didChangeDependencies();
//   //   final provider = Provider.of<CardProvider>(context, listen: false);
//   //   provider.resetUsers();
//   // }

//   Future<void> _refresh() async {
//     setState(() {
//       r = !r;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return RefreshIndicator(
//       onRefresh: _refresh,
//       child: Consumer<CardProvider>(
//         builder: (context, provider, child) {
//           if (provider.urlImages.isEmpty) {
//             return Container(
//               color: Colors.black,
//               child: Center(
//                 child: ElevatedButton(
//                   onPressed: () => _refresh,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color.fromARGB(255, 18, 18, 18),
//                   ),
//                   child: const Text('Reset Cards'),
//                 ),
//               ),
//             );
//           } else {
//             print(provider.urlImages.length);
//             return Container(
//               color: Colors.black,
//               child: Stack(
//                 children: provider.urlImages
//                     .map((urlImage) => TinderCard(
//                           urlImage: urlImage,
//                           isFront: provider.urlImages.last == urlImage,
//                         ))
//                     .toList(),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
