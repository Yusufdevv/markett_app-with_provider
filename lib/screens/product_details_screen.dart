import 'package:flutter/material.dart';
import 'package:markett_app/providers/carts.dart';
import 'package:markett_app/screens/cart_screen.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({Key? key}) : super(key: key);

  static const routeName = '/product-details';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments;
    final product = Provider.of<Products>(context, listen: false)
        .findById(productId as String);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 300,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(product.description),
            )
          ],
        ),
      ),
      bottomSheet: BottomSheet(
          onClosing: () {},
          builder: (ctx) {
            return SizedBox(
              height: 100,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Narxi:",
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        Text(
                          "\$${product.price}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 18),
                        )
                      ],
                    ),
                    Consumer<Cart>(
                      builder: (ctx, cart, child) {
                        final isProductAdded =
                            cart.items.containsKey(productId);
                        if (isProductAdded) {
                          return ElevatedButton.icon(
                            onPressed: () => Navigator.of(context)
                                .pushNamed(CartScreen.routeName),
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                primary: Colors.grey.shade200),
                            icon: const Icon(
                              Icons.shopping_bag_outlined,
                              size: 15,
                              color: Colors.black,
                            ),
                            label: const Text(
                              "Savatchaga borish",
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        }
                        return ElevatedButton(
                          onPressed: () => cart.addTocart(productId,
                              product.title, product.imageUrl, product.price),
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              primary: Colors.black),
                          child: const Text(
                            "Savatchaga qo'shish",
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
