select *
from PROD_DW.DW.ACCOUNTING_TELESALES_COMMISSION_REPORT
    limit 10;


--SUBSCRIPTION_FACT_SVIEW table - can be frozen FIN_MET_FROZEN.ARCHIVE_2021_12.FACT_BASE_SUBSCRIPTION_FACT_SVIEW or live PROD_DW.FACT_BASE.SUBSCRIPTION_FACT_SVIEW
select *
from PROD_DW.FACT_BASE.SUBSCRIPTION_FACT_SVIEW
where EFFORT_ID='MKT514593' and PUBCODE='NAVL'
and IS_CURRENT_VERSION=1;



--SUBSCRIPTION_DATES - can be frozen FIN_MET_FROZEN.ARCHIVE_2021_12.subscription_dates  or LIVE: FIN_MET_LIVE.DERIVED.subscription_dates
select *
from FIN_MET_FROZEN.ARCHIVE_2021_12.subscription_dates
where snaid='SAC0000662082';

--Invoice Zuora Table
select *
from FT_PROD.ZUORA_PMT.INVOICE_EVENT_SVIEW
WHERE 1=1
/* and  INVOICE_NUMBER='INV10815628' -- New Sale
and INVOICE_NUMBER='INV11896060'
and  INVOICE_NUMBER='INV05897307' -- M-fee*/
and INVOICE_NUMBER='INV05763686'
;
--IIA table
select *
from FT_PROD.ZUORA_PMT.VW_INVOICE_ITEM_ADJUSTMENT
where 1=1
   and  ADJUSTMENT_NUMBER in ('IIA-19030113',
                        'IIA-19011181')
;

--CBA table
select * from ft_prod.zuora_pmt.vw_credit_balance_adjustment cba
where 1=1
--       NUMBER='CBA-00372762' --Invoice
--and number = 'CBA-00184260'  --Refund
and ACCOUNT_ID='2c92a0fe5f8497ad015f8c95694c2d51'
;

--Invoices that tied to a subscription in Zuora
select *
from ft_prod.ZUORA_PMT.VW_SUBSCRIPTIONS_TO_INVOICES
where ORIGINAL_SUBSCRIPTION_ID = '2c92a00c6f9ddb76016fa6bc26b03200'
;

select count(*) from FIN_MET_LIVE.derived.subscription_dates
where SUB_LAST_DATE='2022-01-31';

select CBA.ID,
       cba.NUMBER                                                      as NUMBER,
                     cba.SOURCE_TRANSACTION_NUMBER AS CBA_NUMBER,
                     cba2.source_transaction_number AS SOURCE,
       cba.ADJUSTMENT_DATE,
                     avg(CASE
                             WHEN cba.type ilike 'Increase' AND cba.status ilike 'processed' THEN cba.amount
                             ELSE NULL END)                                          as credit_payment,
                     avg(CASE
                             WHEN cba.type ilike 'Decrease' AND cba.status ilike 'processed' THEN cba.amount
                             ELSE NULL END)                                          as credit_refund
     from ft_prod.zuora_pmt.vw_credit_balance_adjustment cba
              LEFT JOIN ft_prod.zuora_pmt.vw_credit_balance_adjustment cba2
                        on cba2.id = cba.SOURCE_CREDIT_BALANCE_ADJUSTMENT_ID_C
where cba.NUMBER='CBA-00217073'
GROUP BY 1,2,3,4,5;


select * from FIN_MET_FROZEN.ARCHIVE_2021_12.eletter_subscribers_dates ed
where snaid in ('SAC0025386332','SAC0025089097','SAC0011973964');

select * from FIN_MET_FROZEN.ARCHIVE_2021_12.SUBSCRIPTION_DATES ed
where snaid in ('SAC0025386332','SAC0025089097','SAC0011973964');



select * from  PROD_DW.DW.REVENUE_REFUND_FACT_SVIEW rrf
where TXN_SOURCE = 'Credit' and REFUND_AMOUNT>0
and ORIGINAL_SUB_CREATED_DATE>='2020-01-01'
order by ORIGINAL_SUBSCRIPTION_ID

select *
from ft_prod.zuora_pmt.vw_credit_balance_adjustment cba
where ACCOUNT_ID='2c92a0f946dd1bac0146f3e326fd2590';

select * from