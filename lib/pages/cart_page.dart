import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/cart_item_widget.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/order_list.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _orderList = Provider.of<OrderList>(context, listen: false);
    final Cart cart = Provider.of<Cart>(context);
    final items = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'Carrinho',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 12, top: 12),
            child: Text(
              'Itens do Carrinho:',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (ctx, i) => CartItemWidget(
                      cartItem: items[i],
                    )),
          ),
          Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Total: ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Chip(
                      label: Text(
                        cart.totalAmount.toStringAsFixed(2),
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.blueGrey,
                    ),
                  ],
                ),
                CartButton(cart: cart, orderList: _orderList)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CartButton extends StatefulWidget {
  const CartButton({
    super.key,
    required this.cart,
    required OrderList orderList,
  }) : _orderList = orderList;

  final Cart cart;
  final OrderList _orderList;

  @override
  State<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const CircularProgressIndicator()
        : TextButton(
            onPressed: widget.cart.cartCount == 0
                ? null
                : () async {
                    setState(() {
                      _isLoading = true;
                    });
                    await widget._orderList.addOrder(widget.cart);
                    widget.cart.clearCart();
                    setState(() {
                      _isLoading = false;
                    });
                  },
            child: const Text(
              'Comprar',
              style: TextStyle(color: Colors.blueGrey),
            ));
  }
}
