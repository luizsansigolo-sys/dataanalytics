-- =====================================================
-- STAGING: OPERATIONS
-- Source: operation_v2 (+ operation legacy for start_date)
-- Purpose: Clean, standardize and classify operations
-- =====================================================

CREATE OR REPLACE VIEW stg_operations AS

WITH base AS (
    SELECT
        o.`id`                AS operation_id,
        o.`name`              AS operation_name,
        o.`endDate`           AS operation_end_date,
        o.`assetSymbol`       AS asset_symbol,
        o.`goal`              AS fundraising_goal,
        o.`amountConfirmed`   AS amount_confirmed_operation,
        o.`estimatedDuration` AS estimated_duration,
        o.`estimatedIRR`      AS estimated_irr,
        ov1.`start_date`      AS operation_start_date,

        o.`paymentFrequency`,
        o.`visibility`,
        o.`status`,
        o.`thesisName`,
        o.`originatorTranslated`,
        o.`realPu`
    FROM `operation_v2` o
    LEFT JOIN `operation` ov1
        ON ov1.`id` = o.`id`
),

cleaned AS (
    SELECT
        b.*,

        /* Payment frequency */
        CASE
            WHEN b.`paymentFrequency` = 'HCP__PAYMENT_FRACTION' THEN 'Fracionado'
            WHEN b.`paymentFrequency` = 'HCP__PAYMENT_MONTHLY'  THEN 'Mensal'
            WHEN b.`paymentFrequency` IN ('HCP__PAYMENT_AT_END','HCP__BULLET') THEN 'Bullet'
            WHEN b.`paymentFrequency` = 'HCP__IRREGULAR' THEN 'Irregular'
            ELSE b.`paymentFrequency`
        END AS payment_type,

        /* Visibility */
        CASE
            WHEN REPLACE(b.`visibility`, 'HCP__', '') = 'PUBLIC' THEN 'Público'
            WHEN REPLACE(b.`visibility`, 'HCP__', '') = 'LIST'   THEN 'Lista'
            ELSE REPLACE(b.`visibility`, 'HCP__', '')
        END AS visibility_pt,

        /* Operation status */
        CASE
            WHEN REPLACE(b.`status`, 'HCP__', '') = 'ACTIVE'        THEN 'Ativa'
            WHEN REPLACE(b.`status`, 'HCP__', '') = 'ENDED_SUCCESS' THEN 'Finalizado com Sucesso'
            WHEN REPLACE(b.`status`, 'HCP__', '') = 'OPEN'          THEN 'Aberta'
            ELSE REPLACE(b.`status`, 'HCP__', '')
        END AS operation_status_pt,

        /* realPu fallback / correction */
        CASE
            WHEN UPPER(TRIM(b.`status`)) IN ('HCP__ENDED_SUCCESS', 'ENDED') THEN COALESCE(b.`realPu`, 0)
            WHEN b.`realPu` IS NULL THEN 1
            ELSE b.`realPu`
        END AS real_pu_fixed

    FROM base b
),

classified AS (
    SELECT
        c.*,

        /* ======================
           ORIGINATOR (Originadora)
           ====================== */
        CASE
            WHEN c.`originatorTranslated` IS NOT NULL AND TRIM(c.`originatorTranslated`) <> ''
                THEN TRIM(c.`originatorTranslated`)
            -- TODO: add your layered pattern rules here (token/name overrides)
            ELSE 'Outros'
        END AS originadora_raw,

        /* ======================
           THESIS (Tese)
           ====================== */
        CASE
            WHEN c.`thesisName` IS NOT NULL AND TRIM(c.`thesisName`) <> ''
                THEN TRIM(c.`thesisName`)
            -- TODO: add your layered rules here
            ELSE 'Outros'
        END AS tese_raw

    FROM cleaned c
)

SELECT
    operation_id,
    operation_name,
    operation_start_date,
    operation_end_date,
    asset_symbol,
    fundraising_goal,
    amount_confirmed_operation,
    estimated_duration,
    estimated_irr,

    payment_type,
    visibility_pt,
    real_pu_fixed,
    operation_status_pt,

    tese_raw  AS tese,
    /* Normalize Originadora casing */
    CONCAT(
        UPPER(LEFT(originadora_raw, 1)),
        LOWER(SUBSTRING(originadora_raw, 2))
    ) AS originadora

FROM classified

WHERE
    NOT REGEXP_LIKE(LOWER(operation_name),
        'vitreo|cancelada|teste|originadora|exemplo|ktti'
    )
    AND NOT REGEXP_LIKE(LOWER(COALESCE(status,'')), 'hcp__cancelled|pending')
;

