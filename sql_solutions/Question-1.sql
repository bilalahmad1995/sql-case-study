--Question 1
--How far back does data go

SELECT
    (SELECT STRFTIME('%Y-%m-%d', MIN(LEAD_CREATED_DATE))
     FROM enpal_sql_challenge.main.leads) AS earliest_lead_created_date,
     
    (SELECT STRFTIME('%Y-%m-%d', MAX(CASE_CLOSED_SUCCESSFUL_DATE))
     FROM enpal_sql_challenge.main.sales_funnel) AS latest_case_closed_successful_date