-- this pulls a list of potentially test accounts that are not identified as is_test in Salesforce.
create or replace temporary table public.test_accounts as
Select
      distinct rrf.SNAID/*,
       POSSIBLE_TEST.PersonEmail,
       POSSIBLE_TEST.PersonMailingStreet,
       POSSIBLE_TEST.firstname,
       POSSIBLE_TEST.lastname,
       POSSIBLE_TEST.PERSONMAILINGCITY,
       rrf.INVOICE_DATE,
       rrf.INVOICE_NUMBER,
       rrf.TRANSACTION_DATE,
       rrf.TXN_SOURCE,
       sf.TERM_TYPE,
       sf.CURRENT_TERM,
       sf.CURRENT_TERM_PERIOD_TYPE,
       SUM(rrf.GROSS_REVENUE) AS REVENUE,
       sum(rrf.REFUND_AMOUNT) AS REFUND*/
from PROD_DW.DW.REVENUE_REFUND_FACT_SVIEW as rrf
    left join PROD_DW.FACT_BASE.SUBSCRIPTION_FACT_SVIEW sf
    on rrf.SUBSCRIPTION_ID=sf.SUBSCRIPTION_ID
INNER JOIN (
    SELECT
        sf.sfid as id,
        sf.SNAID__C as snaid,
        sf.PersonEmail,
        sf.PersonMailingStreet,
        PERSONMAILINGCITY,
        FIRSTNAME,
        LASTNAME
    FROM FT_PROD.heroku_salesforce.vw_account sf
    WHERE
      sf.is_test_account__c=FALSE
        AND(
        UPPER(sf.PersonEmail) LIKE '%STANSBERRYRESEARCH.COM%'
                 OR UPPER(sf.PersonEmail) LIKE '%LEGACYRESEARCH.COM%'
                 OR UPPER(sf.PersonEmail) like '%LRGQUALITYASSURANCE%'
                 OR UPPER(sf.PersonEmail) LIKE '%TRADESMITH.COM%'
                 OR UPPER(sf.personemail) LIKE '%INVESTORMEDIA.COM%'
                 OR UPPER(sf.personemail) LIKE '%INVESTORPLACE.COM%'
                 OR UPPER(sf.Personemail) LIKE '%SRTEST%'
                 OR UPPER(sf.personemail) LIKE '%AGORA%'
                 OR UPPER(personemail) LIKE '%TEST+%'
                 OR UPPER(personemail) LIKE '%TEST-%'
                 OR UPPER(sf.PersonEmail) LIKE '%@TEST.COM%'
                 OR UPPER(sf.PersonEmail) LIKE '%SRTEST%'
                 OR UPPER(sf.PersonEmail) LIKE '%@EXAMPLE.COM%'
                 OR UPPER(sf.personemail) LIKE '%LEELAKRISHNAN.SUBRAMANIAM%'
                 OR UPPER(sf.personemail) LIKE '%HOMARCUS+%'
                 OR UPPER(sf.PersonMailingStreet) IN ('1125 N CHARLES ST',
                                                      '1125 N. CHARLSE STREET' ,
                                                      '1125 N. CHARLSE ST' ,
                                                      '1125 N CHARLES ST' ,
                                                      '1125 N CHARLES' ,
                                                      '1125 N. CHALES STREET' ,
                                                      '1125 N CHALES STREET' ,
                                                      '1125 NORTH CHARLES STREET',
                                                      '1125 N CHARLES STREET',
                                                      '1125 N. CHARLES ST',
                                                      '1217 SAINT PAUL ST',
                                                      '1217  SAINT PAUL ST',
                                                      '1217 ST. PAUL STREET',
                                                      '1217 ST PAUL STREET',
                                                      '1217 ST PAUL',
                                                      '1117  SAINT PAUL ST',
                                                      '1117 SAINT PAUL ST',
                                                      '1117  SAINT PAUL ST',
                                                      '1117 ST PAUL STREET',
                                                      '1117 ST. PAUL STREET',
                                                      '1119 ST. PAUL STREET',
                                                      '1119 SAINT PAUL ST',
                                                      '1119  SAINT PAUL ST',
                                                      '105 W MONUMENT ST',
                                                      '808 SAINT PAUL ST',
                                                      '16 W MADISON ST',
                                                      '14 W MADISON ST',
                                                      '14 W MOUNT VERNON PL',
                                                      '55 NE 5th AVE',
                                                      '1221 WASHINGTON AVE',
                                                      '1314 WASHINGTON AVE',
                                                      '3253  NORMANDY WOODS DR',
                                                      '7116, APT NO 104, WINDSOR AT P',
                                                      '7116,  APT NO 104, WINDSOR AT P',
                                                      '7116,   APT NO 104, WINDSOR AT P',
                                                      '7116,    APT NO 104, WINDSOR AT P',
                                                      '7116, APT NO 104, WINDSOR AT P, DUCKETTS LANE',
                                                      '7116 APT NO 104 WINDSOR AT P','9420 KEY WEST AVE',
                                                      '5299 S FLETCHER AVE','428 DAMAYAN',
                                                      '3224 HOLLY HOCK DRIVE',
                                                      '3224  HOLLYHOCK DR',
                                                      '300 N ALPINE DR',
                                                      '290 E FORT DADE AVE',
                                                      '2862  CALEB AVE',
                                                      '1A VISTA ROAD',
                                                      '123 TEST STREET',
                                                      '123 TEST',
                                                      '123 TEST ST',
                                                      '123 TEST RD',
                                                      '111 TEST STREET',
                                                      '1 TEST WAY',
                                                      '9201 CORPORATE BLVD',
                                                      '95 BUELL DR',
                                                      '95            BUELL DRIVE') --filter out Agora/stansberry
                 OR (UPPER(personmailingcity) LIKE '%BALTIMORE%'
                         and (UPPER(sf.PERSONMAILINGSTREET) LIKE '1125 N CHARLES ST%'
                             OR UPPER(sf.PERSONMAILINGSTREET) LIKE '1125 N. CHARLSE STREET%'
                             OR UPPER(sf.PERSONMAILINGSTREET) LIKE '1125 N. CHARLSE ST%'
                             OR UPPER(sf.PERSONMAILINGSTREET) LIKE '1125 N CHARLES ST%'
                             OR UPPER(sf.PERSONMAILINGSTREET) LIKE '1125 N CHARLES%'
                             OR UPPER(sf.PERSONMAILINGSTREET) LIKE '1125 N. CHALES STREET%'
                             OR UPPER(sf.PERSONMAILINGSTREET) LIKE '1125 N CHALES STREET%'
                             OR UPPER(sf.PERSONMAILINGSTREET) LIKE '1125 NORTH CHARLES STREET%'
                             OR UPPER(sf.PERSONMAILINGSTREET) LIKE '1125 N CHARLES STREET%'
                             OR UPPER(sf.PERSONMAILINGSTREET) LIKE '1125 N. CHARLES ST%'
                             OR UPPER(sf.PERSONMAILINGSTREET) LIKE '1217 SAINT PAUL ST%'
                             OR UPPER(sf.PERSONMAILINGSTREET) LIKE '1217  SAINT PAUL ST%%'
                             OR UPPER(sf.PERSONMAILINGSTREET) LIKE '1217 ST. PAUL STREET%%'
                             OR UPPER(sf.PERSONMAILINGSTREET) LIKE '1217 ST PAUL STREET%%'
                             OR UPPER(sf.PERSONMAILINGSTREET) LIKE '1217 ST PAUL%'))
                 OR (UPPER(sf.PersonMailingStreet) LIKE '%55 NE 5th AVE%' AND UPPER(personmailingcity) LIKE '%DELRAY%')
                 OR UPPER(sf.PersonMailingStreet) LIKE '%WEBINAR%'
                 OR UPPER(sf.PersonMailingStreet) LIKE '%UPSELL%'
                 OR UPPER(sf.PersonMailingStreet) LIKE '%@GMAIL.COM%'
                 OR UPPER(sf.PersonEmail) LIKE '%RAJTEST%'
                 OR UPPER(sf.PersonEmail) LIKE '%mcevallos.stansberry+01172019@gmail.com%'
                 OR UPPER(sf.PersonEmail) LIKE '%bssqa2019%'
                 OR UPPER(sf.PersonEmail) LIKE '%lrgqualityassurance@gmail.com%'
                 OR UPPER(sf.PersonEmail) LIKE '%lrgqualityassurance+%'
                 OR UPPER(sf.PersonEmail) LIKE '%PRODTEST%'
                 OR UPPER(sf.PersonEmail) LIKE '%LRGQA55%'
                 OR UPPER (sf.PersonEmail) LIKE  '%BEACONSTREETSERVICES.COM%'
                 OR UPPER(sf.PersonMailingStreet) = 'TEST'
                 OR UPPER(sf.PersonMailingStreet) = 'T'
                 OR (UPPER(personmailingcity) = UPPER(personmailingstreet) AND UPPER(firstname) = UPPER(lastname) AND UPPER(firstname) = UPPER(personmailingstreet) AND UPPER(firstname) = UPPER(personemail)) --Not sure about this one...
                 OR UPPER(firstname) = 'TEST'
                 OR UPPER(lastname) = 'TEST'
                 OR UPPER(firstname) LIKE '% TEST %'
                 OR UPPER(lastname) LIKE '% TEST %'
                 OR UPPER(personmailingcity) = 'TEST'
                 OR UPPER(personmailingcity) LIKE '% TEST %'
                 OR UPPER(sf.PersonMailingStreet) = 'TEST'
                 OR UPPER(sf.PersonMailingStreet) LIKE '% TEST %'
                 OR UPPER(sf.firstname) = 'FIRST NAME'
                 OR UPPER(sf.lastname) = 'LAST NAME'
            )) POSSIBLE_TEST
    on POSSIBLE_TEST.snaid=rrf.snaid
