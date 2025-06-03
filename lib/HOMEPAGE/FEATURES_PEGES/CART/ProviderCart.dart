import 'package:flutter/material.dart';
import 'package:werable_project/VENDITORE/ProductModel.dart';


class CartProvider extends ChangeNotifier {
  final List<Product> _products = [];

  List<Product> get products => _products;

  void add(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void remove(Product product) {
    _products.remove(product);
    notifyListeners();
  }

  double get total {
    return _products.fold(0.0, (sum, item) => sum + double.parse(item.price));
  }

  void clear() {
    _products.clear();
    notifyListeners();
  }
}
