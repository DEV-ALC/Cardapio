import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../providers/provider_login.dart';

class AdministrativoPage extends StatefulWidget {
  const AdministrativoPage({super.key});

  @override
  State<AdministrativoPage> createState() => _AdministrativoPageState();
}

class _AdministrativoPageState extends State<AdministrativoPage> {
  final user = TextEditingController();
  final pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              const Text('Login Administrativo',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              TextField(
                  controller: user,
                  decoration: const InputDecoration(
                      labelText: "Usuário", border: OutlineInputBorder())),
              const SizedBox(height: 20),
              TextField(
                  controller: pass,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: "Senha", border: OutlineInputBorder())),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (user.text == "admin" && pass.text == "123") {
                    AuthProvider.instance.login(); // Atualiza o login
                    context.go("/admin"); // Vai para admin
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Usuário ou senha inválidos"),
                          backgroundColor: Colors.red),
                    );
                  }
                },
                child: const Text("Entrar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
