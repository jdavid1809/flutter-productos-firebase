import 'package:flutter/material.dart';
import 'package:productosapp/screens/screens.dart';
import 'package:productosapp/services/services.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

final productsService = Provider.of<ProductService>(context);
final authService = Provider.of<AuthService>(context, listen: false);

if(productsService.isLoading) return LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Products"),
        // actions: [
        //   IconButton(
        //     onPressed: (){

        //     },
        //     icon: Icon(Icons.logout_outlined),
        //   ),
        // ],
        leading: IconButton(
          icon: Icon(Icons.logout_outlined),
          onPressed: (){
            authService.logout();
            Navigator.pushReplacementNamed(context, 'login');
          },
        ),
      ),
      body: ListView.builder(
        itemCount: productsService.products.length,
        itemBuilder: (BuildContext context, int index) => GestureDetector(
          onTap: () {
            productsService.selectedProduct = productsService.products[index].copy();
            Navigator.pushNamed(context, "product");
          },
          child: ProductCard(product: productsService.products[index],),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: (){
          productsService.selectedProduct = Product(
            available: true,
             name: "",
              price: 0
            );
          Navigator.pushNamed(context, 'product');

        },
      ),
    );
  }
}