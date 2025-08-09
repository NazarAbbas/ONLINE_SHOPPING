import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:online_shopping/about_us_page.dart';
import 'package:online_shopping/cart_page.dart';
import 'package:online_shopping/contact_us_page.dart';
import 'package:online_shopping/controllers/home_page_controller.dart';
import 'package:online_shopping/detail_page.dart';

class HomePage extends StatelessWidget {
  final HomePageController controller = Get.put(HomePageController());

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [_buildHome(context), AboutUs(), ContactUs()];

    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 48, // default is 56, reduce to make it shorter
          backgroundColor: Colors.red,
          centerTitle: true,
          elevation: 2,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center, // vertical center alignment
            mainAxisSize: MainAxisSize.min, // only take as much space as needed
            children: const [
              Text(
                'ChopChop',
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ],
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.shopping_cart,
                    size: 36, // increase this number for a bigger icon
                  ),
                  onPressed: () {
                    Get.to(
                      () => CartPage(
                        cartItems: controller.cartItems.toList(),
                        productQuantities: controller.productQuantities,
                        onQuantityChanged: (productId, change) {
                          final product = controller.cartItems.firstWhere(
                            (item) => item['id'] == productId,
                          );
                          controller.updateQuantity(productId, product, change);
                        },
                      ),
                    );
                  },
                ),
                if (controller.totalItemsInCart > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.green,
                      child: Text(
                        '${controller.totalItemsInCart}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        body: pages[controller.currentTabIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.currentTabIndex.value,
          onTap: controller.changeTab,
          selectedItemColor: Colors.redAccent,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.info_outline),
              label: 'About Us',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mail_outline),
              label: 'Contact Us',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHome(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      String selectedCategory = controller.selectedCategoryLabel;
      List<Map<String, dynamic>> products =
          controller.productsByCategory[selectedCategory] ?? [];

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildBanner(),
            const SizedBox(height: 20),
            _buildCategorySelector(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '$selectedCategory Products',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: _buildProductGrid(products),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    });
  }

  Widget _buildBanner() {
    return Obx(
      () => CarouselSlider(
        options: CarouselOptions(
          height: 180.0,
          autoPlay: true,
          enlargeCenterPage: true,
          viewportFraction: 0.9,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
        ),
        items: controller.bannerImages.map((imageUrl) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Obx(
      () => SizedBox(
        height: 50,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemCount: controller.categories.length,
          itemBuilder: (context, index) {
            final cat = controller.categories[index];
            bool isSelected = index == controller.selectedCategoryIndex.value;

            return GestureDetector(
              onTap: () => controller.changeCategory(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.redAccent : Colors.grey[200],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    cat['label'] ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductGrid(List<Map<String, dynamic>> products) {
    final screenWidth = MediaQuery.of(Get.context!).size.width;
    const crossAxisCount = 2;
    const desiredCardHeight = 260; // fixed height
    const spacing = 8.0;

    // Calculate card width based on screen width & spacing
    final totalHorizontalSpacing =
        spacing * (crossAxisCount - 1) + 16; // + padding
    final cardWidth = (screenWidth - totalHorizontalSpacing) / crossAxisCount;

    // Convert fixed height to aspect ratio
    final aspectRatio = (cardWidth - 22) / desiredCardHeight;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: aspectRatio, // ✅ forces exact height
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        final productId = product['id'] ?? '';

        //return GestureDetector(

        return GestureDetector(
          onTap: () => Get.to(
            () => DetailPage(
              product: product, // ✅ this must be Map<String, dynamic>
              initialQuantity: controller.productQuantities[product['id']] ?? 0,
              cartCount: controller.totalItemsInCart,
              onQuantityChanged: controller.updateQuantity,
              productQuantities: controller.productQuantities,
              cartItems: controller.cartItems,
            ),
          ),
          child: SizedBox(
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(5),
                    ),
                    child: Image.network(
                      _getFirstImage(product['images']),
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['name'] ?? '',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                product['price'] ?? '',
                                style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                product['discounted_price'] ?? '',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Divider(color: Colors.grey[300], thickness: 1),
                          Center(
                            child: product['isAvailable'] == 'true'
                                ? Obx(() {
                                    final quantity =
                                        controller
                                            .productQuantities[productId] ??
                                        0;
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.remove_circle_outline,
                                            color: Colors.redAccent,
                                            size: 35.0,
                                          ),
                                          onPressed: () =>
                                              controller.updateQuantity(
                                                productId,
                                                product,
                                                -1,
                                              ),
                                        ),
                                        Text(
                                          '$quantity',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.add_circle_outline,
                                            color: Colors.green,
                                            size: 35.0,
                                          ),
                                          onPressed: () =>
                                              controller.updateQuantity(
                                                productId,
                                                product,

                                                1,
                                              ),
                                        ),
                                      ],
                                    );
                                  })
                                : const Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 14.0,
                                    ),
                                    child: Text(
                                      'Coming soon!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _getFirstImage(dynamic images) {
    if (images is List && images.isNotEmpty && images[0] is String) {
      return images[0];
    }
    return 'https://via.placeholder.com/150';
  }
}
