import 'package:flutter/material.dart';
import 'package:markett_app/providers/orders.dart';
import 'package:markett_app/widgets/appdrawer.dart';
import 'package:markett_app/widgets/order_item.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  static const routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future _orderFuture;

  Future _getOrderFuture() {
    return Provider.of<Orders>(context, listen: false).getOrdersFromFirebase();
  }

  @override
  void initState() {
    _orderFuture = _getOrderFuture();

    // Future.delayed(Duration.zero).then((_) {
    //   setState(() {
    //     _isloading = true;
    //   });
    //   Provider.of<Orders>(context, listen: false)
    //       .getOrdersFromFirebase()
    //       .then((value) {
    //     setState(() {
    //       _isloading = false;
    //     });
    //   });
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buyurtmalar"),
      ),
      drawer: const AppDrawer(),
      body:
          // orders.items.isEmpty
          //     ? const Center(
          //         child: Text("Buyurtmalar mavjud emas!"),
          //       )
          //     : _isloading
          //         ?const Center(child:  CircularProgressIndicator())
          //         :
          FutureBuilder(
        future: _orderFuture,
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error == null) {
              return Consumer<Orders>(
                builder: (c, orders, child) => orders.items.isEmpty
                    ? const Center(child: Text("Buyutmalar mavjud emas"))
                    : ListView.builder(
                        itemCount: orders.items.length,
                        itemBuilder: (ctx, i) {
                          final order = orders.items[i];
                          return OrderItem(
                            date: order.date,
                            totalPrice: order.totalPrice,
                            products: order.product,
                          );
                        },
                      ),
              );
            } else {
              return const Center(
                child: Text("Xatolik yuz berdi!"),
              );
            }
          }
        },
      ),
    );
  }
}
