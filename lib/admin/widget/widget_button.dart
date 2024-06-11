// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class WidgetButton extends StatelessWidget {
  const WidgetButton({
    Key? key,
    this.text,
    this.onPressed,
    this.type,
    this.color,
  }) : super(key: key);
  final String? text;
  final Function()? onPressed;
  final GFButtonType? type;
  final Color? color;
  

  @override
  Widget build(BuildContext context) {
    return GFButton(text: text,
      onPressed: onPressed,
      type: type ?? GFButtonType.solid ,
      color: color ?? Theme.of(context).primaryColor,
    );
  }
}
