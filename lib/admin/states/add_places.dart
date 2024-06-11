import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getapi/admin/models/places_model.dart';
import 'package:getapi/admin/unity/app_constant.dart';
import 'package:getapi/admin/unity/app_controller.dart';
import 'package:getapi/admin/unity/app_service.dart';
import 'package:getapi/admin/widget/widget_button.dart';
import 'package:getapi/admin/widget/widget_form.dart';
import 'package:getapi/admin/widget/widget_icon_button.dart';
import 'package:getapi/admin/widget/widget_image_file.dart';
import 'package:getapi/admin/widget/widget_text.dart';
import 'package:getwidget/getwidget.dart';

class AddPlaces extends StatefulWidget {
  final PlacesModel? placeModel;

  const AddPlaces({super.key, this.placeModel });

  @override
  State<AddPlaces> createState() => _AddPlacesState();
}

class _AddPlacesState extends State<AddPlaces> {
  AppContrller appContrller = Get.put(AppContrller());

  final keyForm = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController urlGoogleMapController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.placeModel != null) {
      // Populate text controllers with place details
      nameController.text = widget.placeModel!.name;
      descriptionController.text = widget.placeModel!.description;
      urlGoogleMapController.text = widget.placeModel!.urlGoogleMap;
      
    }
    AppService().processReadAllGroup();

    if (appContrller.xFiles.isNotEmpty) {
      appContrller.xFiles.clear();
    }
    appContrller.display.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const WidgetText(data: 'Add Places'),
        actions: [
          WidgetButton(
            text: 'Save',
            onPressed: () {
              processSave();
            },
          ),
          const SizedBox(
            width: 33,
          ),
        ],
      ),
      body: Obx(() => GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Form(
              key: keyForm,
              child: ListView(
                children: [
                  dropDownGroup(),
                  const SizedBox(
                    height: 16,
                  ),
                  nameForm(),
                  const SizedBox(
                    height: 16,
                  ),
                  descriptionForm(),
                  const SizedBox(
                    height: 16,
                  ),
                  displayGoogleMap(),
                  const SizedBox(
                    height: 16,
                  ),
                  addPhotoButton(),
                  const SizedBox(
                    height: 16,
                  ),
                  validateImage(),
                  imageGridView(),
                  const SizedBox(
                    height: 16,
                  ),
                  saveButton(),
                  const SizedBox(
                    height: 16,
                  ),
                  if (widget.placeModel != null) updateButton(),
                ],
              ),
            ),
          )),
    );
  }

  Row saveButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: Get.width * 0.8,
          child: WidgetButton(
            text: 'Save',
            onPressed: () {
              processSave();
            },
          ),
        ),
      ],
    );
  }

  RenderObjectWidget validateImage() {
    return appContrller.display.value
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: Get.width * 0.8,
                child: WidgetText(
                  data: 'Please Add Photo',
                  style: AppConstant().h3Style(color: GFColors.DANGER),
                ),
              ),
            ],
          )
        : SizedBox();
  }

  Row imageGridView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: Get.width * 0.8,
          child: appContrller.xFiles.isEmpty
              ? const SizedBox()
              : GridView.builder(
                  itemCount: appContrller.xFiles.length,
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      crossAxisCount: 3),
                  itemBuilder: (context, index) => SizedBox(
                    width: 100,
                    height: 100,
                    child: WidgetImageFile(
                      file: File(appContrller.xFiles[index].path),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Row addPhotoButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: Get.width * 0.8,
          child: Row(
            children: [
              WidgetButton(
                text: 'Add Photo',
                onPressed: () {
                  AppService().processTakePhotoMulti();
                },
                type: GFButtonType.outline2x,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row displayGoogleMap() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
            width: Get.width * 0.8,
            child: WidgetForm(
              validator: (p0) {
                if (p0?.isEmpty ?? true) {
                  return 'Plz fill Link GoogleMap';
                } else {
                  return null;
                }
              },
              controller: urlGoogleMapController,
              suffixIcon: WidgetIconButton(
                iconData: Icons.location_searching,
                onPress: () {
                  AppService().processLaunchUrl(url: AppConstant.urlMapStart);
                },
              ),
              keyboardType: TextInputType.text, hintText: '',
            )),
      ],
    );
  }

  Row descriptionForm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: Get.width * 0.8,
          child: WidgetForm(
            validator: (p0) {
              if (p0?.isEmpty ?? true) {
                return 'Plz fill Description';
              } else {
                return null;
              }
            },
            controller: descriptionController,
            label: WidgetText(data: 'Description :'),
            maxLines: 3,
            keyboardType: TextInputType.multiline, hintText: '',
          ),
        ),
      ],
    );
  }

  Row nameForm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: Get.width * 0.8,
          child: WidgetForm(
            validator: (p0) {
              if (p0?.isEmpty ?? true) {
                return 'Plz fill name';
              } else {
                return null;
              }
            },
            controller: nameController,
            keyboardType: TextInputType.text,
            label: WidgetText(data: 'Name Places :'), hintText: '',
          ),
        ),
      ],
    );
  }

  Widget dropDownGroup() {
    return appContrller.indexs.isEmpty
        ? const SizedBox()
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: Get.width * 0.8,
                child: DropdownButtonFormField(
                  validator: (value) {
                    if (appContrller.chooseIndexs.last == null) {
                      return 'Please Choose Group';
                    } else {
                      return null;
                    }
                  },
                  isExpanded: true,
                  value: appContrller.chooseIndexs.last,
                  hint: const WidgetText(data: 'Please Choose Group'),
                  items: appContrller.indexs
                      .map(
                        (element) => DropdownMenuItem(
                          child: WidgetText(
                              data: appContrller.groupModels[element].nameGroup),
                          value: element,
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    appContrller.chooseIndexs.add(value);
                  },
                ),
              ),
            ],
          );
  }

  void processSave() async {
    if (keyForm.currentState!.validate()) {
      if (appContrller.xFiles.isEmpty) {
        appContrller.display.value = true;
      } else {
        appContrller.display.value = false;

        var urlImages = <String>[];
        for (var element in appContrller.xFiles) {
          String? urlImage = await AppService().processUploadImage(
              path: 'places',
              file: File(element.path),
              nameFile: 'places${Random().nextInt(1000)}.jpg');

          if (urlImage != null) {
            urlImages.add(urlImage);
          }
        }

        PlacesModel placesModel = PlacesModel(
          docIDGroup: appContrller.docIDGroups[appContrller.chooseIndexs.last],
          name: nameController.text,
          description: descriptionController.text,
          urlGoogleMap: urlGoogleMapController.text,
          urlImages: urlImages,
        );
        print('##2May PlacesModel  --->${placesModel.toMap()}');

        await FirebaseFirestore.instance
            .collection('places')
            .doc()
            .set(placesModel.toMap())
            .then((value) {
          Get.back();
          Get.snackbar('Add Places Success', 'ThankYou');
        });
      }
    }
  }

  void _processUpdate() async {
    if (keyForm.currentState!.validate()) {
      if (appContrller.xFiles.isEmpty) {
        appContrller.display.value = true;
      } else {
        appContrller.display.value = false;

        var urlImages = <String>[];
        for (var element in appContrller.xFiles) {
          String? urlImage = await AppService().processUploadImage(
              path: 'places',
              file: File(element.path),
              nameFile: 'places${Random().nextInt(1000)}.jpg');

          if (urlImage != null) {
            urlImages.add(urlImage);
          }
        }

        PlacesModel placesModel = PlacesModel(
          docIDGroup: appContrller.docIDGroups[appContrller.chooseIndexs.last],
          name: nameController.text,
          description: descriptionController.text,
          urlGoogleMap: urlGoogleMapController.text,
          urlImages: urlImages,
        );

        if (widget.placeModel != null) {
          String docId = widget.placeModel!.docIDGroup; // Ensure this is set correctly

          print('Updating docId: $docId with data: ${placesModel.toMap()}');

          await FirebaseFirestore.instance
              .collection('places')
              .doc(docId)
              .update(placesModel.toMap())
              .then((value) {
            Get.back();
            Get.snackbar('Update Places Success', 'ThankYou');
          }).catchError((error) {
            print('Failed to update place: $error');
            Get.snackbar('Update Failed', error.toString());
          });
        } else {
          print('No placeModel found');
        }
      }
    }
  }

  Row updateButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: Get.width * 0.8,
          child: WidgetButton(
            text: 'Update',
            onPressed: () {
              _processUpdate();
            },
          ),
        ),
      ],
    );
  }

  void _processDelete() async {
    if (widget.placeModel != null) {
      String docId = widget.placeModel!.docIDGroup; // Set the document ID of the place you want to delete

      await FirebaseFirestore.instance
          .collection('places')
          .doc(docId)
          .delete()
          .then((value) {
        Get.back();
        Get.snackbar('Delete Places Success', 'ThankYou');
      }).catchError((error) {
        print('Failed to delete place: $error');
        Get.snackbar('Delete Failed', error.toString());
      });
    } else {
      print('No placeModel found for deletion');
    }
  }
}
