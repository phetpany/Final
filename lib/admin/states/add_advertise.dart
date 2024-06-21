import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getapi/admin/models/advertise_model.dart';
import 'package:getapi/admin/unity/app_constant.dart';
import 'package:getapi/admin/unity/app_controller.dart';
import 'package:getapi/admin/unity/app_dialog.dart';
import 'package:getapi/admin/unity/app_service.dart';
import 'package:getapi/admin/widget/widget_avatar.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:getapi/admin/widget/widget_button.dart';
import 'package:getapi/admin/widget/widget_form.dart';
import 'package:getapi/admin/widget/widget_icon_button.dart';
import 'package:getapi/admin/widget/widget_image_assets.dart';
import 'package:getapi/admin/widget/widget_text.dart';

class Advertise extends StatefulWidget {
  const Advertise({super.key});

  @override
  State<Advertise> createState() => _AdvertiseState();
}

class _AdvertiseState extends State<Advertise> {
  AppContrller appController = Get.put(AppContrller());

  final keyForm = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    AppService().processReadAllAdvertise();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade300,
        title: const WidgetText(
          data: 'Advertise Locations',
        ),
      ),
      body: Obx(
        () => appController.advertiseModels.isEmpty
            ? const SizedBox()
            : GridView.builder(
                itemCount: appController.advertiseModels.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (context, index) => Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          AppDialog().normalDialog(
                            title: 'Advertise Image',
                            firstWidget: WidgetButton(
                              text: 'Edit',
                              onPressed: () {
                                Get.back();
                                _editAdvertiseDialog(
                                  docId: appController.docIDAdvertises[index],
                                  advertiseModel: appController.advertiseModels[index],
                                );
                              },
                            ),
                            secondWidget: WidgetButton(
                              text: 'Delete',
                              onPressed: () {
                                Get.back();
                                _deleteAdvertise(appController.docIDAdvertises[index]);
                              },
                            ),
                          );
                        },
                        child: WidgetAvatar(
                          radius: 45,
                          shape: GFAvatarShape.standard,
                          backgroundImage: NetworkImage(
                            appController.advertiseModels[index].urlImage,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 55,
                      height: 25,
                      decoration: BoxDecoration(
                          color: Colors.blue.shade200,
                          borderRadius: BorderRadius.circular(5),
                          shape: BoxShape.rectangle),
                      child: WidgetText(
                        data: appController.advertiseModels[index].nameAdvertise,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
      ),
      floatingActionButton: addAdvertiseButton(),
    );
  }

  WidgetButton addAdvertiseButton() {
    return WidgetButton(
      text: 'Add Advertise',
      onPressed: () {
        textEditingController.clear();
        appController.display.value = false;

        if (appController.files.isNotEmpty) {
          appController.files.clear();
          appController.nameFiles.clear();
        }

        AppDialog().normalDialog(
          title: 'Add Advertise Image',
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
                              : CircleAvatar(
                                  radius: 100,
                                  backgroundImage: FileImage(appController.files.last),
                                ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: WidgetIconButton(
                            iconData: Icons.add_photo_alternate,
                            onPress: () {
                              AppService().processTakePhoto(source: ImageSource.gallery);
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
                                return 'Please enter advertisement name';
                              } else {
                                return null;
                              }
                            },
                            label: WidgetText(data: 'Advertise Name'),
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

                AppService().processUploadImage(path: 'advertise').then((value) {
                  String? urlImage = value;
                  print('urlImage ===> $urlImage');

                  AdvertiseModel advertise = AdvertiseModel(
                    nameAdvertise: textEditingController.text,
                    urlImage: urlImage!,
                  );

                  AppService()
                      .processInsertAdvertise(advertiseModel: advertise)
                      .then((value) => AppService().processReadAllAdvertise());
                });
              }
            },
            type: GFButtonType.transparent,
          ),
        );
      },
    );
  }

  void _editAdvertiseDialog({
    required String docId,
    required AdvertiseModel advertiseModel,
  }) {
    textEditingController.text = advertiseModel.nameAdvertise;
    appController.files.clear();
    appController.files.add(advertiseModel.urlImage);  // Store URL directly

    AppDialog().normalDialog(
      title: 'Edit Advertise Image',
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
                      () {
                        if (appController.files.isEmpty) {
                          return WidgetImageAssets(
                            pathImage: 'assets/images/location.png',
                          );
                        } else {
                          var file = appController.files.last;
                          if (file is String) {
                            return CircleAvatar(
                              radius: 100,
                              backgroundImage: NetworkImage(file),
                            );
                          } else if (file is File) {
                            return CircleAvatar(
                              radius: 100,
                              backgroundImage: FileImage(file),
                            );
                          } else {
                            return WidgetImageAssets(
                              pathImage: 'assets/images/location.png',
                            );
                          }
                        }
                      },
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: WidgetIconButton(
                        iconData: Icons.add_photo_alternate,
                        onPress: () {
                          AppService().processTakePhoto(source: ImageSource.gallery);
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
                            return 'Please fill in the name of the advertisement';
                          } else {
                            return null;
                          }
                        },
                        label: WidgetText(data: 'Name of Advertise'),
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

            AppService().processUploadImage(path: 'advertise').then((value) {
              String? urlImage = value ?? advertiseModel.urlImage;

              AdvertiseModel updatedAdvertiseModel = AdvertiseModel(
                nameAdvertise: textEditingController.text,
                urlImage: urlImage,
              );

              AppService()
                  .processUpdateAdvertise(
                    docId: docId,
                    advertiseModel: updatedAdvertiseModel,
                  )
                  .then((value) => AppService().processReadAllAdvertise());
            });
          }
        },
        type: GFButtonType.transparent,
      ),
    );
  }

  void _deleteAdvertise(String docId) {
    AppDialog().normalDialog(
      title: 'Delete Advertise',
      contentWidget: const Text('Are you sure you want to delete this advertise?'),
      firstWidget: WidgetButton(
        text: 'Delete',
        onPressed: () {
          Get.back();
          AppService()
              .processDeleteAdvertise(docId: docId)
              .then((value) => AppService().processReadAllAdvertise());
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
