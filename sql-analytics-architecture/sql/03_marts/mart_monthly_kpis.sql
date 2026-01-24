SELECT
  DATE_FORMAT(`Data da Transação`, '%Y-%m-01') AS month_start,
  `Distribuído por` AS distribution_channel,
  `Tipo de cliente` AS client_type,
  SUM(`Volume Confirmado`) AS total_volume,
  COUNT(DISTINCT account_id) AS active_clients
FROM Base_confirmadas_rt
GROUP BY
  DATE_FORMAT(`Data da Transação`, '%Y-%m-01'),
  `Distribuído por`,
  `Tipo de cliente`;

