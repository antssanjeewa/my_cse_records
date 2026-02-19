# Wallet System Setup Guide

## Overview
The wallet system tracks user cash balance for buy/sell transactions. When users buy stocks, the amount is deducted from their wallet. When they sell stocks, the amount is added back.

## Database Setup (Supabase)

### Step 1: Create the Wallets Table

Run the SQL migration in your Supabase project:

```sql
CREATE TABLE wallets (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade not null,
  balance double precision default 0.0,
  currency text default 'LKR',
  created_at timestamp default now(),
  updated_at timestamp default now(),
  unique(user_id)
);
```

### Step 2: Enable Row Level Security (RLS)

```sql
ALTER TABLE wallets ENABLE ROW LEVEL SECURITY;

-- Users can view their own wallet
CREATE POLICY "Users can view their own wallet"
  ON wallets
  FOR SELECT
  USING (auth.uid() = user_id);

-- Users can update their own wallet
CREATE POLICY "Users can update their own wallet"
  ON wallets
  FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Users can insert their own wallet
CREATE POLICY "Users can insert their own wallet"
  ON wallets
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);
```

### Step 3: Create Indexes

```sql
CREATE INDEX idx_wallets_user_id ON wallets(user_id);
```

### Step 4: Create Auto-Update Trigger (Optional but Recommended)

```sql
CREATE OR REPLACE FUNCTION update_wallets_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_wallets_updated_at
  BEFORE UPDATE ON wallets
  FOR EACH ROW
  EXECUTE FUNCTION update_wallets_updated_at();
```

## How It Works

### Wallet Creation
When a user first makes a transaction, the wallet is automatically created if it doesn't exist.

### Balance Updates
- **Buy Transaction**: Wallet balance is decreased by the total transaction amount (including fees)
- **Sell Transaction**: Wallet balance is increased by the net proceeds (minus fees)
- **Cash Deposit**: Wallet balance is increased by the deposit amount

### File Structure

```
lib/
├── domain/
│   ├── entities/
│   │   └── wallet.dart          # Wallet entity
│   ├── repositories/
│   └── usecases/
│       └── wallet_usecases.dart # Wallet use cases (GetWallet, CreateWallet, etc.)
├── data/
│   ├── datasources/
│   │   └── supabase_datasource.dart  # Added wallet methods
│   ├── models/
│   │   └── wallet_model.dart    # Wallet model with JSON serialization
│   └── repositories/
│       └── wallet_repository_impl.dart  # Wallet repository
└── presentation/
    └── viewmodels/
        ├── home_viewmodel.dart  # Updated to fetch wallet
        └── add_transaction_viewmodel.dart  # Updated to modify wallet
```

## Usage Examples

### Get User Wallet
```dart
final getWallet = getIt<GetWallet>();
final wallet = await getWallet.call(userId);
print('Balance: ${wallet?.balance}');
```

### Create New Wallet
```dart
final createWallet = getIt<CreateWallet>();
final newWallet = await createWallet.call(userId, initialBalance: 100000);
```

### Add Funds to Wallet
```dart
final addToWallet = getIt<AddToWalletBalance>();
await addToWallet.call(userId, 50000); // Add 50,000
```

### Update Wallet Balance Directly
```dart
final updateWallet = getIt<UpdateWalletBalance>();
await updateWallet.call(userId, 150000); // Set to 150,000
```

## Transaction Flow

1. User creates a buy/sell transaction
2. Transaction is saved to the database
3. Wallet balance is automatically updated:
   - **BUY**: `new_balance = current_balance - total_price`
   - **SELL**: `new_balance = current_balance + total_price`
4. HomeViewModel fetches updated wallet balance for display

## Integration Points

### HomeScreen
The home screen displays the total portfolio value. This can now be combined with wallet balance:
```dart
double totalValue = (summary?.totalValue ?? 0) + (wallet?.balance ?? 0);
```

### CashTransaction
When cash transactions occur (deposits/withdrawals), update wallet:
```dart
final addToWallet = getIt<AddToWalletBalance>();
if (transaction.type == 'DEPOSIT') {
  await addToWallet.call(userId, transaction.amount);
} else if (transaction.type == 'WITHDRAW') {
  await addToWallet.call(userId, -transaction.amount);
}
```

## Future Enhancements

1. **Wallet History**: Track all wallet changes with timestamps
2. **Multi-Currency Support**: Allow different currencies per wallet
3. **Wallet Alerts**: Notify when balance is low
4. **Dividend Distribution**: Automatically add dividends to wallet
5. **Withdrawal Requests**: Allow users to withdraw cash from wallet
