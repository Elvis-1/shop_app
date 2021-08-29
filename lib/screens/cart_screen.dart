import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget/cart_item.dart' ;
import '../providers/cart.dart' show Cart;
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);
    static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total', style: TextStyle(fontSize: 20),),
                  // SizedBox(width: 10,),
                  Spacer(),
                  Chip(label: Text('\$${cart.totalAmount}', style: TextStyle(color: Theme.of(context).primaryTextTheme.title!.color),),
                  backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    child: Text('Order Now'),
                    onPressed: (){
                      Provider.of<Orders>(context, listen: false).addOrder(cart.items.values.toList(), cart.totalAmount);
                      cart.clear();
                    },
                  textColor: Theme.of(context).primaryColor,),
                ],
              ),
            ),
          ),
          // ListView can't be used directly in a column
          SizedBox(height: 10,),
          Expanded(child: ListView.builder(itemCount: cart.items.length, itemBuilder:(ctx,i) =>
          // we need to access values as we are accessing a map
              CartItem(
                  cart.items.values.toList()[i].id,cart.items.values.toList()[i].price,
                  cart.items.values.toList()[i].quantity,
                  cart.items.values.toList()[i].title,
                  cart.items.keys.toList()[i])))
        ],
      ),
    );
  }
}
