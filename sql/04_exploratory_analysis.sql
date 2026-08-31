-- ============================================================
-- EXPLORATORY DATA ANALYSIS
-- Maven Fuzzy Factory E-Commerce Dataset
-- ============================================================


-- 1. BUSINESS OVERVIEW

SELECT
    COUNT(DISTINCT ws.user_id) AS total_users,
    COUNT(DISTINCT ws.website_session_id) AS total_sessions,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(
        100.0 * COUNT(DISTINCT o.order_id)
        / COUNT(DISTINCT ws.website_session_id),
        2
    ) AS conversion_rate_pct
FROM website_sessions ws
LEFT JOIN orders o
    ON ws.website_session_id = o.website_session_id;


-- 2. FINANCIAL OVERVIEW

SELECT
    COUNT(*) AS total_orders,
    SUM(items_purchased) AS units_sold,
    ROUND(SUM(price_usd), 2) AS total_revenue,
    ROUND(SUM(cogs_usd), 2) AS total_cogs,
    ROUND(SUM(price_usd - cogs_usd), 2) AS gross_profit,
    ROUND(AVG(price_usd), 2) AS average_order_value,
    ROUND(
        100.0 * SUM(price_usd - cogs_usd) / SUM(price_usd),
        2
    ) AS gross_margin_pct
FROM orders;

-- 3. MONTHLY BUSINESS PERFORMANCE

SELECT
    DATE_TRUNC('month', created_at)::DATE AS month,
    COUNT(*) AS orders,
    SUM(items_purchased) AS units_sold,
    ROUND(SUM(price_usd), 2) AS revenue,
    ROUND(SUM(price_usd - cogs_usd), 2) AS gross_profit,
    ROUND(AVG(price_usd), 2) AS average_order_value
FROM orders
GROUP BY DATE_TRUNC('month', created_at)
ORDER BY month;


-- 4. MONTHLY TRAFFIC AND CONVERSION

SELECT
    DATE_TRUNC('month', ws.created_at)::DATE AS month,
    COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(
        100.0 * COUNT(DISTINCT o.order_id)
        / COUNT(DISTINCT ws.website_session_id),
        2
    ) AS conversion_rate_pct
FROM website_sessions ws
LEFT JOIN orders o
    ON ws.website_session_id = o.website_session_id
GROUP BY DATE_TRUNC('month', ws.created_at)
ORDER BY month;


-- 5. PERFORMANCE BY PRODUCT

SELECT
    p.product_id,
    p.product_name,
    COUNT(oi.order_item_id) AS units_sold,
    ROUND(SUM(oi.price_usd), 2) AS revenue,
    ROUND(SUM(oi.cogs_usd), 2) AS cogs,
    ROUND(SUM(oi.price_usd - oi.cogs_usd), 2) AS gross_profit,
    ROUND(
        100.0 * SUM(oi.price_usd - oi.cogs_usd)
        / NULLIF(SUM(oi.price_usd), 0),
        2
    ) AS gross_margin_pct
FROM products p
LEFT JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY revenue DESC;


-- 6. ORDERS BY NUMBER OF ITEMS

SELECT
    items_purchased,
    COUNT(*) AS orders,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage_of_orders
FROM orders
GROUP BY items_purchased
ORDER BY items_purchased;


-- 7. NEW VS REPEAT SESSION PERFORMANCE

SELECT
    ws.is_repeat_session,
    COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(
        100.0 * COUNT(DISTINCT o.order_id)
        / COUNT(DISTINCT ws.website_session_id),
        2
    ) AS conversion_rate_pct,
    ROUND(
        SUM(o.price_usd)
        / NULLIF(COUNT(DISTINCT o.order_id), 0),
        2
    ) AS average_order_value
FROM website_sessions ws
LEFT JOIN orders o
    ON ws.website_session_id = o.website_session_id
GROUP BY ws.is_repeat_session
ORDER BY ws.is_repeat_session;


-- 8. DEVICE PERFORMANCE

SELECT
    ws.device_type,
    COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(
        100.0 * COUNT(DISTINCT o.order_id)
        / COUNT(DISTINCT ws.website_session_id),
        2
    ) AS conversion_rate_pct,
    ROUND(SUM(o.price_usd), 2) AS revenue,
    ROUND(
        SUM(o.price_usd)
        / COUNT(DISTINCT ws.website_session_id),
        2
    ) AS revenue_per_session
FROM website_sessions ws
LEFT JOIN orders o
    ON ws.website_session_id = o.website_session_id
GROUP BY ws.device_type
ORDER BY revenue DESC NULLS LAST;


