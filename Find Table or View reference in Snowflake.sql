
--Find TABLE References

USE ROLE ANALYST;
alter session
   SET query_tag = 'object-dependency';
   SET (object_name,object_type,object_database,object_schema) =
   ('CURRENT_SUBSCRIPTION_WEB_ACCESS'
       , 'TABLE'
       , 'PROD_DW'
       , 'DW');
WITH RECURSIVE referenced_cte (object_name_path,
                              referenced_object_name,
                              referenced_object_domain,
                              referencing_object_domain,
                              referencing_object_name,
                              referenced_object_id,
                              referencing_object_id,
                              referenced_database,
                              referencing_database,
                              referenced_schema,
                              referencing_schema
                              )
    AS
(
  SELECT referenced_object_name || '-->' || referencing_object_name AS object_name_path
         , referenced_object_name
         , referenced_object_domain
         , referencing_object_domain
         , referencing_object_name
         , referenced_object_id
         , referencing_object_id
         , referenced_database
         , referencing_database
         , referenced_schema
         , referencing_schema
  FROM snowflake.account_usage.object_dependencies REFERENCING
  WHERE TRUE
  AND   referenced_object_name = UPPER($object_name)
  AND   referenced_object_domain = UPPER($object_type)
  AND   referenced_database = UPPER($object_database)
  AND   referenced_schema = UPPER($object_schema)
  UNION ALL
  SELECT object_name_path || '-->' || referencing.referencing_object_name
         , referencing.referenced_object_name
         , referencing.referenced_object_domain
         , referencing.referencing_object_domain
         , referencing.referencing_object_name
         , referencing.referenced_object_id
         , referencing.referencing_object_id
         , referencing.referenced_database
         , referencing.referencing_database
         , referencing.referenced_schema
         , referencing.referencing_schema
  FROM snowflake.account_usage.object_dependencies REFERENCING
    JOIN referenced_cte
      ON referencing.referenced_object_id = referenced_cte.referencing_object_id
     AND referencing.referenced_object_domain = referenced_cte.referencing_object_domain
)
SELECT object_name_path
       , referenced_object_name
       , referenced_object_domain
       , referencing_object_name
       , referencing_object_domain
       , referencing_database
       , referencing_schema
FROM referenced_cte;

--Find VIEW references
alter session
   SET query_tag = 'object-dependency';

SET (object_name,object_type,object_database,object_schema) = ('VW_NTA_LTV_INPUT'
       , 'VIEW'
       , 'PREDICTIVE_ANALYTICS'
       , 'NTH_LTV_MODEL');

WITH RECURSIVE referenced_cte (object_name_path,
                              referenced_object_name,
                              referenced_object_domain,
                              referencing_object_domain,
                              referencing_object_name,
                              referenced_object_id,
                              referencing_object_id,
                              referenced_database,
                              referencing_database,
                              referenced_schema,
                              referencing_schema
                              )
    AS
(
  SELECT referenced_object_name || '<--' || referencing_object_name AS object_name_path
         , referenced_object_name
         , referenced_object_domain
         , referencing_object_domain
         , referencing_object_name
         , referenced_object_id
         , referencing_object_id
         , referenced_database
         , referencing_database
         , referenced_schema
         , referencing_schema
  FROM snowflake.account_usage.object_dependencies REFERENCING
  WHERE TRUE
  AND   referencing_object_name = UPPER($object_name)
  AND   referencing_object_domain = UPPER($object_type)
  UNION ALL
  SELECT referencing.referenced_object_name || '<--' || object_name_path
         , referencing.referenced_object_name
         , referencing.referenced_object_domain
         , referencing.referencing_object_domain
         , referencing.referencing_object_name
         , referencing.referenced_object_id
         , referencing.referencing_object_id
         , referencing.referenced_database
         , referencing.referencing_database
         , referencing.referenced_schema
         , referencing.referencing_schema
  FROM snowflake.account_usage.object_dependencies REFERENCING
    JOIN referenced_cte
      ON referencing.referencing_object_id = referenced_cte.referenced_object_id
     AND referencing.referencing_object_domain = referenced_cte.referenced_object_domain
)
SELECT object_name_path
       , referenced_object_name
       , referenced_object_domain
       , referencing_object_name
       , referencing_object_domain
       , referencing_database
       , referencing_schema
FROM referenced_cte;
