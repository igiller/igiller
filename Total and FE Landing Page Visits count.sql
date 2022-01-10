SELECT 0        as                                                                                                                           AFFILIATE_ID,
       'FE Landing Page Visits'                                                                                                              KPI,
       SUM
           (case
                when daily_campaign_stats.ESTDATE between '2021-01-01' and
                    '2021-12-31'
                    then daily_campaign_stats.TOTAL_LANDINGPAGE_VISITS
                else null
           end) as                                                                                                                           Previous_Qtr
FROM prod_dw.dw.campaign_dim_sview AS campaign_dim
         LEFT JOIN prod_dw.FACTS.DAILY_CAMPAIGN_STATS_SVIEW AS daily_campaign_stats
                   ON (daily_campaign_stats."CAMPAIGN_ID") = campaign_dim.campaign_id
WHERE campaign_dim.campaign_type in ('Front End Promotion', 'Front End Evergreen')
GROUP BY 1,
         2;

SELECT 0        as                                                                                                                           AFFILIATE_ID,
       'Landing Page Visits'                                                                                                                 KPI,
       SUM
           (case
                when daily_campaign_stats.ESTDATE between '2021-01-01' and
                    '2021-12-31'
                    then daily_campaign_stats.TOTAL_LANDINGPAGE_VISITS
                else null
           end) as                                                                                                                           Previous_Qtr
FROM prod_dw.dw.campaign_dim_sview AS campaign_dim
         LEFT JOIN prod_dw.FACTS.DAILY_CAMPAIGN_STATS_SVIEW AS daily_campaign_stats
                   ON (daily_campaign_stats."CAMPAIGN_ID") = campaign_dim.campaign_id
GROUP BY 1,
         2;