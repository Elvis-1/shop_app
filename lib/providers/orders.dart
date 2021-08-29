import 'package:flutter/foundation.dart';
import './cart.dart';

class OrderItem{
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
   required this.id,
    required this.amount,
    required this.products,
    required this.dateTime
  });
}
class Orders with ChangeNotifier{
  List<OrderItem> _orders = [];

  List<OrderItem> get orders{
    return [..._orders];
  }
  void addOrder(List<CartItem> cartProducts, double total){
    // add adds to the last element, inserts using 0 index adds to the first, index 1 adds to the last
  _orders.insert(0, OrderItem(
      id: DateTime.now().toString(),
      amount: total,
      products: cartProducts,
      dateTime: DateTime.now()));
  notifyListeners(); // this will notify any part of the app where changes that happens here is been listened to
  }

}