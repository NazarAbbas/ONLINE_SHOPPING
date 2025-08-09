import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_shopping/HomePage.dart' hide HomeController;
import 'package:online_shopping/controllers/home_page_controller.dart';
import 'package:online_shopping/load_json.dart';

void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
//  await loadNonVegData(); // Load once at app start
 Get.put(HomePageController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false, // 🔴 Hides the debug banner
      title: 'Flutter Demo',

      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        // You can replace `poppinsTextTheme` with other fonts like `latoTextTheme`
      ),
      // theme: ThemeData(

      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      // ),
      home: HomePage(),
    );
  }
}
