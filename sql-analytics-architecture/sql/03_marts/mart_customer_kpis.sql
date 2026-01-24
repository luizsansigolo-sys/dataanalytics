SELECT
  bc.account_id,

  SUM(bc.`Volume Confirmado`) AS total_confirmed,

  CASE
    WHEN MAX(bc.`Custódia Total`) IS NULL THEN SUM(bc.`Volume Confirmado`)
    ELSE MAX(bc.`Custódia Total`)
  END AS custody_amount,

  bc.`Classe Cliente`  AS customer_class,
  bc.`Distribuído por` AS distribution_channel

FROM Base_confirmadas bc
WHERE
  bc.`Tipo de contato (Sócios)` = 'Clientes'
  AND bc.`Volume Confirmado` > 0
GROUP BY
  bc.account_id;

