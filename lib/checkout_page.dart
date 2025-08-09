import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutPage extends StatefulWidget {
  final String cartMessage;
  final void Function(
    String finalMessage,
    bool saveAddress,
    String name,
    String email,
    String phone,
    String address,
  )
  onPlaceOrder;

  const CheckoutPage({
    Key? key,
    required this.cartMessage,
    required this.onPlaceOrder,
  }) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool _saveAddress = false;

  /// Load user data
  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('name') ?? '';
      _emailController.text = prefs.getString('email') ?? '';
      _phoneController.text = prefs.getString('phone') ?? '';
      _addressController.text = prefs.getString('address') ?? '';
      _saveAddress = prefs.getBool('saveAddress') ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.green),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.green, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        toolbarHeight: 48,
        title: const Text(
          "Checkout",
          style: TextStyle(fontSize: 22, color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // makes the back button (arrow) white
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Delivery Details",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Name
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration("Full Name", Icons.person),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter your name" : null,
              ),
              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: _emailController,
                decoration: _inputDecoration("Email (optional)", Icons.email),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Phone
              TextFormField(
                controller: _phoneController,
                decoration: _inputDecoration("Phone Number", Icons.phone),
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty
                    ? "Enter your phone number"
                    : null,
              ),
              const SizedBox(height: 16),

              // Address
              TextFormField(
                controller: _addressController,
                decoration: _inputDecoration("Full Address", Icons.location_on),
                maxLines: 3,
                validator: (value) => value == null || value.isEmpty
                    ? "Enter your address"
                    : null,
              ),
              const SizedBox(height: 16),

              // Save address checkbox
              CheckboxListTile(
                value: _saveAddress,
                onChanged: (value) {
                  setState(() {
                    _saveAddress = value ?? false;
                  });
                },
                title: const Text("Save address for future orders"),
                activeColor: Colors.green,
                contentPadding: EdgeInsets.zero,
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      // Bottom button
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.check_circle, color: Colors.white),
              label: const Text(
                "Place Order",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  String finalMessage =
                      "${widget.cartMessage}\n\n"
                      "🚚 Shipping Address:\n\n" // Label near top
                      "👤 Name: ${_nameController.text.trim()}\n"
                      "${_emailController.text.trim().isNotEmpty ? "📧 Email: ${_emailController.text.trim()}\n" : ""}"
                      "📱 Phone: ${_phoneController.text.trim()}\n"
                      "📍 ${_addressController.text.trim()}"; // Address with icon at bottom
                  widget.onPlaceOrder(
                    finalMessage,
                    _saveAddress,
                    _nameController.text.trim(),
                    _emailController.text.trim(),
                    _phoneController.text.trim(),
                    _addressController.text.trim(),
                  );
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
