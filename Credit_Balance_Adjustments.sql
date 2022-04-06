--Credit Balance Adjustments
SELECT distinct
       cba.number,
       cba.id as cba_id,
       cba.credit_source_c,
       cba.DECREASE_SUBSCRIPTION_ORIGINAL_ID_C,
       coalesce(cba.ADJUSTMENT_DATE::date, cba.created_date::date) as event_date,
       i.invoice_number,
       i.invoice_date,
       i.transaction_type_c as invoice_type,
       i.istestaccount,
       pd.producttype,
       i.payment_amount,
       i.refund_amount,
       cba.amount as credit_applied_amount,
       sf.term_type,
       sf.subscription_start_date
FROM ft_prod.zuora_pmt.vw_credit_balance_adjustment cba
LEFT JOIN ft_prod.zuora_pmt.vw_invoice i ON cba.source_transaction_id = i.id
LEFT JOIN prod_dw.fact_base.subscription_fact_sview sf ON sf.original_subscription_id = cba.DECREASE_SUBSCRIPTION_ORIGINAL_ID_C and sf.is_current_version=1
LEFT JOIN prod_dw.dw.product_dim_sview pd ON pd.publicationcode = i.pubcode_c
WHERE coalesce(cba.ADJUSTMENT_DATE::date, cba.created_date::date) BETWEEN CAST('2021-01-01' AS DATE) AND CURRENT_DATE()-1
AND EXISTS (SELECT 1 FROM ft_prod.zuora_pmt.vw_credit_balance_adjustment cba2 WHERE cba2.id = cba.SOURCE_CREDIT_BALANCE_ADJUSTMENT_ID_C AND cba2.credit_source_c IN ('Goodwill','Incentive'))
AND cba.credit_source_c <> 'Expiration'
