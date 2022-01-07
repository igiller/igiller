USE database fin_met_frozen;

SET base_schema = (SELECT schema_name FROM fin_met_frozen.information_schema.schemata WHERE 1=1
and created = (SELECT max(created) FROM fin_met_frozen.information_schema.schemata
where SCHEMA_NAME not like '%Q%'));

use schema identifier($base_schema);

create or replace temporary table public.cohort_ltv_frozen_data as (
WITH cohort_ltv_frozen_data AS
(select A.nth_year,
       a.value,
       B.total_nth_per_year,
       sum(A.net_cash) as sum_net_cash,
       sum_net_cash / B.total_nth_per_year as avg_ltv,
       sum(avg_ltv) over (partition by A.nth_year, value order by A.nth_year /*year_of_life*/) as cume_ltv

from (
         select nth.snaid,
                nth.SNAID_SEQ_HASH,
                nth.NTH_DATE,
                year(nth_date)                                                        as nth_year,
                rrf.TRANSACTION_DATE,
               F.VALUE,
                case when to_date(rrf.transaction_date) <= dateadd('days',value, NTH_DATE) then sum(GROSS_REVENUE) - sum(REFUND_AMOUNT) else null end     as net_cash
         from (SELECT DISTINCT * FROM RRF_COMBO
                            WHERE SUBSCRIPTION_FLG = 'Y' AND TXN_SOURCE NOT ILIKE 'credit') rrf
                  inner join FIN_MET_NTH_TRANSACTIONS nth
                             on nth.snaid = rrf.SNAID
                                 and rrf.TRANSACTION_DATE between nth.NTH_DATE and nth.NTH_END
         FULL JOIN TABLE(FLATTEN(INPUT => ARRAY_CONSTRUCT(1,30,60,90,180,270,365,548,730,1095,1460,1825,2190,2555,2920))) F

         where year(NTH_DATE)/*=*2018*/>= 2014
               and nth.nth_method = 1
               --and nth.SNAID = 'SAC0017305588'
         --and LTV_END <= NTH_END
         group by 1, 2, 3, 4, 5, 6
     ) A

    inner join (
        select year(nth_date) as nth_year, count(distinct nth.SNAID_SEQ_HASH) as total_nth_per_year
         from FIN_MET_NTH_TRANSACTIONS nth
    where year(NTH_DATE) >= 2014
    and nth.NTH_METHOD = 1
    group by 1
    ) B
    on A.nth_year = b.nth_year
group by 1,2,3
 )

SELECT * FROM cohort_ltv_frozen_data);



delete from FIN_MET_FROZEN.REPORTING.ANNUAL_NTH_COHORT_LTV_BY_DAY WHERE fully_mature = false;

insert into FIN_MET_FROZEN.REPORTING.ANNUAL_NTH_COHORT_LTV_BY_DAY
    (
        SELECT
        $base_schema as data_set,
        to_number(clf.value) days,
        clf.nth_year,
        clf.total_nth_per_year,
        clf.cume_ltv,
        CASE WHEN dateadd('days',clf.value, to_date(concat(nth_year,'-01-01'))) < date_trunc('year',current_date) = TRUE THEN TRUE ELSE FALSE END as fully_mature
        FROM public.cohort_ltv_frozen_data clf
        WHERE not exists (SELECT 1 FROM FIN_MET_FROZEN.REPORTING.ANNUAL_NTH_COHORT_LTV_BY_DAY an WHERE an.nth_year = clf.nth_year and to_number(clf.value) = an.days and an.fully_mature = true )
    );

select * from FIN_MET_FROZEN.REPORTING.ANNUAL_NTH_COHORT_LTV_BY_DAY