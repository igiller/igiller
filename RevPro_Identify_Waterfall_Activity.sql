select c.INVOICE_NUMBER,
             hash_value,
             EXT_SELL_PRICE,
             START_DATE,
             END_DATE,
             pub,
             waterfall_month,
             case
                 when waterfall_month = date_trunc('month', START_DATE) then first_month_recognized
                 when waterfall_month = date_trunc('month', END_DATE) then last_month_recognized
                 else monthly_recognized
            end             as deferred_amount
      from REVREG_DB.ITC.COMBINED_FILES c

               inner join (select DATE_ID::date as waterfall_month
                           from prod_dw.dim.date_dim
                           where MONTH_BEGIN_DATE::date = date_id::date) dd
                          on dd.waterfall_month between date_trunc('month', START_DATE) and date_trunc('month', END_DATE)
where c.INVOICE_NUMBER = 'INV11240727'
;