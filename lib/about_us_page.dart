import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text.rich(
            TextSpan(
              style: const TextStyle(fontSize: 15.5, height: 1.6),
              children: [
                TextSpan(
                  text: 'Welcome to ',
                ),
                TextSpan(
                  text: 'The Meat Market',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
                TextSpan(
                  text:
                      ' — your ultimate destination for premium, fresh, and hygienically sourced non-vegetarian products. We are a team of passionate professionals committed to changing the way India experiences meat shopping.\n\n',
                ),

                TextSpan(
                  text: '🥩 What We Do:\n',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      'We provide a wide range of meats including Chicken, Mutton, Fish, and Seafood — all processed and packaged with the highest standards. Our goal is to make your everyday cooking both convenient and flavorful.\n\n',
                ),

                TextSpan(
                  text: '🌿 Sourcing with Care:\n',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      'We partner with ethical farms, verified fisheries, and reliable vendors who believe in quality and sustainability. All animals are raised without antibiotics or growth hormones.\n\n',
                ),

                TextSpan(
                  text: '🧼 Hygienic Processing:\n',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      'Our products are cleaned, cut, and packed in FSSAI-approved facilities under strict hygiene protocols. Every pack is vacuum-sealed and leak-proof to retain freshness.\n\n',
                ),

                TextSpan(
                  text: '⏱ Fresh, Not Frozen:\n',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      'We believe in serving you fresh meat — never frozen. Our cold-chain logistics ensures the meat stays at optimal temperature until it reaches your doorstep.\n\n',
                ),

                TextSpan(
                  text: '🚚 Doorstep Delivery:\n',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      'Skip the long queues and wet markets! Order through our app or website and get freshly packed meat delivered straight to your home within hours.\n\n',
                ),

                TextSpan(
                  text: '🔥 What Sets Us Apart:\n',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      '• Premium meat cuts for all cooking styles\n• Boneless, skinless, or custom-cut options\n'
                      '• 100% freshness guarantee\n• Fast & safe delivery\n'
                      '• Affordable pricing with frequent offers\n\n',
                ),

                TextSpan(
                  text: '❤️ Our Promise:\n',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      'We promise quality, cleanliness, transparency, and consistency. Every product on our shelf is something we’d serve in our own kitchens.\n\n',
                ),

                TextSpan(
                  text: '💬 Customer First:\n',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      'Our customers are at the heart of everything we do. Whether it’s resolving your queries, taking feedback seriously, or introducing new meat varieties — your satisfaction is our top priority.\n\n',
                ),

                TextSpan(
                  text: '🧾 Legal & Safe:\n',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      'We are fully licensed under FSSAI and comply with all food safety regulations. Transparency is our policy — from farm source to delivery.\n\n',
                ),

                TextSpan(
                  text: '📍 Our Vision:\n',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      'To redefine meat shopping in India with trust, hygiene, and convenience. We’re not just selling meat — we’re creating an experience.\n\n',
                ),

                TextSpan(
                  text: '🔔 Stay Updated:\n',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      'Follow us on social media or subscribe to our newsletter for recipes, deals, new arrivals, and kitchen tips.\n\n',
                ),

                TextSpan(
                  text: 'Thank you for trusting ',
                ),
                TextSpan(
                  text: 'The Meat Market',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
                TextSpan(
                  text:
                      '. We’re honored to be a part of your daily meals and special moments. Here’s to serving you only the freshest — always!',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
