WITH churn_daily AS (with period as (
          select AFFILIATE_ID,
                 AFFILIATE_NAME,
                 AFFILIATE_ABBREVIATION,
                 '12 months' as duration,
                 REPORT_DATE,
                 report_month_start,
                 trailing_start as start_date
          from (
                   select distinct MONTH_END_DATE::date                         as report_date,
                                   MONTH_BEGIN_DATE::date                       as report_month_start,
                                   min(add_months(MONTH_BEGIN_DATE, -11)::date) as trailing_start

                   from prod_dw.dim.DATE_DIM
                   where report_month_start>= date_trunc(months, DATEADD(DAY, -1, current_date))
                     and MONTH_END_DATE <= dateadd(month, 1, date_trunc(month, DATEADD(DAY, -1, current_date)))
                   group by 1,2
               ) A

                   join

               (
                   select distinct AFFILIATE_ID,
                                   AFFILIATE_NAME,
                                   AFFILIATE_ABBREVIATION
                   from prod_dw.dim.BRAND_LOOKUP
               )
      ),

      active_snaids_period_start as (
          select distinct p.AFFILIATE_ID, p.report_date, duration, sd.snaid
          from FIN_MET_LIVE.derived.subscription_dates sd
                  inner join PROD_DW.dim.BRAND_LOOKUP bl
                      on bl.BRAND_ID = sd.BRAND_ID

                  inner join period p
                      on start_date between sd.sub_1st_date and sd.sub_last_date
                      and p.AFFILIATE_ID = sd.AFFILIATE_ID
                      and report_date >= bl.SA_ACQUISITION_DATE

          where p.AFFILIATE_ID <> 0

          union all

          select distinct 0 as affiliate_id, p.report_date, duration, sd.snaid
          from FIN_MET_LIVE.derived.subscription_dates sd
                   inner join PROD_DW.dim.BRAND_LOOKUP bl
                      on bl.BRAND_ID = sd.BRAND_ID
                   inner join period p
                              on start_date between sd.sub_1st_date and sd.sub_last_date
                              and start_date >= bl.SA_ACQUISITION_DATE
      ),

      active_snaids_period_end as (
          select distinct p.AFFILIATE_ID, p.report_date, p.duration, sd.snaid
          from FIN_MET_LIVE.derived.subscription_dates sd
                  inner join PROD_DW.dim.BRAND_LOOKUP bl
                      on bl.BRAND_ID = sd.BRAND_ID

                  inner join period p
                      on report_date between sd.sub_1st_date and sd.sub_last_date
                      and p.AFFILIATE_ID = sd.AFFILIATE_ID
                      and report_date >= bl.SA_ACQUISITION_DATE

          where p.AFFILIATE_ID<>0


          union all

          select distinct 0 as affiliate_id, p.report_date, duration, sd.snaid
          from FIN_MET_LIVE.derived.subscription_dates sd
                   inner join PROD_DW.dim.BRAND_LOOKUP bl
                      on bl.BRAND_ID = sd.BRAND_ID
                   inner join period p
                              on report_date between sd.sub_1st_date and sd.sub_last_date
                              and report_date >= bl.SA_ACQUISITION_DATE
      ),


      nta_in_period as (
          select distinct p.AFFILIATE_ID, p.report_date, p.duration, nta.snaid
          from FIN_MET_LIVE.derived.FIN_MET_NTA_TRANSACTIONS nta
                  inner join period p
                      on nta.NTA_DATE between p.start_date and p.report_date
                      and p.AFFILIATE_ID = nta.AFFILIATE_ID
          where p.AFFILIATE_ID <>0

          union all

          select distinct p.AFFILIATE_ID, p.report_date, p.duration, nth.snaid
          from FIN_MET_LIVE.derived.FIN_MET_NTH_TRANSACTIONS nth
                  inner join period p
                      on nth.NTH_DATE between p.start_date and p.report_date
          where p.AFFILIATE_ID = 0
      ),

      churned_snaids as (
      --customers active at start not active at end
      select AFFILIATE_ID, duration, report_date, snaid, 'existing customers' as segment
      from active_snaids_period_start asp
      WHERE NOT EXISTS (SELECT 1 FROM active_snaids_period_end aep
                        WHERE aep.snaid = asp.snaid AND aep.affiliate_id = asp.affiliate_id
                        AND aep.duration = asp.duration AND aep.report_date = asp.report_date)
      UNION
      --nta/nth customers during period not active at end
      select affiliate_id, duration, report_date, snaid, 'nta customers' as segment
      from nta_in_period nrp
      WHERE NOT EXISTS (SELECT 1 FROM active_snaids_period_end aep
                        WHERE aep.snaid = nrp.snaid AND aep.affiliate_id = nrp.affiliate_id
                        AND nrp.duration = aep.duration AND nrp.report_date = aep.report_date)
      )

      SELECT cs.*, sd.original_subscription_id, sd.sub_last_date, pd.producttype, sf.pubcode, sf.sub_status, sf.cancellation_reason, sf.term_type, ed.media_source, cd.campaign_name
      FROM churned_snaids cs
      LEFT JOIN (SELECT sd.snaid, sd.original_subscription_id, ll.affiliate_id, sd.sub_last_date
                 FROM FIN_MET_LIVE.derived.subscription_dates sd
                 JOIN (SELECT sd.snaid, sd.affiliate_id, MAX(sub_last_date) last_date
                            FROM FIN_MET_LIVE.derived.subscription_dates sd
                            INNER JOIN churned_snaids cs ON cs.snaid = sd.snaid AND cs.affiliate_id = sd.affiliate_id AND sd.sub_last_date <= cs.report_date
                            GROUP BY 1,2
                            UNION
                            SELECT sd.snaid, 0 as affiliate_id, MAX(sd.sub_last_date) last_date
                            FROM FIN_MET_LIVE.derived.subscription_dates sd
                            INNER JOIN churned_snaids cs ON cs.snaid = sd.snaid AND cs.affiliate_id = 0 AND sd.sub_last_date <= cs.report_date
                            GROUP BY 1,2
                         ) ll ON ll.snaid = sd.snaid and sd.sub_last_date = ll.last_date) sd ON cs.snaid = sd.snaid AND cs.affiliate_id = sd.affiliate_id
      LEFT JOIN prod_dw.fact_base.subscription_fact_sview sf ON sf.original_subscription_id = sd.original_subscription_id AND sf.is_current_version=1
      LEFT JOIN prod_dw.dw.product_dim pd ON pd.publicationcode = sf.pubcode
      LEFT JOIN prod_dw.dw.effort_dim ed ON ed.effort_id = sf.effort_id
      LEFT JOIN prod_dw.dw.campaign_dim cd ON cd.campaign_id = ed.campaign_id
      where SUB_LAST_DATE between date_trunc(months, DATEADD(DAY, -1, current_date)) and DATEADD(DAY, -1, current_date)
       )
SELECT
    churn_daily."PRODUCTTYPE"  AS "churn_daily.producttype",
        (TO_CHAR(TO_DATE(churn_daily."SUB_LAST_DATE" ), 'YYYY-MM-DD')) AS "churn_daily.sub_last_date",
    COUNT(DISTINCT (churn_daily."SNAID")) AS count_of_snaid
FROM churn_daily
where AFFILIATE_ID=0
GROUP BY
    (TO_DATE(churn_daily."SUB_LAST_DATE" )),
    1
ORDER BY
    1