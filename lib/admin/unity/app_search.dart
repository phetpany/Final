import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getapi/admin/widget/widget_places_details.dart';



class PlacesSearch extends SearchDelegate {
  final List<QueryDocumentSnapshot> places;

  PlacesSearch({required this.places});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = places.where((place) => place['name'].toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        var place = results[index];
        String imageUrl = (place['urlImages'] is List) ? place['urlImages'][0] : place['urlImages'];
        return Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          margin: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
          child: ListTile(
            onTap: () {
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
            subtitle: Text(
              place['description'],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = places.where((place) => place['name'].toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        var places = suggestions[index];
        return ListTile(
          title: Text(places['name']),
          onTap: () {
            query = places['name'];
            showResults(context);
          },
        );
      },
    );
  }
}
