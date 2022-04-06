    select name,sfid,id,SNAID__C,REGISTEREDUSERNAME__C,PERSONEMAIL,ZUORA_ACCOUNT_ID__C
    FROM FT_PROD.heroku_salesforce.vw_account sf
    WHERE sf.is_test_account__c=true