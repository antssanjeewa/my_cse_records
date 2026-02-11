# Wallet Implementation Verification Checklist

## ✅ Backend Setup

- [ ] Run the SQL migration in Supabase to create `wallets` table
  - Navigate to SQL Editor in Supabase dashboard
  - Copy SQL from `supabase_migrations/001_create_wallets_table.sql`
  - Execute the migration
  - Verify table was created with columns: id, user_id, balance, currency, created_at, updated_at

- [ ] Verify RLS policies are applied
  - Go to Authentication > Policies in Supabase
  - Confirm 3 policies exist for wallets table

- [ ] Test database connection
  - Run app and make a transaction
  - Check if wallet is created automatically

## ✅ Code Integration

- [ ] Verify all new files are created:
  ```
  ✓ lib/domain/entities/wallet.dart
  ✓ lib/data/models/wallet_model.dart
  ✓ lib/data/repositories/wallet_repository_impl.dart
  ✓ lib/domain/usecases/wallet_usecases.dart
  ✓ supabase_migrations/001_create_wallets_table.sql
  ```

- [ ] Check imports are correct:
  - `lib/core/di/service_locator.dart` imports wallet classes
  - `lib/presentation/viewmodels/add_transaction_viewmodel.dart` imports wallet use cases
  - `lib/presentation/viewmodels/home_viewmodel.dart` has wallet field

- [ ] Run `flutter pub get` to ensure dependencies are resolved

- [ ] Check for compile errors:
  ```bash
  flutter analyze
  ```

## ✅ Functionality Testing

### Test Wallet Creation
- [ ] Make first transaction as new user
- [ ] Check Supabase > wallets table - wallet should be created with balance = 0

### Test Buy Transaction
- [ ] Create a BUY transaction for 1000 units at 100 LKR = 100,000 LKR total
- [ ] Check wallet balance decreased by ~100,000 (accounting for fees)
- [ ] Verify in Supabase: balance should be negative or reduced

### Test Sell Transaction
- [ ] Create a SELL transaction (if you have holdings)
- [ ] Check wallet balance increased
- [ ] Verify in Supabase: balance should increase

### Test Wallet Display
- [ ] HomeScreen should display wallet balance
- [ ] Navigate to Home screen after transaction
- [ ] Cash balance should be visible and update

### Test Multiple Transactions
- [ ] Create buy and sell transactions in sequence
- [ ] Verify balance updates correctly after each
- [ ] Check Supabase wallet history

## ✅ Error Handling

- [ ] Network error when creating wallet doesn't crash app
- [ ] Missing user context handled gracefully
- [ ] Concurrent transaction updates are consistent
- [ ] Transaction completes even if wallet update fails (add error handling)

## 🚀 Deployment Checklist

- [ ] All files committed to version control
- [ ] Documentation updated with actual user guidance
- [ ] Test on both Android and iOS
- [ ] Verify with real user account
- [ ] Monitor logs for wallet operation errors
- [ ] Performance acceptable (no slow queries)

## 📱 Testing Scenarios

### Scenario 1: Fresh User
1. New user logs in
2. Creates first transaction (BUY 100 shares @ 50 LKR)
3. ✓ Wallet created with negative balance
4. ✓ HomeScreen shows updated cash value

### Scenario 2: Multiple Transactions
1. User creates BUY transaction
2. User creates SELL transaction
3. ✓ Wallet balance changes correctly each time
4. ✓ No data loss or corruption

### Scenario 3: Offline Sync
1. Disable internet
2. Try to create transaction
3. ✓ Appropriate error message
4. ✓ App doesn't crash
5. ✓ Works when internet restored

## 🔍 Database Verification

### Check Wallets Table Structure
```sql
SELECT * FROM wallets LIMIT 1;
-- Should show: id, user_id, balance, currency, created_at, updated_at
```

### Check RLS Policies
```sql
SELECT * FROM pg_policies WHERE tablename = 'wallets';
-- Should show 3 policies
```

### Check Sample Data
```sql
SELECT user_id, balance, currency, created_at 
FROM wallets 
ORDER BY created_at DESC 
LIMIT 5;
```

## ⚠️ Known Issues / Limitations

1. **Initial Balance**: Wallet starts at 0, user needs to deposit funds first
2. **Fee Calculation**: Verify fee percentage is correct in app config
3. **Concurrent Requests**: If multiple transactions happen simultaneously, there could be race conditions
4. **Offline Support**: Currently requires internet connection
5. **Balance History**: No historical tracking of balance changes (could add later)

## 📊 Performance Optimization

- [ ] Wallet query uses index on user_id (created automatically)
- [ ] Wallet fetch is cached in ViewModel to avoid repeated queries
- [ ] Update operations are optimized with single update query
- [ ] Consider adding wallet balance cache if high frequency updates

## 🔧 Troubleshooting

| Issue | Solution |
|---|---|
| Wallet not created | Check RLS policies allow insert |
| Balance not updating | Verify `addToWalletBalance` is called |
| Negative balance allowed | Check if this is intentional for your app |
| High latency | Verify network and database indexes |
| Transaction fails silently | Check error logs in `_log()` output |

## 📞 Support

For issues, check:
1. WALLET_SETUP.md - Setup guide
2. IMPLEMENTATION_SUMMARY.md - Implementation overview
3. Flutter logs: `flutter logs`
4. Supabase logs: Project > Logs in dashboard
5. Database: Check supabase_migrations/001_create_wallets_table.sql
