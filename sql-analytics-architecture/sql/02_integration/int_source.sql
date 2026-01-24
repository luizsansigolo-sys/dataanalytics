### Example: Integrated Analytical Model

The snippet below illustrates how cleaned client, operation, and transaction
data are combined to form the core analytical dataset.

```sql
SELECT
    t.transaction_id,
    t.transaction_date,
    t.amount_confirmed,

    c.account_id,
    c.distribution_channel,
    c.investor_profile,

    o.operation_id,
    o.originadora,
    o.tese,

    /* Derived metrics */
    (t.amount_confirmed * o.real_pu_fixed) AS custody_amount,

    CASE
        WHEN c.first_investment_date IS NOT NULL
         AND YEAR(c.first_investment_date) = YEAR(t.transaction_date)
         AND MONTH(c.first_investment_date) = MONTH(t.transaction_date)
        THEN 'New Client'
        ELSE 'Existing Client'
    END AS client_type

FROM stg_transactions t
LEFT JOIN stg_clients c
    ON c.account_id = t.account_id
LEFT JOIN stg_operations o
    ON o.operation_id = t.operation_id;
