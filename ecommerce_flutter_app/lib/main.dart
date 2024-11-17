import 'package:ecommerce_flutter_app/models/shop_model.dart';
import 'package:ecommerce_flutter_app/screens/cart_screen.dart';
import 'package:ecommerce_flutter_app/screens/intro_screen.dart';
import 'package:ecommerce_flutter_app/screens/shop_screen.dart';
import 'package:ecommerce_flutter_app/screens/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ChangeNotifierProvider(create: (context) => ShopModel()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/intro': (context) => const IntroScreen(),
        '/shop_screen': (context) => const ShopScreen(),
        '/my_cart': (context) => const MyCartScreen(),
      },
      home: const IntroScreen(),
      // theme: lightMode,
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
