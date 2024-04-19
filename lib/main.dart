import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/auth.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/order_list.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/pages/auth_or_home_page.dart';
import 'package:shop/pages/cart_page.dart';
import 'package:shop/pages/orders_page.dart';
import 'package:shop/pages/product_detail_page.dart';
import 'package:shop/pages/product_form_page.dart';
import 'package:shop/pages/product_page.dart';
import 'package:shop/utils/app_routes.dart';

void main() {
  runApp(const MainShop());
}

class MainShop extends StatefulWidget {
  const MainShop({super.key});

  @override
  State<MainShop> createState() => _MainShopState();
}

class _MainShopState extends State<MainShop> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductList>(
          create: (_) => ProductList(),
          update: ((context, auth, previous) {
            return ProductList(
              auth.token ?? '',
              previous?.items ?? [],
              auth.uId ?? '',
            );
          }),
        ),
        ChangeNotifierProxyProvider<Auth, OrderList>(
          create: (_) => OrderList(),
          update: ((context, auth, previous) {
            return OrderList(
              auth.token ?? '',
              previous?.items ?? [],
              auth.uId ?? '',
            );
          }),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // home: const ProductOverviewPage(),
        routes: {
          AppRoutes.prodcutForm: (context) => const ProductFormPage(),
          AppRoutes.products: (context) => const ProductPage(),
          AppRoutes.cartPage: (context) => const CartPage(),
          AppRoutes.productDetailPage: (context) => const ProductDetailPage(),
          AppRoutes.orders: (context) => const OrdersPage(),
          AppRoutes.authOrHomePage: (context) => const AuthOrHomePage(),
        },
      ),
    );
  }
}
