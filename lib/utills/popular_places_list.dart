// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_super_parameters

import 'package:flutter/material.dart';

class PopularPlacesList extends StatelessWidget {
  final ImageProvider imgProvider;
  final String textTitle;
  final String textSubtitle;
  final String textOpenhour;
  final Function()? onTap;
  const PopularPlacesList(
      {Key? key,
      required this.imgProvider,
      required this.textTitle,
      required this.textSubtitle,
      required this.textOpenhour,
      required this.onTap,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: 450,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.blue[300],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      width: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                              image: imgProvider, fit: BoxFit.cover)),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            textTitle,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                          Text(
                            textSubtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                          Text(
                            textOpenhour,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
