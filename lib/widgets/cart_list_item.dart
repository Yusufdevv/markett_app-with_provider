import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:markett_app/providers/carts.dart';

import 'package:provider/provider.dart';

class CartListItem extends StatelessWidget {
  final String productId;
  final String image;
  final String title;
  final double price;
  final int quantity;

  const CartListItem(
      {Key? key,
      required this.productId,
      required this.image,
      required this.title,
      required this.price,
      required this.quantity})
      : super(key: key);

  void notifyUserAboutDelete(BuildContext context, Function() removeItem) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text("Ishonchingiz komilmi?"),
            content: const Text("Savatchadan bu mahsulot o'chmoqda!"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("BEKOR QILISH", style: TextStyle(color: Colors.black54),),
              ),
              ElevatedButton(
                onPressed: () {
                  removeItem();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).errorColor,
                ),
                child: const Text("O'CHIRISH"),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    return Slidable(
      key: ValueKey(productId),
      endActionPane: ActionPane(
        extentRatio: 0.3,
        motion: const ScrollMotion(),
        children: [
          ElevatedButton(
            onPressed: () =>
                notifyUserAboutDelete(context, () => cart.remove(productId)),
            style: ElevatedButton.styleFrom(
                primary: Theme.of(context).errorColor,
                padding:
                    const EdgeInsets.symmetric(vertical: 25, horizontal: 10)),
            child: const Text(
              "O'chirish",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 10,
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(image),
          ),
          title: Text(title),
          subtitle: Text("Umumiy: \$${(price * quantity).toStringAsFixed(2)}"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => cart.removeSingleItem(productId),
                icon: const Icon(
                  Icons.remove,
                  color: Colors.black,
                ),
                splashRadius: 20,
              ),
              Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(child: Text(quantity.toString())),
              ),
              IconButton(
                onPressed: () => cart.addTocart(productId, title, image, price),
                icon: const Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                splashRadius: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
