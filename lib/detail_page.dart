import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'cart_page.dart';

class DetailPage extends StatefulWidget {
  final Map<String, dynamic> product;
  final int initialQuantity;
  final int cartCount;
  final void Function(
    String productId,
    Map<String, dynamic> product,
    int change,
  )
  onQuantityChanged;
  final Map<String, int> productQuantities;
  final List<Map<String, dynamic>> cartItems;

  const DetailPage({
    Key? key,
    required this.product,
    required this.initialQuantity,
    required this.cartCount,
    required this.onQuantityChanged,
    required this.productQuantities,
    required this.cartItems,
  }) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late int quantity;
  int _currentImageIndex = 0; // Add this in _DetailPageState
  @override
  void initState() {
    super.initState();
    quantity = widget.initialQuantity;
  }

  void updateQuantity(int change) {
    final newQty = quantity + change;
    if (newQty >= 0) {
      setState(() {
        quantity = newQty;
      });
      widget.onQuantityChanged(widget.product['id'], widget.product, change);
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final int cartCount = widget.productQuantities.values.fold(
      0,
      (sum, qty) => sum + qty,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        toolbarHeight: 48, // default is 56, reduce to make it shorter
         iconTheme: const IconThemeData(
          color: Colors.white, // makes the back button (arrow) white
        ),
        backgroundColor: Colors.red,
        title: const Text('Product Details', style: TextStyle(color: Colors.white, fontSize: 22),),
         centerTitle: true,
        elevation: 1,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.white,
                size: 36, // increase this number for a bigger icon
                
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CartPage(
                        cartItems: widget.cartItems.toList(),
                        productQuantities: widget.productQuantities,
                        onQuantityChanged: (productId, change) {
                          final product = widget.cartItems.firstWhere(
                            (item) => item['id'] == productId,
                            orElse: () => {},
                          );
                          widget.onQuantityChanged(productId, product, change);
                          setState(() {});
                        },
                      ),
                    ),
                  );
                },
              ),
              if (cartCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.green,
                    child: Text(
                      '$cartCount',
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // CarouselSlider for images
          if (product['images'] != null &&
              product['images'] is List &&
              (product['images'] as List).isNotEmpty)
            CarouselSlider(
              options: CarouselOptions(
                height: 260,
                enlargeCenterPage: true,
                autoPlay: true,
                viewportFraction: 1.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentImageIndex = index;
                  });
                },
              ),
              items: List<String>.from(product['images']).map((imageUrl) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    height: 260,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                );
              }).toList(),
            ),
          // Dots indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(product['images'].length, (index) {
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentImageIndex == index
                      ? Colors.green
                      : Colors.grey.shade300,
                ),
              );
            }),
          ),

          // // Image
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(12),
          //   child: Image.network(
          //     (product['images'] != null &&
          //             product['images'] is List &&
          //             product['images'].isNotEmpty)
          //         ? product['images'][0]
          //         : '',
          //     height: 260,
          //     width: double.infinity,
          //     fit: BoxFit.cover,
          //   ),
          // ),
          const SizedBox(height: 16),

          // Title
          Text(
            product['name'] ?? '',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          if (product['type'] != null)
            Text(
              product['type']!,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          const SizedBox(height: 12),

          // Pricing
          Row(
            children: [
              if (product['mrpPerPack'] != null)
                Text(
                  '₹${product['mrpPerPack']}',
                  style: const TextStyle(
                    fontSize: 12,
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                  ),
                ),
              const SizedBox(width: 8),
              if (product['pricePerPack'] != null)
                Text(
                  '₹${product['pricePerPack']}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
            ],
          ),

          // Net Weight
          if (product['netWeight'] != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Net Weight: ${product['netWeight']}',
                style: const TextStyle(fontSize: 14),
              ),
            ),

          // USP
          if (product['usp'] != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                product['usp']!,
                style: const TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.teal,
                ),
              ),
            ),

          // shortDescrition
          if (product['shortDescription'] != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                product['shortDescription']!,
                style: const TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.teal,
                ),
              ),
            ),

          const SizedBox(height: 16),

          // Quantity Selector
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: product['isAvailable'] == 'true'
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Quantity', style: TextStyle(fontSize: 16)),
                      Row(
                        children: [
                          buildQuantityButton(
                            icon: Icons.remove,
                            color: Colors.redAccent,
                            onPressed: () {
                              updateQuantity(-1);
                              setState(() {});
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              '$quantity',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          buildQuantityButton(
                            icon: Icons.add,
                            color: Colors.green,
                            onPressed: () {
                              updateQuantity(1);
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ],
                  )
                : const Center(
                    child: Text(
                      'Coming Soon',
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),

          const SizedBox(height: 24),

          // Description
          const Text(
            'Description',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            margin: EdgeInsets.zero,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                product['description'] ?? 'No description available.',
                style: const TextStyle(fontSize: 14, height: 1.6),
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Add to Cart Button
          if (product['isAvailable'] == 'true')
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  updateQuantity(1);
                },
                icon: const Icon(
                  Icons.shopping_cart_checkout,
                  color: Colors.white,
                ),
                label: const Text(
                  "Add to Cart",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors
                      .white, // This sets text & icon color (if not overridden)
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildQuantityButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.1),
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}
