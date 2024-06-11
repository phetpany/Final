// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:getapi/components/my_botton.dart';
import 'package:getapi/components/my_textfield.dart';
import 'package:getapi/components/square_tile.dart';
import 'package:getapi/services/auth_services.dart';

class LogInPage extends StatefulWidget {
  final Function()? onTap;

  LogInPage({Key? key, required this.onTap}) : super(key: key);

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn(BuildContext context) async {
  showDialog(
    context: context,
    builder: (context) {
      return Center(
        child: CircularProgressIndicator(),
      );
    },
  );

  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );
    
    Navigator.pop(context);
  } on FirebaseAuthException catch (e){
    Navigator.pop(context);
    showErrorMessage(e.code);

  }
  }

  void showErrorMessage(String message){
    showDialog(context: context, builder: (context){
    return AlertDialog(
      backgroundColor: Colors.blue[900],
      title: Center(child: Text(message),),
    );
    });
  }
  




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Icon(
                  Icons.person,
                  size: 100,
                  color: Colors.blue[900],
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Welcome to LPB login for more interesting places",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                      fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                MyTextfield(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                ),
                SizedBox(
                  height: 10,
                ),
                MyTextfield(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Forgot Password",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                MyBotton(
                  text: "SignIn",
                  onTap: () => signUserIn(context), // Pass context here
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          "Or continue with ",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey.shade400,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(
                      onTap: () => AuthService().singInWithGoogle(),
                      imagePath: "assets/images/Google.png"),
                    SizedBox(
                      width: 10,
                    ),
                    SquareTile(
                      onTap: () {} ,
                      imagePath: "assets/images/Facebook_Logo.png"),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Not a member"),
                    SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Register now",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
