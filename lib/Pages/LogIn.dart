import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LogInPage extends StatefulWidget {
  static const routepage = "/Log_in";
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final auth = FirebaseAuth.instance;

  final _formkey = GlobalKey<FormState>();

  String email = "";

  String password = "";

  final myControlleremail = TextEditingController();
  final myControllerpassword = TextEditingController();

  void _submitauthform(
    String email,
    String password,
  ) async {
    UserCredential authresult;
    try {
      if (myControlleremail.text == null && myControllerpassword.text == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(seconds: 2),
            content: Text("Enter the details to Sign In",
                textAlign: TextAlign.center)));
      }
      print("here is the proublem");
      authresult = await auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
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
      print(email);
      print(password);
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
                  "Log In",
                  style: TextStyle(
                      color: Colors.white, fontSize: size.height / 20),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: size.height / 20),
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
                                _submitauthform(email, password);
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "Log In",
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
