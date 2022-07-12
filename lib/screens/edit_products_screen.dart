import 'package:flutter/material.dart';
import 'package:markett_app/models/product.dart';
import 'package:markett_app/providers/products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);

  static const routeName = '/edit-products';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _form = GlobalKey<FormState>();
  final _imageForm = GlobalKey<FormState>();

  var _product = Product(
    id: "",
    title: "",
    description: "",
    price: 0.0,
    imageUrl: "",
  );

  // final  _priceFocus = FocusNode();

  // @override
  // void dispose() {
  //   super.dispose();
  //   // _priceFocus.dispose();
  // }

  var _hasImage = true;
  var _init = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    // ignore: todo
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_init) {
      final productId = ModalRoute.of(context)!.settings.arguments;

      if (productId != null) {
        final editingProduct =
            Provider.of<Products>(context).findById(productId as String);
        _product = editingProduct;
      }
    }
    _init = false;
  }

  void showImageDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text("Rasm URL-ni kiriting"),
            content: Form(
              key: _imageForm,
              child: TextFormField(
                initialValue: _product.imageUrl,
                decoration: const InputDecoration(
                  labelText: "Rasm URL",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.url,
                onSaved: (newValue) {
                  _product = Product(
                    id: _product.id,
                    title: _product.title,
                    description: _product.description,
                    price: _product.price,
                    imageUrl: newValue!,
                    isFavorite: _product.isFavorite,
                  );
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Iltimos, rasm URL ni kiriting";
                  } else if (!value.startsWith('http')) {
                    return "Iltimos, to'g'ri URL yozing";
                  }
                  return null;
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("BEKOR QILISH"),
              ),
              ElevatedButton(
                onPressed: saveImage,
                child: const Text("SAQLASH"),
              ),
            ],
          );
        });
  }

  void saveImage() {
    final isValid = _imageForm.currentState!.validate();
    if (isValid) {
      _imageForm.currentState!.save();
      setState(() {
        _hasImage = true;
      });
      Navigator.of(context).pop();
    }
  }

  Future<void> saveForm() async {
    FocusScope.of(context).unfocus();
    final isValid = _form.currentState!.validate();
    setState(() {
      _hasImage = _product.imageUrl.isNotEmpty;
    });

    if (isValid && _hasImage) {
      _form.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      if (_product.id.isEmpty) {
        try {
          await Provider.of<Products>(context, listen: false)
              .addProduct(_product);
        } catch (error) {
          await showDialog<void>(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: const Text("Xatolik!"),
                  content: const Text("Internetingiz ishlamayapti!"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text("OK"),
                    ),
                  ],
                );
              });
        }
        //  finally {
        //   setState(() {
        //     _isLoading = false;
        //   });
        //   Navigator.of(context).pop();
        // }
      } else {
        try {
          await Provider.of<Products>(context, listen: false)
              .updateProduct(_product);
        } catch (error) {
          await showDialog<void>(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: const Text("Xatolik!"),
                  content: const Text("Internetingiz ishlamayapti!"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text("OK"),
                    ),
                  ],
                );
              });
        }
      }
      setState(() {
        _isLoading = false;
      });
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mahsulotlarni tahrirlash"),
        actions: [
          IconButton(
            onPressed: saveForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _product.title,
                        decoration: const InputDecoration(
                          labelText: "Nomi",
                          border: OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.next,
                        // onFieldSubmitted:(_) {
                        //   FocusScope.of(context).requestFocus(_priceFocus);
                        // } ,
                        onSaved: (newValue) {
                          _product = Product(
                              id: _product.id,
                              title: newValue!,
                              description: _product.description,
                              price: _product.price,
                              imageUrl: _product.imageUrl,
                              isFavorite: _product.isFavorite);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Iltimos, mahsulot nomini kiriting";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: _product.id.isEmpty
                            ? ''
                            : _product.price.toStringAsFixed(2),
                        decoration: const InputDecoration(
                          labelText: "Narxi",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        // focusNode: _priceFocus,
                        onSaved: (newValue) {
                          _product = Product(
                              id: _product.id,
                              title: _product.title,
                              description: _product.description,
                              price: double.parse(newValue!),
                              imageUrl: _product.imageUrl,
                              isFavorite: _product.isFavorite);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Iltimos, mahsulot narxini kiriting";
                          } else if (double.tryParse(value) == null) {
                            return "Iltimos, to'g'ri narxini kiriting";
                          } else if (double.parse(value) < 1) {
                            return "Mahsulot narxi 0 dan katta bo'lishi kerak";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: _product.description,
                        decoration: const InputDecoration(
                          labelText: "Qo'shimcha malumot",
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        // focusNode: _priceFocus,
                        onSaved: (newValue) {
                          _product = Product(
                              id: _product.id,
                              title: _product.title,
                              description: newValue!,
                              price: _product.price,
                              imageUrl: _product.imageUrl,
                              isFavorite: _product.isFavorite);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Iltimos, mahsulot ta'rifini kiriting";
                          } else if (value.length < 10) {
                            return "Iltimos, batafsilroq yozing";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      Card(
                        margin: const EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: _hasImage
                                  ? Colors.grey
                                  : Theme.of(context).errorColor),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: InkWell(
                          splashColor: Theme.of(context).primaryColor,
                          highlightColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(5),
                          onTap: () => showImageDialog(context),
                          // child: Container(
                          //   height: 180,
                          //   width: double.infinity,
                          //   alignment: Alignment.center,
                          //   child:const Text("Asosiy rasm URL-ni kiriting!"),
                          // ),
                          child: SizedBox(
                            height: 180,
                            width: double.infinity,
                            child: Center(
                              child: _product.imageUrl.isEmpty
                                  ? Text(
                                      "Asosiy rasm URL-ni kiriting!",
                                      style: TextStyle(
                                          color: _hasImage
                                              ? Colors.black
                                              : Theme.of(context).errorColor),
                                    )
                                  : Image.network(
                                      _product.imageUrl,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
