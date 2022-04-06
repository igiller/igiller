          select d.month_end,
          0 as affiliate_id,
          count(distinct ed.snaid) free_subscribers
          from FIN_MET_FROZEN.ARCHIVE_2021_12.eletter_subscribers_dates ed
                   INNER JOIN (SELECT distinct CAST(d.month_end_date as DATE) month_end
                               FROM prod_dw.dim.date_dim d
                               WHERE CAST(d.date_id as DATE) BETWEEN CAST('2017-01-01' as date) AND CURRENT_DATE()
                               ORDER BY 1 DESC) d ON d.month_end BETWEEN ed.eletter_start::date and ed.eletter_stop::date
          WHERE not exists(
                  select distinct snaid
                  from FIN_MET_FROZEN.ARCHIVE_2021_12.SUBSCRIPTION_DATES sd
                  where d.month_end between SUB_1ST_DATE and SUB_LAST_DATE
                    and ed.snaid = sd.snaid
              )
          GROUP BY d.month_end, affiliate_id