import 'dart:convert';
import 'package:epsi_shop/cart.dart';
import 'package:epsi_shop/bo/product.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class ListProductPage extends StatelessWidget {
  ListProductPage({super.key});

  Future<List<Product>> getProducts() async {
    //télécharger les données
    Response res = await get(Uri.parse("https://fakestoreapi.com/products"));
    if (res.statusCode == 200) {
      print(res.body);
      List<dynamic> listMapProducts = jsonDecode(res.body);
      //Convertir cette lsite dynamique en List<Product>
      return listMapProducts.map((lm) => Product.fromJson(lm)).toList();
    }
    return Future.error("Erreur de téléchargement");
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
        body: FutureBuilder<List<Product>>(
            future: getProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasData) {
                final listProducts = snapshot.data!;
                return ListViewProducts(listProducts: listProducts);
              } else {
                return Text("Erreur");
              }
            }));
  }
}

class ListViewProducts extends StatelessWidget {
  const ListViewProducts({
    super.key,
    required this.listProducts,
  });

  final List<Product> listProducts;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: listProducts.length,
        itemBuilder: (ctx, index) => InkWell(
              onTap: () => ctx.go("/detail/${listProducts[index].id}"),
              // /detail/4
              child: ListTile(
                leading: Image.network(
                  listProducts[index].image,
                  width: 90,
                  height: 90,
                ),
                title: Text(listProducts[index].title),
                subtitle: Text(listProducts[index].getPrice()),
              ),
            ));
  }
}
