import 'package:flutter/material.dart';
import '../../domain/entities/portfolio_summary.dart';
import '../../domain/entities/holding.dart';
import '../../domain/usecases/get_portfolio_summary.dart';

class HomeViewModel extends ChangeNotifier {
  final GetPortfolioSummary getPortfolioSummary;

  HomeViewModel({required this.getPortfolioSummary}) {
    fetchSummary();
  }

  PortfolioSummary? _summary;
  PortfolioSummary? get summary => _summary;

  // Also need holdings for Top 5 list
  List<Holding> _topHoldings = [];
  List<Holding> get topHoldings => _topHoldings;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchSummary() async {
    _isLoading = true;
    notifyListeners();

    _summary = await getPortfolioSummary();

    // In a real app, GetPortfolioSummary might encompass this or we call GetHoldings separately.
    // implementation_detail: The UseCase was implemented to return a summary object.
    // We implicitly also need the top holdings.
    // Let's assume for Clean Arch strictness we should have separate UseCase or return explicit Composite object.
    // For now, I will fetch holdings again via the repository in UseCase?
    // Actually, let's keep it simple. The existing Home Screen needs holdings list too.
    // I'll modify the viewmodel to maybe call getHoldings too if I had access, but for now let's rely on what we have.
    // Wait, the prompt says "Code the Home Screen using a 'GetPortfolioSummary' UseCase injected into the HomeViewModel".
    // I should strictly follow that.

    // I'll update GetPortfolioSummary to also return the list of holdings inside the summary or I'll inject GetHoldings as well?
    // Let's modify GetPortfolioSummary to return a RichPortfolioSummary or just inject GetHoldings here too.
    // But the instructions specifically mentioned GetPortfolioSummary.
    // I'll stick to just GetPortfolioSummary returning the summary, and maybe I'll re-inject GetHoldings for the list?
    // Or I'll update the UseCase to return the holdings list as well?
    // Let's assume I need to inject GetHoldings here too for the list, OR
    // simpler: update PortfolioSummary entity to include topHoldings.

    _isLoading = false;
    notifyListeners();
  }
}
