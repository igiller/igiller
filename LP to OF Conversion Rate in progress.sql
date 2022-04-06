SELECT 0                 as                   AFFILIATE_ID,
       'LP to OF Conversion Rate'             KPI,
       (sum
           (case
                when daily_campaign_stats.ESTDATE between DATEADD(DAY, -7, current_date) and DATEADD(DAY, -1, current_date)
                    then daily_campaign_stats."TOTAL_ORDERFORM_VISITS"
                else null
                   end)) /
       (sum
           (case
                when daily_campaign_stats.ESTDATE between DATEADD(DAY, -7, current_date) and DATEADD(DAY, -1, current_date)
                    then daily_campaign_stats."TOTAL_LANDINGPAGE_VISITS"
                else null
                   end)) as                   last_7_days,
       (sum
           (case
                when daily_campaign_stats.ESTDATE between DATEADD(DAY, -14, current_date) and DATEADD(DAY, -8, current_date)
                    then daily_campaign_stats."TOTAL_ORDERFORM_VISITS"
                else null
                   end)) /
       (sum
           (case
                when daily_campaign_stats.ESTDATE between DATEADD(DAY, -14, current_date) and DATEADD(DAY, -8, current_date)
                    then daily_campaign_stats."TOTAL_LANDINGPAGE_VISITS"
                else null
                   end)) as                   prior_to_last_7_days,

       Last_7_Days - Prior_to_Last_7_Days     "% Change (WOW)",
       (sum
           (case
                when daily_campaign_stats.ESTDATE between date_trunc(months, current_date) and DATEADD(DAY, -1, current_date)
                    then daily_campaign_stats."TOTAL_ORDERFORM_VISITS"
                else null
                   end)) /
       (sum
           (case
                when daily_campaign_stats.ESTDATE between date_trunc(months, current_date) and DATEADD(DAY, -1, current_date)
                    then daily_campaign_stats."TOTAL_LANDINGPAGE_VISITS"
                else null
                   end)) as                   MTD,
       null                                   Percent_of_Month_Complete,
       MTD                                    Full_Month_Projection,
       (sum
           (case
                when daily_campaign_stats.ESTDATE between dateadd(months, -1, date_trunc(month, current_date)) and dateadd(days, -1, date_trunc(month, current_date))
                    then daily_campaign_stats."TOTAL_ORDERFORM_VISITS"
                else null
                   end)) /
       (sum
           (case
                when daily_campaign_stats.ESTDATE between dateadd(months, -1, date_trunc(month, current_date)) and dateadd(days, -1, date_trunc(month, current_date))
                    then daily_campaign_stats."TOTAL_LANDINGPAGE_VISITS"
                else null
                   end)) as                   Previous_Month,
       Full_Month_Projection - Previous_Month "% Change (MOM)",
       (sum
           (case
                when daily_campaign_stats.ESTDATE between date_trunc(quarters, current_date) and DATEADD(DAY, -1, current_date)
                    then daily_campaign_stats."TOTAL_ORDERFORM_VISITS"
                else null
                   end)) /
       (sum
           (case
                when daily_campaign_stats.ESTDATE between date_trunc(quarters, current_date) and DATEADD(DAY, -1, current_date)
                    then daily_campaign_stats."TOTAL_LANDINGPAGE_VISITS"
                else null
                   end)) as                   QTD,
       null                                   Percent_of_Qtr_Complete,
       QTD                                    Full_Qtr_Projection,
       (sum
           (case
                when daily_campaign_stats.ESTDATE between dateadd(quarter, -1, date_trunc(quarter, current_date)) and
                    dateadd(day, -1, date_trunc(quarter, current_date))
                    then daily_campaign_stats."TOTAL_ORDERFORM_VISITS"
                else null
                   end)) /
       (sum
           (case
                when daily_campaign_stats.ESTDATE between dateadd(quarter, -1, date_trunc(quarter, current_date)) and
                    dateadd(day, -1, date_trunc(quarter, current_date))
                    then daily_campaign_stats."TOTAL_LANDINGPAGE_VISITS"
                else null
                   end)) as                   Previous_Qtr,
       Full_Qtr_Projection - Previous_Qtr     "% Change (Q/Q)"
FROM prod_dw.dw.campaign_dim_sview AS campaign_dim
         LEFT JOIN prod_dw.FACTS.DAILY_CAMPAIGN_STATS_SVIEW AS daily_campaign_stats
                   ON (daily_campaign_stats."CAMPAIGN_ID") = campaign_dim.campaign_id
GROUP BY 1,
         2

union

