import 'package:ecommerce_flutter_app/models/product_model.dart';

class CategoryModel {
  final String id;
  final String name;
  final String image;
  final List<ProductModel> productList;

  CategoryModel(
      {required this.id,
      required this.image,
      required this.name,
      required this.productList});
}
