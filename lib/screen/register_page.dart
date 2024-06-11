// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:getapi/components/my_botton.dart';
import 'package:getapi/components/my_textfield.dart';
import 'package:getapi/components/square_tile.dart';
import 'package:getapi/services/auth_services.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  RegisterPage({Key? key, required this.onTap}) : super(key: key);
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
    final usernameController = TextEditingController();


  Future<void> signUserUp(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
         

    try {
      if (passwordController.text == confirmPasswordController.text) {
        // Create user with email and password
           UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        Navigator.pop(context);
       FirebaseFirestore.instance.
       collection('user').
       doc(userCredential.user!.email).
       set({
        'username':usernameController.text,
        'bio':"Enter your Bio here..."
       });
        // Registration successful
        
      } 
      
      else {
        Navigator.pop(context);
        showErrorMessage("Passwords don't match!");
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showErrorMessage(e.code);
    }
    
  }
  Future addUser(
    String username ,String email, String password, String TypeUser
  ) async{
    FirebaseFirestore.instance.collection('users').add(
      {
        'username': username,
        'email':email,
        'password':password,
        'TypeUser': TypeUser,
      }
    );
  }

  void showErrorMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.blue[900],
            title: Center(
              child: Text(
                message,
              ),
            ),
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
                  Icons.lock,
                  size: 80,
                  color: Colors.blue[900],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Welcome to LPB Register for more interesting places",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                      fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                 MyTextfield(
                  controller: usernameController,
                  hintText: "Username",
                  obscureText: false,
                ),
                const SizedBox(
                  height: 10,
                ),
                MyTextfield(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                ),
                const SizedBox(
                  height: 10,
                ),
                MyTextfield(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                ),
               const  SizedBox(
                  height: 10,
                ),
                MyTextfield(
                  controller: confirmPasswordController,
                  hintText: "Confirm Password",
                  obscureText: true,
                ),
                
                const SizedBox(
                  height: 10,
                ),
                MyBotton(
                  text: "Sign Up",
                  onTap: () => signUserUp(context), // Pass context here
                ),
                const SizedBox(
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
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(
                      onTap: () async=> await AuthService().singInWithGoogle(),
                      imagePath: "assets/images/Google.png"),
                    const SizedBox(
                      width: 10,
                    ),
                    SquareTile(
                      onTap: (){},
                      imagePath: "assets/images/Facebook_Logo.png"),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account"),
                    const SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "LogIn",
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