-- group by 1,2,3,4,5,6,7,8,9,10,11,12,13
-- order by REVENUE;

create or replace temporary table public.zuora_606_20210101_20210930_test_transactions_fuzzy_logic as
SELECT SUBSCRIPTION_AFFILIATE_NAME__INFO
,SUBSCRIPTION_BRAND_NAME__INFO
,CUST_NUM
,SUBSCRIPTION_ORIGINAL_ID__INFO
,CAMPAIGNID__INFO
,SUBSCRIPTION_ISSTACKED__INFO
,INV_NUM
,TO_DATE(r.INV_DATE) as INV_DATE
,OFFER_OFFER_ID__INFO
,CAMPAIGNNAME__INFO
,SUBSCRIPTION_PUBLICATIONCODE__INFO
,PROD_CLASS
,PROD_LN
,PROD_TYPE__C
,SUBSCRIPTION_TERMTYPE__INFO
,SUBSCRIPTION_ORDERTYPE__INFO
,RATEPLANCHARGETABLE_CHARGETYPE__INFO
,SUBSCRIPTION_INITIAL_TERM__INFO
,SUBSCRIPTION_RENEWAL_TERM__INFO
,OFFERPRICECHOICE_ONETIMEPRICE2BILLAFTERDAYS__INFO
,OFFERPRICECHOICE_ONETIMEPRICE__INFO
,OFFERPRICECHOICE_ONETIMEPRICE2__INFO
,OFFERPRICECHOICE_RECURRINGPRICE__INFO
,RATEPLANCHARGEPRICE_MINUS_DISCOUNTAMOUNT__INFO
,TO_DATE(r.START_DATE) START_DATE
,SUBSCRIPTION_STARTDATE__INFO
,TO_DATE(r.end_date) END_DATE
,SUBSCRIPTION_ENDDATE__INFO
,SUBSCRIPTION_CANCELLEDDATE__INFO
,SUBSCRIPTION_STATUSCODE__INFO
,SUBSCRIPTION_STATUSDESCRIPTION__INFO
,IS_TEST_ACCOUNT
,TO_NUMBER(AVG_EXT_SLL_PRC, 10, 2) AS AVG_EXT_SLL_PRC
,TO_NUMBER(INVOICE_TAX_AMOUNT, 10, 2) AS INVOICE_TAX_AMOUNT
FROM prod_dw.DW.REV_REG_1_ZUORA_606_REPORT AS r
--test account table
inner join public.test_accounts pt ON pt.snaid = r.CUST_NUM
WHERE r.INV_DATE >= TO_TIMESTAMP('2021-01-01')
      AND r.INV_DATE < TO_TIMESTAMP('2021-10-01')
