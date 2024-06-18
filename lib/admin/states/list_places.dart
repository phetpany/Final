import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getapi/admin/models/places_model.dart';
import 'package:getapi/admin/states/add_places.dart';
import 'package:getapi/admin/unity/app_constant.dart';
import 'package:getapi/admin/unity/app_controller.dart';
import 'package:getapi/admin/unity/app_service.dart';
import 'package:getapi/admin/widget/widget_button.dart';
import 'package:getapi/admin/widget/widget_image_network.dart';
import 'package:getapi/admin/widget/widget_text.dart';

class ListPlaces extends StatefulWidget {
  const ListPlaces({Key? key}) : super(key: key);

  @override
  State<ListPlaces> createState() => _ListPlacesState();
}

class _ListPlacesState extends State<ListPlaces> {
  final AppContrller appController = Get.put(AppContrller());

  @override
  void initState() {
    super.initState();
    AppService().processReadAllPlace();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const WidgetText(data: 'List Places'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Obx(
        () => appController.placesModels.isEmpty
            ? const SizedBox()
            : ListView.builder(
                itemCount: appController.placesModels.length,
                itemBuilder: (context, index) => Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(8),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: WidgetImageNetwork(
                        fit: BoxFit.cover,
                        urlImage: appController.placesModels[index].urlImages.last,
                        width: 100, // Adjust width of the image
                        height: 150, // Adjust height of the image
                      ),
                    ),
                    title: WidgetText(
                      data: appController.placesModels[index].name,
                      style: AppConstant().h2Style(),
                    ),
                    subtitle: Text(
                      _truncateDescription(appController.placesModels[index].description),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Get.to(AddPlaces(placeModel: appController.placesModels[index]))
                                ?.then((value) => AppService().processReadAllPlace());
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _showDeleteConfirmationDialog(appController.placesModels[index]);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
      floatingActionButton: WidgetButton(
        text: 'Add Places',
        onPressed: () {
          Get.to(AddPlaces())
              ?.then((value) => AppService().processReadAllPlace());
        },
      ),
    );
  }

  String _truncateDescription(String description) {
    if (description.length <= 80) {
      return description;
    } else {
      return description.substring(0, 77) + '...';
    }
  }

  void _showDeleteConfirmationDialog(PlacesModel placeModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Place"),
          content: Text("Are you sure you want to delete ${placeModel.name}?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () {
                _deletePlace(placeModel);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deletePlace(PlacesModel placeModel) {
    AppService().processDeletePlace(placeModel.docId!);
    // Optionally, you can refresh the list after deletion
    AppService().processReadAllPlace();
  }
}
