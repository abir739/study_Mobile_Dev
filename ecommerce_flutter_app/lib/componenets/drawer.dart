import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      shadowColor: Theme.of(context).colorScheme.inversePrimary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                DrawerHeader(
                    child: Icon(
                  Icons.shopping_cart,
                  size: 80,
                  color: Theme.of(context).colorScheme.inversePrimary,
                )),
                const SizedBox(
                  height: 20,
                ),
                // MyListTitle(icon: Icons.home, onTap: (){}, title: 'H O M E'),

                ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  title: const Text(
                    'H O M E',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                    leading: Icon(
                      Icons.shopping_bag,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    title: const Text(
                      'M Y C A R T',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/my_cart');
                    }),
                ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  title: const Text(
                    'S E T T I N G S',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: Column(
              children: [
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  title: const Text(
                    'L O G O U T',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  onTap: () => Navigator.pushNamedAndRemoveUntil(
                      context, '/intro', (route) => false),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
