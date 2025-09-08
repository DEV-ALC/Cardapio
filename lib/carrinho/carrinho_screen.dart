import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/carrinho.dart';
import 'package:go_router/go_router.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CarrinhoProvider>(
      builder: (context, carrinho, _) {
        if (carrinho.itens.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Carrinho"),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go("/"),
              ),
            ),
            body: const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Seu carrinho está vazio",
                    style: TextStyle(fontSize: 20, color: Colors.blue),
                  ),
                  Icon(Icons.shopping_cart, color: Colors.blue)
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text("Carrinho"),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.go("/"),
            ),
          ),
          body: Card(
            margin: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    "Carrinho de Compras",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),

                  // Lista dos itens
                  Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: carrinho.itens.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final item = carrinho.itens[index];
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(item.quantidade.toString()),
                          ),
                          title: Text(item.produto),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "R\$ ${(item.preco * item.quantidade).toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: () {
                                  context
                                      .read<CarrinhoProvider>()
                                      .diminuirQuantidade(item.cod);
                                },
                                icon: const Icon(Icons.remove_circle),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "R\$ ${carrinho.total.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Botão de finalizar
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Compra finalizada! 🎉"),
                        ),
                      );
                    },
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text("Finalizar Pedido"),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
