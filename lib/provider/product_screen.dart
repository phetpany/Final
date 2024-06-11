import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'product.dart';
import 'provided.dart';


class JewelryScreen extends StatefulWidget {
  @override
  _JewelryScreenState createState() => _JewelryScreenState();
}

class _JewelryScreenState extends State<JewelryScreen> {
  
  @override
  void initState() {
    super.initState();
    Provider.of<JewelryProvider>(context, listen: false).fetchJewelryProducts();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Jewelry Products"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              await Provider.of<JewelryProvider>(context, listen: false).addNewProduct(
                "New Product",
                "Description of new product",
                99.99,
                "https://example.com/image.jpg",
              );
            },
          ),
        ],
      ),
      body: Consumer<JewelryProvider>(
        builder: (context, jewelryProvider, child) {
          if (jewelryProvider.jewelryProducts.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: jewelryProvider.jewelryProducts.length,
            itemBuilder: (context, index) {
              final product = jewelryProvider.jewelryProducts[index];
              return ListTile(
                title: Text(product.title),
                subtitle: Text('\$${product.price.toString()}'),
                leading: Image.network(product.image, width: 50, height: 50, fit: BoxFit.cover),
                onTap: () async {
                  await _showUpdateProductDialog(context, product);
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showUpdateProductDialog(BuildContext context, JewelryProduct product) async {
    TextEditingController titleController = TextEditingController(text: product.title);
    TextEditingController descriptionController = TextEditingController(text: product.description);
    TextEditingController priceController = TextEditingController(text: product.price.toString());
    TextEditingController imageController = TextEditingController(text: product.image);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Product'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                TextField(
                  controller: imageController,
                  decoration: InputDecoration(labelText: 'Image URL'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Update'),
              onPressed: () async {
                // Call updateProduct with the updated information
                await Provider.of<JewelryProvider>(context, listen: false).updateProduct(
                  product.id,
                  titleController.text,
                  descriptionController.text,
                  double.parse(priceController.text),
                  imageController.text,
                );
                Navigator.of(context).pop(); // Close the dialog
              },

              
            ),
            TextButton(
                  child: Text('Delete'),
                  onPressed: () async {
                    // Call deleteProduct to delete the product
                    await Provider.of<JewelryProvider>(context, listen: false).deleteProduct(product.id);
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
          ],
        );
      },
    );
  }
}
