import 'package:flutter/material.dart';

// Mock de pedidos
final List<Map<String, String>> mockPedidos = [
  {"id": "001", "cliente": "João", "status": "Pendente"},
  {"id": "002", "cliente": "Maria", "status": "Entregue"},
  {"id": "003", "cliente": "Carlos", "status": "Preparando"},
  {"id": "004", "cliente": "Ana", "status": "Cancelado"},
];

class PainelPedidos extends StatefulWidget {
  const PainelPedidos({super.key});

  @override
  State<PainelPedidos> createState() => _PainelPedidosState();
}

class _PainelPedidosState extends State<PainelPedidos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Painel de Pedidos')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: mockPedidos.length,
        itemBuilder: (context, index) {
          final pedido = mockPedidos[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 3,
            child: ListTile(
              title: Text('Pedido ${pedido["id"]} - ${pedido["cliente"]}'),
              subtitle: Text('Status: ${pedido["status"]}'),
              trailing: ElevatedButton(
                onPressed: () {
                  // Aqui você pode atualizar status ou navegar pra detalhes
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ação no pedido ${pedido["id"]}')),
                  );
                },
                child: const Text('Detalhes'),
              ),
            ),
          );
        },
      ),
    );
  }
}
