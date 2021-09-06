import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import '../screens/product_details_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';


class ProductItem extends StatelessWidget {
  //const ProductItem({Key? key}) : super(key: key);
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(this.id, this.title, this.imageUrl);
  @override
  Widget build(BuildContext context) {
   final product = Provider.of<Product>(context, listen: false);
   final cart = Provider.of<Cart>(context, listen: false);
   final authData = Provider.of<Auth>(context, listen: false);
   // Note that if the data changes affect only a single widget, using stateful will be okay, if its just to change how something is displayed in one widget, you don't need a provider
   // setting listen to false makes it to not listen to every changes made that is not directly related
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child:GestureDetector(
          onTap: (){
            Navigator.of(context).pushNamed(ProductDetailsScreen.routeName, arguments:product.id,);
            // Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> ProductDetailsScreen(title),));
          },
            child: Image.network(product.imageUrl, fit: BoxFit.cover,)),
      footer: GridTileBar(
        // consumer is another way of using provider.of, it is also used if only a part of your widget depends on the data provided
        leading:Consumer<Product>(
          builder: (ctx,product, child) => IconButton(
            // child is a part of the consumer that does not listen to the notification
            onPressed: (){
              product.toggleFavorite(authData.token);
            },
            icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).accentColor
            ),
          ),
        ),
        backgroundColor: Colors.black87,
        title: Text(product.title, textAlign: TextAlign.center,),
        trailing: IconButton(icon: Icon(Icons.shopping_cart,
        color: Theme.of(context).accentColor,),
        onPressed: (){
           cart.addItem(product.id, product.price, product.title);
             // Scaffold.of(context).openDrawer(); // it takes the context of the nearest scaffold;
           Scaffold.of(context).hideCurrentSnackBar();
           Scaffold.of(context).showSnackBar(SnackBar(content: Text('Added Item to cart',),
           duration: Duration(seconds: 2),
            action: SnackBarAction(label: 'UNDO',onPressed: (){
              cart.removeSingleItem(product.id);
            },),
           ));
        },),
      ),
      ),
    );
  }
}
