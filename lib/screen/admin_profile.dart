import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getapi/admin/states/add_advertise.dart';
import 'package:getapi/admin/states/add_group.dart';
import 'package:getapi/admin/states/add_places.dart';
import 'package:getapi/admin/states/list_places.dart';
import 'package:getapi/admin/unity/app_controller.dart';
import 'package:getapi/admin/unity/app_service.dart';
import 'package:getapi/admin/widget/widget_button.dart';
import 'package:getapi/admin/widget/widget_text.dart';
import 'package:getapi/screen/search_static_page.dart';
import 'package:image_picker/image_picker.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  AppContrller appContrller = Get.put(AppContrller());
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    AdminHome(),
    UserProfile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          'Admin',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              await AppService().processLogout();
            },
            child: Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              textStyle: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}

class AdminHome extends StatelessWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildMenuButton(
            text: 'ເພີ່ມໝວດໝູ່',
            color: Colors.purple,
            onPressed: () => Get.to(AddGroup()),
          ),
          SizedBox(height: 16),
          buildMenuButton(
            text: 'ເພີ່ມສະຖານທີ່',
            color: Colors.blue,
            onPressed: () => Get.to(ListPlaces()),
          ),
          SizedBox(height: 16),
          buildMenuButton(
            text: 'ເພີ່ມສະຖານທີ່ໂຄສະນາ',
            color: Colors.green,
            onPressed: () => Get.to(Advertise()),
          ),
          SizedBox(height: 16),
          buildMenuButton(
            text: 'ສະຖິຕິການຄົ້ນຫາສະຖານທີ່',
            color: Color.fromARGB(255, 227, 114, 95),
            onPressed: () => Get.to(SearchStatisticsPage()),
          ),
        ],
      ),
    );
  }

  Widget buildMenuButton({
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: Get.width * 0.8,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class UserProfile extends StatelessWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      
      body: user != null
          ? UserInfo(user: user)
          : Center(child: Text('User not logged in')),
    );
  }
}

class UserInfo extends StatefulWidget {
  final User user;

  const UserInfo({Key? key, required this.user}) : super(key: key);

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final TextEditingController _bioController = TextEditingController();
  bool _isEditing = false;
  bool _isLoading = true;
  File? _imageFile;
  String _photoUrl = '';
  String _bio = '';
  String _name = '';

  @override
  void initState() {
    super.initState();
    _photoUrl = widget.user.photoURL ?? 'https://via.placeholder.com/150';
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    var userDoc = await FirebaseFirestore.instance
        .collection('user')
        .doc(widget.user.uid)
        .get();
    if (userDoc.exists) {
      setState(() {
        _name = userDoc.data()!['name'] ?? 'No name provided';
        _bio = userDoc.data()!['bio'] ?? '';
        _bioController.text = _bio;
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      await _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile != null) {
      try {
        final storageRef = FirebaseStorage.instance.ref().child('profile_images').child('${widget.user.uid}.jpg');
        await storageRef.putFile(_imageFile!);
        final downloadUrl = await storageRef.getDownloadURL();
        await widget.user.updatePhotoURL(downloadUrl);

        await FirebaseFirestore.instance.collection('user').doc(widget.user.uid).set({
          'photoURL': downloadUrl,
        }, SetOptions(merge: true));

        await widget.user.reload();
        setState(() {
          _photoUrl = widget.user.photoURL ?? 'https://via.placeholder.com/150';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile photo updated successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload profile photo: $e')),
        );
      }
    }
  }

  Future<void> _updateProfile() async {
    try {
      await FirebaseFirestore.instance.collection('user').doc(widget.user.uid).set({
        'bio': _bioController.text,
      }, SetOptions(merge: true));

      setState(() {
        _bio = _bioController.text;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(_photoUrl),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      widget.user.email ?? '',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Name:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    _name,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Bio:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    _bio,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isEditing = true;
                        });
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Edit Profile'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  TextField(
                                    controller: _bioController,
                                    decoration: InputDecoration(
                                      labelText: 'New Bio',
                                    ),
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _isEditing = false;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    // Save changes
                                    await _updateProfile();
                                    setState(() {
                                      _isEditing = false;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Save'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text('Edit Bio'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _pickImage,
                      child: Text('Change Profile Photo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
