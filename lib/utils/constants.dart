import '../model/CartItem.dart';

class Constant{
  static Map<String, CartItem> cart = {};

  List<CartItem> restoreItem(allItems) {
    Constant.cart.values.forEach((ci){
      for(int i =0; i< allItems.length; i++){
        if(allItems[i].name == ci.name){
            allItems[i].quantity = ci.quantity;
        }
      }
    });
    return allItems;
  }
}