GROUP BY 1, 2, 3, 4, 5, 6, 7, TO_DATE(r.INV_DATE), 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
         20, 21, 22, 23, 24, TO_DATE(r.START_DATE), 26,
         TO_DATE(r.end_date), 28, 29, 30, 31, 32, 33, 34
ORDER BY 8 DESC;

create or replace temporary table public.credit_balance_20210101_20210930_test_transactions_fuzzy_logic as
SELECT SNAID__C,
    ID,
    ACCOUNTID,
    CAMPAIGNID__C,
    INVOICENUMBER,
    TO_DATE(INVOICEDATE_DATE) AS INVOICEDATE_DATE,
    PUBCODE__C,
    STATUS,
    TRANSACTIONTYPE__C,
    ISINSTALLMENT__C,
    TO_NUMBER(AMOUNT, 10, 2) as AMOUNT,
    TO_NUMBER(AMOUNTWITHOUTTAX, 10, 2) as AMOUNTWITHOUTTAX,
    PAYMENTMETHODID__C,
    TO_NUMBER(PAYMENTAMOUNT, 10, 2) as PAYMENTAMOUNT,
    TO_NUMBER(REFUNDAMOUNT, 10, 2) as REFUNDAMOUNT,
    TO_NUMBER(CREDITBALANCEADJUSTMENTAMOUNT, 10, 2) as CREDITBALANCEADJUSTMENTAMOUNT,
    TO_NUMBER(ADJUSTMENTAMOUNT, 10, 2) as ADJUSTMENTAMOUNT,
    TO_NUMBER(TOTALINVOICEBALANCE, 10, 2) as TOTALINVOICEBALANCE,
    TO_NUMBER(CREDITBALANCE, 10, 2) as CREDITBALANCE,
    TO_DATE(UPDATEDDATE_DATE) AS UPDATEDDATE_DATE,
    TO_DATE(CREATEDDATE_DATE) AS CREATEDDATE_DATE,
    TO_DATE(SERVICESTARTDATE_DATE) AS SERVICESTARTDATE_DATE,
    TO_DATE(SERVICEENDDATE_DATE) AS SERVICEENDDATE_DATE,
    TO_DATE(CANCELLEDDATE_DATE) AS CANCELLEDDATE_DATE,
    TO_DATE(ADJUSTMENTDATE) AS ADJUSTMENTDATE,
    IS_TEST_ACCOUNT,
    TO_NUMBER(INVOICE_TAX_AMOUNT, 10, 2) AS INVOICE_TAX_AMOUNT
