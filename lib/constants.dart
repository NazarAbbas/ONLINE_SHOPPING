// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:online_shopping/load_json.dart';
// import 'package:online_shopping/models/non_veg_model.dart';

// class Constant {
//   static List<Map<String, dynamic>> categories = [
//     {'icon': FontAwesomeIcons.fish, 'label': 'Fish & Seafood'},
//     {'icon': FontAwesomeIcons.drumstickBite, 'label': 'Mutton'},
//     {'icon': FontAwesomeIcons.kiwiBird, 'label': 'Chicken'},

//   ];

//   static Map<String, List<Map<String, String>>> productsByCategory = {
//     'Fish & Seafood': List.generate(
//       10,
//       (i) => {
//         'id': 'mutton_soup_bones_1_${i + 1}',
//         'name': 'Mutton Soup Bones (480 - 500g Pack)',
//         'net_weight': '480-500g',
//         'type': 'Rohu',
//         'isAvailable': 'true', // or 'false'
//         'mrp': '₹379.00',
//         'price': '₹379.00',
//         'discounted_price': '₹239.00',
//         'price_per_pack': '₹239.00/pack',
//         'mrp_per_pack': '₹379.00/pack',
//         'usp': '₹0.48/g',
//         'quantity': '1',
//         'image':
//             'http://static.freshtohome.com/cdn-cgi/image/width=400/https://static.freshtohome.com/media/catalog/product/r/e/red-snapper_big.jpg', // Replace with actual image URL
//         'short_description': 'Cleaned mutton bones for soup',
//         'description': '''
// Storage Instructions:
// Store under refrigeration at 4°C or below, in hygienic conditions

// Marketed By:
// Freshtohome Foods Private Limited
// No.201, 2nd FLOOR, Carlton Towers No.1,
// Old Airport Road, Kodihalli, Bangalore Urban,
// Karnataka - 560008

// FSSAI Lic. No. 11221999000168
// ''',
//       },
//     ),

//     'Mutton': List.generate(
//       10,
//       (i) => {
//         'id': 'mobiles_${i + 1}',
//         'image':
//             'http://static.freshtohome.com/cdn-cgi/image/width=400/https://static.freshtohome.com/media/catalog/product/0/8/08-12-23_fth_tile_size_800x533_goat_shoulder_cut.jpg',
//         'name': 'Mutton Soup Bones (480 - 500g Pack) ${i + 1}',
//         'type': 'Mutton Keema (Mince)',
//         'isAvailable': 'true', // or 'false'
//         'price': '₹${150}',
//         'brand': 'MobilesBrand${i + 1}',
//         'rating': '${4.0 + (i % 2) * 0.5}',
//         'reviews': '${60 + i * 10}',
//         'discounted_price': '₹${120}',
//         'short_description': 'Cleaned mutton bones for soup',
//         'description':
//             'Hello hello Hello hello Hello hello Hello hello Hello helloHello hello Hello hello Hello hello',
//       },
//     ),
//     'Chicken': List.generate(
//       10,
//       (i) => {
//         'id': 'chicken_1_${i + 1}',
//         'name': 'Boneless Chicken (480 - 500g Pack)',
//         'net_weight': '480-500g',
//         'type': 'Boneless Chicken',
//         'isAvailable': (i % 2 == 0)
//             .toString(), // Corrected: returns 'true' or 'false' as String
//         'price': '₹379.00',
//         'discounted_price': '₹239.00',
//         'price_per_pack': '₹239.00/pack',
//         'mrp_per_pack': '₹379.00/pack',
//         'usp': '₹0.48/g',
//         'quantity': '1',
//         'image':
//             'http://static.freshtohome.com/cdn-cgi/image/width=400/https://static.freshtohome.com/media/catalog/product/r/e/red-snapper_big.jpg', // Replace with actual image URL
//         'short_description': 'Cleaned mutton bones for soup',
//         'description': '''
// Storage Instructions:
// Store under refrigeration at 4°C or below, in hygienic conditions

// Marketed By:
// Freshtohome Foods Private Limited
// No.201, 2nd FLOOR, Carlton Towers No.1,
// Old Airport Road, Kodihalli, Bangalore Urban,
// Karnataka - 560008

// FSSAI Lic. No. 11221999000168
// ''',
//       },
//     ),
//   };
//   static List<Map<String, String>> get allProducts {
//     return productsByCategory.values.expand((list) => list).toList();
//   }

//   //static List<String> bannerImages = DataProvider.fromJson(json).bannerImages

//   //final loadNonVegDa =  loadNonVegData(); // returns NonVegCategoryData
//   //List<String> banners = loadNonVegDa.

//    static List<String> bannerImages = [
//      'http://static.freshtohome.com/cdn-cgi/image/width=400/https://static.freshtohome.com/media/catalog/product/l/a/lamb_curry_cut_4.jpg',
//      'http://static.freshtohome.com/cdn-cgi/image/width=400/https://static.freshtohome.com/media/catalog/product/m/u/mutton_shank-3pc.jpg',
//      'http://static.freshtohome.com/cdn-cgi/image/width=400/https://static.freshtohome.com/media/catalog/product/p/r/premiumm_goat_mince_1__2_1.jpg',
//    ];
// }
