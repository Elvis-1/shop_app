import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' show Orders; // there is a name clash, since we don't need everything, we just show what we need.
import '../widget/order_item.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: ListView.builder(itemCount:ordersData.orders.length,itemBuilder:(ctx, i) =>OrderItem(ordersData.orders[i]) ),
    );
  }
}
