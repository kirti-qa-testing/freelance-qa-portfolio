-- Freelance QA Portfolio: ETL validation examples
-- IMPORTANT: Replace table/column names with your own synthetic practice schema.
-- Run only against a database you own or are authorized to test.

-- 1. Source and target row counts
SELECT COUNT(*) AS source_count FROM dbo.source_table;
SELECT COUNT(*) AS target_count FROM dbo.target_table;

-- 2. Duplicate target business keys (should return no rows if key must be unique)
SELECT business_key, COUNT(*) AS duplicate_count
FROM dbo.target_table
GROUP BY business_key
HAVING COUNT(*) > 1;

-- 3. Mandatory field null check (should be zero if business_key is required)
SELECT COUNT(*) AS null_key_count
FROM dbo.target_table
WHERE business_key IS NULL;

-- 4. Find source rows missing from target
SELECT s.business_key
FROM dbo.source_table AS s
LEFT JOIN dbo.target_table AS t
  ON s.business_key = t.business_key
WHERE t.business_key IS NULL;

-- 5. Compare mapped columns (adjust casts and transformation rules as needed)
SELECT s.business_key, s.customer_name AS source_name, t.customer_name AS target_name
FROM dbo.source_table AS s
JOIN dbo.target_table AS t
  ON s.business_key = t.business_key
WHERE ISNULL(s.customer_name, '') <> ISNULL(t.customer_name, '');

-- Document expected filters, rejected rows, defaults, rounding and timezone rules
-- before treating any count or mismatch as a defect.
