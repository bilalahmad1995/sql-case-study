-- Question 2.1
-- Best-performing marketing channel regarding Lead → PV System Sold conversion rate

WITH leads_conversion AS (
    SELECT
        L.LEAD_ID,
        L.MARKETING_CHANNEL,
        SUM(
            CASE 
                WHEN SF.SALES_FUNNEL_STEPS = 'PV System Sold' THEN 1
                ELSE 0
            END
        ) AS converted
    FROM enpal_sql_challenge.main.leads L
    LEFT JOIN enpal_sql_challenge.main.sales_funnel SF
        ON L.LEAD_ID = SF.LEAD_ID
    GROUP BY
        L.LEAD_ID,
        L.MARKETING_CHANNEL
)

SELECT
    MARKETING_CHANNEL,
    ROUND(
        100.0 * SUM(converted) / COUNT(*),
        1
    ) AS conversion_rate
FROM leads_conversion
GROUP BY
    MARKETING_CHANNEL
ORDER BY
    conversion_rate DESC;