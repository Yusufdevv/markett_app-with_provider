import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:markett_app/models/cart_item.dart';

class OrderItem extends StatefulWidget {
  final DateTime date;
  final double totalPrice;
  final List<CartItem> products;
  const OrderItem({
    Key? key,
    required this.date,
    required this.totalPrice,
    required this.products,

  }) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool expandItem = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          ListTile(
            title: Text("\$${widget.totalPrice.toStringAsFixed(2)}", style:const TextStyle(fontWeight: FontWeight.bold),),
            subtitle: Text(DateFormat('dd/MM/yyyy hh:mm').format(widget.date)),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  expandItem = !expandItem;
                });
              },
              icon: Icon(expandItem ? Icons.expand_less : Icons.expand_more),
            ),
          ),
          if(expandItem)
          Container(
            padding: const EdgeInsets.all(5),
            height: min(widget.products.length*20+30 , 100),
            child: ListView.builder(
              itemExtent: 20,
              itemCount: widget.products.length,
              itemBuilder: (ctx, i) {
                final productItem = widget.products[i];
                return ListTile(
                  title: Text(productItem.title, style:const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Text("${productItem.quantity}x \$${productItem.price}"),
                );
            }),
          )
        ],
      ),
    );
  }
}
