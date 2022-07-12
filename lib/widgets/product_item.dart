import 'package:flutter/material.dart';
import 'package:markett_app/providers/auth.dart';
import 'package:provider/provider.dart';

import '../providers/carts.dart';

import '../models/product.dart';

import '/screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context,listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, pro, child) {
              return IconButton(
                onPressed: () {
                  pro.toggleFavorite(auth.token!, auth.userId);
                },
                icon: Icon(
                  pro.isFavorite ? Icons.favorite : Icons.favorite_outline,
                  color: Theme.of(context).primaryColor,
                ),
              );
            },
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            onPressed: () {
              cart.addTocart(
                product.id,
                product.title,
                product.imageUrl,
                product.price,
              );
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:const Text("Savatchaga qo'shildi"),
                  duration:const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: "BEKOR QILISH",
                    onPressed: () {
                      cart.removeSingleItem(product.id, isCartButton: true);
                    },
                  ),
                ),
              );
            },
            icon: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailsScreen.routeName,
                arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
