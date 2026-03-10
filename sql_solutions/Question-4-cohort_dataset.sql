--Question 4
--dataset that would enable cohort analysis by marketing channel

SELECT
    L.lead_id,
    L.marketing_channel,
	L.lead_created_date,
    SF.sales_funnel_steps AS funnel_step,

    COALESCE(
        SF.case_closed_successful_date,
        SF.case_opened_date
    ) AS event_date,

    DATEDIFF(
        'day',
        L.lead_created_date,
        COALESCE(
            SF.case_closed_successful_date,
            SF.case_opened_date
        )
    ) AS days_since_cohort

FROM enpal_sql_challenge.main.leads L
LEFT JOIN enpal_sql_challenge.main.sales_funnel SF
    ON L.lead_id = SF.lead_id

ORDER BY
    L.lead_created_date,
    L.marketing_channel,
    L.lead_id,
    SF.sales_funnel_steps;

--
-- To check for leads without corresponding sales funnel entries
SELECT COUNT(*)
FROM enpal_sql_challenge.main.leads L
LEFT JOIN enpal_sql_challenge.main.sales_funnel SF
ON L.lead_id = SF.lead_id
WHERE SF.lead_id IS NULL;