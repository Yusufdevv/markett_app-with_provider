import 'package:flutter/material.dart';
import 'package:markett_app/providers/carts.dart';
import 'package:markett_app/screens/cart_screen.dart';
import 'package:markett_app/widgets/appdrawer.dart';
import 'package:markett_app/widgets/custom_cart.dart';

import 'package:provider/provider.dart';

import '../widgets/product_grid.dart';

enum FiltersOption {
  Favorites,
  All,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  
  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _showOnlyFavorites = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Market App"),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            onSelected: (FiltersOption filter) {
              setState(() {
                if (filter == FiltersOption.All) {
                  _showOnlyFavorites = false;
                } else {
                  _showOnlyFavorites = true;
                }
              });
            },
            itemBuilder: (ctx) {
              return const [
                PopupMenuItem(
                  value: FiltersOption.All,
                  child: Text("Barchasi"),
                ),
                PopupMenuItem(
                  value: FiltersOption.Favorites,
                  child: Text("Sevimli"),
                ),
              ];
            },
          ),
          Consumer<Cart>(
            builder: (ctx, cart, child) {
              return CustomCart(
                number: cart.itemCount().toString(),
                child: child!,
              );
            },
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      drawer:const AppDrawer(),
      body: ProductGrid(_showOnlyFavorites),
    );
  }
}
