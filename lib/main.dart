import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:epsi_shop/cart.dart'; // Importez la nouvelle page
import 'package:epsi_shop/app.dart'; // Import de ton app

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Cart(),
      child: MyApp(),
    ),
  );
}
