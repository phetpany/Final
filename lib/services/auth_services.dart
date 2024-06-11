// ignore_for_file: unused_import

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService{
   singInWithGoogle() async{
    // final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    // final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    // final credential = GoogleAuthProvider.credential(
    //   accessToken: gAuth.accessToken,
    //   idToken: gAuth.idToken,
    // );
    // return await  FirebaseAuth.instance.signInWithCredential(credential);
    GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: 'your-client_id.apps.googleusercontent.com',
  scopes: <String>[
  'email',
  'https://www.googleapis.com/auth/contacts.readonly',
],
);
await Firebase.initializeApp().then((value) async {
await _googleSignIn.signIn().then((value) {
print("Login whith gmail seccess");
});

});

      }
}