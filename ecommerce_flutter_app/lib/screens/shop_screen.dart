import 'package:ecommerce_flutter_app/componenets/drawer.dart';
import 'package:ecommerce_flutter_app/componenets/my_List_card.dart';
import 'package:ecommerce_flutter_app/models/product_model.dart';
import 'package:ecommerce_flutter_app/models/shop_model.dart';
import 'package:ecommerce_flutter_app/screens/themes/light_mode.dart';
import 'package:ecommerce_flutter_app/screens/themes/theme_provider.dart';

import 'package:flutter/material.dart';
import 'package:group_grid_view/group_grid_view.dart';
import 'package:provider/provider.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final ShopModel shop = ShopModel();
  String? selectedCategoryId;

  void addProductToShopList(ProductModel product) {
    Provider.of<ShopModel>(context, listen: false).addProductToCart(product);
  }

  @override
  Widget build(BuildContext context) {
    final products = selectedCategoryId != null
        ? shop.getProductsByCategory(selectedCategoryId!)
        : shop.getAllProducts();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Center(
          child: Text(
            'Shoppe',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
            // icon: const Icon(Icons.wb_sunny),
            icon: Icon(
              Provider.of<ThemeProvider>(context).themeData == lightMode
                  ? Icons.nights_stay
                  : Icons.wb_sunny,
            ),
          )
        ],
      ),
      drawer: const MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: shop.getCategories().length,
                itemBuilder: (context, index) {
                  final category = shop.getCategories()[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategoryId = category.id;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 3,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              backgroundImage: AssetImage(category.image),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            category.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Our Products Items',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GroupGridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                sectionCount: 1,
                itemInSectionCount: (section) => products.length,
                itemInSectionBuilder: (context, indexPath) {
                  final product = products[indexPath.index];
                  return MyListCard(
                      description: product.description,
                      image: product.image,
                      name: product.name,
                      price: product.price,
                      onTap: () {
                        addProductToShopList(product);
                        _showAddToCartDialog(product);
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddToCartDialog(ProductModel product) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            icon: const Icon(
              Icons.check_circle,
              size: 60,
            ),
            iconColor: Colors.green,
            title: const Text('Product Added to Cart'),
            content: Text('${product.name} has been added to your cart.'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 18),
                  ))
            ],
          );
        });
  }
}
