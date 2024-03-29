import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_products_screen.dart';
import '../providers/products.dart';
import '../widgets/appdrawer.dart';
import '../widgets/user_products_list.dart';

class ManageProductsScreen extends StatelessWidget {
  const ManageProductsScreen({Key? key}) : super(key: key);

  static const routeName = '/manage-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .getProductsFromFirebase(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsProvider = Provider.of<Products>(context);
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
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshotData) {
          if (snapshotData.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshotData.connectionState == ConnectionState.done) {
            return RefreshIndicator(
              onRefresh: () => _refreshProducts(context),
              child: Consumer<Products>(builder: (c, productsProvider, _) {
                return productsProvider.list.isNotEmpty
                    ? ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: productsProvider.list.length,
                        itemBuilder: (ctx, i) {
                          final product = productsProvider.list[i];
                          return ChangeNotifierProvider.value(
                            value: product,
                            child: const UserProductsItem(),
                          );
                        })
                    : const Center(
                        child: Text("Maxsulotlaringiz mavjud emas"),
                      );
              }),
            );
          } else {
            return const Center(
              child: Text("Xatolik sodir bo'ldi"),
            );
          }
        },
      ),
    );
  }
}
