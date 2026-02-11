// Example: Displaying Wallet in HomeScreen
// Add this to your home_screen.dart file

// In the build method, after Consumer<HomeViewModel>:
/*
Consumer<HomeViewModel>(
  builder: (context, viewModel, child) {
    final summary = viewModel.summary;
    final wallet = viewModel.wallet;  // Access wallet
    
    // Calculate total available funds
    final totalCash = wallet?.balance ?? 0;
    final portfolioValue = summary?.totalValue ?? 0;
    
    return CustomScrollView(
      // ... rest of your code
    );
  },
)
*/

// To use wallet balance in the hero card:
Widget _buildHeroCard(double value, double load, double? cashBalance) {
  final totalAvailable = (cashBalance ?? 0) + value;
  
  return Container(
    padding: const EdgeInsets.all(AppSizes.p24),
    decoration: BoxDecoration(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(AppSizes.r24),
      boxShadow: [
        BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10)),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Total Portfolio Value',
            style: GoogleFonts.inter(color: Colors.white70, fontSize: 14)),
        const SizedBox(height: AppSizes.p8),
        Text(AppFormatters.formatCurrency(totalAvailable),
            style: GoogleFonts.inter(
                color: AppColors.textPrimary,
                fontSize: 32,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: AppSizes.p16),
        
        // Show breakdown
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Holdings',
                    style: GoogleFonts.inter(
                        color: Colors.white70, fontSize: 12)),
                Text(AppFormatters.formatCurrency(value),
                    style: GoogleFonts.inter(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Cash',
                    style: GoogleFonts.inter(
                        color: Colors.white70, fontSize: 12)),
                Text(AppFormatters.formatCurrency(cashBalance ?? 0),
                    style: GoogleFonts.inter(
                        color: AppColors.success,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        
        const SizedBox(height: AppSizes.p16),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppSizes.r8)),
              child: Row(
                children: [
                  const Icon(Icons.trending_up,
                      color: AppColors.success, size: AppSizes.iconSm),
                  const SizedBox(width: AppSizes.p4),
                  Text('+LKR ${load.toStringAsFixed(2)} (2.5%)',
                      style: GoogleFonts.inter(
                          color: AppColors.success,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(width: AppSizes.p8),
            Text('Today',
                style:
                    GoogleFonts.inter(color: Colors.white60, fontSize: 12)),
          ],
        ),
      ],
    ),
  );
}

// Update the Consumer builder to pass wallet:
/*
Consumer<HomeViewModel>(
  builder: (context, viewModel, child) {
    // Fetch wallet for current user when needed
    final authViewModel = context.watch<AuthViewModel>();
    if (authViewModel.currentUser != null && viewModel.wallet == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.fetchWalletForUser(authViewModel.currentUser!.id);
      });
    }
    
    // Use in the UI...
  },
)
*/
