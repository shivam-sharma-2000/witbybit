import 'package:flutter/material.dart';
import 'package:untitled/model/CartItem.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  void addItem(String name, int price, {String image = ''}) {
    if (_items.containsKey(name)) {
      _items[name]!.quantity += 1;
    } else {
      _items[name] = CartItem(name: name, price: price, image: image, quantity: 1);
    }
    notifyListeners();
  }

  void removeItem(String name) {
    if (_items.containsKey(name)) {
      if (_items[name]!.quantity > 1) {
        _items[name]!.quantity -= 1;
      } else {
        _items.remove(name);
      }
      notifyListeners();
    }
  }

  int getQuantity(String name) {
    return _items[name]?.quantity ?? 0;
  }

  int get totalItems {
    return _items.values.fold(0, (sum, item) => sum + item.quantity);
  }

  int get totalPrice {
    return _items.values.fold(0, (sum, item) => sum + item.price * item.quantity);
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
