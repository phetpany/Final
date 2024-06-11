import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getapi/admin/models/group_model.dart';
import 'package:getapi/admin/unity/app_constant.dart';
import 'package:getapi/admin/widget/widget_avatar.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:getapi/admin/unity/app_controller.dart';
import 'package:getapi/admin/unity/app_dialog.dart';
import 'package:getapi/admin/unity/app_service.dart';
import 'package:getapi/admin/widget/widget_button.dart';
import 'package:getapi/admin/widget/widget_form.dart';
import 'package:getapi/admin/widget/widget_icon_button.dart';
import 'package:getapi/admin/widget/widget_image_assets.dart';
import 'package:getapi/admin/widget/widget_text.dart';

class AddGroup extends StatefulWidget {
  const AddGroup({super.key});

  @override
  State<AddGroup> createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {
  final AppContrller appController = Get.put(AppContrller());

  final keyForm = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    AppService().processReadAllGroup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade300,
        title: const WidgetText(
          data: ' ໝວດໝູ່ຂອງສະຖານທີ່ທ່ອງທ່ຽວ',
        ),
      ),
      body: Obx(
        () => appController.groupModels.isEmpty
            ? const SizedBox()
            : GridView.builder(
                itemCount: appController.groupModels.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (context, index) => Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          AppDialog().normalDialog(
                            title: 'ໝວດໝູ່',
                            firstWidget: WidgetButton(
                              text: 'Edit',
                              onPressed: () {
                                Get.back();
                                _editGroupDialog(
                                  docId: appController.docIDGroups[index],
                                  groupModel: appController.groupModels[index],
                                );
                              },
                            ),
                            secondWidget: WidgetButton(
                              text: 'Delete',
                              onPressed: () {
                                Get.back();
                                _deleteGroup(
                                    appController.docIDGroups[index]);
                              },
                            ),
                          );
                        },
                        child: WidgetAvatar(
                          backgroundImage: NetworkImage(
                              appController.groupModels[index].urlImage),
                          radius: 45,
                        ),
                      ),
                    ),
                    Container(
                        width: 55,
                        height: 25,
                        decoration: BoxDecoration(
                            color: Colors.blue.shade200,
                            borderRadius: BorderRadiusDirectional.circular(5),
                            shape: BoxShape.rectangle),
                        child: WidgetText(
                          data: appController.groupModels[index].nameGroup,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        )),
                  ],
                ),
              ),
      ),
      floatingActionButton: addGroupButton(),
    );
  }

  WidgetButton addGroupButton() {
    return WidgetButton(
      text: 'Add Group',
      onPressed: () {
        textEditingController.clear();
        appController.display.value = false;

        if (appController.files.isNotEmpty) {
          appController.files.clear();
          appController.nameFiles.clear();
        }

        AppDialog().normalDialog(
          title: 'Add Group',
          contentWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: Stack(
                      children: [
                        Obx(
                          () => appController.files.isEmpty
                              ? WidgetImageAssets(
                                  pathImage: 'assets/images/location.png',
                                )
                              : WidgetAvatar(
                                  radius: 100,
                                  backgroundImage:
                                      FileImage(appController.files.last),
                                ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: WidgetIconButton(
                            iconData: Icons.add_photo_alternate,
                            onPress: () {
                              AppService().processTakePhoto(
                                  source: ImageSource.gallery);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Obx(() => appController.display.value
                      ? WidgetText(
                          data: 'Please Choose Photo',
                          style: AppConstant().h3Style(color: GFColors.DANGER),
                        )
                      : const SizedBox()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 250,
                        child: Form(
                          key: keyForm,
                          child: WidgetForm(
                            controller: textEditingController,
                            validator: (p0) {
                              if (p0?.isEmpty ?? true) {
                                return 'Please Fill Name Group';
                              } else {
                                return null;
                              }
                            },
                            label: WidgetText(data: 'Name Group'),
                            hintText: '',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          firstWidget: WidgetButton(
            text: 'Save',
            onPressed: () {
              if (appController.files.isEmpty) {
                appController.display.value = true;
              } else if (keyForm.currentState!.validate()) {
                Get.back();

                AppService().processUploadImage(path: 'group').then((value) {
                  String? urlImage = value;
                  print('urlImage ===>$urlImage');

                  GroupModel groupModel = GroupModel(
                      nameGroup: textEditingController.text,
                      urlImage: urlImage!);

                  AppService()
                      .processInsertGroup(groupModel: groupModel)
                      .then((value) => AppService().processReadAllGroup());
                });
              }
            },
            type: GFButtonType.transparent,
          ),
        );
      },
    );
  }

  // Method to show the edit group dialog
  void _editGroupDialog({required String docId, required GroupModel groupModel}) {
    textEditingController.text = groupModel.nameGroup;
    appController.files.clear();
    appController.files.add(File(groupModel.urlImage));

    AppDialog().normalDialog(
      title: 'Edit Group',
      contentWidget: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: Stack(
                  children: [
                    Obx(
                      () => appController.files.isEmpty
                          ? WidgetImageAssets(
                              pathImage: 'assets/images/location.png',
                            )
                          : WidgetAvatar(
                              radius: 100,
                              backgroundImage:
                                  FileImage(appController.files.last),
                            ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: WidgetIconButton(
                        iconData: Icons.add_photo_alternate,
                        onPress: () {
                          AppService().processTakePhoto(
                              source: ImageSource.gallery);
                        },
                      ),
                    )
                  ],
                ),
              ),
              Obx(() => appController.display.value
                  ? WidgetText(
                      data: 'Please Choose Photo',
                      style: AppConstant().h3Style(color: GFColors.DANGER),
                    )
                  : const SizedBox()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 250,
                    child: Form(
                      key: keyForm,
                      child: WidgetForm(
                        controller: textEditingController,
                        validator: (p0) {
                          if (p0?.isEmpty ?? true) {
                            return 'Please Fill Name Group';
                          } else {
                            return null;
                          }
                        },
                        label: WidgetText(data: 'Name Group'),
                        hintText: '',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      firstWidget: WidgetButton(
        text: 'Save',
        onPressed: () {
          if (appController.files.isEmpty) {
            appController.display.value = true;
          } else if (keyForm.currentState!.validate()) {
            Get.back();

            AppService().processUploadImage(path: 'group').then((value) {
              String? urlImage = value ?? groupModel.urlImage;

              GroupModel updatedGroupModel = GroupModel(
                nameGroup: textEditingController.text,
                urlImage: urlImage,
              );

              AppService()
                  .processUpdateGroup(docId: docId, groupModel: updatedGroupModel)
                  .then((value) => AppService().processReadAllGroup());
            });
          }
        },
        type: GFButtonType.transparent,
      ),
    );
  }

  // Method to delete a group
  void _deleteGroup(String docId) {
    AppDialog().normalDialog(
      title: 'Delete Group',
      contentWidget: const Text('Are you sure you want to delete this group?'),
      firstWidget: WidgetButton(
        text: 'Delete',
        onPressed: () {
          Get.back();
          AppService()
              .processDeleteGroup(docId: docId)
              .then((value) => AppService().processReadAllGroup());
        },
        type: GFButtonType.transparent,
      ),
      secondWidget: WidgetButton(
        text: 'Cancel',
        onPressed: () => Get.back(),
        type: GFButtonType.transparent,
      ),
    );
  }
}
