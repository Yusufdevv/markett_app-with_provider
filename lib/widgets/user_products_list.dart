import 'package:flutter/material.dart';
import 'package:markett_app/providers/products.dart';
import 'package:provider/provider.dart';

import '../screens/edit_products_screen.dart';
import '../models/product.dart';

class UserProductsItem extends StatelessWidget {
  const UserProductsItem({Key? key}) : super(key: key);

  void notifyUserAboutDelete(BuildContext context, Function() removeItem) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text("Ishonchingiz komilmi?"),
            content: const Text("Bu mahsulot o'chmoqda!"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  "BEKOR QILISH",
                  style: TextStyle(color: Colors.black54),
                ),
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
    final product = Provider.of<Product>(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
            product.imageUrl,
          ),
        ),
        title: Text(product.title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName,
                    arguments: product.id);
              },
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
            ),
            IconButton(
              splashRadius: 20,
              onPressed: () {
                notifyUserAboutDelete(context, () async {
                  try {
                    await Provider.of<Products>(context, listen: false)
                        .deleteProduct(product.id);
                  } catch (e) {
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                      ),
                    );
                  }
                });
              },
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
