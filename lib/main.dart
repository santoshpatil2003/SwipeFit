import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/CameraCustom.dart';
import 'package:flutter_application_1/Pages/LogIn.dart';
import 'package:flutter_application_1/Pages/Profile.dart';
import 'package:flutter_application_1/Pages/Send.dart';
import 'package:flutter_application_1/Pages/SignIn.dart';
import 'package:flutter_application_1/Pages/Store.dart';
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
      const StorePage(),
      CameraApp(
        camera: cameras,
      ),
      // Camera(uid: widget.uid),
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
        type: BottomNavigationBarType.fixed, // Add this line
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront),
            label: 'Store',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Camera',
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
