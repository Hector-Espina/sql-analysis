CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    created_at TIMESTAMP NOT NULL,
    product_name TEXT NOT NULL
);

CREATE TABLE website_sessions (
    website_session_id INTEGER PRIMARY KEY,
    created_at TIMESTAMP NOT NULL,
    user_id INTEGER NOT NULL,
    is_repeat_session SMALLINT NOT NULL,
    utm_source TEXT,
    utm_campaign TEXT,
    utm_content TEXT,
    device_type TEXT,
    http_referer TEXT
);

CREATE TABLE website_pageviews (
    website_pageview_id INTEGER PRIMARY KEY,
    created_at TIMESTAMP NOT NULL,
    website_session_id INTEGER NOT NULL,
    pageview_url TEXT NOT NULL,
    FOREIGN KEY (website_session_id)
        REFERENCES website_sessions(website_session_id)
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    created_at TIMESTAMP NOT NULL,
    website_session_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    primary_product_id INTEGER NOT NULL,
    items_purchased INTEGER NOT NULL,
    price_usd NUMERIC(10, 2) NOT NULL,
    cogs_usd NUMERIC(10, 2) NOT NULL,
    FOREIGN KEY (website_session_id)
        REFERENCES website_sessions(website_session_id),
    FOREIGN KEY (primary_product_id)
        REFERENCES products(product_id)
);

CREATE TABLE order_items (
    order_item_id INTEGER PRIMARY KEY,
    created_at TIMESTAMP NOT NULL,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    is_primary_item SMALLINT NOT NULL,
    price_usd NUMERIC(10, 2) NOT NULL,
    cogs_usd NUMERIC(10, 2) NOT NULL,
    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),
    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

CREATE TABLE order_item_refunds (
    order_item_refund_id INTEGER PRIMARY KEY,
    created_at TIMESTAMP NOT NULL,
    order_item_id INTEGER NOT NULL,
    order_id INTEGER NOT NULL,
    refund_amount_usd NUMERIC(10, 2) NOT NULL,
    FOREIGN KEY (order_item_id)
        REFERENCES order_items(order_item_id),
    FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);