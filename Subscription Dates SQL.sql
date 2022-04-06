select CURRENT_DATE as DATE_AS_OF,
       sfv.SNAID,
       sfv.AFFILIATE_ID,
       sfv.BRAND_ID,
       sfv.SUBSCRIPTION_ID,
       sfv.SUBSCRIPTION_START_DATE,
       sfv.ORIGINAL_SUBSCRIPTION_ID,
       sfv.ORIGINAL_CREATED_DATE,
       case
           when sfv.STATUS = 'Active' and sfv.SUB_STATUS = 'AC'
               then 'Active'
           else 'Inactive'
           end as SUB_ACCESS_STATUS,
       web_login.last_web_login_affiliate,
       web_login.last_web_login_brand
from PROD_DW.FACT_BASE.SUBSCRIPTION_FACT_SVIEW sfv
         LEFT JOIN (select wlb.snaid
                         , wlb.affiliate_id
                         , wlb.brand_id
                         , last_web_login_affiliate
                         , max(date(web_last_login_est)) as last_web_login_brand
                    from PROD_DW.FACT_BASE.WEB_LOGINS_SVIEW wlb
                             inner join (
                        select snaid
                             , affiliate_id
                             , max(date(web_last_login_est)) last_web_login_affiliate
                        from PROD_DW.FACT_BASE.WEB_LOGINS_SVIEW
                        group by 1, 2) wla on wla.snaid = wlb.snaid and wla.affiliate_id = wlb.affiliate_id
                    group by 1, 2, 3, 4
                    order by 1, 2) web_login
                   on sfv.snaid = web_login.snaid and sfv.BRAND_ID = web_login.BRAND_ID
where 1 = 1
  and IS_CURRENT_VERSION = 1
limit 20;