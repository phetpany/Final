import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:getapi/admin/states/add_group.dart';
import 'package:getapi/admin/states/authen.dart';
import 'package:getapi/firebase_options.dart';
import 'package:getapi/screen/admin_profile.dart';
import 'package:getapi/screen/auth_page.dart';
import 'package:getapi/screen/home_page.dart';

String? initRoute;
List<GetPage<dynamic>> getPages = [
  GetPage(name: '/authen', page: () => const Authen(),),
  GetPage(name: '/user', page: () => const HomePage(),),
  GetPage(name: '/admin', page: () => const AdminPage(),),
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Check if the user is logged in
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? email = prefs.getString('email');
  String? password = prefs.getString('password');

  if (email != null && password != null) {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      // Assume we have a function to get the user role
      String? userRole = await getUserRole(FirebaseAuth.instance.currentUser);

      if (userRole == 'admin') {
        initRoute = '/admin';
      } else {
        initRoute = '/user';
      }
    } catch (e) {
      initRoute = '/authen';
    }
  } else {
    initRoute = '/authen';
  }

  runApp(MyApp());
}

Future<String?> getUserRole(User? user) async {
  // Add logic to get user role from Firebase or other source
  // For example, fetching from Firestore
  // For now, return a dummy role for demonstration purposes
  if (user != null) {
    // Example: check user's email for role (this should be replaced with actual logic)
    if (user.email == 'admin@gmail.com') {
      return 'admin';
    } else {
      return 'user';
    }
  }
  return null;
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: getPages,
      initialRoute: initRoute ?? '/authen', 
    );
  }
}
