## Operations Transactions – Staging Layer

The operations transactions dataset is sourced from the raw
`operation_transaction_v2` table and represents individual investment
transactions executed by clients.

This dataset is the most granular layer of the model and serves as the
foundation for all volume, revenue, and customer activity metrics.

At this stage, the data is prepared to ensure transactional consistency and
analytical reliability.

Key transformations include:

- filtering transactions to include only confirmed and valid records
- exclusion of internal, exchange-based, or non-relevant transaction origins
- standardization of transactional timestamps and identifiers
- preservation of transaction-level granularity (no aggregation)
- preparation of clean keys for integration with client and operation datasets

No financial aggregations, customer classifications, or KPIs are calculated at
this layer.

