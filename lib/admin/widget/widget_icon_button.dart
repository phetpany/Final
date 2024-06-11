import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class WidgetIconButton extends StatelessWidget {
  const WidgetIconButton({
    Key? key,
    required this.iconData,
    required this.onPress,
    this.type,
    this.color,
  }) : super(key: key);
  final IconData iconData;
  final Function() onPress;
  final GFButtonType? type;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GFIconButton(
      icon: Icon(iconData),
      onPressed: onPress,
      type: type ?? GFButtonType.transparent,
      color: color ?? Theme.of(context).primaryColor,
    );
  }
}