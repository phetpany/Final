import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlacesSearch extends SearchDelegate<String> {
  PlacesSearch({required this.places});

  final List<DocumentSnapshot> places;

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
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final List<DocumentSnapshot> filteredPlaces = places.where((place) {
      final String placeName = place['name'].toString().toLowerCase();
      final String queryLower = query.toLowerCase();
      return placeName.contains(queryLower);
    }).toList();

    return ListView.builder(
      itemCount: filteredPlaces.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(filteredPlaces[index]['name']),
          onTap: () {
            // Handle tap on the search result
            String placeId = filteredPlaces[index].id;
            // Increment search count
            incrementSearchCount(placeId);
            // Navigate to place details or perform any action here
            Navigator.of(context).pop(); // Close search delegate
            // Navigate to place details page or perform action
          },
        );
      },
    );
  }
  Future<void> incrementSearchCount(String placeId) async {
  try {
    // Reference to the place document in place_searches collection
    DocumentReference placeRef = FirebaseFirestore.instance.collection('place_searches').doc(placeId);

    // Use a transaction to ensure atomic updates
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(placeRef);
      if (snapshot.exists) {
        // Update the searchCount field
        int newSearchCount = (snapshot.data() as Map<String, dynamic>)['searchCount'] ?? 0;
        newSearchCount++; // Increment search count
        transaction.update(placeRef, {'searchCount': newSearchCount});
      } else {
        // Create a new document if it doesn't exist (although it should exist)
        transaction.set(placeRef, {'searchCount': 1});
      }
    });
  } catch (e) {
    print('Error incrementing search count: $e');
  }
}
}
