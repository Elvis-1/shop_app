import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget/app_drawer.dart';
import './cart_screen.dart';
import '../providers/cart.dart';

import '../widget/product_grid.dart';
import '../widget/badge.dart';


enum filterOptions {
  Favorites,
  All,
}
class ProductsOverViewScreen extends StatefulWidget {
  //const ProductsOverViewScreen({Key? key}) : super(key: key);

  @override
  _ProductsOverViewScreenState createState() => _ProductsOverViewScreenState();
}

class _ProductsOverViewScreenState extends State<ProductsOverViewScreen> {
  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    // final productsContainer = Provider.of<Products>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: [

          PopupMenuButton(
            onSelected: (filterOptions selectedValue){
              setState(() {
                if(selectedValue == filterOptions.Favorites){
                  _showOnlyFavorites = true;
                }else{
                  _showOnlyFavorites = false;
                }
              });

            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_)=> [
              PopupMenuItem(child: Text('Only Fovorites'),value:filterOptions.Favorites),
              PopupMenuItem(child: Text('Show All'),value:filterOptions.All),
            ],
          ),
          Consumer<Cart>(builder: (_,cart,ch) =>
              Badge(
                color: Theme.of(context).accentColor,
           child:ch!,
            value: cart.itemCount.toString(),
          ) ,
            child: IconButton(
              icon: Icon(Icons.shopping_cart,),
              onPressed: (){
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}
