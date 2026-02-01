import '../../domain/entities/holding.dart';

abstract class LocalDataSource {
  Future<List<Holding>> getHoldings();
}

class LocalDataSourceImpl implements LocalDataSource {
  @override
  Future<List<Holding>> getHoldings() async {
    // Simulate DB delay
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Holding(
          ticker: 'JKH.N0000',
          name: 'John Keells Holdings PLC',
          sector: 'Blue Chip',
          quantity: 1250,
          avgCost: 192.50,
          marketPrice: 216.45),
      Holding(
          ticker: 'SAMP.N0000',
          name: 'Sampath Bank PLC',
          sector: 'Banking',
          quantity: 3000,
          avgCost: 78.40,
          marketPrice: 74.98),
      Holding(
          ticker: 'COMB.N0000',
          name: 'Commercial Bank',
          sector: 'Banking',
          quantity: 850,
          avgCost: 102.75,
          marketPrice: 105.00),
      Holding(
          ticker: 'LOLC.N0000',
          name: 'LOLC Holdings PLC',
          sector: 'Diversified',
          quantity: 2000,
          avgCost: 425.00,
          marketPrice: 427.50),
    ];
  }
}
