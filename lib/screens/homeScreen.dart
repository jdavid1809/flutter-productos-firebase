import 'package:flutter/material.dart';
import 'package:productosapp/screens/screens.dart';
import 'package:productosapp/services/services.dart';
import 'package:provider/provider.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

final productsService = Provider.of<ProductService>(context);
if(productsService.isLoading) return LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
      ),
      body: ListView.builder(
        itemCount: productsService.products.length,
        itemBuilder: (BuildContext context, int index) => GestureDetector(
          onTap: () => Navigator.pushNamed(context, "product"),
          child: ProductCard(product: productsService.products[index],),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){},
      ),
    );
  }
}