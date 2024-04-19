import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/cart_item.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  const CartItemWidget({
    super.key,
    required this.cartItem,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (_) {
        return showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Tem Certeza?'),
            content: const Text('Quer mesmo remover o item do carrinho?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Sim')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Não')),
            ],
          ),
        );
      },
      onDismissed: (_) => Provider.of<Cart>(context, listen: false)
          .removeItem(cartItem.productId),
      key: ValueKey(cartItem.id),
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.red,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 15,
            ),
            Icon(Icons.delete, color: Colors.white),
          ],
        ),
      ),
      child: Card(
        child: ListTile(
          leading: Text(
            '${cartItem.quantity} x',
            style: const TextStyle(fontSize: 16),
          ),
          title: Text(
            cartItem.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'R\$ ${cartItem.price}',
            style: const TextStyle(color: Colors.grey),
          ),
          trailing: Text(
            'Subtotal: ${cartItem.price * cartItem.quantity}',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
        ),
      ),
    );
  }
}