FROM prod_dw.DW.REV_REG_2_CREDIT_BALANCE_REPORT as c
--test account table
inner join public.test_accounts pt ON pt.snaid = c.snaid__c
WHERE INVOICEDATE_DATE >= TO_TIMESTAMP('2021-01-01')
    AND INVOICEDATE_DATE < TO_TIMESTAMP('2021-10-01')
GROUP BY 1, 2, 3, 4, 5, TO_DATE(INVOICEDATE_DATE), 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18,
         19, TO_DATE(UPDATEDDATE_DATE), TO_DATE(CREATEDDATE_DATE),
         TO_DATE(SERVICESTARTDATE_DATE),
         TO_DATE(SERVICEENDDATE_DATE),
         TO_DATE(CANCELLEDDATE_DATE), TO_DATE(ADJUSTMENTDATE), 26, 27
ORDER BY 6 DESC;

create or replace temporary table public.blank_invoices_20210101_20210930_test_transactions_fuzzy_logic as
SELECT BRAND_NAME,
    SNAID__C,
    ID,
    CAMPAIGNID__C,
    TO_DATE(INVOICEDATE_DATE),
    INVOICENUMBER,
    TO_NUMBER(INVOICE_AMOUNT, 10, 2) as INVOICE_AMOUNT,
    OFFER_ID__C,
    CAMPAIGN_NAME,
    PUBLICATIONCODE__C,
    TXN_TYPE,
    PRODUCT_NAME,
    PRODUCTTYPE__C,
    TERMTYPE,
    ORDERTYPE__C,
    CHARGETYPE,
    INITIALTERM,
    RENEWALTERM,
    TO_NUMBER(OFFER_PRICE_CHOICE_ONETIMEPRICE2BILLAFTERDAYS__C, 10, 2) as OFFER_PRICE_CHOICE_ONETIMEPRICE2BILLAFTERDAYS__C,
    TO_NUMBER(OFFER_PRICE_CHOICE_ONETIMEPRICE__C, 10, 2) as OFFER_PRICE_CHOICE_ONETIMEPRICE__C,
    TO_NUMBER(OFFER_PRICE_CHOICE_ONETIMEPRICE2__C, 10, 2) as OFFER_PRICE_CHOICE_ONETIMEPRICE2__C,
    TO_NUMBER(OFFER_PRICE_CHOICE_RECURRINGPRICE__C, 10, 2) as OFFER_PRICE_CHOICE_RECURRINGPRICE__C,
    TO_NUMBER(RATE_PLAN_CHARGE_DISCOUNTAMOUNT, 10, 2) as RATE_PLAN_CHARGE_DISCOUNTAMOUNT,
    TO_DATE(SUBSCRIPTIONSTARTDATE_DATE),
    TO_DATE(SERVICESTARTDATE_DATE),
    TO_DATE(SUBSCRIPTIONENDDATE_DATE),
    TO_DATE(SERVICEENDDATE_DATE),
    TO_DATE(CANCELLEDDATE_DATE),
    SUBSTATUS__C,
    STATUS,
    TO_NUMBER(GROSS_REVENUE, 10, 2) as GROSS_REVENUE,
    IS_TEST_ACCOUNT,
    TO_NUMBER(INVOICE_TAX_AMOUNT, 10, 2) AS INVOICE_TAX_AMOUNT
