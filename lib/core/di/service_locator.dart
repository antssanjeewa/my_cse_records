import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/datasources/supabase_datasource.dart';
import '../../data/repositories/portfolio_repository_impl.dart';

import '../../domain/repositories/portfolio_repository.dart';
import '../../domain/usecases/get_holdings.dart';
import '../../domain/usecases/get_portfolio_summary.dart';
import '../../domain/usecases/get_transactions.dart';

import '../services/biometric_service.dart';
import '../services/secure_storage_service.dart';
import '../../domain/usecases/get_stocks.dart';
import '../../domain/usecases/add_transaction.dart';
import '../../domain/usecases/get_holding_by_stock.dart';
import '../../presentation/viewmodels/home_viewmodel.dart';
import '../../presentation/viewmodels/portfolio_viewmodel.dart';
import '../../presentation/viewmodels/transaction_history_viewmodel.dart';
import '../../presentation/viewmodels/auth_viewmodel.dart';
import '../../presentation/viewmodels/add_transaction_viewmodel.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // Supabase Client
  getIt.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  // Services
  getIt.registerLazySingleton<BiometricService>(() => BiometricService());
  getIt.registerLazySingleton<SecureStorageService>(
      () => SecureStorageService());

  // Data Sources
  getIt.registerLazySingleton<RemoteDataSource>(
    () => SupabaseDataSourceImpl(supabase: getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<PortfolioRepository>(
    () => PortfolioRepositoryImpl(remoteDataSource: getIt()),
  );

  // Use Cases
  getIt.registerLazySingleton(() => GetHoldings(getIt()));
  getIt.registerLazySingleton(() => GetPortfolioSummary(getIt()));
  getIt.registerLazySingleton(() => GetTransactions(getIt()));
  getIt.registerLazySingleton(() => GetStocks(getIt()));
  getIt.registerLazySingleton(() => AddTransaction(getIt()));
  getIt.registerLazySingleton(() => GetHoldingByStock(getIt()));

  // ViewModels
  getIt.registerFactory(() => AuthViewModel(supabase: getIt()));
  getIt.registerFactory(() => HomeViewModel(
        getPortfolioSummary: getIt(),
        getTransactions: getIt(),
      ));
  getIt.registerFactory(() => PortfolioViewModel(getHoldings: getIt()));
  getIt.registerFactory(
      () => TransactionHistoryViewModel(getTransactions: getIt()));
  getIt.registerFactory(() => AddTransactionViewModel(
        getStocks: getIt(),
        addTransaction: getIt(),
        getHoldingByStock: getIt(),
        userId: getIt<AuthViewModel>().currentUser?.id ?? '',
      ));
}
