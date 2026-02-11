import '../../domain/entities/wallet.dart';
import '../../data/repositories/wallet_repository_impl.dart';

class GetWallet {
  final WalletRepository repository;

  GetWallet({required this.repository});

  Future<Wallet?> call(String userId) async {
    return await repository.getWallet(userId);
  }
}

class CreateWallet {
  final WalletRepository repository;

  CreateWallet({required this.repository});

  Future<Wallet> call(String userId,
      {double initialBalance = 0, String currency = 'LKR'}) async {
    return await repository.createWallet(userId,
        initialBalance: initialBalance, currency: currency);
  }
}

class UpdateWalletBalance {
  final WalletRepository repository;

  UpdateWalletBalance({required this.repository});

  Future<void> call(String userId, double newBalance) async {
    await repository.updateWalletBalance(userId, newBalance);
  }
}

class AddToWalletBalance {
  final WalletRepository repository;

  AddToWalletBalance({required this.repository});

  Future<void> call(String userId, double amount) async {
    await repository.addToWalletBalance(userId, amount);
  }
}
