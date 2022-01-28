Select * from SBX.igiller.accounting_revenue_refund_report_new
limit 5;

select 'DEV' as Totals,count(*), sum(INVOICE_AMOUNT),sum(GROSS_REFUND),sum(GROSS_REVENUE),sum(GROSS_ORDERS)
from SBX.igiller.accounting_revenue_refund_report_new
WHERE TRANSACTION_DATE between '2021-01-01' and '2021-12-31'
GROUP BY 1

union

select 'PROD' as Totals, count(*), sum(INVOICE_AMOUNT),sum(GROSS_REFUND),sum(GROSS_REVENUE),sum(GROSS_ORDERS)
from PROD_DW.DW.accounting_revenue_refund_report
WHERE TRANSACTION_DATE between '2021-01-01' and '2021-12-31'
Group by 1;

get ddl
