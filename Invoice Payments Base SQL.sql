SELECT
    subscription_fact_sview."SUBSCRIPTION_NAME"  AS "subscription_fact_sview.subscription_name",
    salesforce_account_detail.first_name || ' ' || salesforce_account_detail.last_name  AS "salesforce_account_detail.fullname",
    rev_refund_fact.payment_type  AS "rev_refund_fact.payment_type",
    subscription_fact_sview."SUB_STATUS"  AS "subscription_fact_sview.sub_status",
        (TO_CHAR(TO_DATE(CONVERT_TIMEZONE('UTC', 'America/New_York', CAST(rev_refund_fact."ORIGINAL_SUB_CREATED_DATE"  AS TIMESTAMP_NTZ))), 'YYYY-MM-DD')) AS "rev_refund_fact.original_created_date",
        (TO_CHAR(TO_DATE(payment_schedule."DATE_SCHEDULED" ), 'YYYY-MM-DD')) AS "payment_schedule.date_scheduled_date",
    payment_schedule."INSTALLMENT_AMOUNT"  AS "payment_schedule.installment_amount",
    userprofile_view_owner."NAME"  AS "userprofile_view_owner.name",
    payment_schedule."OUTSTANDING_BALANCE_NUMBER"  AS "payment_schedule.outstanding_balance",
    payment_schedule."STATUS"  AS "payment_schedule.status",
    invoice."INVOICE_NUMBER"  AS "invoice.invoice_number",
    invoice."AMOUNT"  AS "invoice.amount"
FROM FT_PROD.HEROKU_SALESFORCE.OPPORTUNITY_SVIEW  AS opportunity_sview
LEFT JOIN DIM.SALESFORCE_ACCOUNT_DETAIL_VIEW  AS salesforce_account_detail ON (opportunity_sview."ACCOUNT_ID") = (salesforce_account_detail."CRM_ACCOUNT_ID")
LEFT JOIN FT_PROD.HEROKU_SALESFORCE.USERPROFILE_VIEW  AS userprofile_view_owner ON (opportunity_sview."OWNER_ID") = (userprofile_view_owner."USER_ID")
LEFT JOIN dw.revenue_refund_fact_SVIEW  AS rev_refund_fact ON opportunity_sview.original_subscription_id = rev_refund_fact.original_subscription_id
LEFT JOIN PROD_DW.FACT_BASE.SUBSCRIPTION_FACT_SVIEW  AS subscription_fact_sview ON opportunity_sview.original_subscription_id = (subscription_fact_sview."ORIGINAL_SUBSCRIPTION_ID")
    and (subscription_fact_sview."IS_CURRENT_VERSION" = 1) = 1
LEFT JOIN FT_PROD.HEROKU_SALESFORCE.PAYMENT_SCHEDULE_SVIEW  AS payment_schedule ON (opportunity_sview."OPPORTUNITY_ID") = (payment_schedule."OPPORTUNITY_ID")
LEFT JOIN FT_PROD.ZUORA_PMT.INVOICE_SVIEW  AS invoice ON (opportunity_sview."ZUORA_INVOICE_NUMBER") = (invoice."INVOICE_NUMBER")
WHERE (rev_refund_fact."ORIGINAL_SUB_CREATED_DATE" ) < ((CONVERT_TIMEZONE('America/New_York', 'UTC', CAST(DATEADD('day', -366, DATE_TRUNC('day', CONVERT_TIMEZONE('UTC', 'America/New_York', CAST(CURRENT_TIMESTAMP() AS TIMESTAMP_NTZ)))) AS TIMESTAMP_NTZ)))) AND (payment_schedule."OUTSTANDING_BALANCE_NUMBER" ) > 0
GROUP BY
    (TO_DATE(CONVERT_TIMEZONE('UTC', 'America/New_York', CAST(rev_refund_fact."ORIGINAL_SUB_CREATED_DATE"  AS TIMESTAMP_NTZ)))),
    (TO_DATE(payment_schedule."DATE_SCHEDULED" )),
    1,
    2,
    3,
    4,
    7,
    8,
    9,
    10,
    11,
    12
ORDER BY
    6 DESC