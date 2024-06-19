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
          onTap: ()async {
            // Handle tap on the search result
            // String placeId = filteredPlaces[index].id;
            // Increment search count
            // incrementSearchCount(placeId);
            // Navigate to place details or perform any action here


            //  await incrementSearchCount(placeId);
            await saveSearchToFirestore(filteredPlaces[index]);

            Navigator.of(context).pop(); // Close search delegate
            // Navigate to place details page or perform action
          },
        );
      },
    );
  }
//   Future<void> incrementSearchCount(String placeId) async {
//   try {
//     // Reference to the place document in place_searches collection
//     DocumentReference placeRef = FirebaseFirestore.instance.collection('place_searches').doc(placeId);

//     // Use a transaction to ensure atomic updates
//     await FirebaseFirestore.instance.runTransaction((transaction) async {
//       DocumentSnapshot snapshot = await transaction.get(placeRef);
//       if (snapshot.exists) {
//         // Update the searchCount field
//         int newSearchCount = (snapshot.data() as Map<String, dynamic>)['searchCount'] ?? 0;
//         newSearchCount++; // Increment search count
//         transaction.update(placeRef, {'searchCount': newSearchCount});
//       } else {
//         // Create a new document if it doesn't exist (although it should exist)
//         transaction.set(placeRef, {'searchCount': 1});
//       }
//     });
//   } catch (e) {
//     print('Error incrementing search count: $e');
//   }
// }


Future<void> saveSearchToFirestore(DocumentSnapshot place) async {
  try {
    // Define a time threshold for recent searches, e.g., searches within the last day
    final DateTime oneDayAgo = DateTime.now().subtract(Duration(days: 1));

    // Query the collection for recent searches with the same placeId
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('place_searches')
        .where('placeId', isEqualTo: place.id)
        .where('timestamp', isGreaterThan: Timestamp.fromDate(oneDayAgo))
        .get();

    print("Query Snapshot: ${querySnapshot.docs.length} documents found.");

    // If no recent search is found, add a new search entry
    if (querySnapshot.docs.isEmpty) {
      await FirebaseFirestore.instance.collection('place_searches').add({
        'placeId': place.id,
        'name': place['name'],
        'timestamp': FieldValue.serverTimestamp(),
      });
      print("New search entry added for place: ${place['name']}");
    } else {
      print('A recent search for this place already exists.');
    }
  } catch (e) {
    print('Error saving search to Firestore: $e');
  }
}



}
