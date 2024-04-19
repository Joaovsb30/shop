import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/product_grid_item.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavoriteOnly;
  const ProductGrid({
    required this.showFavoriteOnly,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<Product> product = showFavoriteOnly
        ? Provider.of<ProductList>(context).favoriteItems
        : Provider.of<ProductList>(
            context,
          ).items;
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: product.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5),
      itemBuilder: ((ctx, i) {
        return ChangeNotifierProvider.value(
          value: product[i],
          child: ProductGridItem(),
        );
      }),
    );
  }
}
