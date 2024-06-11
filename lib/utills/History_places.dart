// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_super_parameters

import 'package:flutter/material.dart';

class HistoryPlaces extends StatelessWidget {
  final ImageProvider imgProvider;
  final String textTitle;
  final String textSubtitle;
  final String textOpenhour;

  const HistoryPlaces(
      {Key? key,
      required this.imgProvider,
      required this.textTitle,
      required this.textSubtitle,
      required this.textOpenhour})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
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
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                        Text(
                          textSubtitle,
                          style: TextStyle(color: Colors.white),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                        SingleChildScrollView(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                textOpenhour,
                                style: TextStyle(color: Colors.blue[900], fontSize: 10),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Icon(
                                color: Colors.red,
                                Icons.star,
                                size: 15,
                              ),
                              Icon(color: Colors.red, Icons.star, size: 15),
                              Icon(color: Colors.red,Icons.star, size: 15),
                              Icon(Icons.star, size: 15),
                              Icon(Icons.star, size: 15),
                            ],
                          ),
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
    );
  }
}
