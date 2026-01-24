# SQL Analytics Architecture

## Client Data – Staging Layer

The client dataset is sourced from the raw `account_v2` table and serves as the
foundation for all customer-level analytics.

At this stage, the data is:
- cleaned from test and invalid records
- standardized (text casing and formats)
- translated from system enums into business-friendly labels
- enriched with basic segmentation attributes

No business metrics or aggregations are applied at this layer.

## Operations Data – Staging Layer

The operations dataset is sourced from the raw `operation_v2` table and
represents all operations that were offered and sold on the platform.

At this stage, the data undergoes extensive normalization and classification
to address historical inconsistencies and missing metadata.

Key transformations include:

- normalization of operation names, statuses, and visibility fields
- translation of system enums into business-friendly labels
- classification of originators using a multi-layer fallback strategy
  (official mappings, token patterns, operation names, and specific overrides)
- classification of investment thesis based on explicit metadata and
  pattern recognition
- correction of known data quality issues and legacy edge cases
- exclusion of test, cancelled, and invalid operations

This staging layer focuses on producing a clean and semantically consistent
representation of operations, without applying aggregations or financial KPIs.


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


## Integration Layer – Single Source of Truth

The integration layer combines the cleaned and standardized datasets from the
staging layer into a unified analytical model.

At this stage, client, operation, and transaction data are joined to establish
a single source of truth that supports consistent reporting and decision-making
across the organization.

This layer is responsible for:

- defining canonical relationships between clients, operations, and transactions
- resolving data conflicts across source systems
- applying business rules that depend on multiple domains
- creating derived analytical attributes and metrics
- ensuring temporal consistency for customer and operational analyses

The core output of this layer is the **Base_confirmadas** dataset, which serves
as the foundation for all downstream dashboards, KPIs, and analytical marts.
