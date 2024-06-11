import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getapi/admin/widget/widget_button.dart';
import 'package:getapi/admin/widget/widget_text.dart';
import 'package:getwidget/getwidget.dart';

class AppDialog {
  void normalDialog({
    required String title,
    Widget? iconWidget,
    Widget? contentWidget,
    Widget? firstWidget,
    Widget? secondWidget, 
     WidgetButton? firstAction,
     WidgetButton? secondAction, 
     Row? content,
  }) {
    Get.dialog(
      AlertDialog(
        title: WidgetText(data: title),
        icon: iconWidget,
        content: contentWidget,
        actions: [
          firstWidget ?? SizedBox(),
          secondWidget ??
              WidgetButton(
                text: firstWidget == null ? 'Ok' : 'Cancel',
                onPressed:() => Get.back(),
                type: GFButtonType.transparent,
              )
        ],
      ),
    );
  }
}
