import 'package:flutter/material.dart';
import 'package:markett_app/screens/splash_screen.dart';
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
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products(),
          update: (ctx, auth, previousProducts) =>
              previousProducts!..setParams(auth.token, auth.userId),
        ),
        ChangeNotifierProvider<Cart>(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders(),
          update: (ctx, auth, previousOrders) =>
              previousOrders!..setParams(auth.token, auth.userId),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, authData, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Market App',
            theme: theme,
            home: authData.isAuth
                ? const HomeScreen()
                : FutureBuilder(
                    future: authData.autoLogin(),
                    builder: (c, autoLoginData) {
                      if (autoLoginData.connectionState ==
                          ConnectionState.waiting) {
                        return const SplashScreen();
                      } else {
                        return const AuthScreen();
                      }
                    }),
            routes: {
              HomeScreen.routeName: (ctx) => const HomeScreen(),
              ProductDetailsScreen.routeName: (ctx) =>
                  const ProductDetailsScreen(),
              CartScreen.routeName: (ctx) => const CartScreen(),
              OrdersScreen.routeName: (ctx) => const OrdersScreen(),
              ManageProductsScreen.routeName: (ctx) =>
                  const ManageProductsScreen(),
              EditProductScreen.routeName: (ctx) => const EditProductScreen(),
            },
          );
        },
      ),
    );
  }
}
