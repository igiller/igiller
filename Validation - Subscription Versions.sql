select snaid, SUBSCRIPTION_ID, ORIGINAL_SUBSCRIPTION_ID,PREVIOUS_SUBSCRIPTION_ID, to_date(ORIGINAL_CREATED_DATE) as ORIGINAL_CREATED_DATE, to_date(CREATED_DATE) as CREATED_DATE,
       to_date(TERM_START_DATE) as TERM_START_DATE, to_date(TERM_END_DATE) as TERM_END_DATE,
       STATUS, SUB_STATUS,VERSION, IS_CURRENT_VERSION, IS_STACKED,PUBCODE,CAMPAIGN_ID,CANCELLATION_REASON, CURRENT_TERM,
       SUBSCRIPTION_START_DATE, SUBSCRIPTION_END_DATE, AMENDMENT_TYPE
from prod_dw.fact_base.subscription_fact_sview sfs
where 1=1
and ORIGINAL_SUBSCRIPTION_ID='2c92a0fe6fa7f077016faff34d6463f6'
--and snaid='SAC0006661976'
and PUBCODE='PBV'
ORDER BY VERSION ASC;