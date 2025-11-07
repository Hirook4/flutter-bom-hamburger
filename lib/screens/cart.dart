import 'package:bom_hamburguer/_utils/color_theme.dart';
import 'package:flutter/material.dart';

class Cart extends StatelessWidget {
  final List<Map<String, dynamic>> cart;
  const Cart({super.key, required this.cart});

  double calcValues(List<Map<String, dynamic>> cart) {
    return cart.fold(0.0, (sum, item) => sum + (item['price'] as double));
  }

  double calcDiscount(List<Map<String, dynamic>> cart) {
    /* Verifica os tipos existentes no carrinho e calcula o desconto */
    final types = cart.map((item) => item['type'] as String).toSet();

    bool hasBurger = types.contains('burger');
    bool hasExtra = types.contains('extra');
    bool hasDrink = types.contains('drink');

    if (hasBurger && hasExtra && hasDrink) {
      return calcValues(cart) * 0.20;
    } else if (hasBurger && hasDrink) {
      return calcValues(cart) * 0.15;
    } else if (hasBurger && hasExtra) {
      return calcValues(cart) * 0.10;
    } else {
      return calcValues(cart) * 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = calcValues(cart);
    final discount = calcDiscount(cart);
    final finalTotal = total - discount;

    return Scaffold(
      backgroundColor: ColorTheme.primaryColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: ColorTheme.primaryColor),
        title: const Text(
          "Seu Carrinho 🛒",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: ColorTheme.quaternaryColor,
      ),
      body: cart.isEmpty
          ? const Center(
              child: Text(
                'Carrinho vazio',
                style: TextStyle(
                  fontSize: 20,
                  color: ColorTheme.quaternaryColor,
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final item = cart[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 90,
                              height: 90,
                              child: Image.asset(
                                'assets/${item['image']}',
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '\$${(item['price'] as num).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 55),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Valor dos Itens:",
                            style: const TextStyle(fontSize: 25),
                          ),
                          Spacer(),
                          Text(
                            "\$${total.toStringAsFixed(2)}",
                            style: const TextStyle(fontSize: 25),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Desconto: ",
                            style: const TextStyle(fontSize: 25),
                          ),
                          Spacer(),
                          Text(
                            "\$${discount.toStringAsFixed(2)}",
                            style: const TextStyle(fontSize: 25),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Text(
                            "Valor Final: ",
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "\$${finalTotal.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorTheme.tertiaryColor,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: Text(
                              'Pagar Via PIX',
                              style: TextStyle(
                                color: ColorTheme.quaternaryColor,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
