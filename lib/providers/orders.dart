import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/cart_item.dart';
import '../models/order.dart';

class Orders with ChangeNotifier {
  List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }
  

  Future<void> getOrdersFromFirebase() async {
    final url = Uri.parse(
        "https://online-magazin-e3ce2-default-rtdb.firebaseio.com/orders.json");

    try {
      final response = await http.get(url);
      if(jsonDecode(response.body) == null) {
        return;
      }
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final List<Order> loadedOrders = [];
      data.forEach((orderId, order) {
        loadedOrders.insert(
          0,
          Order(
            id: orderId,
            totalPrice: order['totalPrice'],
            date: DateTime.parse(order['date']),
            product: (order['product'] as List<dynamic>)
                .map(
                  (product) => CartItem(
                    id: product['id'],
                    title: product['title'],
                    quantity: product['quantity'],
                    price: product['price'],
                    image: product['image'],
                  ),
                )
                .toList(),
          ),
        );
      });
      _items = loadedOrders;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addToOrders(List<CartItem> products, double totalPrice) async {
    final url = Uri.parse(
        "https://online-magazin-e3ce2-default-rtdb.firebaseio.com/orders.json");


    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            'totalPrice': totalPrice,
            'date': DateTime.now().toIso8601String(),
            'product': products
                .map((product) => {
                      'id': product.id,
                      'title': product.title,
                      'quantity': product.quantity,
                      'price': product.price,
                      'image': product.image,
                    })
                .toList(),
          },
        ),
      );

      final name = jsonDecode(response.body)['name'];
      _items.insert(
          0,
          Order(
            id: name,
            totalPrice: totalPrice,
            date: DateTime.now(),
            product: products,
          ));
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
