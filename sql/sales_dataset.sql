-- Builds one flat analytical table: one row per session
-- with session params, account info and ordered product (BigQuery, dataset DA)
WITH ses_params AS (
  SELECT
    ses.date AS session_date,
    ses.ga_session_id AS session_id,
    sp.continent AS continent,
    sp.country AS country,
    sp.device AS device,
    sp.browser AS browser,
    sp.mobile_model_name AS mobile_model,
    sp.operating_system AS operating_system,
    sp.language AS browser_language,
    sp.name AS traffic,
    sp.channel AS traffic_channel
  FROM `DA.session` ses
  LEFT JOIN `DA.session_params` sp
    ON ses.ga_session_id = sp.ga_session_id
),

acc_params AS (
  SELECT
    acs.ga_session_id AS session_id,
    acs.account_id AS account_id,
    acc.is_verified AS verified,
    acc.is_unsubscribed AS unsubscribed
  FROM `DA.account_session` acs
  LEFT JOIN `DA.account` acc
    ON acs.account_id = acc.id
),

products AS (
  SELECT
    ord.ga_session_id AS session_id,
    prd.category AS product_category,
    prd.name AS product_name,
    prd.price AS product_price,
    prd.short_description AS product_description
  FROM `DA.order` ord
  LEFT JOIN `DA.product` prd
    ON ord.item_id = prd.item_id
)

SELECT
  sp.session_date,
  sp.session_id,
  sp.continent,
  sp.country,
  sp.device,
  sp.browser,
  sp.mobile_model,
  sp.operating_system,
  sp.browser_language,
  sp.traffic,
  sp.traffic_channel,
  ap.account_id,
  ap.verified,
  ap.unsubscribed,
  pr.product_category,
  pr.product_name,
  pr.product_price,
  pr.product_description
FROM ses_params sp
LEFT JOIN acc_params ap
  ON sp.session_id = ap.session_id
LEFT JOIN products pr
  ON sp.session_id = pr.session_id
