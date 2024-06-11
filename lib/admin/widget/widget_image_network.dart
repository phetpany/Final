// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class WidgetImageNetwork extends StatelessWidget {
  const WidgetImageNetwork({
    Key? key,
    required this.urlImage,
    this.fit,
    this.width,
    this.height,
  }) : super(key: key);
  final String urlImage;
  final BoxFit? fit;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Image.network(urlImage, fit: fit, width: width,height: height,);
  }
}
