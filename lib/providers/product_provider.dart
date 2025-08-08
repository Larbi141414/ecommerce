import 'package:flutter/foundation.dart';
import '../models/product.dart';

class ProductProvider extends ChangeNotifier {
  final List<Product> _products = [
    Product(id: 'p1', name: 'Sample Product', price: 100.0),
  ];

  List<Product> get products => List.unmodifiable(_products);

  Product? getById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  bool addProduct(Product product) {
    if (getById(product.id) != null) return false;
    _products.add(product);
    notifyListeners();
    return true;
  }

  bool deleteProduct(String id) {
    final idx = _products.indexWhere((p) => p.id == id);
    if (idx == -1) return false;
    _products.removeAt(idx);
    notifyListeners();
    return true;
  }
}
