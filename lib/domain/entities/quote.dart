class Quote { // Porcentaje de cambio en el precio

  Quote({
    required this.companyName,
    required this.stockPrice,
    required this.changePercentage,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();
  final String companyName; // Nombre de la empresa
  final double stockPrice; // Precio de la acción
  final double changePercentage;
  DateTime lastUpdated;

  @override
  String toString() {
    return 'Quote(companyName: $companyName, stockPrice: $stockPrice, changePercentage: $changePercentage)';
  }
}
