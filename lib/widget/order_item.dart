import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math'; // import this to use min
import '../providers/orders.dart' as ord;
import 'package:intl/intl.dart';



class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  const OrderItem(this.order) : super();

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
margin: EdgeInsets.all(10),
child: Column(
  children: [
    ListTile(
title: Text('\$${widget.order.amount}'),
      subtitle: Text(DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)),
      trailing: IconButton(icon:Icon(_expanded ? Icons.expand_less : Icons.expand_more,),
        onPressed: (){
        setState(() {
          _expanded =!_expanded;
        });
        },
    ),
    ),
    if(_expanded == true) 
      Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        height: min(widget.order.products.length*20.0 + 10, 100),
        child: ListView(
          children: widget.order.products.map((prod)=>Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(prod.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              Text('${prod.quantity}x \$${prod.price}', style: TextStyle(fontSize: 18, color: Colors.grey),),
            ],
          )).toList(),
        ),
      ),
  ],
),
    );
  }
}
