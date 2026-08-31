-- ============================================================
-- DATA VALIDATION
-- Maven Fuzzy Factory E-Commerce Dataset
-- ============================================================


-- 1. ROW COUNTS

SELECT 'products' AS table_name, COUNT(*) AS row_count FROM products
UNION ALL
SELECT 'website_sessions', COUNT(*) FROM website_sessions
UNION ALL
SELECT 'website_pageviews', COUNT(*) FROM website_pageviews
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'order_item_refunds', COUNT(*) FROM order_item_refunds;


-- 2. DUPLICATE PRIMARY KEYS

SELECT product_id, COUNT(*)
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;

SELECT website_session_id, COUNT(*)
FROM website_sessions
GROUP BY website_session_id
HAVING COUNT(*) > 1;

SELECT website_pageview_id, COUNT(*)
FROM website_pageviews
GROUP BY website_pageview_id
HAVING COUNT(*) > 1;

SELECT order_id, COUNT(*)
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT order_item_id, COUNT(*)
FROM order_items
GROUP BY order_item_id
HAVING COUNT(*) > 1;

SELECT order_item_refund_id, COUNT(*)
FROM order_item_refunds
GROUP BY order_item_refund_id
HAVING COUNT(*) > 1;


-- 3. NULL CHECKS

SELECT
    COUNT(*) FILTER (WHERE website_session_id IS NULL) AS null_session_id,
    COUNT(*) FILTER (WHERE created_at IS NULL) AS null_created_at,
    COUNT(*) FILTER (WHERE user_id IS NULL) AS null_user_id,
    COUNT(*) FILTER (WHERE is_repeat_session IS NULL) AS null_repeat_session,
    COUNT(*) FILTER (WHERE utm_source IS NULL) AS null_utm_source,
    COUNT(*) FILTER (WHERE utm_campaign IS NULL) AS null_utm_campaign,
    COUNT(*) FILTER (WHERE utm_content IS NULL) AS null_utm_content,
    COUNT(*) FILTER (WHERE device_type IS NULL) AS null_device_type,
    COUNT(*) FILTER (WHERE http_referer IS NULL) AS null_http_referer
FROM website_sessions;


-- 4. DATE RANGE CHECKS

SELECT
    'products' AS table_name,
    MIN(created_at) AS first_date,
    MAX(created_at) AS last_date
FROM products

UNION ALL

SELECT
    'website_sessions',
    MIN(created_at),
    MAX(created_at)
FROM website_sessions

UNION ALL

SELECT
    'website_pageviews',
    MIN(created_at),
    MAX(created_at)
FROM website_pageviews

UNION ALL

SELECT
    'orders',
    MIN(created_at),
    MAX(created_at)
FROM orders

UNION ALL

SELECT
    'order_items',
    MIN(created_at),
    MAX(created_at)
FROM order_items

UNION ALL

SELECT
    'order_item_refunds',
    MIN(created_at),
    MAX(created_at)
FROM order_item_refunds;

-- 5. CATEGORICAL VALUE CHECKS

SELECT
    device_type,
    COUNT(*) AS sessions
FROM website_sessions
GROUP BY device_type
ORDER BY sessions DESC;


SELECT
    utm_source,
    COUNT(*) AS sessions
FROM website_sessions
GROUP BY utm_source
ORDER BY sessions DESC;


SELECT
    utm_campaign,
    COUNT(*) AS sessions
FROM website_sessions
GROUP BY utm_campaign
ORDER BY sessions DESC;


SELECT
    utm_content,
    COUNT(*) AS sessions
FROM website_sessions
GROUP BY utm_content
ORDER BY sessions DESC;


SELECT
    is_repeat_session,
    COUNT(*) AS sessions
FROM website_sessions
GROUP BY is_repeat_session
ORDER BY is_repeat_session;


-- 6. REFERENTIAL INTEGRITY CHECKS

SELECT COUNT(*) AS orphan_pageviews
FROM website_pageviews wp
LEFT JOIN website_sessions ws
    ON wp.website_session_id = ws.website_session_id
WHERE ws.website_session_id IS NULL;

SELECT COUNT(*) AS orphan_orders
FROM orders o
LEFT JOIN website_sessions ws
    ON o.website_session_id = ws.website_session_id
WHERE ws.website_session_id IS NULL;

SELECT COUNT(*) AS orphan_order_items
FROM order_items oi
LEFT JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

SELECT COUNT(*) AS orphan_refunds
FROM order_item_refunds r
LEFT JOIN order_items oi
    ON r.order_item_id = oi.order_item_id
WHERE oi.order_item_id IS NULL;


-- 7. BUSINESS RULE CHECKS

-- Orders with invalid values
SELECT COUNT(*) AS invalid_orders
FROM orders
WHERE items_purchased <= 0
   OR price_usd < 0
   OR cogs_usd < 0;


-- Order items with invalid values
SELECT COUNT(*) AS invalid_order_items
FROM order_items
WHERE price_usd < 0
   OR cogs_usd < 0;


-- Refunds with invalid amounts
SELECT COUNT(*) AS invalid_refunds
FROM order_item_refunds
WHERE refund_amount_usd <= 0;


-- Unexpected session flags
SELECT DISTINCT is_repeat_session
FROM website_sessions
ORDER BY is_repeat_session;


-- Unexpected primary item flags
SELECT DISTINCT is_primary_item
FROM order_items
ORDER BY is_primary_item;