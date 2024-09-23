import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignInPage extends StatefulWidget {
  static const routepage = "/Sign_in";
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final auth = FirebaseAuth.instance;

  final _formkey = GlobalKey<FormState>();

  String name = "";

  String user_name = "";

  String email = "";

  String password = "";

  String confirm_password = "";

  final myControllername = TextEditingController();
  final myControlleruser_name = TextEditingController();
  final myControlleremail = TextEditingController();
  final myControllerpassword = TextEditingController();

  void _submitauthform(
    String name,
    String userName,
    String email,
    String password,
  ) async {
    UserCredential authresult;
    try {
      if (myControllername.text == null &&
          myControlleruser_name.text == null &&
          myControlleremail.text == null &&
          myControllerpassword.text == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(seconds: 2),
            content: Text("Enter the details to Sign In",
                textAlign: TextAlign.center)));
      }
      print("here is the proublem");
      authresult = await auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      await FirebaseFirestore.instance
          .collection("users")
          .doc(authresult.user?.uid)
          .set({
        "DpUrl": "none",
        "name": name,
        "user_name": userName,
        "email": email,
        "password": password,
        "auth_id": authresult.user?.uid,
        "friends": {
          "friends": "0",
          "friends ids": [],
        },
        "chat": [],
        "notifications": {
          "friend req": [],
        },
      });
      // await Firestore.instance
      //     .collection("users/8x907mNurAgZ2xvma1DG/user_data")
      //     .document(authresult.user.uid)
      //     .collection("chats");

      print("done");
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void>? _formvalid() {
    final isvalid = _formkey.currentState?.validate();
    FocusScope.of(context).unfocus();
    if (isvalid!) {
      _formkey.currentState?.save();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 10, 10),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                child: Text(
                  "Sign In",
                  style: TextStyle(
                      color: Colors.white, fontSize: size.height / 20),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: size.height / 22),
            child: Form(
              key: _formkey,
              child: SizedBox(
                child: Column(children: [
                  Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: size.height / 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10)),
                                height: size.height / 17,
                                width: size.width / 1.2,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: size.width / 20,
                                  ),
                                  child: TextFormField(
                                    controller: myControllername,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: size.height / 40),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Name",
                                      hintStyle: TextStyle(
                                          color: Color.fromARGB(
                                              124, 255, 255, 255)),
                                    ),
                                    onSaved: (value) {
                                      name = value!;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: size.height / 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10)),
                                height: size.height / 17,
                                width: size.width / 1.2,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: size.width / 20,
                                  ),
                                  child: TextFormField(
                                    controller: myControlleruser_name,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: size.height / 40),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "User Name",
                                      hintStyle: TextStyle(
                                          color: Color.fromARGB(
                                              124, 255, 255, 255)),
                                    ),
                                    onSaved: (value) {
                                      user_name = value!;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: size.height / 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10)),
                                height: size.height / 17,
                                width: size.width / 1.2,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: size.width / 20,
                                  ),
                                  child: TextFormField(
                                    controller: myControlleremail,
                                    validator: (value) {
                                      if (value!.isEmpty ||
                                          !value.contains("@")) {
                                        return "please enter a valid email address";
                                      }
                                      return null;
                                    },
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: size.height / 40),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Email",
                                      hintStyle: TextStyle(
                                          color: Color.fromARGB(
                                              124, 255, 255, 255)),
                                    ),
                                    onSaved: (value) {
                                      email = value!;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: size.height / 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10)),
                                height: size.height / 17,
                                width: size.width / 1.2,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: size.width / 20,
                                  ),
                                  child: TextFormField(
                                    controller: myControllerpassword,
                                    validator: (value) {
                                      if (value!.isEmpty || value.length <= 6) {
                                        return "please enter a strong password (password length > 7)";
                                      }
                                      return null;
                                    },
                                    // obscureText: true,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: size.height / 40),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Password",
                                      hintStyle: TextStyle(
                                          color: Color.fromARGB(
                                              124, 255, 255, 255)),
                                    ),
                                    onSaved: (value) {
                                      password = value!.trim();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: size.height / 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10)),
                                height: size.height / 17,
                                width: size.width / 1.2,
                                child: Container(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: size.width / 20,
                                    ),
                                    child: TextFormField(
                                      validator: ((value) {
                                        if (value !=
                                            myControllerpassword.text) {
                                          print("wrong");
                                          return "enter the same password";
                                        }
                                        return null;
                                      }),
                                      // obscureText: true,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: size.height / 40),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Confirm Password",
                                        hintStyle: TextStyle(
                                            color: Color.fromARGB(
                                                124, 255, 255, 255)),
                                      ),
                                      onSaved: (value) {
                                        confirm_password = value!.trim();
                                      },
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
                  SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          child: Container(
                            height: size.height / 18,
                            width: size.width / 3,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(50)),
                            child: TextButton(
                              onPressed: () async {
                                await _formvalid();
                                _submitauthform(
                                    name, user_name, email, password);
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                    fontSize: size.height / 40,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          )
        ],
      ),
    );
  }
}
