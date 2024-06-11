import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'product.dart';

class JewelryProvider with ChangeNotifier {
  List<JewelryProduct> _jewelryProducts = [];
  List<JewelryProduct> get jewelryProducts => _jewelryProducts;

  // Fetch jewelry products from the API
  Future<void> fetchJewelryProducts() async {
    final response = await http.get(Uri.parse('https://fakestoreapi.com/products/category/jewelery'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      _jewelryProducts = data.map((item) => JewelryProduct.fromJson(item)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load jewelry products');
    }
  }

  // Add a new jewelry product
  
  Future<void> addNewProduct(String title, String description, double price, String image) async {
    final url = Uri.parse('https://fakestoreapi.com/products');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': title,
        'description': description,
        'price': price,
        'image': image,
        'category': 'jewelery',
      }),
    );
  // Implement updateProduct and deleteProduct methods as wel
print('response.body:${response.body}');
print('response.body:${response.statusCode}');
    if (response.statusCode == 200) {
      final newProduct = JewelryProduct.fromJson(json.decode(response.body));
      _jewelryProducts.add(newProduct);
      notifyListeners();
    } else {
      throw Exception('Failed to add a new product');
    }
  }

  // Update a jewelry product
  Future<void> updateProduct(int productId, String title, String description, double price, String image) async {
    final url = Uri.parse('https://fakestoreapi.com/products/$productId');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': title,
        'description': description,
        'price': price,
        'image': image,
      }),
    );
   
 print('response.update:${response.body}');
    if (response.statusCode == 200) {
      final updatedProduct = JewelryProduct.fromJson(json.decode(response.body));
      final index = _jewelryProducts.indexWhere((product) => product.id == productId);
      if (index != -1) {
        _jewelryProducts[index] = updatedProduct;
        notifyListeners();
      }
    } else {
      throw Exception('Failed to update product');
    }
  }

  // Delete a jewelry product
  Future<void> deleteProduct(int productId) async {
    final url = Uri.parse('https://fakestoreapi.com/products/$productId');
    final response = await http.delete(url);
print('response.body:${response.body}');
    if (response.statusCode == 200) {
      _jewelryProducts.removeWhere((product) => product.id == productId);
      notifyListeners();
    } else {
      throw Exception('Failed to delete product');
    }
  }
  
}
