import 'package:flutter/material.dart';
import '../carrinho/models.dart'; // o model de cima

class CarrinhoProvider extends ChangeNotifier {
  final List<ProdutoCarrinho> _itens = [];

  List<ProdutoCarrinho> get itens => List.unmodifiable(_itens);

  double get total =>
      _itens.fold(0, (soma, item) => soma + (item.preco * item.quantidade));

  void adicionar(ProdutoCarrinho produto) {
    final index = _itens.indexWhere((p) => p.cod == produto.cod);

    if (index >= 0) {
      _itens[index].quantidade++;
    } else {
      _itens.add(produto);
    }
    notifyListeners();
  }

  void remover(String cod) {
    _itens.removeWhere((p) => p.cod == cod);
    notifyListeners();
  }

  void diminuirQuantidade(String cod) {
    final index = _itens.indexWhere((p) => p.cod == cod);
    if (index >= 0) {
      if (_itens[index].quantidade > 1) {
        _itens[index].quantidade--;
      } else {
        _itens.removeAt(index);
      }
      notifyListeners();
    }
  }

  void limpar() {
    _itens.clear();
    notifyListeners();
  }
}
