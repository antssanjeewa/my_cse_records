import 'package:get_it/get_it.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/portfolio_viewmodel.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<AuthViewModel>(() => AuthViewModel());
  getIt.registerLazySingleton<PortfolioViewModel>(() => PortfolioViewModel());
}
