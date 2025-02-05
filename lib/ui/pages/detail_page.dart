import 'dart:convert';
import 'package:epsi_shop/bo/product.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:epsi_shop/cart.dart';
import 'package:http/http.dart' as http;

class DetailPage extends StatefulWidget {
  final int productId;

  const DetailPage({super.key, required this.productId});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<Product> _productFuture;

  @override
  void initState() {
    super.initState();
    _productFuture = fetchProduct(widget.productId);
  }

  // Fonction pour récupérer un produit depuis l'API
  Future<Product> fetchProduct(int productId) async {
    final response = await http.get(Uri.parse('https://fakestoreapi.com/products/$productId'));

    if (response.statusCode == 200) {
      // Si la requête est un succès, on retourne un objet Product
      return Product.fromJson(jsonDecode(response.body));
    } else {
      // En cas d'erreur, on lance une exception
      throw Exception('Failed to load product');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('EPSI Shop'),
        actions: [
          IconButton(
            onPressed: () => context.go("/cart"),
            icon: Badge(
              label: Text(context.watch<Cart>().getAll().length.toString()),
              child: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      body: FutureBuilder<Product>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Aucun produit trouvé.'));
          }

          final product = snapshot.data!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                product.image,
                height: 150,
              ),
              TitleLinePrice(product: product),
              Description(product: product),
              Spacer(),
              ButtonReserverEssai(),
              AddToCartButton(product: product),  // Ajout du bouton "Ajouter au panier"
            ],
          );
        },
      ),
    );
  }
}

class Description extends StatelessWidget {
  const Description({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        product.description,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}

class TitleLinePrice extends StatelessWidget {
  const TitleLinePrice({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            product.title,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          Text(
            product.getPrice(),
            style: Theme.of(context).textTheme.bodyLarge,
          )
        ],
      ),
    );
  }
}

class ButtonReserverEssai extends StatelessWidget {
  const ButtonReserverEssai({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(onPressed: () {}, child: const Text("Réserver un essai")),
      ),
    );
  }
}

// Nouveau widget pour le bouton "Ajouter au panier"
class AddToCartButton extends StatelessWidget {
  const AddToCartButton({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: () {
            // Ajout du produit au panier
            context.read<Cart>().add(product);
            // Affichage d'un message de confirmation
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${product.title} ajouté au panier')),
            );
          },
          child: const Text("Ajouter au panier"),
        ),
      ),
    );
  }
}
