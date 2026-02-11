-- Supabase SQL Migration for Wallets Table

-- Create wallets table
CREATE TABLE wallets (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade not null,
  balance double precision default 0.0,
  currency text default 'LKR',
  created_at timestamp default now(),
  updated_at timestamp default now(),
  unique(user_id)
);

-- Enable RLS on wallets table
ALTER TABLE wallets ENABLE ROW LEVEL SECURITY;

-- Create RLS policy to allow users to see only their own wallet
CREATE POLICY "Users can view their own wallet"
  ON wallets
  FOR SELECT
  USING (auth.uid() = user_id);

-- Create RLS policy to allow users to update their own wallet
CREATE POLICY "Users can update their own wallet"
  ON wallets
  FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Create RLS policy to allow users to insert their own wallet
CREATE POLICY "Users can insert their own wallet"
  ON wallets
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Create index on user_id for faster lookups
CREATE INDEX idx_wallets_user_id ON wallets(user_id);

-- Optional: Create a trigger to update the updated_at timestamp automatically
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
