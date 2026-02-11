import '../../domain/entities/wallet.dart';
import '../datasources/supabase_datasource.dart';

abstract class WalletRepository {
  Future<Wallet?> getWallet(String userId);
  Future<Wallet> createWallet(String userId,
      {double initialBalance = 0, String currency = 'LKR'});
  Future<void> updateWalletBalance(String userId, double newBalance);
  Future<void> addToWalletBalance(String userId, double amount);
}

class WalletRepositoryImpl implements WalletRepository {
  final RemoteDataSource remoteDataSource;

  WalletRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Wallet?> getWallet(String userId) async {
    return await remoteDataSource.getWallet(userId);
  }

  @override
  Future<Wallet> createWallet(String userId,
      {double initialBalance = 0, String currency = 'LKR'}) async {
    return await remoteDataSource.createWallet(userId,
        initialBalance: initialBalance, currency: currency);
  }

  @override
  Future<void> updateWalletBalance(String userId, double newBalance) async {
    await remoteDataSource.updateWalletBalance(userId, newBalance);
  }

  @override
  Future<void> addToWalletBalance(String userId, double amount) async {
    await remoteDataSource.addToWalletBalance(userId, amount);
  }
}
