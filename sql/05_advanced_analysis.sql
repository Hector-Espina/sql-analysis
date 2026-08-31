-- ============================================================
-- ADVANCED SQL ANALYSIS
-- Maven Fuzzy Factory E-Commerce Dataset
-- ============================================================


-- 1. MONTH-OVER-MONTH REVENUE GROWTH

WITH monthly_performance AS (
    SELECT
        DATE_TRUNC('month', created_at)::DATE AS month,
        COUNT(*) AS orders,
        ROUND(SUM(price_usd), 2) AS revenue,
        ROUND(SUM(price_usd - cogs_usd), 2) AS gross_profit
    FROM orders
    GROUP BY DATE_TRUNC('month', created_at)
),

growth_analysis AS (
    SELECT
        month,
        orders,
        revenue,
        gross_profit,
        LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue
    FROM monthly_performance
)

SELECT
    month,
    orders,
    revenue,
    gross_profit,
    previous_month_revenue,
    ROUND(
        100.0 * (revenue - previous_month_revenue)
        / NULLIF(previous_month_revenue, 0),
        2
    ) AS revenue_growth_pct
FROM growth_analysis
ORDER BY month;


-- 2. PRODUCT REVENUE RANKING

WITH product_performance AS (
    SELECT
        p.product_id,
        p.product_name,
        COUNT(oi.order_item_id) AS units_sold,
        ROUND(SUM(oi.price_usd), 2) AS revenue,
        ROUND(SUM(oi.price_usd - oi.cogs_usd), 2) AS gross_profit
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.product_id,
        p.product_name
)

SELECT
    *,
    RANK() OVER (ORDER BY revenue DESC) AS revenue_rank,
    ROUND(
        100.0 * revenue / SUM(revenue) OVER (),
        2
    ) AS revenue_share_pct
FROM product_performance
ORDER BY revenue_rank;


-- 3. CUSTOMER VALUE RANKING

WITH customer_performance AS (
    SELECT
        user_id,
        COUNT(*) AS orders,
        SUM(items_purchased) AS units_purchased,
        ROUND(SUM(price_usd), 2) AS lifetime_revenue,
        ROUND(AVG(price_usd), 2) AS average_order_value
    FROM orders
    GROUP BY user_id
)

SELECT
    *,
    DENSE_RANK() OVER (
        ORDER BY lifetime_revenue DESC
    ) AS customer_rank
FROM customer_performance
ORDER BY customer_rank
LIMIT 20;


-- 4. CONVERSION FUNNEL

WITH session_funnel AS (
    SELECT
        website_session_id,
        MAX(CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END)
            AS viewed_products,
        MAX(CASE WHEN pageview_url LIKE '/the-%' THEN 1 ELSE 0 END)
            AS viewed_product,
        MAX(CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END)
            AS reached_cart,
        MAX(CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END)
            AS reached_shipping,
        MAX(
            CASE
                WHEN pageview_url IN ('/billing', '/billing-2') THEN 1
                ELSE 0
            END
        ) AS reached_billing,
        MAX(CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END)
            AS completed_order
    FROM website_pageviews
    GROUP BY website_session_id
)

SELECT
    COUNT(*) AS total_sessions,
    SUM(viewed_products) AS product_list_sessions,
    SUM(viewed_product) AS product_page_sessions,
    SUM(reached_cart) AS cart_sessions,
    SUM(reached_shipping) AS shipping_sessions,
    SUM(reached_billing) AS billing_sessions,
    SUM(completed_order) AS completed_order_sessions
FROM session_funnel;


-- 5. FUNNEL CONVERSION RATES

WITH session_funnel AS (
    SELECT
        website_session_id,
        MAX(CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END)
            AS viewed_products,
        MAX(CASE WHEN pageview_url LIKE '/the-%' THEN 1 ELSE 0 END)
            AS viewed_product,
        MAX(CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END)
            AS reached_cart,
        MAX(CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END)
            AS reached_shipping,
        MAX(
            CASE
                WHEN pageview_url IN ('/billing', '/billing-2') THEN 1
                ELSE 0
            END
        ) AS reached_billing,
        MAX(CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END)
            AS completed_order
    FROM website_pageviews
    GROUP BY website_session_id
)

SELECT
    ROUND(
        100.0 * SUM(viewed_product)
        / NULLIF(SUM(viewed_products), 0),
        2
    ) AS products_to_product_pct,

    ROUND(
        100.0 * SUM(reached_cart)
        / NULLIF(SUM(viewed_product), 0),
        2
    ) AS product_to_cart_pct,

    ROUND(
        100.0 * SUM(reached_shipping)
        / NULLIF(SUM(reached_cart), 0),
        2
    ) AS cart_to_shipping_pct,

    ROUND(
        100.0 * SUM(reached_billing)
        / NULLIF(SUM(reached_shipping), 0),
        2
    ) AS shipping_to_billing_pct,

    ROUND(
        100.0 * SUM(completed_order)
        / NULLIF(SUM(reached_billing), 0),
        2
    ) AS billing_to_order_pct
FROM session_funnel;