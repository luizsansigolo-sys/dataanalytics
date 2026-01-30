# 📊 Product Co-occurrence Analysis
**Behavioral affinity matrix for cross-sell strategy**

## 📌 Overview
In multi-product financial environments, cross-sell initiatives are often built on generic assumptions rather than actual client behavior.  
This project aims to transform transactional data into **actionable insights**, identifying which products tend to co-occur within the same client base.

The core question addressed is:

> **Given that a client owns a specific product, which other products are they most likely to own as well?**

---

## 🎯 Business Objective
- Identify behavioral affinities between financial products
- Support cross-sell and upsell strategies with real data
- Improve campaign targeting and commercial prioritization
- Provide analytical input for CRM and marketing teams

---

## 🧠 Methodology

### Data foundation
- Transactional client-level data
- Binary product ownership per client

### Analytical approach
For each **base product**:
1. Identify all clients who own the product
2. Map additional products owned by the same clients
3. Compute **conditional co-occurrence**:
   - Probability of a client owning product B given ownership of product A
4. Normalize results as percentages to avoid base-size distortion

This approach focuses on **behavioral affinity**, not statistical correlation.

---

## 📈 Output: Co-occurrence Matrix

The result is a normalized co-occurrence matrix visualized as a heatmap, where:
- Rows represent the base product
- Columns represent secondary products
- Each cell indicates the percentage of clients who own both products

![Product Cooccurrence Matrix](images/cooccurrence.png)

Higher values indicate stronger cross-sell potential, while lower values highlight niche or isolated product profiles.

---

## 🛠️ Tools & Stack
- SQL for data extraction and transformation
- DAX and PowerQuery used to a second layer transformation
- Analytical modeling using conditional probabilities
- Visualization via BI tools
- Data anonymization for portfolio purposes

> ⚠️ All data shown has been anonymized or adjusted to preserve confidentiality.

---
## 📬 Author
**Luiz Sansigolo**  
Data Analyst | BI | Analytics  
[LinkedIn](https://linkedin.com/in/luiz-sansigolo)
