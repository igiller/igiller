create or replace temp table public.ies as
select INVOICE_NUMBER,
       sum(CASH_REFUND)::decimal(10, 2)   as cash_refund,
       sum(CREDIT_REFUND)::decimal(10, 2) as credit_refund,
       sum(IIA)::decimal(10, 2)           as iia
from ft_prod.ZUORA_PMT.INVOICE_EVENT_SVIEW
group by 1;

create or replace temporary table public.results as
SELECT distinct
       MAX(sf.SNAID) snaid,
       s.PARENT_BUNDLED_SUB_ORIGINAL_ID_C,
       sf2.pubcode as parent_pubcode,
       sf2.original_created_date_est as parent_original_created_date_est,
       sf2.initial_term as parent_initial_term,
       sf2.term_type as parent_term_type,
       sf3.status as parent_status,
       sf3.sub_status as parent_sub_status,
       sf3.cancelled_date as parent_cancelled_date,
       sf2.initial_term_periodtype as parent_initial_term_periodtype,
       sf2.order_type as parent_order_type,
       ed2.campaign_name,
       vsti.invoice_number,
       vsti.transaction_type_c,
       vsti.invoice_date,
       vsti.invoice_amount,
       i.AMOUNT_WITHOUT_TAX,
       ies.cash_refund,
       ies.credit_refund,
       ies.iia,
       array_to_string(array_agg(sf.original_subscription_id),',') as bundled_original_subscription_id,
       array_to_string(array_agg(sf.pubcode),',') as bundled_pubcode,
       array_to_string(array_agg(sf.TERM_TYPE),',') as bundled_term_types,
       array_to_string(array_agg(sf.original_created_date_est),',') as bundled_original_created_date_est,
       array_to_string(array_agg(sf.initial_term),',') as bundled_initial_term,
       array_to_string(array_agg(sf.initial_term_periodtype),',') as bundled_initial_term_period_type,
       array_to_string(array_agg(sf.status),',') bundled_status,
       array_to_string(array_agg(sf.sub_status),',') bundled_sub_status,
       array_to_string(array_agg(sf.cancelled_date),',') bundled_cancelled_date,
       array_to_string(array_agg(sf.SUBSCRIPTION_RATE_PLAN_PRICE_ONE_TIME),',') as bundled_SUBSCRIPTION_RATE_PLAN_PRICE_ONE_TIME,
       array_to_string(array_agg(sf.order_type),',') as bundled_order_type
FROM fact_base.subscription_fact_sview sf
LEFT JOIN prod_dw.dw.effort_dim_sview ed ON sf.effort_id = ed.effort_id
LEFT JOIN ft_prod.zuora.vw_subscription s ON s.id = sf.SUBSCRIPTION_ID
LEFT JOIN prod_dw.fact_base.subscription_fact_sview sf2 ON sf2.original_subscription_id = s.PARENT_BUNDLED_SUB_ORIGINAL_ID_C AND sf2.version=1
LEFT JOIN prod_dw.fact_base.subscription_fact_sview sf3 ON sf2.original_subscription_id = sf3.original_subscription_id AND sf3.is_current_version=1
LEFT JOIN prod_dw.dw.effort_dim_sview ed2 ON sf3.effort_id = ed2.effort_id
LEFT JOIN ft_prod.ZUORA_PMT.VW_SUBSCRIPTIONS_TO_INVOICES vsti on vsti.original_subscription_id = sf2.original_subscription_id AND vsti.first_invoice_on_sub=1
LEFT JOIN ft_prod.zuora_pmt.vw_invoice i ON i.invoice_number = vsti.invoice_number
LEFT JOIN public.ies as ies ON ies.invoice_number = vsti.invoice_number
WHERE sf.is_current_version=1 AND sf.initial_term > 3 AND sf.SUBSCRIPTION_RATE_PLAN_PRICE_ONE_TIME = 0 and ((sf.INITIAL_TERM < sf2.INITIAL_TERM) or (sf.TERM_TYPE = 'TERMED' and sf2.TERM_TYPE = 'EVERGREEN'))
 AND year(vsti.invoice_date) = 2021 AND s.parent_bundled_sub_original_id_c IS NOT NULL AND ed.campaign_id = ed2.campaign_id
 AND NOT EXISTS (SELECT 1 FROM prod_dw.dw.revenue_refund_fact_sview rrf WHERE rrf.original_subscription_id = sf.original_subscription_id)
GROUP BY 2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20;

--check for duplicates. passes, no duplicates
SELECT invoice_number, COUNT(*)
FROM public.results
GROUP BY 1
HAVING COUNT(*) > 1

SELECT COUNT(*) FROM public.results --34211

SELECT * FROM public.results;

select ORIGINAL_SUBSCRIPTION_ID,PARENT_BUNDLED_SUB_ORIGINAL_ID
from fact_base.subscription_fact_sview
where ORIGINAL_SUBSCRIPTION_ID='2c92a0107c9b72ac017c9fe97d702493'