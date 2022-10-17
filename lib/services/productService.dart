import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:productosapp/models/models.dart';
import 'package:http/http.dart' as http;

class ProductService extends ChangeNotifier{
  final String _baseUrl = "flutter-varios-a10ba-default-rtdb.firebaseio.com";
  final List<Product> products = [];
  late Product selectedProduct;

  File? newPictureFile;

  bool isLoading = true;
  bool isSaving = false;

  ProductService(){
    this.loadProducts();
  }

  Future <List<Product>>/*Esto estaria de mas*/ loadProducts() async{
      
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, "products.json");
    final resp = await http.get(url);

    final Map<String, dynamic> productsMap = json.decode( resp.body);
    
    productsMap.forEach((key, value) {
      final temoProduct = Product.fromMap(value);
      temoProduct.id = key;
      products.add(temoProduct);
    });


    isLoading = false;
    notifyListeners();

    return products;//Esto estaria de mas

  }

  Future saveOrCreateProduct(Product product)async{
    isSaving= true;
    notifyListeners();
    if(product.id == null){
      await createProduct(product);
    }else{
      await updateProduct(product);
    }
    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Product product)async{
    final url = Uri.https(_baseUrl, "products/${product.id}.json");
    final resp = await http.put(url, body: product.toJson());
    final decodedData = resp.body;

    //Forma del curso

    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;

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
  
  Future<String> createProduct(Product product)async{
    final url = Uri.https(_baseUrl, "products.json");
    final resp = await http.post(url, body: product.toJson());
    final decodedData = json.decode(resp.body);

    product.id = decodedData['name'];
    products.add(product);

    return "";
  }

  void updateSelectedProductImage(String path){
    selectedProduct.picture = path;
    newPictureFile = File.fromUri(Uri(path: path));

    notifyListeners();
  }

  void deleteSelectProduct(){
    
  }

  Future<String?> uploadImage()async{
    if(newPictureFile == null) return null;

    isSaving = true;
    notifyListeners();

    final url = Uri.parse("https://api.cloudinary.com/v1_1/dvtliykyw/image/upload?upload_preset=eictoljn");

    final imageUploadRequest = http.MultipartRequest('Post',url);

    final file = await http.MultipartFile.fromPath('file', newPictureFile!.path);

    imageUploadRequest.files.add(file);

    final streamResponce = await imageUploadRequest.send();

    final resp = await http.Response.fromStream(streamResponce);

    if(resp.statusCode != 200 && resp.statusCode != 201){
      print("algo salio mal");
      print(resp.body);
      return null;
    }

    final decodedData = json.decode(resp.body);
    return decodedData['secure_url'];
  }


}

