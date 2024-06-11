// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class PopularPlaces extends StatelessWidget {
  final ImageProvider imgProviderr;
const PopularPlaces({ Key? key , required this.imgProviderr}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),

      child: Container(
                  width: 350,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                  image: imgProviderr, // Use the provided ImageProvider
                  fit: BoxFit.cover,
                ),
                  )
                  ),
                  );
  
  }
}