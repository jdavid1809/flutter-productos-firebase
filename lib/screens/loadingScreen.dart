import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
   
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
      ),
      body: const Center(
         child: CircularProgressIndicator(
          color: Colors.indigo,
         ),
      ),
    );
  }
}