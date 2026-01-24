-- =====================================================
-- STAGING: CLIENTS
-- Source: account_v2
-- Purpose: Clean, standardize and translate client data
-- =====================================================

CREATE OR REPLACE VIEW stg_clients AS

SELECT
    /* =========================
       IDENTIFICATION
       ========================= */
    a.id                         AS account_id,
    a.nid                        AS cpf,
    LOWER(a.email)               AS email,
    UPPER(a.fullName)            AS full_name,
    a.phone                      AS phone,

    /* =========================
       SYSTEM & ACCESS
       ========================= */
    a.device,
    a.lastLogin                  AS last_login,
    a.confirmedMfa               AS mfa_confirmed,
    a.hsContactId                AS hubspot_contact_id,
    a.hsOwnerId                  AS hubspot_owner_id,

    /* =========================
       LOCATION
       ========================= */
    a.street,
    a.neighborhood,
    a.city,
    a.translatedState            AS state,
    a.translatedCountry          AS country,
    a.brazilianRegion            AS region,
    a.postalCode                 AS zip_code,

    /* =========================
       PERSONAL DATA
       ========================= */
    a.translatedGender           AS gender,
    REPLACE(a.translatedNationality,'HCP__NATIONALITY.','') AS nationality,
    a.translatedMaritalStatus    AS marital_status,
    REPLACE(a.translatedProfession,'HCP__PROFESSION.','')  AS profession,
    a.birthdate,

    /* =========================
       INVESTOR PROFILE
       ========================= */
    CASE
        WHEN a.translatedSuitabilityInvestorProfile = 'HCP__BOLD' THEN 'Arrojado'
        WHEN a.translatedSuitabilityInvestorProfile = 'HCP__AGGRESSIVE' THEN 'Agressivo'
        WHEN a.translatedSuitabilityInvestorProfile = 'HCP__MODERATE' THEN 'Moderado'
        WHEN a.translatedSuitabilityInvestorProfile = 'HCP__CONSERVATIVE' THEN 'Conservador'
        WHEN a.translatedSuitabilityInvestorProfile = 'HCP__ULTRA_CONSERVATIVE' THEN 'Ultra Conservador'
        ELSE a.translatedSuitabilityInvestorProfile
    END AS investor_profile,

    /* =========================
       PARTNER & SEGMENTATION
       ========================= */
    CASE
        WHEN a.partner IS NULL OR TRIM(a.partner) = '' OR UPPER(a.partner) = 'HURST'
            THEN 'B2C'
        ELSE 'B2B'
    END AS distribution_channel,

    UPPER(TRIM(a.partner))       AS partner

FROM account_v2 a

WHERE
    LOWER(a.email) NOT LIKE '%teste%'
    AND LOWER(a.fullName) NOT LIKE '%teste%'
    AND UPPER(a.partner) NOT IN ('VITREO','BTG');

