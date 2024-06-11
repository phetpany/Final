import 'package:flutter/material.dart';

class CategoryPlaces extends StatelessWidget {
  final String text;
  final ImageProvider imgProvider; // Now expects an ImageProvider
  final Function()? onTap;
  const CategoryPlaces(
      {Key? key, required this.imgProvider, required this.text ,required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            GestureDetector(
              onTap: onTap,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(30),
                  image: DecorationImage(
                    image: imgProvider, // Use the provided ImageProvider
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Text(text),
            
          ],
          
        ),
      ],
    );
  }
}
