import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:getapi/admin/widget/widget_places_details.dart';
import 'package:getapi/admin/widget/widget_text.dart';

class PlacesData extends StatefulWidget {
  final String groupId;
  final String groupName;

  const PlacesData({super.key, required this.groupId, required this.groupName});

  @override
  State<PlacesData> createState() => _PlacesDataState();
}

class _PlacesDataState extends State<PlacesData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: WidgetText(
          data: widget.groupName,
          textAlign: TextAlign.center,
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('places')
            .where('docIDGroup', isEqualTo: widget.groupId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No places found for this group.'));
          }

          var documents = snapshot.data!.docs;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              var place = documents[index];
              String imageUrl = (place['urlImages'] is List)
                  ? place['urlImages'][0]
                  : place['urlImages'];
              return Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                child: ListTile(
                  onTap: () {
                    // Navigate to PlaceDetails screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlaceDetails(
                          name: place['name'],
                          description: place['description'],
                          imageUrls: List<String>.from(place['urlImages']),
                          googleMapsUrl: place['urlGoogleMap'],
                        ),
                      ),
                    );
                  },
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      width: 100,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(place['name']),
                  subtitle: Text(documents[index]['description'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
