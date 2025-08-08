class Product {
  String id;
  String name;
  double price;
  String? imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
  });
}
