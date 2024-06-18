import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getapi/admin/models/places_search_model.dart';

class SearchStatisticsPage extends StatefulWidget {
  @override
  _SearchStatisticsPageState createState() => _SearchStatisticsPageState();
}

class _SearchStatisticsPageState extends State<SearchStatisticsPage> {
  final PlaceSearchService _placeSearchService = PlaceSearchService();
  late Future<List<PlaceSearch>> _placesFuture;

  @override
  void initState() {
    super.initState();
    _placesFuture = _placeSearchService.getAllPlaceSearches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Statistics'),
      ),
      body: FutureBuilder<List<PlaceSearch>>(
        future: _placesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          List<PlaceSearch> placeSearches = snapshot.data ?? [];

          return ListView.builder(
            itemCount: placeSearches.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(placeSearches[index].name),
                subtitle: Text('Search Count: ${placeSearches[index].searchCount}'),
              );
            },
          );
        },
      ),
    );
  }
  
}
class PlaceSearchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to increment search count for a place
Future<void> incrementSearchCount(String placeId) async {
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


  // Function to fetch all place search statistics
  Future<List<PlaceSearch>> getAllPlaceSearches() async {
    List<PlaceSearch> placeSearches = [];

    // Fetch documents from 'place_searches' collection
    QuerySnapshot snapshot = await _firestore.collection('place_searches').get();
    snapshot.docs.forEach((doc) {
      placeSearches.add(PlaceSearch.fromMap(doc.data() as Map<String, dynamic>, doc.id));
    });

    // Sort places by search count (descending)
    placeSearches.sort((a, b) => b.searchCount.compareTo(a.searchCount));

    return placeSearches;
  }
}

