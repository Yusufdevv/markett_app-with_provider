import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import '../models/product.dart';

import '../providers/products.dart';
import '../widgets/product_item.dart';

class ProductGrid extends StatefulWidget {
  final bool showOnlyFavorites;
  const ProductGrid(
    this.showOnlyFavorites, {
    Key? key,
  }) : super(key: key);

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  late Future _productsFuture;
  // var _init = true;
  // var _isLoading = false;

  Future _getProductsFuture() {
    return Provider.of<Products>(context, listen: false)
        .getProductsFromFirebase();
  }

  @override
  void initState() {
    _productsFuture = _getProductsFuture();
    // Firebasedan malumot olishning  1-usuli
    // Provider.of<Products>(context, listen: false).getProductsFromFirebase();
    // -------
    // 2-usuli
    // Future.delayed(Duration.zero).then((value) {
    // Provider.of<Products>(context, listen: false).getProductsFromFirebase();
    // });
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   if (_init) {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     Provider.of<Products>(context, listen: false).getProductsFromFirebase().then((response) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     });
  //   }
  //   // 3-usuli
  //   _init = false;
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    // final products =
    //     widget.showOnlyFavorites ? productData.favorites : productData.list;

    return FutureBuilder(
        future: _productsFuture,
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error == null) {
              return Consumer<Products>(builder: (c, products, child) {
                final ps = widget.showOnlyFavorites
                    ? products.favorites
                    : products.list;
                return ps.isNotEmpty
                    ? GridView.builder(
                        padding: const EdgeInsets.all(20),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: 3 / 2,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                        ),
                        itemCount: ps.length,
                        itemBuilder: (ctx, i) {
                          return ChangeNotifierProvider<Product>.value(
                            value: ps[i],
                            child: const ProductItem(),
                          );
                        },
                      )
                    : const Center(
                        child: Text("Maxsulotlar mavjud emas"),
                      );
              });
            } else {
              return const Center(child: Text("Xatolik sodi bo'ldi!"),);
            }
          }
        });
  }
}
