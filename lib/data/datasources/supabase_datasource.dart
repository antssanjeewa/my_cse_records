import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/holding_model.dart';
import '../models/stock_model.dart';
import '../models/transaction_model.dart';

abstract class RemoteDataSource {
  Future<List<StockModel>> getStocks();
  Future<List<HoldingModel>> getHoldings();
  Future<List<TransactionModel>> getTransactions({
    int? stockId,
    String? type,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  });
  Future<void> addTransaction(TransactionModel transaction);
  Future<void> updateHolding(HoldingModel holding);
  Future<void> upsertHolding(HoldingModel holding);
  Future<HoldingModel?> getHoldingByStock(String userId, int stockId);
}

class SupabaseDataSourceImpl implements RemoteDataSource {
  final SupabaseClient supabase;

  SupabaseDataSourceImpl({required this.supabase});

  @override
  Future<List<StockModel>> getStocks() async {
    _log('GET', 'stocks');
    try {
      final response = await supabase.from('stocks').select();
      _log('RESPONSE', 'stocks', response);
      return (response as List)
          .map((json) => StockModel.fromJson(json))
          .toList();
    } catch (e) {
      _log('ERROR', 'stocks', e);
      rethrow;
    }
  }

  @override
  Future<List<HoldingModel>> getHoldings() async {
    _log('GET', 'holdings');
    try {
      final response = await supabase.from('holdings').select('*, stocks(*)');
      _log('RESPONSE', 'holdings', response);
      return (response as List)
          .map((json) => HoldingModel.fromJson(json))
          .toList();
    } catch (e) {
      _log('ERROR', 'holdings', e);
      rethrow;
    }
  }

  @override
  Future<List<TransactionModel>> getTransactions({
    int? stockId,
    String? type,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) async {
    _log('GET_FILTERED', 'transactions', {
      'stockId': stockId,
      'type': type,
      'startDate': startDate,
      'endDate': endDate,
      'limit': limit
    });
    try {
      dynamic query = supabase.from('transactions').select('*, stocks(*)');

      if (stockId != null) {
        query = query.eq('stock_id', stockId);
      }
      if (type != null) {
        query = query.eq('type', type.toUpperCase());
      }
      if (startDate != null) {
        query = query.gte('date', startDate.toIso8601String());
      }
      if (endDate != null) {
        query = query.lte('date', endDate.toIso8601String());
      }

      query = query.order('date', ascending: false);

      if (limit != null) {
        query = query.limit(limit);
      }

      final response = await query;
      _log('RESPONSE', 'transactions', 'Count: ${(response as List).length}');
      return (response).map((json) => TransactionModel.fromJson(json)).toList();
    } catch (e) {
      _log('ERROR', 'transactions', e);
      rethrow;
    }
  }

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    final data = transaction.toJson();
    _log('INSERT', 'transactions', data);
    try {
      await supabase.from('transactions').insert(data);
    } catch (e) {
      _log('ERROR', 'transactions', e);
      rethrow;
    }
  }

  @override
  Future<void> updateHolding(HoldingModel holding) async {
    final data = holding.toJson();
    _log('UPDATE', 'holdings', data);
    try {
      await supabase.from('holdings').update(data).eq('id', holding.id);
    } catch (e) {
      _log('ERROR', 'holdings', e);
      rethrow;
    }
  }

  @override
  Future<void> upsertHolding(HoldingModel holding) async {
    final data = holding.toJson();
    _log('UPSERT', 'holdings', data);
    try {
      await supabase.from('holdings').upsert(
            data,
            onConflict: 'user_id, stock_id',
          );
    } catch (e) {
      _log('ERROR', 'holdings', e);
      rethrow;
    }
  }

  @override
  Future<HoldingModel?> getHoldingByStock(String userId, int stockId) async {
    _log('GET_SINGLE', 'holdings', {'user_id': userId, 'stock_id': stockId});
    try {
      final response = await supabase
          .from('holdings')
          .select('*, stocks(*)')
          .eq('user_id', userId)
          .eq('stock_id', stockId)
          .maybeSingle();
      _log('RESPONSE', 'holdings_single', response);

      if (response == null) {
        return null;
      }
      return HoldingModel.fromJson(response);
    } catch (e) {
      _log('ERROR', 'holdings_single', e);
      rethrow;
    }
  }

  void _log(String method, String table, [dynamic data]) {
    if (kDebugMode) {
      print('DEBUG [Supabase $method] $table');
      if (data != null) {
        print('      Data: $data');
      }
    }
  }
}
