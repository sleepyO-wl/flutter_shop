import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screen/orders_screen.dart';
import 'package:shop_app/screen/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // backgroundColor: Theme.of(context).colorScheme.tertiary,
      child: Column(
        children: [
          AppBar(
            title: const Text(
              'Menu',
              style: TextStyle(color: Colors.white),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          // Divider(),
          ListTile(
            leading: const Icon(
              Icons.shop,
              // color: Colors.white,
            ),
            title: const Text(
              'Shop',
              // style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          // Divider(),
          ListTile(
            leading: const Icon(
              Icons.payment,
              // color: Colors.white,
            ),
            title: const Text(
              'Orders',
              // style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                OrdersScreen.routeName,
              );
            },
          ),
          // Divider(),
          ListTile(
            leading: const Icon(
              Icons.edit,
              // color: Colors.white,
            ),
            title: const Text(
              'Manage Products',
              // style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                UserProductsScreen.routeName,
              );
            },
          ),
          // Divider(),
          ListTile(
            leading: const Icon(
              Icons.exit_to_app,
              color: Colors.red,
            ),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
