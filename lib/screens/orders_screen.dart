import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' show Orders; // there is a name clash, since we don't need everything, we just show what we need.
import '../widget/order_item.dart';
import '../widget/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  const OrdersScreen({Key? key}) : super(key: key);




  // var _isLoading = false;
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   // Future.delayed(Duration.zero).then((_) async{
  //   //   setState(() {
  //   //     _isLoading = true;
  //   //   });
  //   //   await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  //   //   setState(() {
  //   //     _isLoading = false;
  //   //   });
  //   // });
  //   super.initState();

  @override
  Widget build(BuildContext context) {
    print('building orders');
   // final ordersData = Provider.of<Orders>(context); // getting the order data here will create an infinite loop, because it will keep fetching anytime buider runs
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      //We are using a future builder as an alternative to changing the widget to a stateful widget because of isLoading like we did in products screen, you can also convert product screen to future builder if you lik.
      body: FutureBuilder(future:  Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),builder: (ctx, dataSnapshot){
        if(dataSnapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        }else{
          if(dataSnapshot.error != null){
            // error handling
            return Center(child: Text('An Error occurred'),);
          }else{
            // we are using a consumer instead since this is the only place we need the order data
           return Consumer<Orders>(builder:(ctx, ordersData, child)=>
               ListView.builder(itemCount:ordersData.orders.length,itemBuilder:(ctx, i) =>
                   OrderItem(ordersData.orders[i]) ));
          }
        }
      },)

    );
  }
}
