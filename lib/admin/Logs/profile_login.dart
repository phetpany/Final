import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getapi/utills/text_box.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({Key? key}) : super(key: key);

  @override
  _AdminProfilePageState createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final userCollection = FirebaseFirestore.instance.collection('user');

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }
  Future<void> editField (String Field) async{
     String newValue ="";
     await showDialog(
      context: context, 
      builder:(context)=> AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text("Edit $Field",
          style: const TextStyle(color: Colors.white),
          ),
          content: TextField(
            autofocus: true,
            style:const TextStyle(color: Colors.white),
            decoration: InputDecoration(hintText: "Enter New $Field",
            hintStyle: const TextStyle(color: Colors.grey),
            
            ),
            onChanged: (value) {
              newValue = value;
            },
          
          ),
          actions: [
            TextButton(
              onPressed: ()=> Navigator.pop(context), 
              child: const Text("Cancel",style: TextStyle(color: Colors.white),),
              ),

              TextButton(
              onPressed: ()=> Navigator.of(context).pop(newValue), 
              child:const Text("Save",style: TextStyle(color: Colors.white),),
              ),
          ],


      ));
      if(newValue.trim().length>0){
        await userCollection.doc(user.email).update({Field:newValue});
      };

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[100],
          actions: [
            IconButton(onPressed: signUserOut, icon:const  Icon(Icons.logout))
          ],
        ),
        backgroundColor: Colors.blue[100],
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('user').doc(user.email).snapshots(), 
          builder: (context , snapshot){
            if (snapshot.hasData){
              final userData = snapshot.data!.data() as Map<String,dynamic>;
  return ListView(
            children: [
              const Icon(
                Icons.person,
                size: 64,
              ),
             const  SizedBox(
                height: 15,
              ),
              Text(
                user.email!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, color: Colors.blueGrey),
              ),
             const  SizedBox(
                height: 25,
              ),
             const  Padding(
                padding:  EdgeInsets.only(left: 35),
                child: Text(
                  "My Profile",
                  style: TextStyle(fontSize: 18, color: Colors.blueGrey),
                ),
              ),
              MyTextBox(
                onPressed: () => editField('username'),
                text: userData['username'], selcetedName: "uesername"),
              MyTextBox(
                onPressed: () => editField('bio'),
                text: userData['bio'], selcetedName: "Bio"),
            ],
          );

            }else if (snapshot.hasError){
              return Center(
                child: Text('error${snapshot.error}'),
              );
            }
            return const Center(child: CircularProgressIndicator(),);
          }) 
        
        );
  }
}
