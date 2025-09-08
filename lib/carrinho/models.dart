class ProdutoCarrinho {
  final String cod;
  final String produto;
  final double preco;
  int quantidade;

  ProdutoCarrinho({
    required this.cod,
    required this.produto,
    required this.preco,
    this.quantidade = 1,
  });
}
