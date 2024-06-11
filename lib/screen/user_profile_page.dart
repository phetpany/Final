import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

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
