class PlaceSearch {
  final String id;
  final String name;
  final int searchCount;

  PlaceSearch({required this.id, required this.name, required this.searchCount});

  factory PlaceSearch.fromMap(Map<String, dynamic> data, String id) {
    return PlaceSearch(
      id: id,
      name: data['name'] ?? '',
      searchCount: data['searchCount'] ?? 0,
    );
  }
}