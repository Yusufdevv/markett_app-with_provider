import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/carts.dart';
import '../providers/orders.dart';
import '../widgets/cart_list_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Sizning savatchangiz"),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Umumiy: ", style: TextStyle(fontSize: 16)),
                  const Spacer(),
                  Chip(
                    label: Text("\$${cart.totalPrice.toStringAsFixed(2)}"),
                    labelStyle: const TextStyle(color: Colors.white),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: cart.itemCount(),
                itemBuilder: (ctx, i) {
                  final cartItem = cart.items.values.toList()[i];
                  return CartListItem(
                      productId: cart.items.keys.toList()[i],
                      image: cartItem.image,
                      title: cartItem.title,
                      price: cartItem.price,
                      quantity: cartItem.quantity);
                }),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isloading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart.items.isEmpty || _isloading) 
      ? null 
      : () async {
        setState(() {
          _isloading = true;
        });
        await Provider.of<Orders>(context, listen: false).addToOrders(
          widget.cart.items.values.toList(),
          widget.cart.totalPrice,
        );
        setState(() {
          _isloading = false;
        });
        widget.cart.clearCart();
      },
      child: _isloading ? const CircularProgressIndicator() : const Text("BUYURTMA QILISH"),
    );
  }
}
