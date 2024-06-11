import 'package:flutter/material.dart';

class WidgetImageAssets extends StatelessWidget {
  const WidgetImageAssets({
    Key? key,
    required this.pathImage,
  }) : super(key: key);

  final String pathImage;

  @override
  Widget build(BuildContext context) {
    return Image.asset(pathImage,);
  }
}
