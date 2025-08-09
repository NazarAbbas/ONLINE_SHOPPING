class DataProvider {
  final List<String> banners;
  final List<Category> categories;
  final Map<String, List<Product>> productsByCategory;

  DataProvider({
    required this.banners,
    required this.categories,
    required this.productsByCategory,
  });

  factory DataProvider.fromJson(Map<String, dynamic> json) {
    final bannerList = List<String>.from(json['bannerImages'] ?? []);

    final categoryList = (json['categories'] as List)
        .map((e) => Category.fromJson(e))
        .toList();

    final Map<String, List<Product>> productsMap = {};
    final rawProductMap = json['productsByCategory'] ?? {};

    if (rawProductMap is Map<String, dynamic>) {
      rawProductMap.forEach((key, value) {
        if (value is List) {
          productsMap[key] = value
              .map((item) => Product.fromJson(item))
              .toList();
        }
      });
    }

    return DataProvider(
      banners: bannerList,
      categories: categoryList,
      productsByCategory: productsMap,
    );
  }
}

class Category {
  final String? icon;
  final String? label;

  Category({this.icon, this.label});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(icon: json['icon'], label: json['label']);
  }
}

class Product {
  final String? id;
  final String? name;
  final String? netWeight;
  final String? type;
  final String? isAvailable;
  final String? price;
  final String? discountedPrice;
  final String? pricePerPack;
  final String? mrpPerPack;
  final String? usp;
  final String? quantity;
  final List<String>? images;
  final String? shortDescription;
  final String? description;

  Product({
    this.id,
    this.name,
    this.netWeight,
    this.type,
    this.isAvailable,
    this.price,
    this.discountedPrice,
    this.pricePerPack,
    this.mrpPerPack,
    this.usp,
    this.quantity,
    this.images,
    this.shortDescription,
    this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"],
      name: json["name"],
      netWeight: json["net_weight"],
      type: json["type"],
      isAvailable: json["isAvailable"],
      price: json["price"],
      discountedPrice: json["discounted_price"],
      pricePerPack: json["price_per_pack"],
      mrpPerPack: json["mrp_per_pack"],
      usp: json["usp"],
      quantity: json["quantity"],
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      shortDescription: json["short_description"],
      description: json["description"],
    );
  }
}
