import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:getapi/admin/models/advertise_model.dart';
import 'package:getapi/admin/models/group_model.dart';
import 'package:getapi/admin/models/places_model.dart';
import 'package:getapi/admin/models/user_model.dart';
import 'package:getapi/admin/unity/app_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AppService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final AppContrller appContrller = Get.put(AppContrller());
  final RxList<UserModel> currentUserModels = <UserModel>[].obs;

  // Photo handling methods
  Future<void> processTakePhoto({required ImageSource source}) async {
    var result = await ImagePicker().pickImage(
      source: source,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (result != null) {
      File file = File(result.path);
      String nameFile = basename(file.path);

      appContrller.files.add(file);
      appContrller.nameFiles.add(nameFile);
      appContrller.display.value = false;
    }
  }

  Future<void> processTakePhotoMulti() async {
    await ImagePicker().pickMultiImage(maxWidth: 800, maxHeight: 800).then((value) {
      if (value.isNotEmpty) {
        appContrller.xFiles.addAll(value);
      }
    });
  }

  Future<String?> processUploadImage({
    required String path,
    File? file,
    String? nameFile,
  }) async {
    String? urlImage;
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    Reference reference = firebaseStorage.ref().child('$path/${nameFile ?? appContrller.nameFiles.last}');
    UploadTask task = reference.putFile(file ?? appContrller.files.last);

    await task.whenComplete(() async {
      urlImage = await reference.getDownloadURL();
    });
    return urlImage;
  }

  // Firestore operations for groups
  Future<void> processInsertGroup({required GroupModel groupModel}) async {
    await FirebaseFirestore.instance.collection('group').doc().set(groupModel.toMap());
  }

  Future<void> processReadAllGroup() async {
    FirebaseFirestore.instance.collection('group').orderBy('nameGroup', descending: true).get().then((value) {
      if (appContrller.groupModels.isNotEmpty) {
        appContrller.groupModels.clear();
        appContrller.docIDGroups.clear();
        appContrller.indexs.clear();
      }

      if (value.docs.isNotEmpty) {
        int i = 0;
        for (var element in value.docs) {
          GroupModel groupModel = GroupModel.fromMap(element.data());
          appContrller.groupModels.add(groupModel);
          appContrller.docIDGroups.add(element.id);
          appContrller.indexs.add(i);
          i++;
        }
      }
    });
  }

  Future<void> processUpdateGroup({required String docId, required GroupModel groupModel}) async {
    try {
      await FirebaseFirestore.instance.collection('group').doc(docId).update(groupModel.toMap());
    } catch (e) {
      print('Error updating group: $e');
    }
  }

  Future<void> processDeleteGroup({required String docId}) async {
    try {
      await FirebaseFirestore.instance.collection('group').doc(docId).delete();
    } catch (e) {
      print('Error deleting group: $e');
    }
  }

  // Firestore operations for places
  Future<void> processReadAllPlace() async {
  await FirebaseFirestore.instance.collection('places').get().then((value) {
    if (appContrller.placesModels.isNotEmpty) {
      appContrller.placesModels.clear();
    }

    if (value.docs.isNotEmpty) {
      for (var element in value.docs) {
        PlacesModel placesModel = PlacesModel.fromMap(element.data(), element.id);
        appContrller.placesModels.add(placesModel);
      }
    }
  });
}


  Future<void> processDeletePlace(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('places').doc(docId).delete();
      Get.snackbar('Delete Success', 'Place has been deleted');
    } catch (e) {
      Get.snackbar('Delete Failed', 'Failed to delete the place');
    }
  }

  Future<void> processUpdatePlace(String docId, PlacesModel updatedPlace) async {
    try {
      await FirebaseFirestore.instance.collection('places').doc(docId).update(updatedPlace.toMap());
      Get.snackbar('Update Success', 'Place has been updated');
    } catch (e) {
      Get.snackbar('Update Failed', 'Failed to update the place');
    }
  }

  // URL launcher
  Future<void> processLaunchUrl({required String url}) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Cannot Open URL';
    }
  }

  // Authentication methods
  Future<void> processCheckAuthen({required String email, required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      String uid = userCredential.user!.uid;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email);
      await prefs.setString('password', password);

      String? userRole = await getUserRole(_firebaseAuth.currentUser);

      if (userRole == 'admin') {
        Get.offAllNamed('/admin');
      } else {
        Get.offAllNamed('/user');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> processLogout() async {
    await _firebaseAuth.signOut();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');

    Get.offAllNamed('/authen');
  }

  Future<String?> getUserRole(User? user) async {
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore.instance.collection('user').doc(user.uid).get();
      if (userDoc.exists) {
        UserModel userModel = UserModel.fromMap(userDoc.data()!);
        return userModel.typeUser;
      }
    }
    return null;
  }

  Future<void> processRouteToState({required String docIdUser}) async {
    DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore.instance.collection('user').doc(docIdUser).get();
    UserModel userModel = UserModel.fromMap(userDoc.data()!);
    currentUserModels.add(userModel);
    Get.offAllNamed('/${userModel.typeUser}');
    Get.snackbar('Authen Success', 'Welcome to MyApp');
  }

  Future<void> processCreateNewAccount({required String name, required String email, required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      String uid = userCredential.user!.uid;
      UserModel userModel = UserModel(name: name, email: email, password: password, typeUser: 'user');
      await FirebaseFirestore.instance.collection('user').doc(uid).set(userModel.toMap());
      Get.back();
      Get.snackbar('Create Account Success', 'Thank You');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> _saveCredentials({required String email, required String password}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  Future<Map<String, String>?> _getSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final password = prefs.getString('password');
    if (email != null && password != null) {
      return {'email': email, 'password': password};
    }
    return null;
  }

  Future<void> autoLogin() async {
    final savedCredentials = await _getSavedCredentials();
    if (savedCredentials != null) {
      await processCheckAuthen(
        email: savedCredentials['email']!,
        password: savedCredentials['password']!,
      );
    }
  }

  // Firestore operations for advertisements
  Future<void> processInsertAdvertise({required AdvertiseModel advertiseModel}) async {
    await FirebaseFirestore.instance.collection('advertise').doc().set(advertiseModel.toMap());
  }

  Future<void> processReadAllAdvertise() async {
    FirebaseFirestore.instance.collection('advertise').orderBy('nameAdvertise', descending: true).get().then((value) {
      if (appContrller.advertiseModels.isNotEmpty) {
        appContrller.advertiseModels.clear();
        appContrller.indexs.clear();
      }

      if (value.docs.isNotEmpty) {
        int i = 0;
        for (var element in value.docs) {
          AdvertiseModel advertiseModel = AdvertiseModel.fromMap(element.data());
          appContrller.advertiseModels.add(advertiseModel);
          appContrller.indexs.add(i);
          i++;
        }
      }
    });
  }


  
}
