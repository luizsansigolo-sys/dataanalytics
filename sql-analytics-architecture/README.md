# SQL Analytics Architecture

## Client Data – Staging Layer

The client dataset is sourced from the raw `account_v2` table and serves as the foundation for all customer-level analytics.

At this stage, the data is:
- cleaned from test and invalid records
- standardized (text casing, formats)
- translated from system enums to business-friendly labels
- enriched with basic segmentation attributes

No business metrics or aggregations are applied at this layer.
