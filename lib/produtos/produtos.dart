import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'imagem_produto.dart';

class Grupo {
  final String codigo;
  final String descricao;
  final List<Produto> produtos;

  Grupo(
      {required this.codigo, required this.descricao, required this.produtos});

  factory Grupo.fromMap(Map<String, dynamic> map) {
    return Grupo(
      codigo: map['grupoCodigo'],
      descricao: map['grupoDescricao'],
      produtos:
          (map['produtos'] as List).map((p) => Produto.fromMap(p)).toList(),
    );
  }
}

class Produto {
  final String codigo;
  final String nome;
  final double preco;
  final String codba;

  Produto({
    required this.codigo,
    required this.nome,
    required this.preco,
    required this.codba,
  });

  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
      codigo: map['cod'],
      nome: map['produto'],
      preco: (map['preco'] as num).toDouble(),
      codba: map['codba'],
    );
  }
}

class CardapioPage extends StatefulWidget {
  const CardapioPage({super.key});

  @override
  State<CardapioPage> createState() => _CardapioPageState();
}

class _CardapioPageState extends State<CardapioPage> {
  List<Grupo> grupos = [];

  @override
  void initState() {
    super.initState();
    buscaProdutos();
  }

  Future<void> buscaProdutos() async {
    final url =
        Uri.parse("http://100.127.60.1/api_7/mesas/busca_produtos_grupo.php");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final map = jsonDecode(response.body);
      if (map['code'] == 1) {
        final itens = map['result'] as List;
        setState(() {
          grupos = itens.map((g) => Grupo.fromMap(g)).toList();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (grupos.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return DefaultTabController(
      length: grupos.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("🍽️ Cardápio Online"),
          centerTitle: true,
          actions: [
            ElevatedButton(
              onPressed: () => context.go('/admin'),
              child: Text("Ir pro Administrativo"),
            )
          ],
          bottom: TabBar(
            isScrollable: true,
            tabs: grupos.map((g) => Tab(text: g.descricao)).toList(),
          ),
        ),
        body: TabBarView(
          children: grupos.map((grupo) {
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              itemCount: grupo.produtos.length,
              itemBuilder: (context, index) {
                final p = grupo.produtos[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: p.codba.isNotEmpty
                            ? Center(
                                child: ProdutoImageWidget(
                                  codba: p.codba,
                                  grid: true,
                                  ip: '100.127.60.1',
                                ),
                              )
                            : const Icon(Icons.fastfood,
                                size: 60, color: Colors.grey),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              p.nome,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "R\$ ${p.preco.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.deepOrange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<String?> findValidImage(List<String> urls) async {
    for (var url in urls) {
      try {
        final response = await http.head(Uri.parse(url));
        if (response.statusCode == 200) {
          return url;
        }
      } catch (_) {}
    }
    return null; // nenhuma URL funcionou
  }
}
