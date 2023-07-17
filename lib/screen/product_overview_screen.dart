import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screen/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/products_grid.dart';
import 'package:shop_app/widgets/badge.dart';

enum filterOpitons {
  Favorites,
  All,
}

class ProductOverview extends StatefulWidget {
  const ProductOverview({super.key});

  @override
  State<ProductOverview> createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  var _showOnlyFavorites = false;
  var _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<Products>(context, listen: false)
        .fetchAndSetData()
        .then((value) => setState(() {
              _isLoading = false;
            }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'My',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'Shop',
              style: TextStyle(
                color: Colors.amber,
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        actions: [
          Consumer<Cart>(
            builder: (_, cart, ch) => GestureDetector(
              onTap: () =>
                  Navigator.of(context).pushNamed(CartScreen.routeName),
              child: Bdg(
                value: cart.itemCount.toString(),
                color: Theme.of(context).colorScheme.secondary,
                child: ch!,
              ),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.shopping_cart,
                // color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
          PopupMenuButton(
            position: PopupMenuPosition.under,
            onSelected: (filterOpitons selectedValue) {
              setState(() {
                if (selectedValue == filterOpitons.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: const Icon(
              Icons.more_vert,
              // color: Colors.white,
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: filterOpitons.Favorites,
                child: Text('Only Favorites'),
              ),
              const PopupMenuItem(
                value: filterOpitons.All,
                child: Text('Show All'),
              ),
            ],
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(showFavs: _showOnlyFavorites),
    );
  }
}
