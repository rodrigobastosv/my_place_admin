class PrecoUtils {
  static String limpaStringPreco(String preco) =>
      preco.replaceAll('R\$', '').trim();

  static double getNumeroStringPreco(String preco) => double.parse(preco
      .replaceAll('R\$', '')
      .replaceAll(',', '')
      .replaceAll('.', '')
      .trim());
}
