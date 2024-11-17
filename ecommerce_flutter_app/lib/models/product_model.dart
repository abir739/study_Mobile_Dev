class ProductModel {
  final String id;
  final String name;
  final String description;
  final String price;
  final String image;
  final String categoryId;

  ProductModel({
    required this.id,
    required this.image,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
  });
}
