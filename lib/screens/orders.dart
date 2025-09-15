import 'package:bom_hamburguer/_utils/color_theme.dart';
import 'package:flutter/material.dart';

class Orders extends StatelessWidget {
  final List<Map<String, dynamic>> orders;
  final String name;

  const Orders({super.key, required this.orders, required this.name});

  /* Verifica os tipos existentes no carrinho e calcula o desconto, provavelmente não é a melhor forma de mostrar o desconto novamente, ja que o calculo foi feito no carrinho...*/
  double calcValues(List<Map<String, dynamic>> cart) {
    return cart.fold(0.0, (sum, item) => sum + (item['price'] as double));
  }

  double calcDiscount(List<Map<String, dynamic>> cart) {
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
    return Scaffold(
      backgroundColor: ColorTheme.primaryColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: ColorTheme.primaryColor),
        title: Text(
          "Pedidos 📋",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: ColorTheme.quaternaryColor,
      ),
      body: orders.isEmpty
          ? Center(
              child: Text(
                'Nenhum pedido realizado',
                style: TextStyle(
                  fontSize: 20,
                  color: ColorTheme.quaternaryColor,
                ),
              ),
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final orderData = orders[index];
                final orderName = orderData['name'];
                final orderItems = List<Map<String, dynamic>>.from(
                  orderData['items'],
                );
                final total = calcValues(orderItems);
                final discount = calcDiscount(orderItems);
                final finalTotal = total - discount;

                return Card(
                  child: ListTile(
                    title: Text(
                      "Pedido #${index + 1} - $orderName",
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...orderItems.map((item) {
                          return Text(
                            "${item['name']} - \$${item['price'].toStringAsFixed(2)}",
                            style: TextStyle(fontSize: 16),
                          );
                        }),
                        SizedBox(height: 8),
                        Text(
                          "Desconto: \$${discount.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Valor Final: \$${finalTotal.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
