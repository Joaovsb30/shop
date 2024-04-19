import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/utils/app_routes.dart';

class BadgeApp extends StatelessWidget {
  const BadgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    Cart cart = Provider.of<Cart>(context);
    return Stack(children: [
      IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.cartPage);
          },
          icon: const Icon(
            Icons.shopping_cart,
            color: Colors.white,
          )),
      Positioned(
        left: 26,
        top: 3,
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 9,
          child: Consumer<Cart>(
              builder: (context, value, child) => Text(
                    cart.cartCount.toString(),
                    style: const TextStyle(fontSize: 14),
                  )),
        ),
      )
    ]);
  }
}
