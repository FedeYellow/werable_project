import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/CART/ProviderCart.dart';
import 'package:werable_project/VENDITORE/ProductModel.dart';
import 'package:werable_project/VENDITORE/ShopperModel.dart';


class ShopperPage extends StatelessWidget {
  final Shopper shopper;

  const ShopperPage({super.key, required this.shopper});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(shopper.name),
      ),
      body: ListView.builder(
        itemCount: shopper.products.length,
        itemBuilder: (context, index) {
          final product = shopper.products[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            elevation: 2,
            child: ListTile(
              leading: const Icon(Icons.fastfood),
              title: Text(product.name),
              subtitle: Text('Scadenza: ${product.expiry}\nPrezzo: €${product.price}\nCalorie: ${product.calories} kcal'),
              trailing: IconButton(
                icon: const Icon(Icons.add_shopping_cart),
                onPressed: () {
                  final productWithShop = Product(
                    name: product.name,
                    price: product.price,
                    expiry: product.expiry,
                    shopperName: shopper.name,
                    calories: product.calories,
                  );
                  cart.add(productWithShop);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${product.name} aggiunto al carrello')),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