SELECT AFFILIATE_ID,
              'LP to OF Conversion Rate'             KPI,
       (sum
           (case
                when daily_campaign_stats.ESTDATE between DATEADD(DAY, -7, current_date) and DATEADD(DAY, -1, current_date)
                    then daily_campaign_stats."TOTAL_ORDERFORM_VISITS"
                else null
                   end)) /
       nullif((sum
           (case
                when daily_campaign_stats.ESTDATE between DATEADD(DAY, -7, current_date) and DATEADD(DAY, -1, current_date)
                    then daily_campaign_stats."TOTAL_LANDINGPAGE_VISITS"
                else null
                   end)),0)  as                   last_7_days,
       (sum
           (case
                when daily_campaign_stats.ESTDATE between DATEADD(DAY, -14, current_date) and DATEADD(DAY, -8, current_date)
                    then daily_campaign_stats."TOTAL_ORDERFORM_VISITS"
                else null
                   end)) /
       nullif((sum
           (case
                when daily_campaign_stats.ESTDATE between DATEADD(DAY, -14, current_date) and DATEADD(DAY, -8, current_date)
                    then daily_campaign_stats."TOTAL_LANDINGPAGE_VISITS"
                else null
                   end)) ,0) as                   prior_to_last_7_days,

       Last_7_Days - Prior_to_Last_7_Days     "% Change (WOW)",
       (sum
           (case
                when daily_campaign_stats.ESTDATE between date_trunc(months, current_date) and DATEADD(DAY, -1, current_date)
                    then daily_campaign_stats."TOTAL_ORDERFORM_VISITS"
                else null
                   end)) /
       nullif((sum
           (case
                when daily_campaign_stats.ESTDATE between date_trunc(months, current_date) and DATEADD(DAY, -1, current_date)
                    then daily_campaign_stats."TOTAL_LANDINGPAGE_VISITS"
                else null
                   end)),0) as                   MTD,
       null                                   Percent_of_Month_Complete,
       MTD                                    Full_Month_Projection,
       (sum
           (case
                when daily_campaign_stats.ESTDATE between dateadd(months, -1, date_trunc(month, current_date)) and dateadd(days, -1, date_trunc(month, current_date))
                    then daily_campaign_stats."TOTAL_ORDERFORM_VISITS"
                else null
                   end)) /
       nullif((sum
           (case
                when daily_campaign_stats.ESTDATE between dateadd(months, -1, date_trunc(month, current_date)) and dateadd(days, -1, date_trunc(month, current_date))
                    then daily_campaign_stats."TOTAL_LANDINGPAGE_VISITS"
                else null
                   end)),0) as                   Previous_Month,
       Full_Month_Projection - Previous_Month "% Change (MOM)",
       (sum
           (case
                when daily_campaign_stats.ESTDATE between date_trunc(quarters, current_date) and DATEADD(DAY, -1, current_date)
                    then daily_campaign_stats."TOTAL_ORDERFORM_VISITS"
                else null
                   end)) /
       nullif((sum
           (case
                when daily_campaign_stats.ESTDATE between date_trunc(quarters, current_date) and DATEADD(DAY, -1, current_date)
                    then daily_campaign_stats."TOTAL_LANDINGPAGE_VISITS"
                else null
                   end)),0) as                   QTD,
       null                                   Percent_of_Qtr_Complete,
       QTD                                    Full_Qtr_Projection,
       (sum
           (case
                when daily_campaign_stats.ESTDATE between dateadd(quarter, -1, date_trunc(quarter, current_date)) and
                    dateadd(day, -1, date_trunc(quarter, current_date))
                    then daily_campaign_stats."TOTAL_ORDERFORM_VISITS"
                else null
                   end)) /
       nullif((sum
           (case
                when daily_campaign_stats.ESTDATE between dateadd(quarter, -1, date_trunc(quarter, current_date)) and
                    dateadd(day, -1, date_trunc(quarter, current_date))
                    then daily_campaign_stats."TOTAL_LANDINGPAGE_VISITS"
                else null
                   end)),0) as                   Previous_Qtr,
       Full_Qtr_Projection - Previous_Qtr     "% Change (Q/Q)"
FROM prod_dw.dw.campaign_dim_sview AS campaign_dim
         LEFT JOIN prod_dw.FACTS.DAILY_CAMPAIGN_STATS_SVIEW AS daily_campaign_stats
                   ON (daily_campaign_stats."CAMPAIGN_ID") = campaign_dim.campaign_id
WHERE AFFILIATE_ID not in (4000, 9000)
GROUP BY 1,
    2
