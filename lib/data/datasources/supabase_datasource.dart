import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/holding_model.dart';
import '../models/stock_model.dart';
import '../models/transaction_model.dart';

abstract class RemoteDataSource {
  Future<List<StockModel>> getStocks();
  Future<List<HoldingModel>> getHoldings();
  Future<List<TransactionModel>> getTransactions();
  Future<void> addTransaction(TransactionModel transaction);
  Future<void> updateHolding(HoldingModel holding);
}

class SupabaseDataSourceImpl implements RemoteDataSource {
  final SupabaseClient supabase;

  SupabaseDataSourceImpl({required this.supabase});

  @override
  Future<List<StockModel>> getStocks() async {
    final response = await supabase.from('stocks').select();
    return (response as List).map((json) => StockModel.fromJson(json)).toList();
  }

  @override
  Future<List<HoldingModel>> getHoldings() async {
    final response = await supabase.from('holdings').select('*, stocks(*)');
    return (response as List)
        .map((json) => HoldingModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<TransactionModel>> getTransactions() async {
    final response = await supabase
        .from('transactions')
        .select('*, stocks(*)')
        .order('date', ascending: false);
    return (response as List)
        .map((json) => TransactionModel.fromJson(json))
        .toList();
  }

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    await supabase.from('transactions').insert(transaction.toJson());
  }

  @override
  Future<void> updateHolding(HoldingModel holding) async {
    await supabase
        .from('holdings')
        .update(holding.toJson())
        .eq('id', holding.id);
  }
}
