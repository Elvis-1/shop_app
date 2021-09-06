import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import './screens/auth_screen.dart';
import './screens/cart_screen.dart';
import './screens/product_details_screen.dart';
import './screens/products_overview_screen.dart';
import './providers/products.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './providers/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // we could have added our auth provider only to the auth screen but since we will need it in different screens, lets it here
        ChangeNotifierProvider.value(
            value: Auth()),
        ChangeNotifierProxyProvider<Auth,Products>(
          create: (BuildContext context) => Products(Provider.of<Auth>(context, listen:false).token,[]),
          update: (_,auth,previousProducts) => Products(auth.token,previousProducts == null? []:previousProducts.items),
        ),

    // create: (ctx) => Products(), // where products() is a new instance of the provider class
        ChangeNotifierProvider.value(
          // The additional benefit of using ChangeNotifierProvider is that it does not store data in memory
          value: Cart(),),
        // ChangeNotifierProvider.value(
        //     value: Orders(),),
        ChangeNotifierProxyProvider<Auth,Orders>(
            create:(BuildContext context) => Orders(Provider.of<Auth>(context).token,[]),
           update: (_,auth, previousOrders) => Orders(Provider.of<Auth>(context).token,[]),),
    ],


      child: Consumer<Auth>(builder:(ctx, auth, _)=>MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          // home: ProductsOverViewScreen(),
          home: auth.isAuth? ProductsOverViewScreen() : AuthScreen(),
          routes: {
            ProductDetailsScreen.routeName : (ctx)=> ProductDetailsScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName : (ctx)=>OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx)=> EditProductScreen(),
          }
      ), )
    );
  }
}


