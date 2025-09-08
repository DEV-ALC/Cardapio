import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'imagem_produto.dart';
import '../providers/carrinho.dart';
import '../carrinho/models.dart';
import 'package:provider/provider.dart';

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
            Consumer<CarrinhoProvider>(
              builder: (context, carrinho, _) {
                int totalItens = carrinho.itens.fold(
                  0,
                  (sum, item) => sum + item.quantidade,
                );

                return Stack(
                  children: [
                    IconButton(
                      onPressed: () {
                        context.go('/carrinho');
                      },
                      icon: const Icon(
                        Icons.shopping_cart,
                        color: Colors.blue,
                      ),
                    ),
                    if (totalItens > 0)
                      Positioned(
                        right: 4,
                        top: 4,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Text(
                            totalItens.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.blue,
            dividerColor: Colors.blue,
            indicatorColor: Colors.blue,
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
                childAspectRatio: 0.7,
              ),
              itemCount: grupo.produtos.length,
              itemBuilder: (context, index) {
                final p = grupo.produtos[index];

                // Pega a quantidade atual do produto no carrinho
                final carrinho = context.watch<CarrinhoProvider>();
                final itemCarrinho = carrinho.itens.firstWhere(
                  (item) => item.cod == p.codigo,
                  orElse: () => ProdutoCarrinho(
                      cod: p.codigo,
                      produto: p.nome,
                      preco: p.preco,
                      quantidade: 0),
                );
                return GestureDetector(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Flexible(
                              flex: 3,
                              child: Center(
                                child: p.codba.isNotEmpty
                                    ? ProdutoImageWidget(
                                        codba: p.codba,
                                        grid: true,
                                        ip: '100.127.60.1',
                                      )
                                    : const Icon(
                                        Icons.fastfood,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      p.nome,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "R\$ ${p.preco.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.deepOrange),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (itemCarrinho.quantidade > 0)
                          Positioned(
                            left: 8,
                            top: 8,
                            child: GestureDetector(
                              onTap: () {
                                context
                                    .read<CarrinhoProvider>()
                                    .diminuirQuantidade(p.codigo);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.remove,
                                    size: 20, color: Colors.white),
                              ),
                            ),
                          ),

                        // Badge de quantidade
                        if (itemCarrinho.quantidade > 0)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.orange,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                itemCarrinho.quantidade.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  onTap: () {
                    context.read<CarrinhoProvider>().adicionar(
                          ProdutoCarrinho(
                            cod: p.codigo,
                            produto: p.nome,
                            preco: p.preco,
                          ),
                        );
                  },
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
