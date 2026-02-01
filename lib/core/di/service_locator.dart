import 'package:get_it/get_it.dart';
import '../../data/datasources/local_datasource.dart';
import '../../data/repositories/portfolio_repository_impl.dart';
import '../../domain/repositories/portfolio_repository.dart';
import '../../domain/usecases/get_holdings.dart';
import '../../domain/usecases/get_portfolio_summary.dart';
import '../../presentation/viewmodels/home_viewmodel.dart';
import '../../presentation/viewmodels/portfolio_viewmodel.dart';
import '../../presentation/viewmodels/auth_viewmodel.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // Data Sources
  getIt.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl());

  // Repositories
  getIt.registerLazySingleton<PortfolioRepository>(
    () => PortfolioRepositoryImpl(localDataSource: getIt()),
  );

  // Use Cases
  getIt.registerLazySingleton(() => GetHoldings(getIt()));
  getIt.registerLazySingleton(() => GetPortfolioSummary(getIt()));

  // ViewModels
  getIt.registerFactory(() => AuthViewModel());
  getIt.registerFactory(() => HomeViewModel(getPortfolioSummary: getIt()));
  getIt.registerFactory(() => PortfolioViewModel(getHoldings: getIt()));
}
