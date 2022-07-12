import 'package:flutter/material.dart';
import 'package:markett_app/screens/edit_products_screen.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

import '../widgets/appdrawer.dart';
import '../widgets/user_products_list.dart';

class ManageProductsScreen extends StatelessWidget {
  const ManageProductsScreen({Key? key}) : super(key: key);

  static const routeName = '/manage-products';

  Future<void> refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context).getProductsFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Mahsulotlarni boshqarish"),
        actions: [
          IconButton(
            onPressed: () =>
                  Navigator.of(context).pushNamed(EditProductScreen.routeName),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => refreshProducts(context),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: productsProvider.list.length,
          itemBuilder: (ctx, i) {
            final product = productsProvider.list[i];
          return ChangeNotifierProvider.value(
            value: product,
            child:const UserPrdouctsList());
        }  ),
      )
    );
  }
}
