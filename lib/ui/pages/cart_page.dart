import 'dart:convert';

import 'package:epsi_shop/bo/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:epsi_shop/cart.dart';
import 'package:http/http.dart' as http;

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  Future<void> _sendPurchaseRequest(BuildContext context, Cart cart) async {
    final url = Uri.parse('https://api.allorigins.win/get?url=http://ptsv3.com/t/EPSISHOPC1/');
    //utilisation d'un proxy pour contourner la cors policy, l'envoie de la requête est valide mais le site ne recois rien donc je ne sais pas
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(cart.items.map((product) => product.toJson()).toList()),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Achat effectué avec succès')),
      );
      cart.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'achat')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<Cart>();  // Récupérer le panier via Provider

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panier'),
      ),
      body: cart.count == 0
          ? Center(child: const Text('Votre panier est vide.'))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Total: ${cart.total.toStringAsFixed(2)} €',
                  ),
                ),
                Expanded(
                  child: ListView.builder(
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
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _sendPurchaseRequest(context, cart);
                    },
                    child: Text('Procéder au paiement'),
                  ),
                ),
              ],
            ),
    );
  }
}
