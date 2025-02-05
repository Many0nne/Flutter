import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:epsi_shop/cart.dart';
import 'package:epsi_shop/bo/product.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<Cart>();  // Récupérer le panier via Provider

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panier'),
      ),
      body: cart.count == 0
          ? Center(child: const Text('Votre panier est vide.'))
          : ListView.builder(
              itemCount: cart.count,
              itemBuilder: (context, index) {
                final product = cart.getAll()[index];  // Récupérer l'article du panier
                return ListTile(
                  leading: Image.network(
                    product.image,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(product.title),
                  subtitle: Text(product.getPrice()),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle),
                    onPressed: () {
                      cart.remove(product);  // Retirer l'article du panier
                    },
                  ),
                );
              },
            ),
    );
  }
}
