-- Seed data for major stocks in the Colombo Stock Exchange
INSERT INTO stocks (ticker, name, sector, last_price)
VALUES
    ('JKH.N0000', 'John Keells Holdings PLC', 'Capital Goods', 195.50),
    ('COMB.N0000', 'Commercial Bank of Ceylon PLC', 'Banks', 92.30),
    ('HNB.N0000', 'Hatton National Bank PLC', 'Banks', 165.00),
    ('SAMP.N0000', 'Sampath Bank PLC', 'Banks', 75.80),
    ('LOLC.N0000', 'LOLC Holdings PLC', 'Diversified Financials', 420.00),
    ('DIST.N0000', 'Distilleries Company of Sri Lanka PLC', 'Food, Beverage & Tobacco', 26.50),
    ('HAYL.N0000', 'Hayleys PLC', 'Capital Goods', 85.00),
    ('TILE.N0000', 'Lanka Tiles PLC', 'Capital Goods', 48.20),
    ('LIOC.N0000', 'Lanka IOC PLC', 'Energy', 115.00),
    ('SLTL.N0000', 'Sri Lanka Telecom PLC', 'Telecommunication Services', 88.50),
    ('DIAL.N0000', 'Dialog Axiata PLC', 'Telecommunication Services', 10.20),
    ('EXPO.N0000', 'Expolanka Holdings PLC', 'Transportation', 145.00),
    ('VLL.N0000', 'Vallibel Power Erathna PLC', 'Utilities', 8.40),
    ('ACL.N0000', 'ACL Cables PLC', 'Capital Goods', 78.00),
    ('RICH.N0000', 'Richard Pieris & Company PLC', 'Capital Goods', 21.00);

-- Ensure updated_at is refreshed on seed
UPDATE stocks SET updated_at = NOW();
