import 'package:flutter/material.dart';
import 'package:bom_hamburguer/_utils/color_theme.dart';
import 'package:bom_hamburguer/screens/cart.dart';
import 'package:bom_hamburguer/screens/orders.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  /* Recuperando nome de usuário recebido da tela de login*/
  final String name;
  const Home({super.key, required this.name});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  /* Função assíncrona que carrega e converte os dados do JSON que contem os itens do cardápio */
  Future<List<Map<String, dynamic>>> loadItems() async {
    /* rootBundle acessa arquivos "locais" | loadString carrega eles como String  */
    final String menuItems = await rootBundle.loadString(
      'assets/menu_items.json',
    );
    /* converte a String para uma lista dinâmica e depois "força" a tipagem correta */
    final List<dynamic> items = jsonDecode(menuItems);
    return items.cast<Map<String, dynamic>>();
  }

  /* Função para adicionar itens no carrinho e confirmação por AlertDialog (modal) */
  List<Map<String, dynamic>> cart = [];
  void addToCart(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorTheme.primaryColor,
          title: Text('Confirmar'),
          content: Text(
            'Adicionar "${item['name']}" ao carrinho?',
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Adicionar'),
                  onPressed: () {
                    if (!cart.any(
                      (element) => element['type'] == item['type'],
                    )) {
                      Navigator.of(context).pop();
                      setState(() {
                        cart.add(item);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green,
                          content: Text(
                            '${item['name']} adicionado ao carrinho!',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            'Você já possui um ${item['type'].toUpperCase()} adicionado ao carrinho!',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  /* Inicializa lista de pedidos */
  List<Map<String, dynamic>> orders = [];

  /* Função assíncrona para salvar pedidos localmente */
  Future<void> saveOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final ordersJson = jsonEncode(orders);
    await prefs.setString('savedOrders', ordersJson);
  }

  /* Função para carregar lista de pedidos salva localmente */
  Future<void> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('savedOrders');

    if (savedData != null) {
      final decoded = jsonDecode(savedData);
      setState(() {
        orders = List<Map<String, dynamic>>.from(
          decoded.map(
            (order) => {
              'name': order['name'],
              'items': List<Map<String, dynamic>>.from(order['items']),
            },
          ),
        );
      });
    }
  }

  /* Carrega os pedidos junto no momento que a tela é carregada */
  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.primaryColor,
      appBar: AppBar(
        title: Text(
          "BOM HAMBURGUER 🍔",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: ColorTheme.quaternaryColor,
      ),
      /* Exibe após confirmar que os dados do loadItems() foram carregados */
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: loadItems(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data!;
          return ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "BEM VINDO(A) ${widget.name}!",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Center(
                  child: Text(
                    "Sabor irresistível a cada mordida!",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(24, 10, 24, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.monetization_on),
                    Text("Pedido Mínimo \$20", style: TextStyle(fontSize: 16)),
                    Spacer(),
                    Icon(Icons.timer_outlined),
                    Text("40 - 60 min", style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
              /* Itera cada item da lista e cria um Widget */
              ...items.map((item) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Material(
                    color: ColorTheme.tertiaryColor,
                    child: InkWell(
                      onTap: () {
                        addToCart(item);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorTheme.quaternaryColor),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              margin: EdgeInsets.all(8),
                              child: Image.asset(
                                'assets/${item['image']}',
                                fit: BoxFit.contain,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${item['name']}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(item['description']),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 8, 8, 0),
                              child: Text(
                                '\$${item['price'].toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          switch (index) {
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Orders(orders: orders, name: widget.name),
                ),
              );
              break;
            case 2:
              Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Cart(cart: cart)),
                  ) /* Após retorno do pagamento, cria pedido e limpa o carrinho */
                  .then((paymentDone) {
                    if (paymentDone == true) {
                      setState(() {
                        orders.add({
                          'name': widget.name,
                          'items': List<Map<String, dynamic>>.from(cart),
                        });
                        cart.clear();
                      });
                      saveOrders();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green,
                          content: Text(
                            'Pagamento via PIX recebido com sucesso!',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }
                  });
              break;
            default:
          }
        },
        currentIndex: 0,
        backgroundColor: ColorTheme.primaryColor,
        selectedItemColor: ColorTheme.quaternaryColor,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            label: 'Cardápio',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: 'Pedidos'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Carrinho',
          ),
        ],
      ),
    );
  }
}
