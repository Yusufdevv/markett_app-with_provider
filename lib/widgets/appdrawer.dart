import 'package:flutter/material.dart';
import 'package:markett_app/providers/auth.dart';
import 'package:markett_app/screens/home_screen.dart';
import 'package:markett_app/screens/manage_products_screen.dart';
import 'package:markett_app/screens/orders_screen.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            title: const Text("Drawer"),
          ),
          ListTile(
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(HomeScreen.routeName),
            leading:const Icon(Icons.shop),
            title:const Text("Magazin"),
          ),
          const Divider(),
          ListTile(
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(OrdersScreen.routeName),
            leading:const Icon(Icons.shopping_bag),
            title:const Text("Buyurtmalar"),
          ),
          const Divider(),
          ListTile(
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(ManageProductsScreen.routeName),
            leading:const Icon(Icons.settings),
            title:const Text("Mahsulotlarni boshqarish"),
          ),
          const Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logout();
            } ,
            leading:const Icon(Icons.exit_to_app),
            title:const Text("Chiqish"),
          )
        ],
      ),
    );
  }
}
