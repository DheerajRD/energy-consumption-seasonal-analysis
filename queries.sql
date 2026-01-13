-- 1. Total Energy Consumption: Winter vs Summer
SELECT
    CASE
        WHEN EXTRACT(MONTH FROM usage_date) IN (12,1,2) THEN 'Winter'
        WHEN EXTRACT(MONTH FROM usage_date) IN (6,7,8) THEN 'Summer'
    END AS season,
    SUM(kwh_consumed) AS total_kwh
FROM energy_usage
WHERE EXTRACT(MONTH FROM usage_date) IN (12,1,2,6,7,8)
GROUP BY season;


-- 2. Average Energy Consumption per Customer by Season
SELECT
    season,
    AVG(kwh_consumed) AS avg_kwh
FROM (
    SELECT
        customer_id,
        kwh_consumed,
        CASE
            WHEN EXTRACT(MONTH FROM usage_date) IN (12,1,2) THEN 'Winter'
            WHEN EXTRACT(MONTH FROM usage_date) IN (6,7,8) THEN 'Summer'
        END AS season
    FROM energy_usage
) t
GROUP BY season;


-- 3. Top 10 High-Consumption Customers by Season
SELECT
    customer_id,
    season,
    SUM(kwh_consumed) AS total_kwh
FROM (
    SELECT
        customer_id,
        kwh_consumed,
        CASE
            WHEN EXTRACT(MONTH FROM usage_date) IN (12,1,2) THEN 'Winter'
            WHEN EXTRACT(MONTH FROM usage_date) IN (6,7,8) THEN 'Summer'
        END AS season
    FROM energy_usage
) t
GROUP BY customer_id, season
ORDER BY total_kwh DESC
LIMIT 10;


-- 4. Energy Consumption by Customer Type and Season
SELECT
    c.customer_type,
    season,
    SUM(e.kwh_consumed) AS total_kwh
FROM energy_usage e
JOIN customers c ON e.customer_id = c.customer_id
CROSS JOIN LATERAL (
    SELECT
        CASE
            WHEN EXTRACT(MONTH FROM e.usage_date) IN (12,1,2) THEN 'Winter'
            WHEN EXTRACT(MONTH FROM e.usage_date) IN (6,7,8) THEN 'Summer'
        END AS season
) s
WHERE season IS NOT NULL
GROUP BY c.customer_type, season;
