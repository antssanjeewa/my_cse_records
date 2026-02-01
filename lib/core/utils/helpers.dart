class AppHelpers {
  // Add any helper functions here
  static double calculateProfit(double current, double cost) {
    return current - cost;
  }

  static double calculateProfitPercent(double current, double cost) {
    if (cost == 0) return 0.0;
    return ((current - cost) / cost) * 100;
  }
}
