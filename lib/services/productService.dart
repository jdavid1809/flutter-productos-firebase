import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:productosapp/models/models.dart';
import 'package:http/http.dart' as http;

class ProductService extends ChangeNotifier{
  final String _baseUrl = "flutter-varios-a10ba-default-rtdb.firebaseio.com";
  final List<Product> products = [];
  late Product selectedProduct;

  bool isLoading = true;
  bool isSaving = false;

  ProductService(){
    this.loadProducts();
  }

  Future <List<Product>>/*Esto estaria de mas*/ loadProducts() async{
      
    bool isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, "products.json");
    final resp = await http.get(url);

    final Map<String, dynamic> productsMap = json.decode( resp.body);
    
    productsMap.forEach((key, value) {
      final temoProduct = Product.fromMap(value);
      temoProduct.id = key;
      this.products.add(temoProduct);
    });


    this.isLoading = false;
    notifyListeners();

    return this.products;//Esto estaria de mas

  }

  Future saveOrCreateProduct(Product product)async{
    isSaving= true;
    notifyListeners();
    if(product.id == null){
      
    }else{
      await this.updateProduct(product);
    }
    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Product product)async{
    final url = Uri.https(_baseUrl, "products/${product.id}.json");
    final resp = await http.put(url, body: product.toJson());
    final decodedData = resp.body;

    //Forma del curso

    final index = this.products.indexWhere((element) => element.id == product.id);
    this.products[index] = product;

    //MI FORMA

    // var i = 0;
    // for (i; product.id != products[i].id; i++) {
    // }
    // products[i].name = product.name; 
    // products[i].price = product.price; 
    // products[i].picture = product.picture;
    // products[i].available = product.available; 

    return product.id!;
  }

}

