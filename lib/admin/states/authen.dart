import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getapi/admin/states/create_new_account.dart';
import 'package:getapi/admin/unity/app_service.dart';
import 'package:getapi/admin/widget/widget_button.dart';
import 'package:getapi/admin/widget/widget_form.dart';
import 'package:getapi/admin/widget/widget_image_assets.dart';
import 'package:getwidget/types/gf_button_type.dart';

class Authen extends StatefulWidget {
  const Authen({Key? key}) : super(key: key);

  @override
  State<Authen> createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  final keyForm = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final appService = Get.put(AppService());

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: ListView(
          children: [
            const WidgetImageAssets(pathImage: 'assets/images/image1.png'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  child: Form(
                    key: keyForm,
                    child: Column(
                      children: [
                        WidgetForm(
                          hintText: 'Email:',
                          controller: emailController,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please Fill Email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        WidgetForm(
                          hintText: 'Password:',
                          controller: passwordController,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please Fill Password';
                            }
                            return null;
                          },
                          obscureText: true,
                        ),
                        const SizedBox(height: 16),
                        WidgetButton(
                          text: 'Login',
                          onPressed: () {
                            if (keyForm.currentState!.validate()) {
                              appService.processCheckAuthen(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                        ),
                        WidgetButton(
                          text: 'Create New Account',
                          type: GFButtonType.transparent,
                          onPressed: () {
                            Get.to(const CreateNewAccount());
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