FROM prod_dw.DW.REV_REG_3_BLANK_INVOICES_REPORT i
--test account table
inner join public.test_accounts pt ON pt.snaid = i.snaid__c
WHERE i.INVOICEDATE_DATE >= TO_DATE(TO_TIMESTAMP('2021-01-01'))
      AND i.INVOICEDATE_DATE < TO_DATE(TO_TIMESTAMP('2021-10-01'))
ORDER BY 5 DESC;

create or replace temporary table public.refund_report_20210101_20210930_test_transactions_fuzzy_logic as
SELECT AFFILIATE_NAME,
	BRAND_NAME,
	SNAID__C,
	ORIGINALID,
	CAMPAIGNID__C,
	ISSTACKED__C,
	INVOICENUMBER,
	TO_DATE(r.INVOICEDATE_DATE) as INVOICEDATE_DATE,
	TO_NUMBER(INVOICE_AMOUNT, 10, 2) as INVOICE_AMOUNT,
	CAMPAIGN_NAME,
	PUBLICATIONCODE__C,
	PRODUCT_NAME,
	PRODUCTTYPE__C,
	TERMTYPE,
	ORDERTYPE__C,
	CHARGETYPE,
	INITIALTERM,
	RENEWALTERM,
	TO_NUMBER(OFFER_PRICE_CHOICE_ONETIMEPRICE2BILLAFTERDAYS__C, 10, 2) as OFFER_PRICE_CHOICE_ONETIMEPRICE2BILLAFTERDAYS__C,
	TO_NUMBER(OFFER_PRICE_CHOICE_ONETIMEPRICE__C, 10, 2) as OFFER_PRICE_CHOICE_ONETIMEPRICE__C,
	TO_NUMBER(OFFER_PRICE_CHOICE_ONETIMEPRICE2__C, 10, 2) as OFFER_PRICE_CHOICE_ONETIMEPRICE2__C,
	TO_NUMBER(OFFER_PRICE_CHOICE_RECURRINGPRICE__C, 10, 2) as OFFER_PRICE_CHOICE_RECURRINGPRICE__C,
	TO_DATE(r.SERVICESTARTDATE_DATE) as SERVICESTARTDATE_DATE,
	TO_DATE(r.SUBSCRIPTIONSTARTDATE_DATE) as SUBSCRIPTIONSTARTDATE_DATE,
	TO_DATE(r.TERMSTARTDATE_DATE) as TERMSTARTDATE_DATE,
	TO_DATE(r.SERVICEENDDATE_DATE) as SERVICEENDDATE_DATE,
	TO_DATE(r.TERMENDDATE_DATE) as TERMENDDATE_DATE,
	REFUND_NUMBER,
	TO_NUMBER(GROSS_REVENUE, 10, 2) as GROSS_REVENUE,
	TO_NUMBER(REFUND_AMOUNT, 10, 2) as REFUND_AMOUNT,
	TO_DATE(r.CANCELLEDDATE_DATE) as CANCELLEDDATE_DATE,
	TO_DATE(r.SUBSCRIPTIONENDDATE_DATE) as SUBSCRIPTIONENDDATE_DATE,
	TO_DATE(r.CONTRACTEFFECTIVEDATE_DATE) as CONTRACTEFFECTIVEDATE_DATE,
	PAYMENT_NUMBER,
	IS_TEST_ACCOUNT,
	TO_NUMBER(REFUND_TAX_AMOUNT, 10, 2) as REFUND_TAX_AMOUNT,
	TO_NUMBER(INVOICE_TAX_AMOUNT, 10, 2) AS INVOICE_TAX_AMOUNT
