// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class WidgetAvatar extends StatelessWidget {
  const WidgetAvatar({
    Key? key,
    required this.backgroundImage,
    this.radius,
    this.shape,
  }) : super(key: key);
  final ImageProvider<Object> backgroundImage;
  final double? radius;
  final GFAvatarShape? shape;

  @override
  Widget build(BuildContext context) {
    return GFAvatar(
      backgroundImage: backgroundImage,
      radius: radius,
      shape: shape ?? GFAvatarShape.circle,
    );
  }
}
