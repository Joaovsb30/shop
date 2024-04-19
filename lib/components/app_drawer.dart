import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/auth.dart';
import 'package:shop/utils/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    Auth _auth = Provider.of(
      context,
      listen: false,
    );
    return Drawer(
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading:
                false, //tira o icon de drawer de dentro do proprio drawer
            title: const Text('Bem Vindo'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Loja'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.authOrHomePage,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Pedidos'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.orders,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Gerenciar Produtos'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.products,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              _auth.logout();
              Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.authOrHomePage);
            },
          )
        ],
      ),
    );
  }
}