-- 9. TRAFFIC SOURCE PERFORMANCE

SELECT
    COALESCE(ws.utm_source, 'direct / organic') AS traffic_source,
    COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(
        100.0 * COUNT(DISTINCT o.order_id)
        / COUNT(DISTINCT ws.website_session_id),
        2
    ) AS conversion_rate_pct,
    ROUND(SUM(o.price_usd), 2) AS revenue,
    ROUND(
        SUM(o.price_usd)
        / COUNT(DISTINCT ws.website_session_id),
        2
    ) AS revenue_per_session
FROM website_sessions ws
LEFT JOIN orders o
    ON ws.website_session_id = o.website_session_id
GROUP BY COALESCE(ws.utm_source, 'direct / organic')
ORDER BY revenue DESC NULLS LAST;


-- 10. CAMPAIGN PERFORMANCE

SELECT
    COALESCE(ws.utm_source, 'direct / organic') AS traffic_source,
    COALESCE(ws.utm_campaign, 'no campaign') AS campaign,
    COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(
        100.0 * COUNT(DISTINCT o.order_id)
        / COUNT(DISTINCT ws.website_session_id),
        2
    ) AS conversion_rate_pct,
    ROUND(SUM(o.price_usd), 2) AS revenue
FROM website_sessions ws
LEFT JOIN orders o
    ON ws.website_session_id = o.website_session_id
GROUP BY
    COALESCE(ws.utm_source, 'direct / organic'),
    COALESCE(ws.utm_campaign, 'no campaign')
ORDER BY revenue DESC NULLS LAST;


-- 11. REFUND PERFORMANCE BY PRODUCT

SELECT
    p.product_id,
    p.product_name,
    COUNT(oi.order_item_id) AS items_sold,
    COUNT(r.order_item_refund_id) AS refunded_items,
    ROUND(
        100.0 * COUNT(r.order_item_refund_id)
        / NULLIF(COUNT(oi.order_item_id), 0),
        2
    ) AS refund_rate_pct,
    ROUND(COALESCE(SUM(r.refund_amount_usd), 0), 2) AS refunded_amount
FROM products p
LEFT JOIN order_items oi
    ON p.product_id = oi.product_id
LEFT JOIN order_item_refunds r
    ON oi.order_item_id = r.order_item_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY refund_rate_pct DESC NULLS LAST;


-- 12. WEBSITE LANDING PAGES

WITH first_pageview AS (
    SELECT
        website_session_id,
        MIN(website_pageview_id) AS first_pageview_id
    FROM website_pageviews
    GROUP BY website_session_id
)

SELECT
    wp.pageview_url AS landing_page,
    COUNT(*) AS sessions
FROM first_pageview fp
JOIN website_pageviews wp
    ON fp.first_pageview_id = wp.website_pageview_id
GROUP BY wp.pageview_url
ORDER BY sessions DESC;


-- 13. MOST VIEWED PAGES

SELECT
    pageview_url,
    COUNT(*) AS pageviews
FROM website_pageviews
GROUP BY pageview_url
ORDER BY pageviews DESC;


-- 14. PAGEVIEWS PER SESSION

SELECT
    ROUND(AVG(pageviews_per_session), 2) AS avg_pageviews_per_session
FROM (
    SELECT
        website_session_id,
        COUNT(*) AS pageviews_per_session
    FROM website_pageviews
    GROUP BY website_session_id
) session_pageviews;


-- 15. CUSTOMER SESSION FREQUENCY

SELECT
    sessions_per_user,
    COUNT(*) AS users
FROM (
    SELECT
        user_id,
        COUNT(*) AS sessions_per_user
    FROM website_sessions
    GROUP BY user_id
) user_sessions
GROUP BY sessions_per_user
ORDER BY sessions_per_user;


-- 16. TOP CUSTOMERS BY REVENUE

SELECT
    user_id,
    COUNT(*) AS orders,
    ROUND(SUM(price_usd), 2) AS revenue,
    ROUND(AVG(price_usd), 2) AS average_order_value
FROM orders
GROUP BY user_id
ORDER BY revenue DESC
LIMIT 10;


-- 17. OVERALL REFUND METRICS

SELECT
    COUNT(DISTINCT r.order_item_refund_id) AS refunds,
    ROUND(SUM(r.refund_amount_usd), 2) AS refunded_amount,
    ROUND(
        100.0 * COUNT(DISTINCT r.order_item_id)
        / COUNT(DISTINCT oi.order_item_id),
        2
    ) AS item_refund_rate_pct
FROM order_items oi
LEFT JOIN order_item_refunds r
    ON oi.order_item_id = r.order_item_id;