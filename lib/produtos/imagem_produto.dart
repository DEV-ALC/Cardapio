import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProdutoImageWidget extends StatefulWidget {
  final String codba;
  final bool grid;
  final String ip;

  const ProdutoImageWidget({
    super.key,
    required this.codba,
    required this.grid,
    required this.ip,
  });

  @override
  State<ProdutoImageWidget> createState() => _ProdutoImageWidgetState();
}

class _ProdutoImageWidgetState extends State<ProdutoImageWidget> {
  double tamanho = 0;
  Widget? cachedImage;
  late final List<String> urls;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    tamanho = widget.grid
        ? MediaQuery.of(context).size.height * 0.16
        : MediaQuery.of(context).size.height * 0.10;

    // Define URLs dependendo do tamanho do codba
    if (widget.codba.length <= 4) {
      urls = [
        "http://${widget.ip}/api_7/cadastros/cadastro_produto/imagem.php?codba=${widget.codba}",
      ];
    } else {
      urls = [
        "http://${widget.ip}/api_7/cadastros/cadastro_produto/imagem.php?codba=${widget.codba}",
        "https://cdn-cosmos.bluesoft.com.br/products/${widget.codba}",
        "http://www.eanpictures.com.br:9000/api/gtin/${widget.codba}",
      ];
    }

    cachedImage ??= ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: _buildImage(0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: tamanho,
        maxHeight: tamanho,
        minWidth: tamanho,
        maxWidth: tamanho,
      ),
      child: cachedImage,
    );
  }

  Widget _buildImage(int index) {
    if (index >= urls.length) return _buildErro();

    return CachedNetworkImage(
      imageUrl: urls[index],
      width: tamanho,
      height: tamanho,
      fit: BoxFit.cover,
      placeholder: (context, url) => _buildErro(),
      errorWidget: (context, url, error) => _buildImage(index + 1),
      errorListener: (error) {
        // não faz nada -> silencia o log padrão
      },
    );
  }

  Widget _buildErro() {
    return Icon(Icons.image, size: tamanho, color: Colors.grey);
  }
}
