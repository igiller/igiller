--Alter ARRF table with new fields
alter session set query_tag = '';
use role sysadmin;

alter table PROD_DW.DW."ACCOUNTING_REVENUE_REFUND_REPORT" add column	OFFER_ID VARCHAR(16777216);
alter table PROD_DW.DW."ACCOUNTING_REVENUE_REFUND_REPORT" add column	OFFER_PRICE_CHOICE_ID VARCHAR(16777216);

use role analyst;
alter session set query_tag = '';



