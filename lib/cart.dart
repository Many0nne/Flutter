// cart.dart
import 'package:flutter/material.dart';
import 'package:epsi_shop/bo/product.dart';

class Cart with ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => _items;

  List<Product> getAll() {
    return _items;
  }

  void add(Product product) {
    _items.add(product);
    notifyListeners();
  }

  void remove(Product product) {
    _items.remove(product);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  int get count => _items.length;

  double get total => _items.fold(0, (sum, item) => sum + (item.price * 1.2)); // TVA 20%
}
