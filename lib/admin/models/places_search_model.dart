class PlaceSearch {
  final String id;
  final String name;
  int searchCount;

  PlaceSearch({
    required this.id,
    required this.name,
    this.searchCount = 0,
  });

  // Convert the model to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'searchCount': searchCount,
    };
  }

  // Factory method to create a PlaceSearch instance from Firestore data
  factory PlaceSearch.fromMap(Map<String, dynamic> map, String id) {
    return PlaceSearch(
      id: id,
      name: map['name'],
      searchCount: map['searchCount'] ?? 0,
    );
  }
}
