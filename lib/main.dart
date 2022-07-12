import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/screens/cart_screen.dart';
import '/screens/auth_screen.dart';
import '/screens/edit_products_screen.dart';
import '/screens/manage_products_screen.dart';
import '/screens/orders_screen.dart';
import '/screens/home_screen.dart';
import '/screens/product_details_screen.dart';

import '/providers/auth.dart';
import 'providers/orders.dart';
import 'providers/products.dart';
import 'providers/carts.dart';

import '../styles/my_market_style.dart';

void main() {
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  ThemeData theme = MyMarketStyle.theme;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(
        create: (ctx) => Auth(),
      ),
        ChangeNotifierProvider<Products>(
        create: (ctx) => Products(),
      ),
      ChangeNotifierProvider<Cart>(
        create: (ctx) => Cart(),
      ),
      ChangeNotifierProvider<Orders>(
        create: (ctx) => Orders(),
      ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: const AuthScreen(),
        routes: {
          HomeScreen.routeName:(context) => const HomeScreen(),
          ProductDetailsScreen.routeName: (ctx) => const ProductDetailsScreen(),
          CartScreen.routeName: (ctx) => const CartScreen(),
          OrdersScreen.routeName: (ctx) => const OrdersScreen(),
          ManageProductsScreen.routeName: (ctx) => const ManageProductsScreen(),
          EditProductScreen.routeName: (ctx) => const EditProductScreen(),

        },
      ),
    );
  }
}