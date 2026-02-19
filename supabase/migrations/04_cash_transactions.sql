-- Create Cash Transactions Table
CREATE TABLE IF NOT EXISTS cash_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    amount DECIMAL(15, 2) NOT NULL, -- Positive for deposits, negative for withdrawals / buys
    type TEXT NOT NULL, -- e.g., 'DEPOSIT', 'WITHDRAWAL', 'BUY', 'SELL'
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- Enable RLS
ALTER TABLE cash_transactions ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view their own cash transactions" ON cash_transactions FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own cash transactions" ON cash_transactions FOR INSERT WITH CHECK (auth.uid() = user_id);
