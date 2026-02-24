class AppConfig {
  static const String locale = 'en_LK';
  static const String currencySymbol = 'LKR ';
  static const String currencySymbolShort = 'Rs. ';
  static const double feePercentage = 0.0112; // 1.12%

  // Supabase
  static const String supabaseUrl = 'https://koevusjggapfimievpld.supabase.co';
  static const String supabaseAnonKey =
      'sb_publishable_KENbWDLkCcVVtsDr7MuZAg_ojvqONUk';

  // Feature Flags
  static const bool enableBiometrics = true;
}
