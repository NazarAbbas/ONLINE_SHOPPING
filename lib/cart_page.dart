import 'package:flutter/material.dart';
import 'package:online_shopping/checkout_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'detail_page.dart';

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final Map<String, int> productQuantities;
  final void Function(String productId, int change) onQuantityChanged;

  const CartPage({
    Key? key,
    required this.cartItems,
    required this.productQuantities,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final double deliveryChargePerItem = 20.0;

  double getPrice(String priceStr) {
    return double.tryParse(priceStr.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
  }

  double calculateItemsTotal() {
    double total = 0.0;
    for (var item in widget.cartItems) {
      final qty = widget.productQuantities[item['id']] ?? 0;
      final price = getPrice(item['price'] ?? '');
      total += price * qty;
    }
    return total;
  }

  double calculateDeliveryTotal() {
    int totalQuantity = 0;
    widget.productQuantities.forEach((_, qty) => totalQuantity += qty);
    return totalQuantity * deliveryChargePerItem;
  }

  double calculateGrandTotal() {
    return calculateItemsTotal() + calculateDeliveryTotal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 48, // default is 56, reduce to make it shorter
        iconTheme: const IconThemeData(
          color: Colors.white, // makes the back button (arrow) white
        ),
        title: Row(
          mainAxisSize:
              MainAxisSize.min, // keeps them together without stretching
          crossAxisAlignment:
              CrossAxisAlignment.center, // vertical center alignment
          children: const [
            Icon(Icons.shopping_cart, color: Colors.white, size: 22),
            SizedBox(width: 6),
            Text(
              'My Cart',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        centerTitle: true,
        elevation: 2,
      ),
      body: widget.cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 100,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Your cart is empty.",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cartItems.length,
                    padding: const EdgeInsets.all(12),
                    itemBuilder: (_, index) {
                      final item = widget.cartItems[index];
                      final productId = item['id']!;
                      final quantity = widget.productQuantities[productId] ?? 0;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        elevation: 3,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailPage(
                                  product: item,
                                  initialQuantity: quantity,
                                  cartCount: widget.productQuantities.values
                                      .fold(0, (sum, qty) => sum + qty),
                                  productQuantities: widget.productQuantities,
                                  cartItems: widget.cartItems,
                                  onQuantityChanged:
                                      (productId, product, change) {
                                        widget.onQuantityChanged(
                                          productId,
                                          change,
                                        );
                                        setState(() {});
                                      },
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    (item['images'] != null &&
                                            item['images'] is List &&
                                            item['images'].isNotEmpty)
                                        ? item['images'][0]
                                        : '',
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['name']!,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          if ((item['price'] ?? '').isNotEmpty)
                                            Text(
                                              item['price'] ?? '',
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                              ),
                                            ),
                                          const SizedBox(width: 8),
                                          if (item.containsKey(
                                            'discounted_price',
                                          ))
                                            Text(
                                              item['discounted_price'] ?? '',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green,
                                                fontSize: 16,
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          buildQuantityButton(
                                            icon: Icons.remove,
                                            color: Colors.redAccent,
                                            onPressed: () {
                                              if (quantity > 0) {
                                                widget.onQuantityChanged(
                                                  productId,
                                                  -1,
                                                );

                                                final updatedQuantity =
                                                    widget
                                                        .productQuantities[productId] ??
                                                    0;

                                                if (updatedQuantity <= 0) {
                                                  widget.productQuantities
                                                      .remove(productId);
                                                  widget.cartItems.removeWhere(
                                                    (cartItem) =>
                                                        cartItem['id'] ==
                                                        productId,
                                                  );
                                                }

                                                setState(() {});
                                              }
                                            },
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                            ),
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
                                              widget.onQuantityChanged(
                                                productId,
                                                1,
                                              );
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Total Summary Section
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      summaryRow('Items Total:', calculateItemsTotal()),
                      summaryRow('Delivery Charges:', calculateDeliveryTotal()),
                      const Divider(thickness: 1, height: 20),
                      summaryRow(
                        'Grand Total:',
                        calculateGrandTotal(),
                        isBold: true,
                        color: Colors.green[700],
                      ),
                    ],
                  ),
                ),

                // Floating WhatsApp Order Button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.chat),
                      label: const Text(
                        'Order via WhatsApp',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      onPressed: () {
                        String cartMessage = "🛒 *Order Details*\n\n";
                        int totalItemsQty = 0;
                        for (var item in widget.cartItems) {
                          final qty = widget.productQuantities[item['id']] ?? 0;
                          if (qty > 0) {
                             totalItemsQty += qty;
                            final price = parsePrice(
                              item['discounted_price'] ?? item['price'],
                            );
                            final totalPrice = qty * price;

                            cartMessage +=
                                "• ${item['name']} (${item['weight'] ?? ''})\n";
                            cartMessage += "   Qty: $qty\n";
                            cartMessage +=
                                "   Price per unit: ₹${price.toStringAsFixed(2)}\n";
                            cartMessage +=
                                "   Total: ₹${totalPrice.toStringAsFixed(2)}\n\n";
                          }
                        }

                        cartMessage += "--------------------------------\n";
                        cartMessage +=
                            "Total Items Qty: $totalItemsQty\n"; // <--- added total qty here
                        cartMessage +=
                            "Items Total: ₹${calculateItemsTotal().toStringAsFixed(2)}\n";
                        cartMessage +=
                            "Delivery Charges: ₹${calculateDeliveryTotal().toStringAsFixed(2)}\n";
                        cartMessage +=
                            "*Grand Total: ₹${calculateGrandTotal().toStringAsFixed(2)}*\n";
                        cartMessage += "--------------------------------";

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CheckoutPage(
                              cartMessage: cartMessage,
                              onPlaceOrder:
                                  (
                                    finalMessage,
                                    saveAddress,
                                    name,
                                    email,
                                    phone,
                                    address,
                                  ) async {
                                    // String phoneNumber = "918860700947";
                                    // String whatsappUrl =
                                    //     "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(finalMessage)}";
                                    // launchUrl(
                                    //   Uri.parse(whatsappUrl),
                                    //   mode: LaunchMode.externalApplication,
                                    // );
                                    print('Final Message' + finalMessage);
                                    if (saveAddress) {
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      await prefs.setString('name', name);
                                      await prefs.setString('email', email);
                                      await prefs.setString('phone', phone);
                                      await prefs.setString('address', address);
                                      await prefs.setBool(
                                        'saveAddress',
                                        saveAddress,
                                      );
                                    }
                                  },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget summaryRow(
    String label,
    double value, {
    bool isBold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '₹${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 15,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color ?? Colors.black,
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

  // Helper: parse price string/double safely
  double parsePrice(dynamic price) {
    if (price == null) return 0.0;
    if (price is double) return price;
    if (price is int) return price.toDouble();
    if (price is String) {
      final cleaned = price.replaceAll(RegExp(r'[₹,\s]'), '');
      return double.tryParse(cleaned) ?? 0.0;
    }
    return 0.0;
  }
}
