-- Question 2.2
-- best-performing marketing channel regarding time-to-conversion

WITH conversions AS (
    SELECT
        SF.LEAD_ID,
        COALESCE(
            SF.CASE_CLOSED_SUCCESSFUL_DATE,
            SF.CASE_OPENED_DATE
        ) AS conversion_date
    FROM enpal_sql_challenge.main.sales_funnel SF
    WHERE SF.SALES_FUNNEL_STEPS = 'PV System Sold'
)

SELECT
    L.MARKETING_CHANNEL,
    ROUND(
        AVG(
            DATEDIFF(
                'day',
                L.LEAD_CREATED_DATE,
                C.conversion_date
            )
        ),
        0
    ) AS avg_days_to_convert
FROM enpal_sql_challenge.main.leads L
JOIN conversions C
    ON L.LEAD_ID = C.LEAD_ID
GROUP BY L.MARKETING_CHANNEL
ORDER BY avg_days_to_convert ASC;