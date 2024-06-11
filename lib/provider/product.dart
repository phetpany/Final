class JewelryProduct {
  final int id;
  final String title;
  final String description;
  final double price;
  final String image;

  JewelryProduct({required this.id, required this.title, required this.description, required this.price, required this.image});

  factory JewelryProduct.fromJson(Map<String, dynamic> json) {
    return JewelryProduct(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'].toDouble(),
      image: json['image'],
    );
  }
}