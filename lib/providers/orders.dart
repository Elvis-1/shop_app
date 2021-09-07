import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
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
  final String? authToken;
  final String? userId;

  Orders(this.authToken,this.userId,this._orders);

  List<OrderItem> get orders{
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async{
    final url = 'https://myapp-a30dc.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(Uri.parse(url));
    final List<OrderItem> loadedOrders = [];

    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    //print(json.decode(response.body));
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(id: orderId,
            amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['dateTime']),
        products: (orderData['products'] as List<dynamic>).map((item)=>
            CartItem(
            id: item['id'],
                title: item['title'],
                quantity: item['quantity'],
                price: item['price'])).toList(),
        )

      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }
  Future<void> addOrder(List<CartItem> cartProducts, double total) async{
    final url = 'https://myapp-a30dc.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timeStamp = DateTime.now(); // this will help to make the time been sent to the server and the one stored locally equal
    final response = await http.post(Uri.parse(url), body: json.encode({
      'amount': total,
      'dateTime': timeStamp.toIso8601String(),
      'products':cartProducts.map((cp)=>{
        'id':cp.id,
        'title':cp.title,
        'quantity':cp.quantity,
        'price':cp.price
      }).toList()
    }));
    // add adds to the last element, inserts using 0 index adds to the first, index 1 adds to the last
  _orders.insert(0, OrderItem(
      id: json.decode(response.body)['name'],
      amount: total,
      products: cartProducts,
      dateTime: timeStamp));
  notifyListeners(); // this will notify any part of the app where changes that happens here is been listened to
  }

}