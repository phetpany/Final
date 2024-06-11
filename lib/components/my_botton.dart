import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyBotton extends StatelessWidget {
  final Function()? onTap;
  final String text;
const MyBotton({ Key? key,  required this.onTap, required this.text }) : super(key: key,  );

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:const  EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(color: Colors.blue[900],
      borderRadius: BorderRadius.circular(10),
      
      ),
      child:  Text(text,
      style: const TextStyle(color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 16,
      ),
      ),
      
      ),
    );
  }
}