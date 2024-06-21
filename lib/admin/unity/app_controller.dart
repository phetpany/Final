import 'dart:io';

import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:getapi/admin/models/advertise_model.dart';
import 'package:getapi/admin/models/group_model.dart';
import 'package:getapi/admin/models/places_model.dart';
import 'package:getapi/admin/models/user_model.dart';
import 'package:getapi/admin/unity/app_service.dart';
import 'package:image_picker/image_picker.dart';

class AppContrller extends GetxController {

   RxList<dynamic> files = <dynamic>[].obs; 
  RxList nameFiles = <String>[].obs;
  RxBool display = false.obs;

  RxList groupModels = <GroupModel>[].obs;
  RxList advertiseModels = <AdvertiseModel>[].obs;
  RxList docIDGroups = <String>[].obs;
  RxList docIDAdvertises = <String>[].obs;

  // RxList choosegroupModels = <GroupModel?>[null].obs;
  RxList chooseIndexs = <int?>[null].obs;
  RxList indexs = <int>[].obs;
  RxList xFiles = <XFile>[].obs;

  RxList placesModels =<PlacesModel>[].obs;
   RxList currentUserModels = <UserModel>[].obs;
    void refreshGroups() {
    AppService().processReadAllGroup();
  }
  
  
   
}