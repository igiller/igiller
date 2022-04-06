-- Free NTAs that brought money over after the initial Free Subscription
                                                      SELECT A.* ,sum(coalesce(rrf.GROSS_REVENUE,0)) - sum(coalesce(rrf.REFUND_AMOUNT,0)) as net_rev
                                                        from
                                                            (select nta.snaid,
                                                             nta.original_subscription_id,
                                                               case when rrf.subscription_original_id is not null
                                                                    then 'Yes'
                                                                    else 'No'
                                                                end paid_nt,
                                                             nta.SNAID_SEQ_HASH,
                                                             nta.BRAND_ID,
                                                             nta.affiliate_id,
                                                             'Affiliate' as level,
                                                             nta.NTA_DATE    as nt_start,
                                                             nta.NTA_END     as nt_end
                                                      from FIN_MET_LIVE.DERIVED.FIN_MET_NTA_TRANSACTIONS nta
                                                      left join fin_met_live.derived.rrf_combo rrf ON rrf.subscription_original_id = nta.original_subscription_id
                                                      where nta.NTA_DATE between '2021-01-01' and '2021-03-31'
                                                      and rrf.subscription_original_id is null
                                                      and nta.AFFILIATE_ID = 7000
                                                         order by 1
                                                  ) A
                                                 LEFT JOIN
                                                        fin_met_live.derived.rrf_combo rrf
                                                            ON (rrf.snaid = A.snaid
                                                      and A.BRAND_ID = rrf.BRAND_ID
                                                     )
                                                      where rrf.TRANSACTION_DATE >= A.nt_start
GROUP BY 1,2,3,4,5,6,7,8,9
