### Example: Transaction Staging Logic

Below is a simplified example of how transaction records are filtered and
prepared at the staging layer.

```sql
SELECT
    ot.transactionId    AS transaction_id,
    ot.accountId        AS account_id,
    ot.operationId      AS operation_id,
    ot.amountConfirmed  AS amount_confirmed,
    ot.assetSymbol      AS asset_symbol,
    ot.confirmedBySystemDate AS transaction_date
FROM operation_transaction_v2 ot
WHERE
    ot.transactionStatus = 'confirmed'
    AND (ot.origin <> 'HCP__EXCHANGE' OR ot.origin IS NULL);
