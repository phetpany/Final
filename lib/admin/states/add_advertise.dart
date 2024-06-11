// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:getapi/admin/models/advertise_model.dart';
import 'package:getapi/admin/models/group_model.dart';
import 'package:getapi/admin/states/add_places.dart';
import 'package:getapi/admin/unity/app_constant.dart';
import 'package:getapi/admin/widget/widget_avatar.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

import 'package:getapi/admin/unity/app_controller.dart';
import 'package:getapi/admin/unity/app_dialog.dart';
import 'package:getapi/admin/unity/app_service.dart';
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
  AppContrller appContrller = Get.put(AppContrller());

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
          data: ' ພື້ນທີ່ໂຄສະນາສະຖານທີ່ທ່ອງທ່ຽວ',
        ),
      ),
      body: Obx(
        () => appContrller.advertiseModels.isEmpty
            ? const SizedBox()
            : GridView.builder(
                itemCount: appContrller.advertiseModels.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (context, index) => Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          AppDialog().normalDialog(title: 'ໝວດໝູ່',);
                        },
                        child: WidgetAvatar(
                          radius: 45,
                          shape: GFAvatarShape.standard,
                          backgroundImage: NetworkImage(
                              appContrller.advertiseModels[index].urlImage),
                          
                        ),
                      ),
                    ),
                    //fix border group
                    Container(
                      width: 55,
                      height: 25,
                      decoration: BoxDecoration(color: Colors.blue.shade200,borderRadius: BorderRadiusDirectional.circular(5), shape: BoxShape.rectangle),
                      child: WidgetText(data: appContrller.advertiseModels[index].nameAdvertise,textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                  ],
                ),
              ),
      ),
      floatingActionButton: addGroupButton(),
    );
  }

  WidgetButton addGroupButton() {
    return WidgetButton(
      text: 'ເພີ່ມຮູບໂຄສະນາ',
      onPressed: () {
        textEditingController.clear();
        appContrller.display.value = false;

        if (appContrller.files.isNotEmpty) {
          appContrller.files.clear();
          appContrller.nameFiles.clear();
        }

        AppDialog().normalDialog(
          title: 'ເພີ່ມຮູບໂຄສະນາ',
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
                          () => appContrller.files.isEmpty
                              ? WidgetImageAssets(
                                  pathImage: 'assets/images/location.png',
                                )
                              : WidgetAvatar(
                                  radius: 100,
                                  backgroundImage:
                                      FileImage(appContrller.files.last), shape: GFAvatarShape.standard,
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
                  Obx(() => appContrller.display.value
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
                                return 'ກະລຸນາເພີ່ມຊື່ໂຄສະນາ';
                              } else {
                                return null;
                              }
                            },
                            label: WidgetText(data: 'ຮູບໂຄສະນາ'), hintText: '',
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
              if (appContrller.files.isEmpty) {
                appContrller.display.value = true;
              } else if (keyForm.currentState!.validate()) {
                Get.back();

                AppService().processUploadImage(path: 'advertise').then((value) {
                  String? urlImage = value;
                  print('urlImage ===>$urlImage');

                  AdvertiseModel advertise = AdvertiseModel(
                    nameAdvertise: textEditingController.text,
                      urlImage: urlImage!, );

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
}
