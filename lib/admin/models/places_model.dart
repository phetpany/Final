class PlacesModel {
  final String? docId;
  final String docIDGroup;
  final String name;
  final String description;
  final String urlGoogleMap;
  final List<String> urlImages;

  PlacesModel({
    this.docId,
    required this.docIDGroup,
    required this.name,
    required this.description,
    required this.urlGoogleMap,
    required this.urlImages,
  });

  Map<String, dynamic> toMap() {
    return {
      'docIDGroup': docIDGroup,
      'name': name,
      'description': description,
      'urlGoogleMap': urlGoogleMap,
      'urlImages': urlImages,
    };
  }

  factory PlacesModel.fromMap(Map<String, dynamic> map, String docId) {
    return PlacesModel(
      docId: docId,
      docIDGroup: map['docIDGroup'],
      name: map['name'],
      description: map['description'],
      urlGoogleMap: map['urlGoogleMap'],
      urlImages: List<String>.from(map['urlImages']),
    );
  }
}
