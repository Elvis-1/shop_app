import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class ProductDetailsScreen extends StatelessWidget {
  //const ProductDetailsScreen({Key? key}) : super(key: key);
 // final String title;
 // ProductDetailsScreen(this.title);

  static const routeName = '/product_detail';
  @override
  Widget build(BuildContext context) {

    final productId = ModalRoute.of(context);
    if(productId == null) return SizedBox.shrink();
   else productId.settings.arguments as String;
      final loadedProduct = Provider.of<Products>(context, listen: false).findById(productId.settings.arguments as String);
      print(loadedProduct.title);

    return Scaffold(
      appBar: AppBar(
        title:Text( loadedProduct.title,),),
      body: Container(
        child: Center(
          child: Text(loadedProduct.description,
          style: TextStyle(color: Theme.of(context).accentColor),),
        ),
      ),
    );
  }
}
