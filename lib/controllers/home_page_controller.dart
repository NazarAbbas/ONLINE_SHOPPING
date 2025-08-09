import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_shopping/load_json.dart';

class HomePageController extends GetxController {
  var selectedCategoryIndex = 0.obs;
  var currentTabIndex = 0.obs;

  var cartItems = <Map<String, dynamic>>[].obs;
  var productQuantities = <String, int>{}.obs;
  

  var isLoading = true.obs;

  /// ✅ Data loaded from JSON
  var bannerImages = <String>[].obs;
  var categories = <Map<String, dynamic>>[].obs;
  var productsByCategory = <String, List<Map<String, dynamic>>>{}.obs;

  /// Returns the total number of items in the cart
  int get totalItemsInCart =>
      productQuantities.values.fold(0, (sum, item) => sum + item);

  /// Returns selected category label
  String get selectedCategoryLabel =>
      categories.isNotEmpty ? categories[selectedCategoryIndex.value]['label'] ?? '' : '';

  /// ✅ Returns products for the selected category
  List<Map<String, dynamic>> get selectedProducts =>
      productsByCategory[selectedCategoryLabel] ?? [];

  /// ✅ Loads data from JSON with delay
  Future<void> loadData() async {
    try {
      isLoading.value = true;

      // Simulate a loading delay (e.g., splash screen)
      await Future.delayed(const Duration(seconds: 2));

      final data = await loadNonVegData();

      /// ✅ Assign banners
      bannerImages.assignAll(data.banners);

      /// ✅ Extract and map categories
      final categoryList = data.categories.map((cat) {
        return {
          'label': cat.label ?? '',
          'icon': cat.icon ?? Icons.fastfood.codePoint,
        };
      }).toList();
      categories.assignAll(categoryList);

      /// ✅ Group products by category
      Map<String, List<Map<String, dynamic>>> grouped = {};

      data.productsByCategory.forEach((label, products) {
        grouped[label] = products.map((product) {
          return {
            'id': product.id ?? '',
            'name': product.name ?? '',
            'price': product.price ?? '',
            'discounted_price': product.discountedPrice ?? '',
            'images': product.images ?? <String>[],
            'category': label,
            'isAvailable': product.isAvailable ?? 'false',
            'type': product.type ?? '',
            'pricePerPack': product.pricePerPack ?? '',
            'mrpPerPack': product.mrpPerPack ?? '',
            'usp': product.usp ?? '',
            'quantity': product.quantity ?? '',
            'shortDescription': product.shortDescription ?? '',
            'description': product.description ?? '',
            'netWeight': product.netWeight ?? '',
          };
        }).toList();
      });

      productsByCategory.assignAll(grouped);
    } catch (e) {
      print('❌ Failed to load data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ Update quantity in cart
  void updateQuantity(
    String productId,
    Map<String, dynamic> product,
    int change,
  ) {
    final currentQty = productQuantities[productId] ?? 0;
    final newQty = currentQty + change;

    if (newQty <= 0) {
      productQuantities.remove(productId);
      cartItems.removeWhere((item) => item['id'] == productId);
    } else {
      productQuantities[productId] = newQty;
      if (!cartItems.any((item) => item['id'] == productId)) {
        cartItems.add(product);
      }
    }
  }

  /// ✅ Change selected category
  void changeCategory(int index) {
    selectedCategoryIndex.value = index;
  }

  /// ✅ Change bottom navigation tab
  void changeTab(int index) {
    currentTabIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    loadData();
  }
  
}
