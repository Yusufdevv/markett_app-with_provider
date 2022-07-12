import 'package:markett_app/models/cart_item.dart';

class Order{
  final String id;
  final double totalPrice;
  final DateTime date;
  final List<CartItem> product;

  Order({required this.id,required this.totalPrice,required this.date,required this.product});

}