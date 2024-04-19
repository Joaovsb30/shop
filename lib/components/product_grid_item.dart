import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/auth.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/product.dart';
import 'package:shop/utils/app_routes.dart';

class ProductGridItem extends StatelessWidget {
  const ProductGridItem({super.key});

  @override
  Widget build(BuildContext context) {
    Cart cart = Provider.of<Cart>(context, listen: false);
    final product = Provider.of<Product>(
      context,
      listen: false, //Listen false, não renderiza a pagina toda para otimização
    );
    final auth = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.blueGrey,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            onPressed: () {
              cart.addItem(product);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Produto adicionado com sucesso'),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                      label: 'Desfazer',
                      onPressed: () {
                        return cart.removeSigleItem(product.id);
                      }),
                ),
              );
            },
            icon: const Icon(Icons.shopping_cart),
          ),
          leading: Consumer<Product>(
            // Uso do widget Consumer para renderizar apenas o unico widget que é mutável na pagina
            builder: (ctx, product, _) => IconButton(
              icon: product.isFavorite
                  ? const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )
                  : const Icon(Icons.favorite),
              onPressed: () =>
                  product.toggleFavorite(auth.token ?? '', auth.uId ?? ''),
            ),
          ),
        ),
        child: InkWell(
          onTap: () => Navigator.of(context).pushNamed(
            AppRoutes.productDetailPage,
            arguments: product,
          ),
          child: Hero(
            tag: product.id,
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
