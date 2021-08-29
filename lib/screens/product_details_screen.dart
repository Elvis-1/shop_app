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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
          height: 300,
          width: double.infinity,
          child: Image.network(loadedProduct.imageUrl, fit: BoxFit.cover,),
        ),
            SizedBox(height: 10,),
            Text('\$${loadedProduct.price}',
              style:TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ) ,),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,// to take as much space as available
              child: Text(loadedProduct.description,
              textAlign: TextAlign.center,
                softWrap: true,// softwrap takes the text to a new line if its gets too much
              ),
            ),
          ],
        ),
      )
    );
  }
}
