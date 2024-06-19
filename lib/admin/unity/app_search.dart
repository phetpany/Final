import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getapi/admin/models/places_search_model.dart';
import 'package:getapi/admin/widget/widget_places_details.dart';

class PlacesSearch extends SearchDelegate {
  final List<QueryDocumentSnapshot> places;
  final PlaceSearchService _placeSearchService = PlaceSearchService();

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
        String placeId = place.id;
        String name = place['name'];
        String imageUrl = (place['urlImages'] is List) ? place['urlImages'][0] : place['urlImages'];

        return Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          margin: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
          child: ListTile(
            onTap: () async {
              // Increment search count and navigate to details
              await _placeSearchService.incrementSearchCount(placeId, name);
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
        var place = suggestions[index];
        String placeId = place.id;

        return ListTile(
          title: Text(place['name']),
          onTap: () {
            query = place['name'];
            showResults(context);
          },
        );
      },
    );
  }
}
class PlaceSearchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to increment search count for a place and ensure the name field is added
  Future<void> incrementSearchCount(String placeId, String name) async {
    try {
      // Reference to the place document
      DocumentReference placeRef = _firestore.collection('place_searches').doc(placeId);

      // Use a transaction to ensure atomic updates
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(placeRef);
        if (snapshot.exists) {
          // Update the searchCount field
          int newSearchCount = (snapshot.data() as Map<String, dynamic>?)?['searchCount'] ?? 0;
          newSearchCount++; // Increment search count
          transaction.update(placeRef, {'searchCount': newSearchCount, 'name': name});
        } else {
          // Create a new document if it doesn't exist
          transaction.set(placeRef, {'searchCount': 1, 'name': name});
        }
      });
    } catch (e) {
      print('Error incrementing search count: $e');
    }
  }

  // Function to fetch all place search statistics
  Future<List<PlaceSearch>> getAllPlaceSearches() async {
    List<PlaceSearch> placeSearches = [];

    try {
      // Fetch documents from 'place_searches' collection
      QuerySnapshot snapshot = await _firestore.collection('place_searches').get();
      snapshot.docs.forEach((doc) {
        placeSearches.add(PlaceSearch.fromMap(doc.data() as Map<String, dynamic>, doc.id));
      });

      // Sort places by search count (descending)
      placeSearches.sort((a, b) => b.searchCount.compareTo(a.searchCount));
    } catch (e) {
      print('Error fetching place searches: $e');
    }

    return placeSearches;
  }
}
