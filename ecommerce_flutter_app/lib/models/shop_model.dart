import 'package:ecommerce_flutter_app/models/category_model.dart';
import 'package:ecommerce_flutter_app/models/product_model.dart';
import 'package:flutter/foundation.dart';

class ShopModel extends ChangeNotifier {
  final List<CategoryModel> _categoryList = [
    CategoryModel(
        id: 'c1', image: 'lib/images/skirts.png', name: 'Men', productList: []),
    CategoryModel(
        id: 'c2',
        image: 'lib/images/women.jpg',
        name: 'Women',
        productList: []),
    CategoryModel(
        id: 'c3', image: 'lib/images/bags.png', name: 'Bags', productList: []),
    CategoryModel(
        id: 'c4',
        image: 'lib/images/shoes.png',
        name: 'Shoes',
        productList: []),
    CategoryModel(
        id: 'c5',
        image: 'lib/images/clothes.jpg',
        name: 'Robes',
        productList: []),
  ];

  final List<ProductModel> _productList = [
    ProductModel(
        id: 'p1',
        name: 'Men\'s Shirt',
        description: 'A stylish shirt',
        price: '29.99',
        image: 'lib/images/skirts.png',
        categoryId: 'c1'),
    ProductModel(
        id: 'p2',
        name: 'Women\'s Dress',
        description: 'A beautiful dress',
        price: '49.99',
        image: 'lib/images/women.jpg',
        categoryId: 'c2'),
    ProductModel(
        id: 'p3',
        name: 'Men\'s Shirt',
        description: 'A stylish shirt',
        price: '29.99',
        image: 'lib/images/skirts.png',
        categoryId: 'c1'),
    ProductModel(
        id: 'p4',
        name: 'Women\'s Dress',
        description: 'A beautiful dress',
        price: '49.99',
        image: 'lib/images/clothes.jpg',
        categoryId: 'c2'),
  ];

  ShopModel() {
    _populateProducts();
  }

  // Assign products to categories based on categoryId
  void _populateProducts() {
    for (var product in _productList) {
      final category = _categoryList.firstWhere(
          (cat) => cat.id == product.categoryId,
          orElse: () =>
              CategoryModel(id: '', name: '', image: '', productList: []));
      notifyListeners();
      if (category.id.isNotEmpty) {
        category.productList.add(product);
        notifyListeners();
      }
    }
  }

  // Get Categories
  List<CategoryModel> getCategories() {
    return _categoryList;
  }

  // Get products by category
  List<ProductModel> getProductsByCategory(String categoryId) {
    return _categoryList.firstWhere((cat) => cat.id == categoryId).productList;
  }

  // Get all products
  List<ProductModel> getAllProducts() {
    return _productList;
  }

// Get products in the cart
  List<ProductModel> cartProducts = [];

  List<ProductModel> getMyCartProducts() {
    return cartProducts;
  }

// add product to the cart
  void addProductToCart(ProductModel item) {
    cartProducts.add(item);
    notifyListeners();
    if (kDebugMode) {
      print('Added to cart: ${item.name}');
    }
  }

//remove product from the cart
  void deleteProductFromCart(ProductModel item) {
    cartProducts.remove(item);
    notifyListeners();
  }
}
