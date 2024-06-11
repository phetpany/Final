import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getapi/admin/unity/app_service.dart';
import 'package:getapi/admin/widget/widget_button.dart';
import 'package:getapi/admin/widget/widget_form.dart';
import 'package:getapi/admin/widget/widget_text.dart';

class CreateNewAccount extends StatefulWidget {
  const CreateNewAccount({Key? key}) : super(key: key);

  @override
  State<CreateNewAccount> createState() => _CreateNewAccountState();
}

class _CreateNewAccountState extends State<CreateNewAccount> {
  final keyForm = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final appService = Get.put(AppService());

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const WidgetText(data: 'Create New Account'),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: ListView(
          children: [
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
                          hintText: 'Display Name:',
                          controller: nameController,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please Fill Name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
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
                          obscureText: true,
                          maxLines: 1,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please Fill Password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        WidgetButton(
                          text: 'Create New Account',
                          onPressed: () {
                            if (keyForm.currentState!.validate()) {
                              appService.processCreateNewAccount(
                                name: nameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
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
