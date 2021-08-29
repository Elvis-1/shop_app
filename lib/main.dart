import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import './screens/cart_screen.dart';
import './screens/product_details_screen.dart';
import './screens/products_overview_screen.dart';
import './providers/products.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
        // The additional benefit of using ChangeNotifierProvider is that it does not store data in memory
        value: Products(),),
    // create: (ctx) => Products(), // where products() is a new instance of the provider class
        ChangeNotifierProvider.value(
          // The additional benefit of using ChangeNotifierProvider is that it does not store data in memory
          value: Cart(),),
        ChangeNotifierProvider.value(
            value: Orders(),),
    ],


      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductsOverViewScreen(),
        routes: {
          ProductDetailsScreen.routeName : (ctx)=> ProductDetailsScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName : (ctx)=>OrdersScreen(),
        }
      ),
    );
  }
}


