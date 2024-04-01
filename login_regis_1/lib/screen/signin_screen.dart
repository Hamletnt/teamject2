import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_regis/reusable_widgets/reusable_widgets.dart';
import 'package:login_regis/screen/HomeReal.dart';
import 'package:login_regis/screen/signup_screen.dart';
import 'package:login_regis/utils/color_utils.dart';
import 'package:login_regis/main.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        hexStringToColor("CB2B93"),
        hexStringToColor("9546C4"),
        hexStringToColor("5E61F4"),
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            20, MediaQuery.of(context).size.height * 0.2, 20, 0),
        child: Column(
          children: <Widget>[
            reusableTextField("Enter Email", Icons.person_outline, false,
                _emailTextController),
            SizedBox(
              height: 30,
            ),
            reusableTextField("Enter Password", Icons.lock_outline, true,
                _passwordTextController),
            SizedBox(
              height: 20,
            ),
            SignInSignUpButton(context, true, () async {
              try {
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: _emailTextController.text,
                    password: _passwordTextController.text);
                print("Sign in successful");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyHomePage(
                              title: 'Your App Title',
                            )));
              } on FirebaseAuthException catch (e) {
                String errorMessage =
                    'An error occurred, please try again later.';
                if (e.code == 'user-not-found') {
                  errorMessage = 'No user found for that email.';
                } else if (e.code == 'wrong-password') {
                  errorMessage = 'Wrong password provided for that user.';
                }

                // Show error message
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Error"),
                      content: Text(errorMessage),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("OK"),
                        ),
                      ],
                    );
                  },
                );
              } catch (e) {
                // Handle other errors
                print("Error ${e.toString()}");
              }
            }),
            signUpOption()
          ],
        ),
      ),
    ));
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                // ignore: prefer_const_constructors
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}