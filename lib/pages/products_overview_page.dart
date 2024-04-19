import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/badge_app.dart';
import 'package:shop/components/product_grid.dart';
import 'package:shop/models/product_list.dart';

enum FilterOptions {
  all,
  favorite,
}

class ProductOverviewPage extends StatefulWidget {
  const ProductOverviewPage({super.key});

  @override
  State<ProductOverviewPage> createState() => _ProductOverviewPageState();
}

class _ProductOverviewPageState extends State<ProductOverviewPage> {
  bool _showFavoriteOnly = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<ProductList>(
      context,
      listen: false,
    ).loadProducts().then(((value) {
      setState(() {
        _isLoading = false;
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          PopupMenuButton(
              onSelected: (FilterOptions filter) {
                setState(() {
                  if (filter == FilterOptions.favorite) {
                    _showFavoriteOnly = true;
                  } else {
                    _showFavoriteOnly = false;
                  }
                });
              },
              iconColor: Colors.white,
              itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: FilterOptions.all,
                      child: Text('Todos'),
                    ),
                    const PopupMenuItem(
                      value: FilterOptions.favorite,
                      child: Text('Favoritos'),
                    ),
                  ]),
          const BadgeApp(),
        ],
        title: const Text(
          'Minha loja',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ProductGrid(showFavoriteOnly: _showFavoriteOnly),
    );
  }
}