FROM PROD_DW.DW.REV_REG_4_REFUND_REPORT AS r
--test account table
inner join public.test_accounts pt ON pt.snaid = r.snaid__c
WHERE r.TRANSACTION_DATE >= TO_DATE(TO_TIMESTAMP('2021-01-01'))
        and r.TRANSACTION_DATE < TO_DATE(TO_TIMESTAMP('2021-10-01'))
GROUP BY 1, 2, 3, 4, 5, 6, 7, TO_DATE(r.INVOICEDATE_DATE), 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
         21, 22, TO_DATE(r.SERVICESTARTDATE_DATE), TO_DATE(r.SUBSCRIPTIONSTARTDATE_DATE),
         TO_DATE(r.TERMSTARTDATE_DATE), TO_DATE(r.SERVICEENDDATE_DATE),
         TO_DATE(r.TERMENDDATE_DATE), 28, 29, 30, TO_DATE(r.CANCELLEDDATE_DATE),
         TO_DATE(r.SUBSCRIPTIONENDDATE_DATE), TO_DATE(r.CONTRACTEFFECTIVEDATE_DATE), 34, 35, 36, 37
ORDER BY 8 DESC;

create or replace temporary table public.nonrefundable_fees_20210101_20210930_test_transactions_fuzzy_logic as
SELECT BRAND_ID,
    r.SNAID,
    CAMPAIGN_ID,
    INVOICE_NUMBER,
    TO_DATE(r.INVOICE_DATE) as INVOICE_DATE,
    to_number(INVOICE_AMOUNT, 10, 2) as INVOICE_AMOUNT,
    PUBCODE,
    ORDER_TYPE,
    TO_DATE(r.PAYMENT_DATE ) as PAYMENT_DATE,
    PAYMENT_NUMBER,
    TO_DATE(r.REFUND_DATE ) as REFUND_DATE,
    REFUND_NUMBER,
    to_number(GROSS_REVENUE, 10, 2) as GROSS_REVENUE,
    to_number(REFUND_AMOUNT, 10, 2) as REFUND_AMOUNT,
    TERM_TYPE,
    IS_TEST_ACCOUNT,
    to_number(REFUND_TAX_AMOUNT, 10, 2) as REFUND_TAX_AMOUNT,
    to_number(INVOICE_TAX_AMOUNT, 10, 2) as INVOICE_TAX_AMOUNT
FROM prod_dw.DW.REV_REG_5_NON_REFUNDABLE_FEES_REPORT r
--test account table
inner join public.test_accounts pt ON pt.snaid = r.snaid
WHERE
	r.REFUND_DATE  >= TO_TIMESTAMP('2021-01-01')
   AND r.REFUND_DATE  < TO_TIMESTAMP('2021-10-01')
GROUP BY 1,2,3,4,TO_DATE(r.INVOICE_DATE),6,7,8,TO_DATE(r.PAYMENT_DATE ),10,TO_DATE(r.REFUND_DATE ),12,13,14,15,16,17,18
ORDER BY 5 DESC;