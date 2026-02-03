import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'service_locator.dart';
import '../../presentation/viewmodels/auth_viewmodel.dart';
import '../../presentation/viewmodels/home_viewmodel.dart';
import '../../presentation/viewmodels/portfolio_viewmodel.dart';
import '../../presentation/viewmodels/transaction_history_viewmodel.dart';

class AppProviders {
  static List<SingleChildWidget> get providers => [
        ChangeNotifierProvider(create: (_) => getIt<AuthViewModel>()),
        ChangeNotifierProvider(create: (_) => getIt<PortfolioViewModel>()),
        ChangeNotifierProvider(create: (_) => getIt<HomeViewModel>()),
        ChangeNotifierProvider(
            create: (_) => getIt<TransactionHistoryViewModel>()),
      ];
}
