import 'package:ecommerce_flutter_app/componenets/button.dart';
import 'package:flutter/material.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart,
              color: Theme.of(context).colorScheme.inversePrimary,
              size: 90,
            ),
            const SizedBox(height: 20),
            const Text(
              'S H O P A P P',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 27,
                // color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Start shopping online conveniently',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20), // Added spacing between text and button
            // Padding(
            //   padding: const EdgeInsets.all(25.0),
            //   child: ElevatedButton(
            //     onPressed: () {
            //       // Add navigation or functionality here
            //     },

            //     style: ElevatedButton.styleFrom(
            //       padding: const EdgeInsets.all(18),
            //       backgroundColor: Theme.of(context).colorScheme.inversePrimary,

            //     ),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //       children: [
            //         const Text(
            //           'Let\'s get started',
            //           style: TextStyle(color: Colors.white, fontSize: 18),
            //         ),
            //         CircleAvatar(
            //           backgroundColor: Colors.white,
            //           radius: 15,
            //           child: Icon(
            //             Icons.arrow_forward,
            //             color: Theme.of(context).colorScheme.inversePrimary,
            //             size: 20,
            //           ),
            //         )
            //       ],
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: MyButton(
                onTap: () => Navigator.pushNamed(context, '/shop_screen'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      'Let\'s get started',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 15,
                      child: Icon(
                        Icons.arrow_forward,
                        color: Theme.of(context).colorScheme.inversePrimary,
                        size: 20,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
