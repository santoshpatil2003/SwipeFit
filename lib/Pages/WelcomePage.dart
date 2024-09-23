import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/LogIn.dart';
import 'package:flutter_application_1/Pages/SignIn.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

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
                  "Welcome to",
                  style: TextStyle(
                      color: Colors.white, fontSize: size.height / 20),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                child: Text(
                  "RateFit",
                  style: TextStyle(
                      color: Colors.white, fontSize: size.height / 20),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: size.height / 10),
            child: SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    child: Container(
                      height: size.height / 17,
                      width: size.width / 3,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(50)),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(SignInPage.routepage);
                        },
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                              fontSize: size.height / 40, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    child: Container(
                      height: size.height / 17,
                      width: size.width / 3,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(50)),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(LogInPage.routepage);
                        },
                        child: Text(
                          "Log In",
                          style: TextStyle(
                              fontSize: size.height / 40, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
