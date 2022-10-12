import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:productosapp/models/models.dart';
import 'package:http/http.dart' as http;

class ProductService extends ChangeNotifier{
  final String _baseUrl = "flutter-varios-a10ba-default-rtdb.firebaseio.com";
  final List<Product> products = [];

  bool isLoading = true;

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

}

