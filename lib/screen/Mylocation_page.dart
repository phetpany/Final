// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';

class MylocationPage extends StatefulWidget {
  const MylocationPage({Key? key}) : super(key: key);

  @override
  _MylocationPageState createState() => _MylocationPageState();
}

class _MylocationPageState extends State<MylocationPage> {
  late double lat, lng;

// @override
//   void initState() {
//     super.initState();

//   }
//   Future<Null> findLatLng() async{
//     LocationData locationData = await findLocationData();
//     lat = locationData.latitude!;
//     lng = locationData.longitude!;

//       }

//   Future<LocationData> findLocationData() async{
//  Location location = Location();
//  try{
//   return location.getLocation();
//  }catch(e){
//  return null;
//  }
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 400,
                height: 200,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
              ),
              SizedBox(
                height: 5,
              ),
              showmap(),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 70,
                ),
                child: Container(
                  width: 250,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.blue[900],
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      "17KM 31min",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  Container showmap() {
    LatLng latLng = LatLng(19.89113387938916, 102.13394736624967);
    // CameraPosition cameraPosition = CameraPosition(zoom: 16.0, target: latLng);
    LatLng lat1Lng1 = LatLng(19.890539676971425, 102.1350589683237);
    

    return Container(
      width: 400,
      height: 480,
      decoration: BoxDecoration(
          color: Colors.blue, borderRadius: BorderRadius.circular(20)),
      child: GoogleMap(
        initialCameraPosition: CameraPosition(target: latLng,zoom: 16.0),
        mapType: MapType.normal,
        onMapCreated: (controller) {},
        markers: {
          Marker(
              markerId: MarkerId("_currentLocation"),
              icon: BitmapDescriptor.defaultMarker,
              position: latLng),
              // Marker(
              // markerId: MarkerId("_currentLocation"),
              // icon: BitmapDescriptor.defaultMarker,
              // position: lat1Lng1),
        },
      ),
    );
  }
}
