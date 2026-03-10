--Question 3
--Top and bottom 3 days (lead_created_date) by marketing channel using: Lead →Sales Call 1 conversion rate. 

WITH lead_conversion AS (
    SELECT
        L.LEAD_ID,
        L.MARKETING_CHANNEL,
        L.LEAD_CREATED_DATE,
        SUM(
            CASE
                WHEN SF.SALES_FUNNEL_STEPS = 'Sales Call 1' THEN 1
                ELSE 0
            END
        ) AS converted
    FROM enpal_sql_challenge.main.leads L
    LEFT JOIN enpal_sql_challenge.main.sales_funnel SF
        ON L.LEAD_ID = SF.LEAD_ID
    GROUP BY
        L.LEAD_ID,
        L.MARKETING_CHANNEL,
        L.LEAD_CREATED_DATE
),

conversion_rates AS (
    SELECT
        MARKETING_CHANNEL,
        LEAD_CREATED_DATE,
        ROUND(100.0 * SUM(converted) / COUNT(*), 1) AS conversion_rate
    FROM lead_conversion
    GROUP BY
        MARKETING_CHANNEL,
        LEAD_CREATED_DATE
),

ranked_days AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY MARKETING_CHANNEL
            ORDER BY conversion_rate DESC, LEAD_CREATED_DATE
        ) AS top_rank,
        ROW_NUMBER() OVER (
            PARTITION BY MARKETING_CHANNEL
            ORDER BY conversion_rate ASC, LEAD_CREATED_DATE
        ) AS bottom_rank
    FROM conversion_rates
)

SELECT
    MARKETING_CHANNEL,
    LEAD_CREATED_DATE,
    conversion_rate
FROM ranked_days
WHERE top_rank <= 3
   OR bottom_rank <= 3
ORDER BY
    MARKETING_CHANNEL,
    conversion_rate DESC;