-- Create Holdings Table
CREATE TABLE IF NOT EXISTS holdings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL, -- Reference to auth.users if applicable
    stock_id BIGINT NOT NULL REFERENCES stocks(id) ON DELETE CASCADE,
    avg_price DECIMAL(15, 4) NOT NULL DEFAULT 0.0000,
    quantity DECIMAL(15, 4) NOT NULL DEFAULT 0.0000,
    profit DECIMAL(15, 2) NOT NULL DEFAULT 0.00,
    dividend DECIMAL(15, 2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    
    UNIQUE(user_id, stock_id)
);

-- Enable RLS
ALTER TABLE holdings ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view their own holdings" ON holdings FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own holdings" ON holdings FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update their own holdings" ON holdings FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete their own holdings" ON holdings FOR DELETE USING (auth.uid() = user_id);
