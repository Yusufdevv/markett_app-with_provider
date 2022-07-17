import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:markett_app/services/http_exception.dart';

import '../models/product.dart';

class Products with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Product> _list = [
    // Product(
    //   id: 'p1',
    //   title: "Macbook Pro M1 14",
    //   decsription: "Ajoyib Macbook Pro M1 14",
    //   price: 1599,
    //   imageUrl:
    //       "https://www.ixbt.com/img/n1/news/2021/9/0/FBlmFlnX0AIbDre_large.jpg",
    // ),
    // Product(
    //   id: 'p2',
    //   title: "Macbook Air M1 13",
    //   decsription: "Ajoyib Macbook Air M1 13",
    //   price: 1399,
    //   imageUrl:
    //       "https://www.notebookcheck-ru.com/uploads/tx_nbc2/appleairm1.png",
    // ),
    // Product(
    //   id: 'p3',
    //   title: "Imac M1",
    //   decsription: "Ajoyib Imac M1",
    //   price: 1499,
    //   imageUrl:
    //       "https://www.ferra.ru/thumb/860x0/filters:quality(75):no_upscale()/imgs/2021/09/06/10/4873148/5589f913ffc883a298bbf932e1998e4a66e34036.jpg",
    // ),
    // Product(
    //   id: 'p4',
    //   title: "Ipad Pro M1",
    //   decsription: "Ajoyib Ipad Pro M1",
    //   price: 999,
    //   imageUrl:
    //       "https://www.cnet.com/a/img/resize/edadd6db9a6b518a9b8d038f89cd80d08856bd7e/hub/2021/05/17/1201d422-1d09-40b4-b893-b56016258c72/ipad-pro-m1-2021-cnet-2021-051.jpg?auto=webp&width=1092",
    // ),
  ];

  String? _authToken;
  String? _userId;

  void setParams(String? authToken, String? userId) {
    _authToken = authToken;
    _userId = userId;
  }

  List<Product> get list {
    return [..._list];
  }

  List<Product> get favorites {
    return _list.where((product) => product.isFavorite).toList();
  }

  Future<void> getProductsFromFirebase([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$_userId"' : '';
    final url = Uri.parse(
        'https://online-magazin-e3ce2-default-rtdb.firebaseio.com/products.json?auth=$_authToken&$filterString');

    try {
      final response = await http.get(url);

      if (jsonDecode(response.body) != null) {
        final favoriteUrl = Uri.parse(
            'https://online-magazin-e3ce2-default-rtdb.firebaseio.com/userFavorites/$_userId.json?auth=$_authToken');

        final favoriteResponse = await http.get(favoriteUrl);
        final favoriteData = jsonDecode(favoriteResponse.body);

        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final List<Product> loadedProducts = [];
        data.forEach((productId, productData) {
          loadedProducts.add(Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            imageUrl: productData['imageUrl'],
            isFavorite:
                favoriteData == null ? false : favoriteData[productId] ?? false,
          ));
        });

        _list = loadedProducts;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    //http formula = Http Endpoint(url) + http so'rovi = natija
    final url = Uri.parse(
        'https://online-magazin-e3ce2-default-rtdb.firebaseio.com/products.json?auth=$_authToken');

    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'creatorId': _userId,
          },
        ),
      );

      final name = (jsonDecode(response.body) as Map<String, dynamic>)['name'];
      final newProduct = Product(
        id: name,
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _list.add(newProduct);
      //_list.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      // throw error;
      rethrow;
    }
  }

  Future<void> updateProduct(Product updateProduct) async {
    final productIndex = _list.indexWhere(
      (product) => product.id == updateProduct.id,
    );
    if (productIndex >= 0) {
      final url = Uri.parse(
          'https://online-magazin-e3ce2-default-rtdb.firebaseio.com/products/${updateProduct.id}.json?auth=$_authToken');
      try {
        await http.patch(
          url,
          body: jsonEncode(
            {
              'title': updateProduct.title,
              'description': updateProduct.description,
              'price': updateProduct.price,
              'imageUrl': updateProduct.imageUrl,
            },
          ),
        );
        _list[productIndex] = updateProduct;
        notifyListeners();
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://online-magazin-e3ce2-default-rtdb.firebaseio.com/products/$id.json?auth=$_authToken');
    
    try {
      var deletingProduct = _list.firstWhere((product) => product.id == id);
      final productIndex = _list.indexWhere((product) => product.id == id);
      _list.removeWhere((product) => product.id == id);
      notifyListeners();

      final response = await http.delete(url);

      if (response.statusCode >= 400) {
        _list.insert(productIndex, deletingProduct);
        notifyListeners();
        throw HttpException("Kechirasiz, o'chirishdagi xatolik");
      }
    } catch (e) {
      rethrow;
    }
  }

  Product findById(String productId) {
    return _list.firstWhere((product) => product.id == productId);
  }
}
