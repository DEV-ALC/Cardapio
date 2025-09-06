import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MenuAdm extends StatefulWidget {
  const MenuAdm({super.key});

  @override
  State<MenuAdm> createState() => MenuAdmState();
}

class MenuAdmState extends State<MenuAdm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Administrativo'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Pedidos'),
              onTap: () {
                context.go('/pedidos');
              },
            ),
          ],
        ),
      ),
      body: Container(
        // fundo azul para garantir que aparece
        width: double.infinity,
        height: double.infinity,
        child: const Center(
          child: Text(
            'Painel Administrativo',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      ),
    );
  }
}
