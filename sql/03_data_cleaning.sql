-- ============================================================
-- DATA CLEANING
-- Maven Fuzzy Factory E-Commerce Dataset
-- ============================================================


-- 1. CONVERT TEXT 'NULL' VALUES TO SQL NULL

UPDATE website_sessions
SET
    utm_source = NULLIF(utm_source, 'NULL'),
    utm_campaign = NULLIF(utm_campaign, 'NULL'),
    utm_content = NULLIF(utm_content, 'NULL'),
    http_referer = NULLIF(http_referer, 'NULL');
WHERE
    utm_source = 'NULL'
    OR utm_campaign = 'NULL'
    OR utm_content = 'NULL'
    OR http_referer = 'NULL';