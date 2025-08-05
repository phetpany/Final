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
import 'package:getapi/admin/widget/widget_image_network.dart';
import 'package:getapi/admin/widget/widget_text.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';

class AddPlaces extends StatefulWidget {
  final PlacesModel? placeModel;

  const AddPlaces({super.key, this.placeModel});

  @override
  State<AddPlaces> createState() => _AddPlacesState();
}

class _AddPlacesState extends State<AddPlaces> {
  final AppContrller appController = Get.put(AppContrller());

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
      // Populate selected group index
      int groupIndex = appController.docIDGroups.indexOf(widget.placeModel!.docIDGroup);
      if (groupIndex != -1) {
        appController.chooseIndexs.add(groupIndex);
      }
      // Populate images
      appController.xFiles.clear();
      appController.networkImageUrls.clear(); // Ensure it's cleared before adding new ones
      for (var imageUrl in widget.placeModel!.urlImages) {
        appController.networkImageUrls.add(imageUrl);
      }
    }
    AppService().processReadAllGroup();
    appController.display.value = false;
  }

  void showImageOptions(int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Change Image'),
              onTap: () async {
                Navigator.pop(context);
                final ImagePicker _picker = ImagePicker();
                final XFile? newImage = await _picker.pickImage(source: ImageSource.gallery);
                if (newImage != null) {
                  // Replace the network image with the new image
                  appController.xFiles.add(newImage);
                  appController.networkImageUrls.removeAt(index);
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete Image'),
              onTap: () {
                Navigator.pop(context);
                // Delete the network image
                appController.networkImageUrls.removeAt(index);
              },
            ),
          ],
        );
      },
    );
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
                  const SizedBox(
                    height: 16,
                  ),
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

  Widget validateImage() {
    return appController.display.value
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
          child: appController.xFiles.isEmpty && appController.networkImageUrls.isEmpty
              ? const SizedBox()
              : GridView.builder(
                  itemCount: appController.xFiles.length + appController.networkImageUrls.length,
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    if (index < appController.networkImageUrls.length) {
                      return GestureDetector(
                        onTap: () => showImageOptions(index),
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: WidgetImageNetwork(
                            fit: BoxFit.cover,
                            urlImage: appController.networkImageUrls[index],
                          ),
                        ),
                      );
                    } else {
                      return GestureDetector(
                        onTap: () {
                          // Add functionality to change or delete new images if needed
                        },
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: WidgetImageFile(
                            file: File(appController.xFiles[index - appController.networkImageUrls.length].path),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }
                  },
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
    return appController.indexs.isEmpty
        ? const SizedBox()
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: Get.width * 0.8,
                child: DropdownButtonFormField(
                  validator: (value) {
                    if (appController.chooseIndexs.last == null) {
                      return 'Please Choose Group';
                    } else {
                      return null;
                    }
                  },
                  isExpanded: true,
                  value: appController.chooseIndexs.last,
                  hint: const WidgetText(data: 'Please Choose Group'),
                  items: appController.indexs
                      .map(
                        (element) => DropdownMenuItem(
                          child: WidgetText(data: appController.groupModels[element].nameGroup),
                          value: element,
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    appController.chooseIndexs.add(value);
                  },
                ),
              ),
            ],
          );
  }

  void processSave() async {
    if (keyForm.currentState!.validate()) {
      if (appController.xFiles.isEmpty) {
        appController.display.value = true;
      } else {
        appController.display.value = false;

        var urlImages = <String>[];
        for (var element in appController.xFiles) {
          String? urlImage = await AppService().processUploadImage(
              path: 'places',
              file: File(element.path),
              nameFile: 'places${Random().nextInt(1000)}.jpg');

          if (urlImage != null) {
            urlImages.add(urlImage);
          }
        }

        PlacesModel placesModel = PlacesModel(
          docIDGroup: appController.docIDGroups[appController.chooseIndexs.last],
          name: nameController.text,
          description: descriptionController.text,
          urlGoogleMap: urlGoogleMapController.text,
          urlImages: urlImages,
        );

        await FirebaseFirestore.instance
            .collection('places')
            .doc()
            .set(placesModel.toMap())
            .then((value) {
          Get.back();
          Get.snackbar('Insert Place Success', 'Thank you for adding the place');
        });
      }
    }
  }

  void processUpdate() async {
    if (keyForm.currentState!.validate()) {
      var urlImages = <String>[];
      for (var element in appController.xFiles) {
        String? urlImage = await AppService().processUploadImage(
            path: 'places',
            file: File(element.path),
            nameFile: 'places${Random().nextInt(1000)}.jpg');

        if (urlImage != null) {
          urlImages.add(urlImage);
        }
      }

      // Include existing images in the update
      urlImages.addAll(appController.networkImageUrls);

      PlacesModel updatedPlace = PlacesModel(
        docIDGroup: appController.docIDGroups[appController.chooseIndexs.last],
        name: nameController.text,
        description: descriptionController.text,
        urlGoogleMap: urlGoogleMapController.text,
        urlImages: urlImages,
      );

      if (widget.placeModel != null && widget.placeModel!.docId != null) {
        String docId = widget.placeModel!.docId!;

        print('Updating docId: $docId with data: ${updatedPlace.toMap()}');

        await AppService().processUpdatePlace(docId, updatedPlace);
      } else {
        print('No placeModel found or docId is null');
      }
    }
  }

  Widget updateButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: Get.width * 0.8,
          child: WidgetButton(
            text: 'Update',
            onPressed: () {
              processUpdate();
            },
          ),
        ),
      ],
    );
  }
}
