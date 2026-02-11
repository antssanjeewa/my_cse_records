import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/holding_model.dart';
import '../models/stock_model.dart';
import '../models/transaction_model.dart';
import '../models/cash_transaction_model.dart';
import '../models/wallet_model.dart';

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

  // Stock Management
  Future<StockModel> addStock({
    required String ticker,
    required String name,
    String? sector,
    required double lastPrice,
  });
  Future<void> updateStock({
    required int stockId,
    String? sector,
    required double lastPrice,
  });
  Future<void> deleteStock(int stockId);

  // Cash Management
  Future<List<CashTransactionModel>> getCashTransactions();
  Future<void> addCashTransaction(CashTransactionModel transaction);
  Future<double> getCashBalance();

  // Wallet Management
  Future<WalletModel?> getWallet(String userId);
  Future<WalletModel> createWallet(String userId,
      {double initialBalance = 0, String currency = 'LKR'});
  Future<void> updateWalletBalance(String userId, double newBalance);
  Future<void> addToWalletBalance(String userId, double amount);
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
        final endOfDay =
            DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
        query = query.lte('date', endOfDay.toIso8601String());
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

  @override
  Future<StockModel> addStock({
    required String ticker,
    required String name,
    String? sector,
    required double lastPrice,
  }) async {
    final data = {
      'ticker': ticker,
      'name': name,
      'sector': sector,
      'last_price': lastPrice,
    };
    _log('INSERT', 'stocks', data);
    try {
      final response =
          await supabase.from('stocks').insert(data).select().single();
      _log('RESPONSE', 'stocks_insert', response);
      return StockModel.fromJson(response);
    } catch (e) {
      _log('ERROR', 'stocks_insert', e);
      rethrow;
    }
  }

  @override
  Future<void> updateStock({
    required int stockId,
    String? sector,
    required double lastPrice,
  }) async {
    final data = {
      'sector': sector,
      'last_price': lastPrice,
    };
    _log('UPDATE', 'stocks', data);
    try {
      await supabase.from('stocks').update(data).eq('id', stockId);
      _log('RESPONSE', 'stocks_update', 'Success');
    } catch (e) {
      _log('ERROR', 'stocks_update', e);
      rethrow;
    }
  }

  @override
  Future<void> deleteStock(int stockId) async {
    _log('DELETE', 'stocks', {'id': stockId});
    try {
      await supabase.from('stocks').delete().eq('id', stockId);
      _log('RESPONSE', 'stocks_delete', 'Success');
    } catch (e) {
      _log('ERROR', 'stocks_delete', e);
      rethrow;
    }
  }

  @override
  Future<List<CashTransactionModel>> getCashTransactions() async {
    _log('GET', 'cash_transactions');
    try {
      final response = await supabase
          .from('cash_transactions')
          .select()
          .order('created_at', ascending: false);
      _log('RESPONSE', 'cash_transactions', (response as List).length);
      return response
          .map((json) => CashTransactionModel.fromJson(json))
          .toList();
    } catch (e) {
      _log('ERROR', 'cash_transactions', e);
      rethrow;
    }
  }

  @override
  Future<void> addCashTransaction(CashTransactionModel transaction) async {
    final data = transaction.toJson();
    _log('INSERT', 'cash_transactions', data);
    try {
      await supabase.from('cash_transactions').insert(data);
    } catch (e) {
      _log('ERROR', 'cash_transactions', e);
      rethrow;
    }
  }

  @override
  Future<double> getCashBalance() async {
    _log('GET_AGGREGATE', 'cash_transactions_balance');
    try {
      final response =
          await supabase.from('cash_transactions').select('amount');

      final total = (response as List).fold<double>(
          0.0, (sum, item) => sum + (item['amount'] as num).toDouble());
      _log('RESPONSE', 'cash_balance', total);
      return total;
    } catch (e) {
      _log('ERROR', 'cash_balance', e);
      rethrow;
    }
  }

  // Wallet Management Implementation
  @override
  Future<WalletModel?> getWallet(String userId) async {
    _log('GET', 'wallets', {'user_id': userId});
    try {
      final response = await supabase
          .from('wallets')
          .select()
          .eq('user_id', userId)
          .maybeSingle();
      _log('RESPONSE', 'wallets_get', response);

      if (response == null) {
        return null;
      }
      return WalletModel.fromJson(response);
    } catch (e) {
      _log('ERROR', 'wallets_get', e);
      rethrow;
    }
  }

  @override
  Future<WalletModel> createWallet(String userId,
      {double initialBalance = 0, String currency = 'LKR'}) async {
    final data = {
      'user_id': userId,
      'balance': initialBalance,
      'currency': currency,
    };
    _log('INSERT', 'wallets', data);
    try {
      final response =
          await supabase.from('wallets').insert(data).select().single();
      _log('RESPONSE', 'wallets_create', response);
      return WalletModel.fromJson(response);
    } catch (e) {
      _log('ERROR', 'wallets_create', e);
      rethrow;
    }
  }

  @override
  Future<void> updateWalletBalance(String userId, double newBalance) async {
    final data = {'balance': newBalance};
    _log('UPDATE', 'wallets', {'user_id': userId, 'balance': newBalance});
    try {
      await supabase.from('wallets').update(data).eq('user_id', userId);
      _log('RESPONSE', 'wallets_update', 'Success');
    } catch (e) {
      _log('ERROR', 'wallets_update', e);
      rethrow;
    }
  }

  @override
  Future<void> addToWalletBalance(String userId, double amount) async {
    _log('UPDATE_INCREMENT', 'wallets', {'user_id': userId, 'amount': amount});
    try {
      // Fetch current balance
      final wallet = await getWallet(userId);
      if (wallet == null) {
        // If wallet doesn't exist, create it
        await createWallet(userId, initialBalance: amount);
      } else {
        // Update wallet with new balance
        await updateWalletBalance(userId, wallet.balance + amount);
      }
      _log('RESPONSE', 'wallets_add', 'Success');
    } catch (e) {
      _log('ERROR', 'wallets_add', e);
      rethrow;
    }
  }

  void _log(String method, String table, [dynamic data]) {
    if (kDebugMode) {
      developer.log('DEBUG [Supabase $method] $table');
      if (data != null) {
        developer.log(table, name: method, error: data, level: 50);
      }
    }
  }
}
